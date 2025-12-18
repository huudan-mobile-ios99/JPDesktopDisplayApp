import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:playtech_transmitter_app/service/config_custom.dart';

class JackpotHiveService {
  static const String _jackpotBoxName = 'jackpotBox';
  static const String _jackpotHistoryKey = 'jackpotHistory';

  Future<void> initHive() async {
    try {
      await Hive.initFlutter();
      if (!Hive.isBoxOpen(_jackpotBoxName)) {
        await Hive.openBox(_jackpotBoxName);
      }
      // debugPrint('Hive initialized for jackpotBox');
    } catch (e) {
      // debugPrint('JackpotHiveService: Error initializing Hive: $e');
      rethrow;
    }
  }

  //Get JackPot History
  Future<List<Map<String, double>>> getJackpotHistory() async {
  final start = DateTime.now();
  try {
    const String jackpotBoxName = 'jackpotBox';
    const String jackpotHistoryKey = 'jackpotHistory';
    const int maxRecords = 10; // Limit to 10 records

    if (!Hive.isBoxOpen(jackpotBoxName)) {
      debugPrint('Jackpot box not open, attempting to open.');
      await Hive.openBox(jackpotBoxName);
    }
    final box = Hive.box(jackpotBoxName);
    final historyRaw = box.get(jackpotHistoryKey, defaultValue: []) as List;
    debugPrint('Total records in jackpot history: ${historyRaw.length}');

    // Trim history to last 10 entries if over limit
    if (historyRaw.length > maxRecords) {
      final trimmedHistory = historyRaw.sublist(historyRaw.length - maxRecords);
      await box.put(jackpotHistoryKey, trimmedHistory);
      // debugPrint('Trimmed history to last $maxRecords entries');
    }

    // Parse and filter valid history entries
    final List<Map<String, double>> history = [];
    for (var item in historyRaw) {
      if (item is Map && item['values'] is Map) {
        final values = <String, double>{};
        item['values'].forEach((key, value) {
          if (key is String && value is num && value != 0.0) {
            values[key] = value.toDouble();
          }
        });
        if (values.isNotEmpty) {
          history.add(values);
        }
      }
    }

    // Deduplicate entries based on exact key-value equality
    final List<Map<String, double>> uniqueHistory = [];
    final Set<String> seen = {};

    for (var entry in history.reversed) { // Process in reverse chronological order
      // Convert entry to a canonical string for comparison
      final sortedKeys = entry.keys.toList()..sort();
      final canonical = sortedKeys.map((k) => '$k:${entry[k]}').join('|');
      if (!seen.contains(canonical)) {
        seen.add(canonical);
        uniqueHistory.add(entry);
      }
      // Stop once we have 3 unique entries
      if (uniqueHistory.isNotEmpty) break;
    }

    // Reverse back to chronological order (newest last)
    final result = uniqueHistory.reversed.toList();
    // debugPrint('Retrieved unique jackpot history: ${result.length} entries');
    return result;
  } catch (e) {
    debugPrint('Error retrieving jackpot history: $e');
    return [];
  } finally {
    final end = DateTime.now();
    debugPrint('getJackpotHistory took: ${end.difference(start).inMilliseconds}ms');
  }
}





  Future<void> saveJackpotValues(Map<String, double> values) async {
    try {
      final box = await Hive.openBox(_jackpotBoxName);
      final historyRaw = box.get(_jackpotHistoryKey, defaultValue: []) as List;
      final filteredValues = <String, double>{};

      values.forEach((key, value) {
        if (value != 0.0 && ConfigCustom.validJackpotNames.contains(key)) {
          filteredValues[key] = value;
        }
      });

      if (filteredValues.isNotEmpty) {
        Map<String, double> lastValues = {};
        if (historyRaw.isNotEmpty && historyRaw.last is Map) {
          final last = historyRaw.last;
          if (last['values'] is Map) {
            last['values'].forEach((k, v) {
              if (k is String && v is num) lastValues[k] = v.toDouble();
            });
          }
        }
        filteredValues.addAll(lastValues..removeWhere((k, v) => filteredValues.containsKey(k)));

        historyRaw.add({
          'values': filteredValues,
          'timestamp': DateTime.now().toIso8601String(),
        });
        await box.put(_jackpotHistoryKey, historyRaw);
      }
    } catch (e) {
      rethrow;
    }
  }



