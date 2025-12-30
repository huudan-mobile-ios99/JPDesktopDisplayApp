// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:playtech_transmitter_app/service/config_custom.dart';
// import 'package:playtech_transmitter_app/service/socket_service/socket_service.dart';
// import 'jackpot_event_socket.dart';
// import 'jackpot_state_socket.dart';

// class JackpotBloc2 extends Bloc<JackpotEvent2, JackpotState2> {
//   final SocketService _socketService;
//   Timer? _imagePageTimer;
//   StreamSubscription<bool>? _connectionSubscription;
//   StreamSubscription<Map<String, dynamic>>? _hitSubscription;
//   StreamSubscription<Map<String, dynamic>>? _initialConfigSubscription;
//   StreamSubscription<Map<String, dynamic>>? _updatedConfigSubscription;

//   JackpotBloc2({SocketService? socketService})
//       : _socketService = socketService ?? SocketService(),
//       super(const JackpotState2()) {

//     on<JackpotConnect>(_onConnect);
//     on<JackpotDisconnect>(_onDisconnect);
//     on<JackpotReconnect>(_onReconnect);
//     on<JackpotError>(_onError);
//     on<JackpotReconnectAttempt>(_onReconnectAttempt);
//     on<JackpotReconnectError>(_onReconnectError);
//     on<JackpotHitReceived>(_onHitReceived);
//     on<JackpotHideImagePage>(_onHideImagePage);
//     on<JackpotCountdownCompleted>(_onCountdownCompleted);

//     _initialize();
//   }

//   void _initialize() {
//     _socketService.initialize();
//     _listenToSocketEvents();
//   }

//   void _listenToSocketEvents() {
//     _connectionSubscription?.cancel();
//     _hitSubscription?.cancel();
//     _initialConfigSubscription?.cancel();
//     _updatedConfigSubscription?.cancel();

//     _connectionSubscription = _socketService.connectionStream.listen((isConnected) {
//       if (isConnected) {
//         add(JackpotConnect());
//       } else {
//         add(JackpotDisconnect());
//       }
//     }, onError: (error) {
//       add(JackpotError('Connection stream error: $error'));
//     });

//     _hitSubscription = _socketService.hitStream.listen((hit) {
//       add(JackpotHitReceived(hit));
//     }, onError: (error) {
//       debugPrint('JackpotBloc2: Hit stream error: $error');
//     });
//   }

//   // Duration configuration matching JackpotBackgroundVideoHitLedHD1920x1080
//   final Map<String, int> _durationConfig = {
//     '0': 29, // frequent
//     '1': 45, // daily
//     '2': 39, // dozen
//     '3': 42, // weekly
//     '4': 45, // vegas
//     '18': 30, // highlimit
//     '35': 37, // 36+1 daily golden
//     '34': 40, // 39+1 daily golden
//     '45': 30, // highlimit
//     '48': 30, // HigHLimit NEW  ---  (APPLIED CURRENT)
//     '46': 43, // 42+1monthly
//     '80': 29, //28+1 triple 777 price
//     '81': 29, //tripple 777
//     '88': 15, //14+1 1000 price jackpot town
//     '89': 15,// 1000 price jackpot town
//     '97': 11, // 10+1 ppochi video
//     '98': 11, // 10+1ppochi video
//     '109': 22,// 21+1 rl video
//     '119': 21,// 20+1slot video,
//     '121': 24,// 888 price
//     '122': 24,// 888 price
//     '123': 24,// 888 price
//     '43':20, // roulette vegas spin jp
//     '40':20, // roulette grand spin jp
//     '41':20, // roulette major spin jp
//   };
//   // Jackpot IDs that require countdown video
//   final List<String> _countdownIds = ['3', '4', '46','48']; // VEGAS WEEKLY , MONTHLY & NEW HIGH LIMIT

//   void _startDisplayTimer(String hitId) {
//     _imagePageTimer?.cancel();
//     final duration = _durationConfig.containsKey(hitId)
//         ? Duration(seconds: _durationConfig[hitId]!)
//         : const Duration(seconds: ConfigCustom.durationTimerVideoHitShow_Jackpot);
//     debugPrint('JackpotBloc2: Starting timer for jackpot ID: $hitId, duration: ${duration.inSeconds} seconds');
//     _imagePageTimer = Timer(duration, () {
//       add(JackpotHideImagePage());
//     });
//   }

//   Future<void> _onConnect(JackpotConnect event, Emitter<JackpotState2> emit) async {
//     debugPrint('JackpotBloc2: Connected to Socket.IO server');
//     emit(state.copyWith(
//       isConnected: true,
//       error: null,
//     ));
//   }

//   Future<void> _onDisconnect(JackpotDisconnect event, Emitter<JackpotState2> emit) async {
//     debugPrint('JackpotBloc2: Disconnected from Socket.IO server');
//     emit(state.copyWith(isConnected: false));
//   }

//   Future<void> _onReconnect(JackpotReconnect event, Emitter<JackpotState2> emit) async {
//     debugPrint('JackpotBloc2: Reconnected to Socket.IO server');
//     emit(state.copyWith(
//       isConnected: true,
//       error: null,
//     ));
//   }

