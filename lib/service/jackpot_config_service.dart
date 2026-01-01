import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class JackpotConfigService {
  static final JackpotConfigService _instance =
      JackpotConfigService._internal();
  factory JackpotConfigService() => _instance;
  JackpotConfigService._internal();

  static const String _configFileName = 'setting.json';
  static const String _assetPath = 'assets/config/setting.json';

  Map<String, dynamic>? _config;

  /// Call once on app start
  Future<void> initialize() async {
    debugPrint('? JackpotConfigService: Initializing (no version mode)');

    final docDir = await getApplicationDocumentsDirectory();
    final configFile = File(path.join(docDir.path, _configFileName));

    try {
      // Always load asset
      final assetJson = await rootBundle.loadString(_assetPath);

      // Always overwrite document config
      await configFile.writeAsString(assetJson);

      debugPrint('? setting.json copied from assets');
      debugPrint('? Path: ${configFile.path}');
    } catch (e) {
      debugPrint('? Failed to copy asset config: $e');
    }

    await _loadConfig();
  }

  /// Reload document config only
  Future<void> reload() async {
    debugPrint('? Reload config from documents');
    await _loadConfig();
  }

  Future<void> _loadConfig() async {
    try {
      final docDir = await getApplicationDocumentsDirectory();
      final configFile = File(path.join(docDir.path, _configFileName));

      if (!await configFile.exists()) {
        debugPrint('? setting.json not found in documents');
        _config = null;
        return;
      }

      final content = await configFile.readAsString();
      final jsonObject = json.decode(content) as Map<String, dynamic>;

      _config = jsonObject;

      final prettyJson =
          const JsonEncoder.withIndent('  ').convert(jsonObject);

      debugPrint('? setting.json LOADED');
      debugPrint('? Content:\n$prettyJson');
    } catch (e, stack) {
      debugPrint('? FAILED to load setting.json: $e');
      debugPrint('$stack');
      _config = null;
    }
  }

  // ====================== GETTERS ======================

  Map<String, String> get defaultHotSeatValues {
    final map =
        _config?['defaultHotSeatValues'] as Map<String, dynamic>? ?? {};
    return map.map((k, v) => MapEntry(k, v.toString()));
  }

  String? getDefaultHotSeatValue(String id) {
    return defaultHotSeatValues[id];
  }

  String getHitVideoPathLedStair(String id) {
    final videos = _config?['hitVideosLedStair'] as Map<String, dynamic>? ?? {};
    return videos[id]?.toString() ??
        videos['default']?.toString() ??
        'asset/video/led_stair/hit.mp4';
  }
  //MARX
  String getHitVideoPathLedMarX(String id) {
    final videos = _config?['hitVideosLedMarX'] as Map<String, dynamic>? ?? {};
    return videos[id]?.toString() ??
        videos['default']?.toString() ??
        'asset/video/led_atm/hit.mp4';
  }
  //ATM
  String getHitVideoPathLedATM(String id) {
    final videos = _config?['hitVideosLedATM'] as Map<String, dynamic>? ?? {};
    return videos[id]?.toString() ??
        videos['default']?.toString() ??
        'asset/video/led_atm/hit.mp4';
  }
  //CURVED
  String getHitVideoPathLedCurved(String id) {
    final videos = _config?['hitVideosLedCurved'] as Map<String, dynamic>? ?? {};
    return videos[id]?.toString() ??
        videos['default']?.toString() ??
        'asset/video/led_curved/hit.mp4';
  }

  //NONSMOKE
  String getHitVideoPathLedNonSmoke(String id) {
    final videos = _config?['hitVideosLedNonSmoke'] as Map<String, dynamic>? ?? {};
    return videos[id]?.toString() ??
        videos['default']?.toString() ??
        'asset/video/led_non_smoke/hit.mp4';
  }
   //BankEnd
  String getHitVideoPathLedBankEnd(String id) {
    final videos = _config?['hitVideosLedBankEnd'] as Map<String, dynamic>? ?? {};
    return videos[id]?.toString() ??
        videos['default']?.toString() ??
        'asset/video/led_non_smoke/hit.mp4';
  }



  String getHitVideoPathLedCustom(String id) {
    final videos = _config?['hitVideosLedCustom'] as Map<String, dynamic>? ?? {};
    return videos[id]?.toString() ??
        videos['default']?.toString() ??
        'asset/video/led_stair/hit.mp4';
  }

  String getHitVideoPathLedWings(String id) {
    final videos = _config?['hitVideosLedWings'] as Map<String, dynamic>? ?? {};
    return videos[id]?.toString() ??
        videos['default']?.toString() ??
        'asset/video/led_wings/hit/hit.mp4';
  }
  String getHitVideoPathLedVMS(String id) {
    final videos = _config?['hitVideosLedVMS'] as Map<String, dynamic>? ?? {};
    return videos[id]?.toString() ??
        videos['default']?.toString() ??
        'asset/video/led_vms_2496x264/hit/hit.mp4';
  }



  int getDuration(String id) {
    final durations = _config?['durations'] as Map<String, dynamic>? ?? {};
    return durations[id] is int ? durations[id] as int : 30;
  }

  bool requiresCountdown(String id) {
    final list = _config?['countdownIds'] as List<dynamic>? ?? [];
    return list.contains(id);
  }

  Map<String, dynamic>? get rawConfig => _config;
}
