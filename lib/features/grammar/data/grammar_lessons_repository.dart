import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/grammar_lesson_model.dart';

class GrammarLessonsRepository {
  static final GrammarLessonsRepository instance = GrammarLessonsRepository._();
  GrammarLessonsRepository._();

  List<GrammarLessonModel>? _cachedLessons;

  /// Nạp toàn bộ bài học từ assets/data/grammar_lessons.json (có cache)
  Future<List<GrammarLessonModel>> getAllLessons() async {
    if (_cachedLessons != null) {
      return _cachedLessons!;
    }

    try {
      final jsonString = await rootBundle.loadString('assets/data/grammar_lessons.json');
      final dynamic raw = jsonDecode(jsonString);

      if (raw is List) {
        _cachedLessons = raw
            .map((item) => GrammarLessonModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        _cachedLessons = [];
      }
      return _cachedLessons!;
    } catch (e) {
      return [];
    }
  }

  /// Lấy 25 chủ đề Ngữ pháp toàn tập (Reference)
  Future<List<GrammarLessonModel>> getReferenceLessons() async {
    final all = await getAllLessons();
    return all.where((l) => l.category == 'reference').toList();
  }

  /// Lấy các bài học Ngữ pháp nâng cao (Advanced)
  Future<List<GrammarLessonModel>> getAdvancedLessons() async {
    final all = await getAllLessons();
    return all.where((l) => l.category == 'advanced').toList();
  }

  /// Lấy bài học theo ID hoặc Slug
  Future<GrammarLessonModel?> getLessonById(String id) async {
    final all = await getAllLessons();
    try {
      return all.firstWhere((l) => l.id == id || l.slug == id);
    } catch (_) {
      return null;
    }
  }

  /// Xóa cache khi cần nạp lại dữ liệu
  void clearCache() {
    _cachedLessons = null;
  }
}
