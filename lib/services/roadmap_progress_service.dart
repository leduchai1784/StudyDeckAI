import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../features/grammar/data/grammar_lessons_data.dart';
import 'flashcard_progress_service.dart';
import 'survey_service.dart';

class RoadmapDailyGoalSummary {
  final int targetLessons;
  final int completedLessons;
  final int remainingLessons;
  final double progressPercent;
  final String timeGoalLabel;
  final String subtitle;
  final String nextLessonId;
  final String nextLessonTitle;
  final String nextLessonRoute;

  const RoadmapDailyGoalSummary({
    required this.targetLessons,
    required this.completedLessons,
    required this.remainingLessons,
    required this.progressPercent,
    required this.timeGoalLabel,
    required this.subtitle,
    required this.nextLessonId,
    required this.nextLessonTitle,
    required this.nextLessonRoute,
  });
}

class RoadmapProgressService {
  static final RoadmapProgressService _instance = RoadmapProgressService._internal();
  factory RoadmapProgressService() => _instance;
  RoadmapProgressService._internal();

  final SurveyService _surveyService = SurveyService();
  final FlashcardProgressService _flashcardProgressService = FlashcardProgressService();

  static const String _completedLessonsPrefix = 'studydeck_completed_lessons_v1_';
  static const String _allCompletedLessonsKey = 'studydeck_all_completed_lessons_v1';

  static String _todayKey() {
    final now = DateTime.now();
    return '$_completedLessonsPrefix${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  Future<List<String>> getTodayCompletedLessonIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_todayKey()) ?? [];
  }

  Future<int> getTodayCompletedLessonsCount() async {
    final list = await getTodayCompletedLessonIds();
    return list.length;
  }

  Future<Set<String>> getAllCompletedLessonIds() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_allCompletedLessonsKey) ?? [];
    return list.toSet();
  }

  Future<void> recordLessonCompleted(
    String lessonId, {
    int durationMinutes = 15,
    String? lessonTitle,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final today = await getTodayCompletedLessonIds();

    if (!today.contains(lessonId)) {
      today.add(lessonId);
      await prefs.setStringList(_todayKey(), today);
    }

    final all = await getAllCompletedLessonIds();
    if (!all.contains(lessonId)) {
      all.add(lessonId);
      await prefs.setStringList(_allCompletedLessonsKey, all.toList());
    }

    // Trigger streak & active study date update
    await _flashcardProgressService.recordTodayStudyActivity();
  }

  Future<RoadmapDailyGoalSummary> getDailyGoalSummary() async {
    await _surveyService.loadSurveyData();
    final target = _surveyService.dailyLessonTarget;
    final completed = await getTodayCompletedLessonsCount();
    final remaining = max(0, target - completed);
    final percent = target > 0 ? (completed / target).clamp(0.0, 1.0) : 0.0;
    final timeLabel = _surveyService.studyTimeLabel;

    String subtitle;
    if (completed >= target) {
      subtitle = '🎉 Tuyệt vời! Bạn đã hoàn thành mục tiêu $target bài học hôm nay!';
    } else {
      subtitle = 'Còn $remaining bài học lộ trình nữa để hoàn thành mục tiêu $timeLabel!';
    }

    // Determine next roadmap lesson
    final allCompleted = await getAllCompletedLessonIds();
    final grammarLessons = GrammarLessonsData.getAllLessons();

    String nextId = 'grm_word_forms';
    String nextTitle = 'Word Forms — Dạng thức từ';
    String nextRoute = '/grammar/lesson';

    for (final l in grammarLessons) {
      if (!allCompleted.contains(l.id)) {
        nextId = l.id;
        nextTitle = l.title;
        break;
      }
    }

    return RoadmapDailyGoalSummary(
      targetLessons: target,
      completedLessons: completed,
      remainingLessons: remaining,
      progressPercent: percent,
      timeGoalLabel: timeLabel,
      subtitle: subtitle,
      nextLessonId: nextId,
      nextLessonTitle: nextTitle,
      nextLessonRoute: nextRoute,
    );
  }
}
