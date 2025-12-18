// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:media_kit/media_kit.dart';
// import 'package:media_kit_video/media_kit_video.dart';
// import 'package:playtech_transmitter_app/screen/background_screen/bloc_socket_time/jackpot_bloc_socket.dart';
// import 'package:playtech_transmitter_app/screen/background_screen/bloc_socket_time/jackpot_event_socket.dart';
// import 'package:playtech_transmitter_app/screen/background_screen/page_background/jackpot_screen_page_hd_led_1920x1080.dart';

// import 'package:playtech_transmitter_app/service/config_custom.dart';
// import 'package:playtech_transmitter_app/screen/background_screen/bloc/video_bloc.dart';
// import 'package:playtech_transmitter_app/service/widget/circlar_progress.dart';


// class JackpotBackgroundShowWindowFadeAnimateP extends StatefulWidget {
//   const JackpotBackgroundShowWindowFadeAnimateP({super.key});

//   @override
//   _JackpotBackgroundShowWindowFadeAnimatePState createState() => _JackpotBackgroundShowWindowFadeAnimatePState();
// }

// class _JackpotBackgroundShowWindowFadeAnimatePState extends State<JackpotBackgroundShowWindowFadeAnimateP>
//     with SingleTickerProviderStateMixin {
//   late final Player _player;
//   late final VideoController _controller;
//   String? _currentVideoPath;
//   bool _isInitialized = false;
//   int _retryCount = 0;
//   static const int _maxRetries = 10;
//   final Media _media = Media('asset://${ConfigCustom.videoBackgroundScreenLedATM_1920x1080}');

//   @override
//   void initState() {
//     super.initState();
//     MediaKit.ensureInitialized();

//     // Initialize player and controller
//     _player = Player();
//     _controller = VideoController(
//       _player,
//       configuration: const VideoControllerConfiguration(
//         enableHardwareAcceleration: true,
//       ),
//     );

//     // Enable looping
//     _player.setPlaylistMode(PlaylistMode.loop);

//     // Load initial video
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _loadVideo(ConfigCustom.videoBackgroundScreenLedMARX_1920x1080);
//     });

//     // Handle errors
//     _player.stream.error.listen((error) {
//       if (mounted && _retryCount < _maxRetries) {
//         _retryCount++;
//         setState(() {
//           _isInitialized = false;
//           _currentVideoPath = null;
//         });
//         Future.delayed(const Duration(milliseconds: 100), () {
//           if (mounted) {
//             _loadVideo(ConfigCustom.videoBackgroundScreenLedATM_1920x1080);
//           }
//         });
//       }
//     });

//     // Ensure playback unless jackpot hit
//     _player.stream.playing.listen((playing) {
//       if (!playing && mounted && context.read<JackpotBloc2>().state is! JackpotHitReceived) {
//         _player.play();
//       }
//     });

//     // Update initialization state
//     _player.stream.width.listen((width) {
//       if (width != null && width > 0 && mounted) {
//         setState(() {
//           _isInitialized = true;
//         });
//       }
//     });
//   }

//   Future<void> _loadVideo(String videoPath) async {
//     if (_currentVideoPath == videoPath) {
//       if (_player.state.playing) return;
//       await _player.play();
//       return;
//     }

//     try {
//       await _player.pause();
//       _currentVideoPath = videoPath;
//       await _player.open(_media, play: false);
//       await _player.setVolume(0.0);
//       await _player.play();
//       _retryCount = 0;
//     } catch (error) {
//       if (mounted && _retryCount < _maxRetries) {
//         _retryCount++;
//         setState(() {
//           _isInitialized = false;
//           _currentVideoPath = null;
//         });
//         Future.delayed(const  Duration(seconds: 100), () {
//           if (mounted) {
//             _loadVideo(videoPath);
//           }
//         });
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _player.pause();
//     _player.dispose();
//     super.dispose();
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     final jackpotState = context.read<JackpotBloc2>().state;
//     if (jackpotState is JackpotHitReceived) {
//       _player.pause();
//     } else if (!_player.state.playing) {
//       _player.play();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocSelector<VideoBloc, ViddeoState, ({String currentVideo, int count, bool isRestart})>(
//       selector: (state) => (currentVideo: state.currentVideo, count: state.count, isRestart: state.isRestart,),
//       builder: (context, value) {
//         if (_currentVideoPath != value.currentVideo && context.read<JackpotBloc2>().state is! JackpotHitReceived) {
//           _loadVideo(value.currentVideo);
//         }
//         return  SizedBox.expand(
//           child: Stack(
//             fit: StackFit.expand,
//             children: [
//               _isInitialized
//                   ? RepaintBoundary(
//                       child: Video(
//                         fill: Colors.transparent,
//                         controls: (state) => Container(),
//                         controller: _controller,
//                         fit: BoxFit.fill,
//                       ),
//                     )
//                   : circularProgessCustom(), // turn this if want video
//               // const RepaintBoundary(child: JackpotDisplayScreen()), //LED WING
//               // const RepaintBoundary(child: JackpotDisplayScreen2496x624()), //LED VMS 2496x264
//               // const RepaintBoundary(child: JackpotDisplayScreenLedHD1920x1080()), //LED VMS 2496x264
//                const RepaintBoundary(child: JackpotDisplayScreenLedHD1920x1080()), //LED VMS 2496x264




//               Positioned(
//                 bottom: 42,
//                 left: 42,
//                 child: Text(
//                   value.isRestart == true ? '?' : '${value.count}  ',
//                   style: const TextStyle(color: Colors.white, fontSize: 16),
//                 ),
//               ),

//             ],
//           ),
//         );
//       },
//     );
//   }
// }
