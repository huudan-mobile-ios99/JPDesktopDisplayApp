import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:playtech_transmitter_app/service/config_custom.dart';
import 'package:playtech_transmitter_app/service/socket_service/socket_service.dart';

part 'video_event.dart';
part 'video_state.dart';


class VideoBloc extends Bloc<VideoEvent, ViddeoState> {
  final String videoBg;
  final BuildContext context;
  Timer? _timer;
  final int totalCountToRestart = ConfigCustom.totalCountToRestart;
  int get additionSeconds {
    if (ConfigCustom.firstDataTimeSeconds == null) {
      return ConfigCustom.additionSeconds; // Fallback if no data time
    }
    final firstDataTime = ConfigCustom.firstDataTimeSeconds!;
    if (firstDataTime > 30) {
      return (firstDataTime - 30).clamp(0, double.infinity).toInt(); // More than 30s: subtract 30
    } else if (firstDataTime == 30) {
      return 29; // Exactly 30s: use 28s
    } else {
      return 29; // Less than 30s: subtract 1
    }
  }
  final SocketService _socketService;

  VideoBloc({
    required this.videoBg,
    required this.context,
    SocketService? socketService,
  })  : _socketService = socketService ?? SocketService(),
        super(ViddeoState(
          id: 1,
          currentVideo: videoBg,
          lastSwitchTime: DateTime.now(),
          count: 0,
          isRestart: false,
          runNumber: '1st',
        )) {
    on<IncrementCount>(_onIncrementCount);
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    final duration = state.count + 1 < totalCountToRestart
        ? ConfigCustom.durationSwitchVideoSecond
        : 29;
    // _logger.i('VideoBloc: Timer started for count ${state.count + 1} with duration $duration seconds');
    _timer = Timer(Duration(seconds: duration), () {
      add(IncrementCount());
    });
  }

  Future<void> _onIncrementCount(IncrementCount event, Emitter<ViddeoState> emit) async {
    final now = DateTime.now();
    int newCount = state.count + 1;
    bool newIsRestart = false;

    if (newCount >= totalCountToRestart) {
      newCount = 0;
      newIsRestart = true;
      // debugPrint('Triggering app restart after $totalCountToRestart counts (final count duration: $additionSeconds seconds)');
      try {
        _socketService.dispose();
        // Phoenix.rebirth(context);
        Future.microtask(() => Phoenix.rebirth(context));
      } catch (e) {
        // _logger.e('Restart failed: $e');
      }
    } else {
      // Restart timer for the next count
      _startTimer();
    }

    emit(ViddeoState(
      currentVideo: videoBg,
      lastSwitchTime: now,
      count: newCount,
      isRestart: newIsRestart,
      id: 1,
      runNumber: '${newCount + 1} run',
    ));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    // _logger.i('VideoBloc closed, timer cancelled');
    return super.close();
  }
}
