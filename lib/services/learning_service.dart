import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/constants/supabase_tables.dart';
import '../core/network/supabase_service.dart';
import '../models/course.dart';
import '../models/lesson.dart';

class LearningService {
  final SupabaseClient _client = SupabaseService.instance.client;

  // Fetch all courses
  Future<List<CourseModel>> fetchCourses() async {
    final response = await _client
        .from(SupabaseTables.courses)
        .select()
        .order('created_at', ascending: true);

    return (response as List).map((json) => CourseModel.fromJson(json)).toList();
  }

  // Fetch lessons by course ID
  Future<List<LessonModel>> fetchLessons(String courseId) async {
    final response = await _client
        .from(SupabaseTables.lessons)
        .select()
        .eq('course_id', courseId)
        .order('order_index', ascending: true);

    return (response as List).map((json) => LessonModel.fromJson(json)).toList();
  }

  // Record learning activity log
  Future<void> logActivity({
    required String userId,
    required String activityType,
    String? referenceId,
    int? durationSeconds,
    bool? isCorrect,
  }) async {
    await _client.from(SupabaseTables.learningLogs).insert({
      'user_id': userId,
      'activity_type': activityType,
      'reference_id': referenceId,
      'duration_seconds': durationSeconds,
      'is_correct': isCorrect,
      'created_at': DateTime.now().toIso8601String(),
    });
  }
}
