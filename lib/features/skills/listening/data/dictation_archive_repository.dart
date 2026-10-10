import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/dictation_model.dart';
import 'listening_mock_data.dart';

class DictationArchiveRepository {
  static Map<String, DictationExercise>? _cache;
  static bool _isLoading = false;

  /// Nạp sẵn toàn bộ 171 bài luyện Dictation từ file JSON asset vào bộ nhớ cache
  static Future<void> ensureLoaded() async {
    if (_cache != null) return;
    if (_isLoading) {
      while (_isLoading) {
        await Future.delayed(const Duration(milliseconds: 40));
      }
      return;
    }

    _isLoading = true;
    try {
      final jsonStr = await rootBundle.loadString('assets/data/dictation_archive_lessons.json');
      final List<dynamic> list = jsonDecode(jsonStr) as List<dynamic>;
      final map = <String, DictationExercise>{};

      for (final item in list) {
        final exercise = DictationExercise.fromJson(item as Map<String, dynamic>);
        // Index theo dictKey (VD: dict_conv_399)
        map[exercise.id] = exercise;

        // Index theo lessonId (VD: conv_399)
        final lessonId = item['lessonId']?.toString();
        if (lessonId != null && lessonId.isNotEmpty) {
          map[lessonId] = exercise;
        }

        // Index theo raw numeric ID (VD: 399)
        final rawId = item['rawId']?.toString();
        if (rawId != null && rawId.isNotEmpty) {
          map[rawId] = exercise;
          map['dict_$rawId'] = exercise;
        }
      }

      _cache = map;
    } catch (e) {
      debugPrint('[DictationArchiveRepository] Error loading archive JSON: $e');
      _cache = {};
    } finally {
      _isLoading = false;
    }
  }

  /// Lấy bài tập Dictation theo ID bất kỳ (dictationId, lessonId hoặc ID số).
  /// Tự động nạp dữ liệu từ asset nếu chưa nạp. Fallback về ListeningMockData nếu không tìm thấy.
  static Future<DictationExercise> getExercise(String? id) async {
    if (id == null || id.isEmpty) {
      return ListeningMockData.dictationExercises.first;
    }

    await ensureLoaded();

    if (_cache != null && _cache!.containsKey(id)) {
      return _cache![id]!;
    }

    // Thử chuẩn hóa id (loại bỏ tiền tố dict_, conv_, gen_, num_, spell_)
    final cleanId = id.replaceAll(RegExp(r'^(dict_|conv_|gen_|num_|spell_)'), '');
    if (_cache != null && _cache!.containsKey(cleanId)) {
      return _cache![cleanId]!;
    }

    // Fallback trong mock data gốc
    try {
      return ListeningMockData.dictationExercises.firstWhere((e) => e.id == id);
    } catch (_) {
      return ListeningMockData.dictationExercises.first;
    }
  }

  /// Lấy đồng bộ từ cache nếu đã nạp trước
  static DictationExercise? getExerciseSync(String id) {
    if (_cache == null) return null;
    if (_cache!.containsKey(id)) return _cache![id];
    final cleanId = id.replaceAll(RegExp(r'^(dict_|conv_|gen_|num_|spell_)'), '');
    return _cache![cleanId];
  }

  /// Danh sách tất cả bài tập đã nạp (chỉ lấy unique theo exercise.id)
  static List<DictationExercise> get allExercises {
    if (_cache == null) return ListeningMockData.dictationExercises;
    final seen = <String>{};
    final list = <DictationExercise>[];
    for (final ex in _cache!.values) {
      if (!seen.contains(ex.id)) {
        seen.add(ex.id);
        list.add(ex);
      }
    }
    return list;
  }
}
