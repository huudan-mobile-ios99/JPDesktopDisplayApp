import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:playtech_transmitter_app/service/config_custom.dart';
import 'package:playtech_transmitter_app/service/jackpot_config_service.dart';
import 'package:playtech_transmitter_app/service/widget/text_style.dart';

class JackpotBackgroundVideoHit1920x1080Floor2 extends StatefulWidget {
  final String number;
  final String value;
  final String id;

  const JackpotBackgroundVideoHit1920x1080Floor2({
    super.key,
    required this.number,
    required this.value,
    required this.id,
  });

  @override
  _JackpotBackgroundVideoHit1920x1080Floor2State createState() => _JackpotBackgroundVideoHit1920x1080Floor2State();
}

class _JackpotBackgroundVideoHit1920x1080Floor2State extends State<JackpotBackgroundVideoHit1920x1080Floor2>
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


final  JackpotConfigService _configService = JackpotConfigService();
  /// Get video path from setting.json ? hitVideos
  String getVideoAssetPath(String id) {
    final String path = _configService.getHitVideoPathLedBankEnd(id);
    debugPrint('? Video Widget (Stair): getVideoAssetPath(id: $id) ? $path');
    return path;
  }
  // String getVideoAssetPath(String id) {
  //   switch (id) {
  //     case '0':
  //       return ConfigCustom.videoHitScreenLedFloor2;
  //     case '1':
  //       return ConfigCustom.videoHitScreenLedFloor2;
  //     case '2':
  //       return ConfigCustom.videoHitScreenLedFloor2;
  //     case '3':
  //       return ConfigCustom.videoHitScreenLedFloor2;
  //     case '4':
  //      return ConfigCustom.videoHitScreenLedFloor2;
  //     case '44':
  //      return ConfigCustom.videoHitScreenLedFloor2;
  //     case '46':
  //       return ConfigCustom.videoHitScreenLedFloor2;
  //     case '34':
  //       return ConfigCustom.videoHitScreenLedFloor2;
  //     case '35':
  //       return ConfigCustom.videoHitScreenLedFloor2;
  //     case '45':
  //       return ConfigCustom.videoHitScreenLedFloor2;
  //     case '48':
  //       return ConfigCustom.videoHitScreenLedFloor2; //New JP hightlimit
  //     case '41'://MAJOR SPIN
  //       return ConfigCustom.videoHitScreenLedFloor2;
  //     case '18':
  //       return ConfigCustom.videoHitScreenLedFloor2;
  //     case '80': //tripple 777 price
  //       return ConfigCustom.videoHitScreenLedFloor2;
  //     case '81':
  //       return ConfigCustom.videoHitScreenLedFloor2;
  //     case '88': //1000 price jackpot town
  //       return ConfigCustom.videoHitScreenLedFloor2;
  //     case '89':
  //       return ConfigCustom.videoHitScreenLedFloor2;
  //     case '97': //ppochi video
  //       return ConfigCustom.videoHitScreenLedFloor2;
  //     case '98':
  //       return ConfigCustom.videoHitScreenLedFloor2;
  //     case '109'://ppochi RL
  //       return ConfigCustom.videoHitScreenLedFloor2;
  //     case '119'://ppochi SLOT
  //       return ConfigCustom.videoHitScreenLedFloor2;
  //     default:
  //       return ConfigCustom.videoHitScreenLedFloor2;
  //   }
  // }

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
        Future.delayed(const Duration(milliseconds: 5), () {
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
  void didUpdateWidget(JackpotBackgroundVideoHit1920x1080Floor2 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.id != oldWidget.id) {
      _loadVideo(getVideoAssetPath(widget.id));
    }
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
      await Future.delayed(const Duration(milliseconds: 1)); // Delay to stabilize libmpv
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
        Future.delayed(const Duration(milliseconds: 1), () {
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
      height: ConfigCustom.fixHeight,
      child: Stack(
        // fit: StackFit.expand,
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
          

          //LED FLOOR 1920x1080
          if (_isInitialized)
            FutureBuilder(
              future: Future.delayed(const Duration(milliseconds: 1)),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Stack(
                    children: [
                        Positioned( //LED WINGS
                          left:  ConfigCustom.text_hit_price_dX_1920x1080_floor2,
                          top: ConfigCustom.text_hit_price_dY_1920x1080_floor2,
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              (widget.value == '0.00' || widget.value == '0' || widget.value == '0.0')
                                  ? ""
                                  : '\$${_numberFormat.format(num.parse(widget.value))}',
                              style: textStyleJPHit1920x1080Floor2,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Positioned(
                          top: ConfigCustom.text_hit_number_dY_1920x1080_floor2,
                          left: ConfigCustom.text_hit_number_dX_1920x1080_floor2,
                          child: Text(
                            '#${widget.number}',
                            style: textStyleJPHit1920x1080SmallFloor2,
                          ),
                        ),
                    ],
                  );
                }
                return Container(
                  width: screenSize.width,
                  height: screenSize.height,color:Colors.black
                );
              },
            ),
        ],
      ),
    );
  }
}
