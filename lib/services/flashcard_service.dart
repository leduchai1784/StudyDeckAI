import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/constants/supabase_tables.dart';
import '../core/network/supabase_service.dart';
import '../models/deck.dart';
import '../models/flashcard.dart';

class FlashcardService {
  final SupabaseClient _client = SupabaseService.instance.client;

  // Fetch Decks of user
  Future<List<DeckModel>> fetchDecks(String userId) async {
    final response = await _client
        .from(SupabaseTables.decks)
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List).map((json) => DeckModel.fromJson(json)).toList();
  }

  // Fetch Flashcards due for review (SM-2 Algorithm requirement)
  Future<List<FlashcardModel>> fetchDueFlashcards(String deckId) async {
    final now = DateTime.now().toIso8601String();
    final response = await _client
        .from(SupabaseTables.flashcards)
        .select()
        .eq('deck_id', deckId)
        .lte('next_review_at', now)
        .order('next_review_at', ascending: true);

    return (response as List).map((json) => FlashcardModel.fromJson(json)).toList();
  }

  // Create new Deck
  Future<DeckModel> createDeck(String userId, String name, {String? description}) async {
    final response = await _client
        .from(SupabaseTables.decks)
        .insert({
          'user_id': userId,
          'name': name,
          'description': description,
          'is_ai_generated': false,
          'created_at': DateTime.now().toIso8601String(),
        })
        .select()
        .single();

    return DeckModel.fromJson(response);
  }

  // Update Flashcard SM-2 attributes after review
  Future<void> updateFlashcardReview(
    String flashcardId, {
    required double easeFactor,
    required int intervalDays,
    required DateTime nextReviewAt,
    required int repetitionCount,
  }) async {
    await _client.from(SupabaseTables.flashcards).update({
      'ease_factor': easeFactor,
      'interval_days': intervalDays,
      'next_review_at': nextReviewAt.toIso8601String(),
      'repetition_count': repetitionCount,
      'last_reviewed_at': DateTime.now().toIso8601String(),
    }).eq('id', flashcardId);
  }
}