//   Future<void> _onError(JackpotError event, Emitter<JackpotState2> emit) async {
//     debugPrint('JackpotBloc2: Socket.IO error: ${event.error}');
//     emit(state.copyWith(
//       error: event.error,
//       isConnected: false,
//     ));
//   }

//   Future<void> _onReconnectAttempt(JackpotReconnectAttempt event, Emitter<JackpotState2> emit) async {
//     debugPrint('JackpotBloc2: Reconnection attempt #${event.attempt}');
//   }

//   Future<void> _onReconnectError(JackpotReconnectError event, Emitter<JackpotState2> emit) async {
//     debugPrint('JackpotBloc2: Reconnection error: ${event.error}');
//     emit(state.copyWith(error: event.error));
//   }

//   Future<void> _onHitReceived(JackpotHitReceived event, Emitter<JackpotState2> emit) async {
//     debugPrint('JackpotBloc2: Received hit for jackpot ID: ${event.hit['id']}, data: ${event.hit}');
//     final hitId = event.hit['id']?.toString() ?? event.hit['jackpotId']?.toString() ?? 'unknown';
//     debugPrint('JackpotBloc2: Extracted hitId: $hitId');
//     final updatedHits = List<Map<String, dynamic>>.from(state.hits)..add(event.hit);

//     final requiresCountdown = _countdownIds.contains(hitId);

//     if (state.showImagePage) {
//       final updatedQueue = List<Map<String, dynamic>>.from(state.hitQueue ?? [])..add(event.hit);
//       debugPrint('JackpotBloc2: Queuing hit for jackpot ID: $hitId, current queue length: ${updatedQueue.length}');
//       emit(state.copyWith(
//         hits: updatedHits,
//         hitQueue: updatedQueue,
//         error: null,
//       ));
//     } else {
//       _startDisplayTimer(hitId);
//       emit(state.copyWith(
//         hits: updatedHits,
//         latestHit: event.hit,
//         showImagePage: true,
//         requiresCountdown: requiresCountdown,
//         error: null,
//       ));
//     }
//   }

//   Future<void> _onCountdownCompleted(JackpotCountdownCompleted event, Emitter<JackpotState2> emit) async {
//     debugPrint('JackpotBloc2: Countdown completed, switching to main video');
//     emit(state.copyWith(
//       requiresCountdown: false,
//     ));
//   }

//   Future<void> _onInitialConfigReceived(JackpotInitialConfigReceived event, Emitter<JackpotState2> emit) async {
//     debugPrint('JackpotBloc2: Received initialConfig: ${event.config}');
//     emit(state.copyWith(config: event.config));
//   }

//   Future<void> _onUpdatedConfigReceived(JackpotUpdatedConfigReceived event, Emitter<JackpotState2> emit) async {
//     debugPrint('JackpotBloc2: Received updatedConfig: ${event.config}');
//     if (event.config.containsKey('status')) {
//       final isConnected = event.config['status'] == 'connected';
//       emit(state.copyWith(
//         isConnected: isConnected,
//         error: null,
//       ));
//     } else if (event.config.containsKey('error')) {
//       emit(state.copyWith(error: event.config['error']));
//     } else {
//       emit(state.copyWith(config: event.config));
//     }
//   }

//   Future<void> _onHideImagePage(JackpotHideImagePage event, Emitter<JackpotState2> emit) async {
//     if (state.hitQueue?.isNotEmpty ?? false) {
//       final nextHit = state.hitQueue!.first;
//       final hitId = nextHit['id']?.toString() ?? nextHit['jackpotId']?.toString() ?? 'unknown';
//       final updatedQueue = List<Map<String, dynamic>>.from(state.hitQueue!)..removeAt(0);
//       final requiresCountdown = _countdownIds.contains(hitId);

//       debugPrint('JackpotBloc2: Hiding current video, displaying next queued hit for jackpot ID: $hitId, remaining queue length: ${updatedQueue.length}');
//       emit(state.copyWith(
//         latestHit: nextHit,
//         showImagePage: true,
//         hitQueue: updatedQueue,
//         requiresCountdown: requiresCountdown,

//       ));
//       _startDisplayTimer(hitId);
//     } else {
//       debugPrint('JackpotBloc2: Hiding video for jackpot ID: ${state.latestHit?['id'] ?? state.latestHit?['jackpotId'] ?? 'unknown'}, no more hits in queue');
//       emit(state.copyWith(
//         showImagePage: false,
//         latestHit: null,
//         requiresCountdown: false,
//       ));
//     }
//   }

//   @override
//   Future<void> close() async {
//     debugPrint('JackpotBloc2: Closing');
//     _imagePageTimer?.cancel();
//     _connectionSubscription?.cancel();
//     _hitSubscription?.cancel();
//     _initialConfigSubscription?.cancel();
//     _updatedConfigSubscription?.cancel();
//     _socketService.dispose();
//     return super.close();
//   }
// }
