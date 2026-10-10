import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/writing_translation_model.dart';

class WritingTranslationRepository {
  static final WritingTranslationRepository instance = WritingTranslationRepository._();
  WritingTranslationRepository._();

  final Map<int, List<WritingTranslationExercise>> _cache = {};

  Future<List<WritingTranslationExercise>> getExercisesByStep(int step) async {
    if (_cache.containsKey(step)) {
      return _cache[step]!;
    }

    try {
      final jsonString = await rootBundle.loadString('assets/data/writing_translation_buoc$step.json');
      final dynamic raw = jsonDecode(jsonString);

      List<WritingTranslationExercise> list = [];
      if (raw is List) {
        list = raw.map((item) {
          return WritingTranslationExercise.fromJson(
            item as Map<String, dynamic>,
            defaultStep: step,
          );
        }).toList();
      }

      list.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
      _cache[step] = list;
      return list;
    } catch (e) {
      // Return empty list on failure or missing file
      return [];
    }
  }

  Future<WritingTranslationExercise?> getExerciseById(String exerciseId) async {
    int targetStep = 1;
    if (exerciseId.startsWith('buoc1-')) {
      targetStep = 1;
    } else if (exerciseId.startsWith('buoc2-')) {
      targetStep = 2;
    } else if (exerciseId.startsWith('buoc3-')) {
      targetStep = 3;
    } else if (exerciseId.startsWith('buoc4-')) {
      targetStep = 4;
    } else if (exerciseId.startsWith('buoc5-')) {
      targetStep = 5;
    }

    final exercises = await getExercisesByStep(targetStep);
    for (final ex in exercises) {
      if (ex.exerciseId == exerciseId || ex.id == exerciseId) {
        return ex;
      }
    }

    // Fallback: search all steps
    for (int s = 1; s <= 5; s++) {
      if (s == targetStep) continue;
      final exList = await getExercisesByStep(s);
      for (final ex in exList) {
        if (ex.exerciseId == exerciseId || ex.id == exerciseId) {
          return ex;
        }
      }
    }
    return null;
  }

  // --- Progress Tracking via SharedPreferences ---

  static const String _progressKeyPrefix = 'writing_trans_progress_';

  Future<Set<int>> getCompletedSentenceIndices(String exerciseId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList('$_progressKeyPrefix$exerciseId') ?? [];
      return list.map((e) => int.tryParse(e) ?? -1).where((e) => e >= 0).toSet();
    } catch (_) {
      return {};
    }
  }

  Future<void> markSentenceCompleted(String exerciseId, int sentenceIndex) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final current = await getCompletedSentenceIndices(exerciseId);
      current.add(sentenceIndex);
      await prefs.setStringList(
        '$_progressKeyPrefix$exerciseId',
        current.map((e) => e.toString()).toList(),
      );
    } catch (_) {}
  }

  Future<int> getCompletedCountForExercise(String exerciseId) async {
    final set = await getCompletedSentenceIndices(exerciseId);
    return set.length;
  }
}
