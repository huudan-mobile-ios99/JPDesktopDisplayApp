import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:playtech_transmitter_app/screen/background_screen/page_hit/jackpot_text_display.dart';
import 'package:playtech_transmitter_app/service/config_custom.dart';
import 'package:playtech_transmitter_app/service/widget/text_style.dart';

class JackpotBackgroundVideoHit5200x1664LedFloor3Mega extends StatefulWidget {
  final String number;
  final String value;
  final String id;

  const JackpotBackgroundVideoHit5200x1664LedFloor3Mega({
    super.key,
    required this.number,
    required this.value,
    required this.id,
  });

  @override
  _JackpotBackgroundVideoHit5200x1664LedFloor3MegaState createState() => _JackpotBackgroundVideoHit5200x1664LedFloor3MegaState();
}




class _JackpotBackgroundVideoHit5200x1664LedFloor3MegaState extends State<JackpotBackgroundVideoHit5200x1664LedFloor3Mega>
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
      case '0':
        return ConfigCustom.videoHitScreenLedFloor3Mega;
      case '1':
        return ConfigCustom.videoHitScreenLedFloor3Mega;
      case '2':
        return ConfigCustom.videoHitScreenLedFloor3Mega;
      case '3':
        return ConfigCustom.videoHitScreenLedFloor3Mega;
      case '4':
       return ConfigCustom.videoHitScreenLedFloor3Mega;
      case '44':
       return ConfigCustom.videoHitScreenLedFloor3Mega;
      case '46':
        return ConfigCustom.videoHitScreenLedFloor3Mega;
      case '34':
        return ConfigCustom.videoHitScreenLedFloor3Mega;
      case '35':
        return ConfigCustom.videoHitScreenLedFloor3Mega;
      case '45':
        return ConfigCustom.videoHitScreenLedFloor3Mega;
      case '48':
        return ConfigCustom.videoHitScreenLedFloor3Mega;//new update
      case '41'://MAJOR SPIN
        return ConfigCustom.videoHitScreenLedFloor3Mega;
      case '18':
        return ConfigCustom.videoHitScreenLedFloor3Mega;
      case '80': //tripple 777 price
        return ConfigCustom.videoHitScreenLedFloor3Mega;
      case '81':
        return ConfigCustom.videoHitScreenLedFloor3Mega;
      case '88': //1000 price jackpot town
        return ConfigCustom.videoHitScreenLedFloor3Mega;
      case '89':
        return ConfigCustom.videoHitScreenLedFloor3Mega;
      case '97': //ppochi video
        return ConfigCustom.videoHitScreenLedFloor3Mega;
      case '98':
        return ConfigCustom.videoHitScreenLedFloor3Mega;
      case '109'://ppochi RL
        return ConfigCustom.videoHitScreenLedFloor3Mega;
      case '119'://ppochi SLOT
        return ConfigCustom.videoHitScreenLedFloor3Mega;
      case '121'://ppochi SLOT
        return ConfigCustom.videoHitScreenLedFloor3Mega;
      case '122'://ppochi SLOT
        return ConfigCustom.videoHitScreenLedFloor3Mega;
      case '123'://ppochi SLOT
        return ConfigCustom.videoHitScreenLedFloor3Mega;
      default:
        return ConfigCustom.videoHitScreenLedFloor3Mega;
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
  void didUpdateWidget(JackpotBackgroundVideoHit5200x1664LedFloor3Mega oldWidget) {
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
      await Future.delayed(const Duration(milliseconds: 20)); // Delay to stabilize libmpv
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
        Future.delayed(const Duration(milliseconds: 20), () {
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
        // fit: StackFit.expand,
        children: [
          _isInitialized? 
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: screenSize.width,
              height: screenSize.height/4, // Fixed video height
              child: Video(
                controller: _controller,
                fit: BoxFit.fitWidth, // Maintain aspect ratio, stretch width
                filterQuality: FilterQuality.low,
                controls: (_) => Container(),
              ),
            ),
          ):Container(),

          //LED STAIR 2080x1560
          // Separate, independent text layer
          JackpotTextDisplay(
            number: widget.number,
            value: widget.value,
          ),
          // if (_isInitialized)
          //   Align(
          //     alignment: Alignment.topCenter,
          //     child: SizedBox(
          //       width: screenSize.width,
          //       height: screenSize.height/5, // Fixed video height
          //       child: FutureBuilder(
          //         future: Future.delayed(const Duration(milliseconds: 20)),
          //         builder: (context, snapshot) {
          //           if (snapshot.connectionState == ConnectionState.done) {
          //             return Stack(
          //               children: [
          //                   Positioned( //LED WINGS
          //                     left:  ConfigCustom.text_hit_price_dX_1920x1080_ledFloor3Mega,
          //                     top: ConfigCustom.text_hit_price_dY_1920x1080_ledFloor3Mega,
          //                     child: Container(
          //                       alignment: Alignment.center,
          //                       child: Text(
          //                         (widget.value == '0.00' || widget.value == '0' || widget.value == '0.0')
          //                             ? ""
          //                             : '\$${_numberFormat.format(num.parse(widget.value))}',
          //                         style: textStyleJPHitFloor3Mega(context),
          //                         textAlign: TextAlign.center,
          //                         textScaleFactor: 1.0, // Prevent text stretching
          //                       ),
          //                     ),
          //                   ),
          //                   Positioned(
          //                     top: ConfigCustom.text_hit_number_dY_1920x1080_ledFloor3Mega,
          //                     left: ConfigCustom.text_hit_number_dX_1920x1080_ledFloor3Mega,
          //                     child: Text(
          //                       '#${widget.number}',
          //                       style: textStyleJPHitFloor3Mega(context),
          //                       textScaleFactor: 1.0, // Prevent text stretching
          //                     ),

          //                   ),
          //               ],
          //             );
          //           }
          //           return Container();
          //         },
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }
}



