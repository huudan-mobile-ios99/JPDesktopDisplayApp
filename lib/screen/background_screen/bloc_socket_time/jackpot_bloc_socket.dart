import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playtech_transmitter_app/service/config_custom.dart';
import 'package:playtech_transmitter_app/service/jackpot_config_service.dart';
import 'package:playtech_transmitter_app/service/socket_service/socket_service.dart';
import 'jackpot_event_socket.dart';
import 'jackpot_state_socket.dart';

class JackpotBloc2 extends Bloc<JackpotEvent2, JackpotState2> {
  final SocketService _socketService;
  final JackpotConfigService _configService = JackpotConfigService(); // Singleton
  Timer? _imagePageTimer;
  StreamSubscription<bool>? _connectionSubscription;
  StreamSubscription<Map<String, dynamic>>? _hitSubscription;
  StreamSubscription<Map<String, dynamic>>? _initialConfigSubscription;
  StreamSubscription<Map<String, dynamic>>? _updatedConfigSubscription;

  JackpotBloc2({SocketService? socketService}) : _socketService = socketService ?? SocketService(),super(const JackpotState2()) {

    on<JackpotConnect>(_onConnect);
    on<JackpotDisconnect>(_onDisconnect);
    on<JackpotReconnect>(_onReconnect);
    on<JackpotError>(_onError);
    on<JackpotReconnectAttempt>(_onReconnectAttempt);
    on<JackpotReconnectError>(_onReconnectError);
    on<JackpotHitReceived>(_onHitReceived);
    on<JackpotHideImagePage>(_onHideImagePage);
    on<JackpotCountdownCompleted>(_onCountdownCompleted);

    _initialize();
  }

  void _initialize() {
    _socketService.initialize();
    _listenToSocketEvents();
  }

  void _listenToSocketEvents() {
    _connectionSubscription?.cancel();
    _hitSubscription?.cancel();
    _initialConfigSubscription?.cancel();
    _updatedConfigSubscription?.cancel();

    _connectionSubscription = _socketService.connectionStream.listen((isConnected) {
      if (isConnected) {
        add(JackpotConnect());
      } else {
        add(JackpotDisconnect());
      }
    }, onError: (error) {
      add(JackpotError('Connection stream error: $error'));
    });

    _hitSubscription = _socketService.hitStream.listen((hit) {
      add(JackpotHitReceived(hit));
    }, onError: (error) {
      debugPrint('JackpotBloc2: Hit stream error: $error');
    });
  }

  // Dynamic timer using setting.json ? durations
  void _startDisplayTimer(String hitId) {
    _imagePageTimer?.cancel();

    final durationSeconds = _configService.getDuration(hitId);
    final Duration duration = Duration(seconds: durationSeconds);
    debugPrint('JackpotBloc2: Starting timer for jackpot ID: $hitId, duration: ${duration.inSeconds} seconds');
    _imagePageTimer = Timer(duration, () {
      add(JackpotHideImagePage());
    });
  }
  // Dynamic timer using setting.json ? durations

  Future<void> _onConnect(JackpotConnect event, Emitter<JackpotState2> emit) async {
    debugPrint('JackpotBloc2: Connected to Socket.IO server');
    emit(state.copyWith(
      isConnected: true,
      error: null,
    ));
  }

  Future<void> _onDisconnect(JackpotDisconnect event, Emitter<JackpotState2> emit) async {
    debugPrint('JackpotBloc2: Disconnected from Socket.IO server');
    emit(state.copyWith(isConnected: false));
  }

  Future<void> _onReconnect(JackpotReconnect event, Emitter<JackpotState2> emit) async {
    debugPrint('JackpotBloc2: Reconnected to Socket.IO server');
    emit(state.copyWith(
      isConnected: true,
      error: null,
    ));
  }

  Future<void> _onError(JackpotError event, Emitter<JackpotState2> emit) async {
    debugPrint('JackpotBloc2: Socket.IO error: ${event.error}');
    emit(state.copyWith(
      error: event.error,
      isConnected: false,
    ));
  }

  Future<void> _onReconnectAttempt(JackpotReconnectAttempt event, Emitter<JackpotState2> emit) async {
    debugPrint('JackpotBloc2: Reconnection attempt #${event.attempt}');
  }

