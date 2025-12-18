import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:playtech_transmitter_app/screen/background_screen/bloc_socket_time/jackpot_bloc_socket.dart';
import 'package:playtech_transmitter_app/screen/background_screen/bloc_socket_time/jackpot_event_socket.dart';
import 'package:playtech_transmitter_app/screen/background_screen/bloc_socket_time/jackpot_state_socket.dart';
import 'package:playtech_transmitter_app/screen/background_screen/page_background/jackpot_screen_page_hd_led_1920x1080.dart';
import 'package:playtech_transmitter_app/screen/background_screen/page_background/jackpot_screen_page_horizontal_2496x264.dart';

import 'package:playtech_transmitter_app/service/config_custom.dart';
import 'package:playtech_transmitter_app/screen/background_screen/bloc/video_bloc.dart';
import 'package:playtech_transmitter_app/service/widget/circlar_progress.dart';


class JackpotBackgroundShowWindowFadeAnimateP extends StatefulWidget {
  const JackpotBackgroundShowWindowFadeAnimateP({super.key});
  @override
  _JackpotBackgroundShowWindowFadeAnimatePState createState() => _JackpotBackgroundShowWindowFadeAnimatePState();
}

class _JackpotBackgroundShowWindowFadeAnimatePState extends State<JackpotBackgroundShowWindowFadeAnimateP>
    with SingleTickerProviderStateMixin {
  late final Player _player;
  late final VideoController _controller;
  String? _currentVideoPath;
  bool _isInitialized = false;
  int _retryCount = 0;
  static const int _maxRetries = 10;
  final Media _media = Media('asset://${ConfigCustom.videoBackgroundScreenLedVMS_2496x264}');

  @override
  void initState() {
    super.initState();
    MediaKit.ensureInitialized();
    // Initialize player and controller
    _player = Player();
    // Enable looping
    _player.setPlaylistMode(PlaylistMode.loop);
    _controller = VideoController(
      _player,
      configuration: const VideoControllerConfiguration(
        enableHardwareAcceleration: true,
      ),
    );

    // Load initial video
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadVideo(ConfigCustom.videoBackgroundScreenLedVMS_2496x264);
    });

    // Handle errors
    _player.stream.error.listen((error) {
      if (mounted && _retryCount < _maxRetries) {
        _retryCount++;
        setState(() {
          _isInitialized = false;
          _currentVideoPath = null;
        });
        Future.delayed(const Duration(milliseconds: 50), () {
          if (mounted) {
            _loadVideo(ConfigCustom.videoBackgroundScreenLedVMS_2496x264);
          }
        });
      }
    });

    // Ensure playback unless jackpot hit
    _player.stream.playing.listen((playing) {
      if (!playing && mounted && context.read<JackpotBloc2>().state is! JackpotHitReceived) {
        _player.play();
      }
    });

    // Update initialization state
    _player.stream.width.listen((width) {
      if (width != null && width > 0 && mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    });
  }

  Future<void> _loadVideo(String videoPath) async {
    if (_currentVideoPath == videoPath) {
      if (_player.state.playing) return;
      debugPrint('JackpotBackgroundShowWindowFadeAnimateP: Resuming existing video: $videoPath');
      await _player.play();
      return;
    }

    try {
      await _player.pause();
      _currentVideoPath = videoPath;
      await _player.open(_media, play: false);
      await _player.setVolume(0.0);
      await _player.play();
      _retryCount = 0;
    } catch (error) {
      if (mounted && _retryCount < _maxRetries) {
        _retryCount++;
        setState(() {
          _isInitialized = false;
          _currentVideoPath = null;
        });
        Future.delayed(const  Duration(seconds: 50), () {
          if (mounted) {
            _loadVideo(videoPath);
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _player.pause();
    _player.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // final jackpotState = context.read<JackpotBloc2>().state;
    // if (jackpotState is JackpotHitReceived) {
    //   _player.pause();
    // } else if (!_player.state.playing) {
    //   _player.play();
    // }
    debugPrint('JackpotBackgroundShowWindowFadeAnimateP: didChangeDependencies called');
    if (!_player.state.playing) {
      debugPrint('JackpotBackgroundShowWindowFadeAnimateP: Resuming video as no hit is active');
      _player.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<JackpotBloc2, JackpotState2, ({Map<String, dynamic>? latestHit, bool showImagePage})>(
      selector: (state) => (latestHit: state.latestHit, showImagePage: state.showImagePage),
      builder: (context, data) {
        if (data.showImagePage && data.latestHit != null) {
          debugPrint('JackpotBackgroundShowWindowFadeAnimateP: Hiding background due to active hit: ${data.latestHit}');
          return Container();
        }
        debugPrint('JackpotBackgroundShowWindowFadeAnimateP: Displaying background');
        return BlocSelector<VideoBloc, ViddeoState, ({String currentVideo, int count, bool isRestart})>(
          selector: (state) => (
            currentVideo: state.currentVideo,
            count: state.count,
            isRestart: state.isRestart,
          ),
          builder: (context, value) {
            if (_currentVideoPath != value.currentVideo && !context.read<JackpotBloc2>().state.showImagePage) {
              debugPrint('JackpotBackgroundShowWindowFadeAnimateP: Loading new video from VideoBloc: ${value.currentVideo}');
              _loadVideo(value.currentVideo);
            }
            debugPrint('JackpotBackgroundShowWindowFadeAnimateP: Rendering UI, currentVideo=${value.currentVideo}, count=${value.count}, isRestart=${value.isRestart}');
            return SizedBox.expand(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _isInitialized
                      ? RepaintBoundary(
                          child: Video(
                            fill: Colors.transparent,
                            controls: (state) => Container(),
                            controller: _controller,
                            fit: BoxFit.fill,
                          ),
                        )
                      : circularProgessCustom(),
                  // const RepaintBoundary(child: JackpotDisplayScreenLedHD1920x1080()),
                  const RepaintBoundary(child: JackpotDisplayScreen2496x624()),

                  Positioned(
                    bottom: 42,
                    left: 42,
                    child: Text(
                      value.isRestart == true ? '?' : '${value.count}',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
