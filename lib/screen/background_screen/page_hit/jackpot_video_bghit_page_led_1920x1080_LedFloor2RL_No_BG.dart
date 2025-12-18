




import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:playtech_transmitter_app/screen/background_screen/page_hit/jackpot_text_display_RL_floor2.dart';
import 'package:playtech_transmitter_app/service/config_custom.dart';
import 'package:playtech_transmitter_app/service/widget/text_style.dart';

class JackpotBackgroundVideoHitLedRLFLOOR2NoBG extends StatefulWidget {
  final String number;
  final String value;
  final String id;

  const JackpotBackgroundVideoHitLedRLFLOOR2NoBG({
    super.key,
    required this.number,
    required this.value,
    required this.id,
  });

  @override
  _JackpotBackgroundVideoHitLedRLFLOOR2NoBGState createState() => _JackpotBackgroundVideoHitLedRLFLOOR2NoBGState();
}

class _JackpotBackgroundVideoHitLedRLFLOOR2NoBGState extends State<JackpotBackgroundVideoHitLedRLFLOOR2NoBG>
   {
  late final Player _player;
  late final VideoController _controller;
  final NumberFormat _numberFormat = NumberFormat('#,##0.00', 'en_US');
  String? _currentVideoPath;
  bool _isSwitching = false;
  bool _isInitialized = false;

  int _retryCount = 0;
  static const int _maxRetries = 10;
  final Map<String, Media> _mediaCache = {};


  String getVideoAssetPath(String id) {
    switch (id) {
      
      case '40': //rl grand
        return ConfigCustom.videoHITLedRLFLOOR2;
      case '41': //rl major
        return ConfigCustom.videoHITLedRLFLOOR2;
      case '43': //rl vegas
        return ConfigCustom.videoHITLedRLFLOOR2;
      
      // case '80': //tripple 777 price
      //   return ConfigCustom.videoHITLedRLFLOOR2;
      // case '81':
      //   return ConfigCustom.videoHITLedRLFLOOR2;
      // case '88': //1000 price jackpot town
      //   return ConfigCustom.videoHITLedRLFLOOR2;
      // case '89':
        // return ConfigCustom.videoHITLedRLFLOOR2;
      case '97': //ppochi video
        return ConfigCustom.videoHITLedRLFLOOR2;
      case '98':
        return ConfigCustom.videoHITLedRLFLOOR2;
      case '109':
        return ConfigCustom.videoHITLedRLFLOOR2;
      case '119':
        return ConfigCustom.videoHITLedRLFLOOR2;
      // case '121':
      //   return ConfigCustom.videoHITLedRLFLOOR2;
      // case '122':
      //   return ConfigCustom.videoHITLedRLFLOOR2;
      // case '123':
      //   return ConfigCustom.videoHITLedRLFLOOR2;
      default:
        return ConfigCustom.videoHITLedRLFLOOR2;
    }
  }

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
      _loadVideo(getVideoAssetPath(widget.id));
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
            _loadVideo(getVideoAssetPath(widget.id));
          }
        });
      }
    });

     // Ensure playback continues unless explicitly stopped
    _player.stream.playing.listen((playing) {
      if (!playing && mounted && _isInitialized) {
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

  @override
  void didUpdateWidget(JackpotBackgroundVideoHitLedRLFLOOR2NoBG oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.id != oldWidget.id) {
      _loadVideo(getVideoAssetPath(widget.id));
    }
  }

  Future<void> _loadVideo(String videoPath) async {
    if (_currentVideoPath == videoPath || _isSwitching) {
      if (_player.state.playing) return;
      await _player.setVolume(100.0);
      await _player.play();
      return;
    }

    _isSwitching = true;
    try {
      await _player.pause();
      await Future.delayed(const Duration(milliseconds: 50)); // Delay to stabilize libmpv
      _currentVideoPath = videoPath;
      Media media = _mediaCache.putIfAbsent(videoPath, () => Media('asset://$videoPath'));
      await _player.open(media, play: true);
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
          _currentVideoPath = null;
        });
        Future.delayed(const Duration(milliseconds: 50), () {
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
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return
    SizedBox(
      width: screenSize.width,
      height: screenSize.height, // Full screen container
      child: Stack(
        children: [
          _isInitialized? Video(
            fill: Colors.transparent,
            controls: (state) => Container(),
            controller: _controller,
            filterQuality: FilterQuality.none,
            fit: BoxFit.fill,
            width: screenSize.width,
            height: screenSize.height,
          ):Container(),
          

          // LED STAIR 1920x1080
          if (_isInitialized)
            Positioned(
            top:0,bottom:0,
            left:0,right:0,
            child: JackpotTextDisplayFullRLFloor2(
              number: widget.number,
              value: widget.value,
            ),
          ),
        ],
      ),
    );
  }
}