  Future<void> _onReconnectError(JackpotReconnectError event, Emitter<JackpotState2> emit) async {
    debugPrint('JackpotBloc2: Reconnection error: ${event.error}');
    emit(state.copyWith(error: event.error));
  }

  // Dynamic timer using setting.json ? durations
  Future<void> _onHitReceived(JackpotHitReceived event, Emitter<JackpotState2> emit) async {
    debugPrint('JackpotBloc2: Received hit for jackpot ID: ${event.hit['id']}, data: ${event.hit}');
    final hitId = event.hit['id']?.toString() ?? event.hit['jackpotId']?.toString() ?? 'unknown';
    debugPrint('JackpotBloc2: Extracted hitId: $hitId');
    final updatedHits = List<Map<String, dynamic>>.from(state.hits)..add(event.hit);

    // Use config service for countdown check
    final bool requiresCountdown = _configService.requiresCountdown(hitId);

    if (state.showImagePage) {
      final updatedQueue = List<Map<String, dynamic>>.from(state.hitQueue ?? [])..add(event.hit);
      debugPrint('JackpotBloc2: Queuing hit for jackpot ID: $hitId, current queue length: ${updatedQueue.length}');
      emit(state.copyWith(
        hits: updatedHits,
        hitQueue: updatedQueue,
        error: null,
      ));
    } else {
      _startDisplayTimer(hitId);
      emit(state.copyWith(
        hits: updatedHits,
        latestHit: event.hit,
        showImagePage: true,
        requiresCountdown: requiresCountdown,
        error: null,
      ));
    }
  }
  // Dynamic timer using setting.json ? durations

  Future<void> _onCountdownCompleted(JackpotCountdownCompleted event, Emitter<JackpotState2> emit) async {
    debugPrint('JackpotBloc2: Countdown completed, switching to main video');
    emit(state.copyWith(
      requiresCountdown: false,
    ));
  }

  Future<void> _onInitialConfigReceived(JackpotInitialConfigReceived event, Emitter<JackpotState2> emit) async {
    debugPrint('JackpotBloc2: Received initialConfig: ${event.config}');
    emit(state.copyWith(config: event.config));
  }

  Future<void> _onUpdatedConfigReceived(JackpotUpdatedConfigReceived event, Emitter<JackpotState2> emit) async {
    debugPrint('JackpotBloc2: Received updatedConfig: ${event.config}');
    if (event.config.containsKey('status')) {
      final isConnected = event.config['status'] == 'connected';
      emit(state.copyWith(
        isConnected: isConnected,
        error: null,
      ));
    } else if (event.config.containsKey('error')) {
      emit(state.copyWith(error: event.config['error']));
    } else {
      emit(state.copyWith(config: event.config));
    }
  }

  Future<void> _onHideImagePage(JackpotHideImagePage event, Emitter<JackpotState2> emit) async {
    if (state.hitQueue?.isNotEmpty ?? false) {
      final nextHit = state.hitQueue!.first;
      final hitId = nextHit['id']?.toString() ?? nextHit['jackpotId']?.toString() ?? 'unknown';
      final updatedQueue = List<Map<String, dynamic>>.from(state.hitQueue!)..removeAt(0);
      final bool requiresCountdown = _configService.requiresCountdown(hitId);

      debugPrint('JackpotBloc2: Hiding current video, displaying next queued hit for jackpot ID: $hitId, remaining queue length: ${updatedQueue.length}');
      emit(state.copyWith(
        latestHit: nextHit,
        showImagePage: true,
        hitQueue: updatedQueue,
        requiresCountdown: requiresCountdown,

      ));
      _startDisplayTimer(hitId);
    } else {
      debugPrint('JackpotBloc2: Hiding video for jackpot ID: ${state.latestHit?['id'] ?? state.latestHit?['jackpotId'] ?? 'unknown'}, no more hits in queue');
      emit(state.copyWith(
        showImagePage: false,
        latestHit: null,
        requiresCountdown: false,
      ));
    }
  }

  @override
  Future<void> close() async {
    debugPrint('JackpotBloc2: Closing');
    _imagePageTimer?.cancel();
    _connectionSubscription?.cancel();
    _hitSubscription?.cancel();
    _initialConfigSubscription?.cancel();
    _updatedConfigSubscription?.cancel();
    _socketService.dispose();
    return super.close();
  }
}