  // In JackpotHiveService.dart ? REPLACE appendJackpotHistory()
Future<void> saveFullJackpotState(Map<String, double> fullValues) async {
  try {
    final box = await Hive.openBox(_jackpotBoxName);
    final historyRaw = box.get(_jackpotHistoryKey, defaultValue: <Map<String, dynamic>>[]) as List;

    // Filter out 0.0 and invalid keys
    final cleanedValues = <String, double>{};
    fullValues.forEach((key, value) {
      if (value > 0.0 && ConfigCustom.validJackpotNames.contains(key)) {
        cleanedValues[key] = value;
      }
    });

    if (cleanedValues.isEmpty) return;

    // Always save full state ? even if same as last
    historyRaw.add({
      'values': Map<String, double>.from(cleanedValues),
      'timestamp': DateTime.now().toIso8601String(),
    });

    // Keep only last 10
    if (historyRaw.length > 10) {
      historyRaw.removeRange(0, historyRaw.length - 10);
    }

    await box.put(_jackpotHistoryKey, historyRaw);
    // debugPrint('JackpotHiveService: FULL STATE saved to Hive: $cleanedValues');
  } catch (e) {
    // debugPrint('JackpotHiveService: Failed to save full state: $e');
    rethrow;
  }
}

  Future<void> appendJackpotHistory(Map<String, double> values) async {
    try {
      final box = await Hive.openBox(_jackpotBoxName);
      final historyRaw = box.get(_jackpotHistoryKey, defaultValue: []) as List;
      final filteredValues = <String, double>{};
      // Filter valid values
      values.forEach((key, value) {
        if (value != 0.0 && ConfigCustom.validJackpotNames.contains(key)) {
          filteredValues[key] = value;
        }
      });
      if (filteredValues.isNotEmpty) {
        // Get last saved values
        Map<String, double> lastValues = {};
        if (historyRaw.isNotEmpty && historyRaw.last is Map) {
          final last = historyRaw.last;
          if (last['values'] is Map) {
            last['values'].forEach((k, v) {
              if (k is String && v is num) lastValues[k] = v.toDouble();
            });
          }
        }

        // Compare new values with last saved values
        bool isDifferent = false;
        if (lastValues.isEmpty) {
          isDifferent = true; // Save if no previous data
        } else {
          // Check if keys are the same
          if (filteredValues.keys.toSet().difference(lastValues.keys.toSet()).isEmpty &&
              lastValues.keys.toSet().difference(filteredValues.keys.toSet()).isEmpty) {
            // Check if values differ for any key
            for (var key in filteredValues.keys) {
              if (filteredValues[key] != lastValues[key]) {
                isDifferent = true;
                break;
              }
            }
          } else {
            isDifferent = true; // Different keys
          }
        }

        if (isDifferent) {
          historyRaw.add({
            'values': filteredValues,
            'timestamp': DateTime.now().toIso8601String(),
          });
          await box.put(_jackpotHistoryKey, historyRaw);
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> clearHive() async {
  try {
    if (!Hive.isBoxOpen(_jackpotBoxName)) {
      await Hive.openBox(_jackpotBoxName);
    }
    final box = Hive.box(_jackpotBoxName);
    await box.clear();
    debugPrint('JackpotHiveService: Cleared all data from $_jackpotBoxName');
  } catch (e) {
    debugPrint('JackpotHiveService: Error clearing hive data: $e');
    rethrow;
  }
}
}
