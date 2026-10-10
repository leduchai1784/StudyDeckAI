import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/reading_result_model.dart';

class ReadingProgressService {
  static const String _resultsKeyPrefix = 'reading_results_';
  static const String _allCompletedIdsKey = 'reading_completed_test_ids';

  Future<void> saveTestResult(ReadingTestResult result) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = jsonEncode(result.toJson());
    await prefs.setString('$_resultsKeyPrefix${result.testId}', jsonStr);

    final completedList = prefs.getStringList(_allCompletedIdsKey) ?? [];
    if (!completedList.contains(result.testId)) {
      completedList.add(result.testId);
      await prefs.setStringList(_allCompletedIdsKey, completedList);
    }
  }

  Future<ReadingTestResult?> getLatestResult(String testId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('$_resultsKeyPrefix$testId');
    if (raw == null) return null;
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return ReadingTestResult.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  Future<List<ReadingTestResult>> getAllResults() async {
    final prefs = await SharedPreferences.getInstance();
    final completedIds = prefs.getStringList(_allCompletedIdsKey) ?? [];
    final List<ReadingTestResult> list = [];

    for (final id in completedIds) {
      final result = await getLatestResult(id);
      if (result != null) list.add(result);
    }
    return list;
  }

  Future<Set<String>> getCompletedTestIds() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_allCompletedIdsKey) ?? []).toSet();
  }
}
