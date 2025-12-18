import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:playtech_transmitter_app/screen/background_screen/bloc_socket_time/jackpot_bloc_socket.dart';
import 'package:playtech_transmitter_app/screen/background_screen/bloc_socket_time/jackpot_event_socket.dart';
import 'package:playtech_transmitter_app/screen/background_screen/page_background/jackpot_screen_page.dart';
// import 'package:playtech_transmitter_app/screen/background_screen/bloc_socket_time/jackpot_state_socket.dart';
// import 'package:playtech_transmitter_app/screen/background_screen/page_background/jackpot_screen_page.dart';
import 'package:playtech_transmitter_app/screen/background_screen/page_background/jackpot_screen_page_1080x1920_lobby.dart';
import 'package:playtech_transmitter_app/screen/background_screen/page_background/jackpot_screen_page_1920x1080Floor3Mega_BACK.dart';
import 'package:playtech_transmitter_app/screen/background_screen/page_background/jackpot_screen_page_5200x1664Floor3Mega.dart';
import 'package:playtech_transmitter_app/screen/background_screen/page_background/jackpot_screen_page__hd_1920x1080_Custom_TripleDaily.dart';
import 'package:playtech_transmitter_app/screen/background_screen/page_background/jackpot_screen_page__hd_1920x1080_RL_FLOOR2.dart';
import 'package:playtech_transmitter_app/screen/background_screen/page_background/jackpot_screen_page_hd_led_1920x1080.dart';
import 'package:playtech_transmitter_app/screen/background_screen/page_background/jackpot_screen_page_horizontal_2496x264.dart';
import 'package:playtech_transmitter_app/screen/background_screen/page_hit/jackpot_hit_page_led_5200x1664Floor3Mega_No_BG.dart';
// import 'package:playtech_transmitter_app/screen/background_screen/page_background/jackpot_screen_page_hd_led_1920x1080.dart';
// import 'package:playtech_transmitter_app/screen/background_screen/page_background/jackpot_screen_page_horizontal_2496x264.dart';

import 'package:playtech_transmitter_app/service/config_custom.dart';
import 'package:playtech_transmitter_app/screen/background_screen/bloc/video_bloc.dart';
import 'package:playtech_transmitter_app/service/widget/circlar_progress.dart';


class JackpotBackgroundShowNoDelay extends StatefulWidget {
  const JackpotBackgroundShowNoDelay({super.key});
  @override
  _JackpotBackgroundShowNoDelayState createState() => _JackpotBackgroundShowNoDelayState();
}

class _JackpotBackgroundShowNoDelayState extends State<JackpotBackgroundShowNoDelay>
    with SingleTickerProviderStateMixin {
  late final Player _player;
  late final VideoController _controller;
  String? _currentVideoPath;
  bool _isInitialized = false;
  bool _isSwitching = false;
  int _retryCount = 0;
  static const int _maxRetries = 10;
  final Media _media1 = Media('asset://${ConfigCustom.videoBackgroundScreenLedVMS_2496x264}');
  final Media _media2 = Media('asset://${ConfigCustom.videoBackgroundScreenLedVMS_2496x264}');

  @override
  void initState() {
    super.initState();
    MediaKit.ensureInitialized();


    // Initialize player and controller
    _player = Player();
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
        Future.delayed(const Duration(milliseconds: 10), () {
          if (mounted) {
            _loadVideo(_currentVideoPath ?? ConfigCustom.videoBackgroundScreenLedVMS_2496x264);
          }
        });
      }
    });

    // Ensure playback unless jackpot hit
    _player.stream.playing.listen((playing) {
      if (!playing && mounted && context.read<JackpotBloc2>().state is! JackpotHitReceived && !_isSwitching) {
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
    if (_currentVideoPath == videoPath || _isSwitching) {
      if (_player.state.playing) return;
      await _player.play();
      return;
    }

    _isSwitching = true;
    try {
      await _player.pause();
      // await Future.delayed( const Duration(milliseconds: ConfigCustom.switchBetweeScreenDuration)); // Delay to stabilize libmpv
      await Future.delayed( const Duration(milliseconds: 1500)); // Delay to stabilize libmpv| 1.5s 

      _currentVideoPath = videoPath;
      final media = videoPath == ConfigCustom.videoBackgroundScreenLedVMS_2496x264 ? _media1 : _media2;
      await _player.open(media, play: false);
      await _player.setVolume(0.0);
      await _player.play();
      if (mounted) {
      }
      _retryCount = 0;
    } catch (error) {
      if (mounted && _retryCount < _maxRetries) {
        _retryCount++;
        setState(() {
          _isInitialized = false;
          _currentVideoPath = null;
        });
        Future.delayed(const Duration(milliseconds: 10), () {
          if (mounted) {
            _loadVideo(videoPath);
          }
        });
      }
    } finally {
      _isSwitching = false;
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
    final jackpotState = context.read<JackpotBloc2>().state;
    if (jackpotState is JackpotHitReceived) {
      // _player.pause();
    } else if (!_player.state.playing && !_isSwitching) {
      _player.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<VideoBloc, ViddeoState, ({String currentVideo, int count, bool isRestart})>(
          selector: (state) => (
            currentVideo: state.currentVideo,
            count: state.count,
            isRestart: state.isRestart,
          ),
          builder: (context, value) {
            if (_currentVideoPath != value.currentVideo && !context.read<JackpotBloc2>().state.showImagePage) {
              // debugPrint('JackpotBackgroundShowNoDelay: Loading new video from VideoBloc: ${value.currentVideo}');
              _loadVideo(value.currentVideo);
            }
            // debugPrint('JackpotBackgroundShowNoDelay: Rendering UI, currentVideo=${value.currentVideo}, count=${value.count}, isRestart=${value.isRestart}');
            return RepaintBoundary(
              child: SizedBox.expand(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _isInitialized
                        ? RepaintBoundary(
                            child: Video(
                              // fill: Colors.transparent,
                              controls: (state) => Container(),
                              controller: _controller,
                              fit: BoxFit.fill,
                            ),
                          )
                        : circularProgessCustom(),
                    // const RepaintBoundary(child: JackpotDisplayScreenLedHD1920x1080()),

                    // const RepaintBoundary(child: JackpotDisplayScreenLedLobbyHD1080x1920()),
                    // const RepaintBoundary(child: JackpotDisplayScreenLedRLFloor2HD()), //BANK END 
                    // const RepaintBoundary(child: JackpotDisplayScreenLedRLFloor2HD()),
                    

                    // const RepaintBoundary(child: JackpotDisplayScreenLedCustomTripleDaily()), //LED Custom Triple & Daily
                    // const RepaintBoundary(child: JackpotDisplayScreen1920x1080Floor3MegaBack()), //LED MEGA 3 FLOOR -BACK
                    // const RepaintBoundary(child: JackpotDisplayScreen()), // LED WINGS DISPLAY 
                    const RepaintBoundary(child: JackpotDisplayScreen2496x624()),
                    // const RepaintBoundary(child: JackpotDisplayScreenLedHD1920x1080()),

              
                    // RepaintBoundary(
                    //   child: Positioned(
                    //     bottom: 12,
                    //     left: 12,
                    //     child: Text(
                    //       value.isRestart == true ? '?' : '${value.count}',
                    //       style: const TextStyle(color: Colors.white, fontSize: 16),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            );
          },
        );
  }
}
