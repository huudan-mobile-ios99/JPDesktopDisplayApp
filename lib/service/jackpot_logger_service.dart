import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class JackpotDisplayLogger {
  static final JackpotDisplayLogger _instance =
      JackpotDisplayLogger._internal();
  factory JackpotDisplayLogger() => _instance;
  JackpotDisplayLogger._internal();

  // ================= CONFIG =================
  static const String _logDirName = 'logs';
  static const String _logFileName = 'jackpot_display_log.json';

  // Prevent duplicate logs
  String? _lastKey;

  // Log file path printed once
  bool _pathLogged = false;

  // ================= PUBLIC API =================

  /// Log jackpot or hotseat hit
  Future<void> logHit({
    required String id,
    required String number,
    required String value,
    required String videoPath,
  }) async {
    final hitKey = '$id|$number|$value|$videoPath';

    // ? Prevent duplicate spam
    if (_lastKey == hitKey) return;
    _lastKey = hitKey;

    try {
      // Get Documents directory
      final docDir = await getApplicationDocumentsDirectory();
      final logDir = Directory(path.join(docDir.path, _logDirName));

      // Create /logs if not exists
      if (!await logDir.exists()) {
        await logDir.create(recursive: true);
      }

      final logFile = File(path.join(logDir.path, _logFileName));

      // Log path once (easy to find on Windows)
      if (!_pathLogged) {
        debugPrint('? JACKPOT LOG FILE PATH: ${logFile.path}');
        _pathLogged = true;
      }

      // Build log entry
      final logEntry = {
        "timestamp": DateTime.now().toIso8601String(),
        "id": id,
        "number": number,
        "value": value,
        "type": _isHotSeat(value) ? "hotseat" : "jackpot",
        "video": videoPath,
        "platform": Platform.operatingSystem,
      };

      // Load existing logs
      List<dynamic> logs = [];
      if (await logFile.exists()) {
        final content = await logFile.readAsString();
        if (content.isNotEmpty) {
          logs = json.decode(content) as List<dynamic>;
        }
      }

      // Append
      logs.add(logEntry);

      // Save
      await logFile.writeAsString(
        const JsonEncoder.withIndent('  ').convert(logs),
      );

      debugPrint('? Jackpot log saved ? ${logEntry["type"]}');
    } catch (e) {
      debugPrint('? Failed to write jackpot log: $e');
    }
  }

  // ================= HELPERS =================

  bool _isHotSeat(String value) {
    return value == '0' || value == '0.0' || value == '0.00';
  }
}
