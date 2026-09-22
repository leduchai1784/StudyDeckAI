import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/constants/supabase_tables.dart';
import '../core/network/supabase_service.dart';
import '../models/vocabulary.dart';

class VocabularyService {
  final SupabaseClient _client = SupabaseService.instance.client;

  // Fetch vocabulary items by lesson
  Future<List<VocabularyModel>> fetchVocabularyByLesson(String lessonId) async {
    final response = await _client
        .from(SupabaseTables.vocabulary)
        .select()
        .eq('lesson_id', lessonId);

    return (response as List).map((json) => VocabularyModel.fromJson(json)).toList();
  }

  // Search vocabulary by term
  Future<List<VocabularyModel>> searchVocabulary(String query) async {
    final response = await _client
        .from(SupabaseTables.vocabulary)
        .select()
        .ilike('term', '%$query%')
        .limit(20);

    return (response as List).map((json) => VocabularyModel.fromJson(json)).toList();
  }
}
