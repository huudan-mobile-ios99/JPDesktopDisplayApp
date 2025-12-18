import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:playtech_transmitter_app/service/config_custom.dart';
import 'package:playtech_transmitter_app/screen/background_screen/bloc_socket_time/jackpot_bloc_socket.dart';
import 'package:playtech_transmitter_app/screen/background_screen/bloc_socket_time/jackpot_event_socket.dart';

class JackpotCountdownVideo extends StatefulWidget {
  const JackpotCountdownVideo({super.key});

  @override
  _JackpotCountdownVideoState createState() => _JackpotCountdownVideoState();
}

class _JackpotCountdownVideoState extends State<JackpotCountdownVideo> {
  late final Player _player;
  late final VideoController _controller;
  bool _isInitialized = false;
  int _retryCount = 0;
  static const int _maxRetries = 10;

  @override
  void initState() {
    super.initState();
    MediaKit.ensureInitialized();
    _player = Player();
    _controller = VideoController(
      _player,
      configuration: const VideoControllerConfiguration(
        enableHardwareAcceleration: true,
      ),
    );

    // Load countdown video
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadVideo();
    });

    // Handle errors
    _player.stream.error.listen((error) {
      if (mounted && _retryCount < _maxRetries) {
        _retryCount++;
        setState(() {
          _isInitialized = false;
        });
        Future.delayed(const Duration(milliseconds: 5), () {
          if (mounted) {
            _loadVideo();
          }
        });
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

    // Notify bloc when countdown completes
    _player.stream.completed.listen((completed) {
      if (completed && mounted) {
        context.read<JackpotBloc2>().add(JackpotCountdownCompleted());
      }
    });
  }

  Future<void> _loadVideo() async {
    try {
      await _player.pause();
      await Future.delayed(const Duration(milliseconds: 5)); // Stabilize libmpv
      await _player.open(
        Media('asset://${ConfigCustom.videoCountDownHD}'),
        play: true,
      );
      await _player.setVolume(100.0);
      _retryCount = 0;
      if (mounted) {
        setState(() {
          _isInitialized = false; // Reset until width confirms initialization
        });
      }
    } catch (error) {
      if (mounted && _retryCount < _maxRetries) {
        _retryCount++;
        setState(() {
          _isInitialized = false;
        });
        Future.delayed(const Duration(milliseconds: 5), () {
          if (mounted) {
            _loadVideo();
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
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return SizedBox(
      // width: ConfigCustom.fixHeight_HD_led_curved,
      // height: ConfigCustom.fixHeight_HD_led_curved,
      width: ConfigCustom.fixHeight_HD_led_curved,
      height: ConfigCustom.fixHeight_HD_led_curved,
      // width: ConfigCustom.fixWidth_led_vms,
      // height: ConfigCustom.fixHeight_led_vms,
      //    width: ConfigCustom.fixWidth,
      // height: ConfigCustom.fixHeight,
      child: _isInitialized
          ? Video(
              fill: Colors.transparent,
              controls: (state) => Container(),
              controller: _controller,
              filterQuality: FilterQuality.none,
              fit: BoxFit.contain,
              width: screenSize.width,
              height: screenSize.height,
            )
          : Container(
            
          ),
    );
  }
}
