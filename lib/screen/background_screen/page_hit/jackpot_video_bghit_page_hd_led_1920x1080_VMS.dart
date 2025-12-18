import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:playtech_transmitter_app/service/config_custom.dart';
import 'package:playtech_transmitter_app/service/widget/text_style.dart';

class JackpotBackgroundVideoHitLedHD1920x1080VMS_F extends StatefulWidget {
  final String number;
  final String value;
  final String id;

  const JackpotBackgroundVideoHitLedHD1920x1080VMS_F({
    super.key,
    required this.number,
    required this.value,
    required this.id,
  });

  @override
  _JackpotBackgroundVideoHitLedHD1920x1080VMS_FState createState() => _JackpotBackgroundVideoHitLedHD1920x1080VMS_FState();
}

class _JackpotBackgroundVideoHitLedHD1920x1080VMS_FState extends State<JackpotBackgroundVideoHitLedHD1920x1080VMS_F>
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
    // switch (id) {
    //   case '0':
    //     return ConfigCustom.jp_id_hit_all_2946x624;
    //   case '1':
    //     return ConfigCustom.jp_id_hit_all_2946x624;
    //   case '2':
    //     return ConfigCustom.jp_id_hit_all_2946x624;
    //   case '3':
    //     return ConfigCustom.jp_id_hit_all_2946x624;
    //   case '4':
    //    return ConfigCustom.jp_id_hit_all_2946x624;
    //   case '44':
    //    return ConfigCustom.jp_id_hit_all_2946x624;
    //   case '46':
    //     return ConfigCustom.jp_id_hit_all_2946x624;
    //   case '34':
    //     return ConfigCustom.jp_id_hit_all_2946x624;
    //   case '35':
    //     return ConfigCustom.jp_id_hit_all_2946x624;
    //   case '45':
    //     return ConfigCustom.jp_id_hit_all_2946x624;
    //   case '48':
    //     return ConfigCustom.jp_id_hit_all_2946x624; //New JP hightlimit
    //   case '18':
    //     return ConfigCustom.jp_id_hit_all_2946x624;
    //   case '80': //tripple 777 price _2946x624
    //     return ConfigCustom.jp_id_777_1st_video_path_2946x624;
    //   case '81':
    //     return ConfigCustom.jp_id_777_1st_video_path_2946x624;
    //   case '88': //1000 price jackpot town
    //     return ConfigCustom.jp_id_1000_1st_video_path_2946x624;
    //   case '89':
    //     return ConfigCustom.jp_id_1000_1st_video_path_2946x624;
    //   case '97': //ppochi video
    //     return ConfigCustom.jp_id_ppochi_Mon_Fri_video_path_2946x624;
    //   case '98':
    //     return ConfigCustom.jp_id_ppochi_Mon_Fri_video_path_2946x624;
    //   case '109'://rl 
    //     return ConfigCustom.jp_id_RL_ppochi_video_path_2946x624;
    //   case '119'://slot new
    //     return ConfigCustom.jp_id_New_20_ppochi_video_path_2946x624;
    //   case '121'://888 price
    //     return ConfigCustom.jp_id_888_video_path_2946x624;
    //   case '122':
    //     return ConfigCustom.jp_id_888_video_path_2946x624;
    //   case '123':
    //     return ConfigCustom.jp_id_888_video_path_2946x624;
    //   default: 
    //     return ConfigCustom.jp_id_hit_all_2946x624;
    // }

    switch (id) {
      case '0':
        return ConfigCustom.jp_id_hit_all_2946x624;
      case '1':
        return ConfigCustom.jp_id_hit_all_2946x624;
      case '2':
        return ConfigCustom.jp_id_hit_all_2946x624;
      case '3':
        return ConfigCustom.jp_id_hit_all_2946x624;
      case '4':
       return ConfigCustom.jp_id_hit_all_2946x624;
      case '44':
       return ConfigCustom.jp_id_hit_all_2946x624;
      case '46':
        return ConfigCustom.jp_id_hit_all_2946x624;
      case '34':
        return ConfigCustom.jp_id_hit_all_2946x624;
      case '35':
        return ConfigCustom.jp_id_hit_all_2946x624;
      case '45':
        return ConfigCustom.jp_id_hit_all_2946x624;
      case '48':
        return ConfigCustom.jp_id_hit_all_2946x624; //New JP hightlimit
      case '18':
        return ConfigCustom.jp_id_hit_all_2946x624;
      case '80': //tripple 777 price _2946x624
        return ConfigCustom.jp_id_hit_all_2946x624;
      case '81':
        return ConfigCustom.jp_id_hit_all_2946x624;
      case '88': //1000 price jackpot town
        return ConfigCustom.jp_id_hit_all_2946x624;
      case '89':
        return ConfigCustom.jp_id_hit_all_2946x624;
      case '97': //ppochi video
        return ConfigCustom.jp_id_hit_all_2946x624;
      case '98':
        return ConfigCustom.jp_id_hit_all_2946x624;
      case '109'://rl 
        return ConfigCustom.jp_id_hit_all_2946x624;
      case '119'://slot new
        return ConfigCustom.jp_id_hit_all_2946x624;
      case '121'://888 price
        return ConfigCustom.jp_id_hit_all_2946x624;
      case '122':
        return ConfigCustom.jp_id_hit_all_2946x624;
      case '123':
        return ConfigCustom.jp_id_hit_all_2946x624;
      default: 
        return ConfigCustom.jp_id_hit_all_2946x624;
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
  void didUpdateWidget(JackpotBackgroundVideoHitLedHD1920x1080VMS_F oldWidget) {
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
      // width: ConfigCustom.fixWidth_led_vms,
      // height: ConfigCustom.fixWidth_led_vms,
      width: ConfigCustom.fixWidth_led_vms,
      height: ConfigCustom.fixHeight_led_vms,
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
          

          //LED STAIR 1920x1080
          if (_isInitialized)
            FutureBuilder(
              future: Future.delayed(const Duration(milliseconds: 20)),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Stack(
                    children: [
                      //LED Curved 1920x1080
                      //LED STAIR 1920x1080
                        Positioned(
                          left:  ConfigCustom.text_hit_price_dX_2496x264,
                          top: ConfigCustom.text_hit_price_dY_2496x264,
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              (widget.value == '0.00' || widget.value == '0' || widget.value == '0.0' )
                                  ? ""
                                  : '\$${_numberFormat.format(num.parse(widget.value))}',
                              style: textStyleJPHit2496x264,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        widget.value == '0.00' || widget.value == '0' || widget.value == '0.0'?
                        Positioned(
                          top:ConfigCustom.text_hit_number_dY_2496x264_only_hotseat,
                          left:ConfigCustom.text_hit_number_dX_2496x264_only_hotseat,
                          child: Text(
                            widget.number,
                            style:textStyleJPHit2496x264SmallOnlyHotSeat
                          ),
                        )
                        :
                        Positioned(
                          top:ConfigCustom.text_hit_number_dY_2496x264,
                          left:ConfigCustom.text_hit_number_dX_2496x264,
                          child: Text(
                            '#${widget.number}',
                            style:textStyleJPHit2496x264Small,
                        ))
                    ],
                  );
                }
                return Container();
              },
            ),
        ],
      ),
    );
  }
}
