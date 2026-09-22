class FlashcardModel {
  final String id;
  final String deckId;
  final String? vocabularyId;
  final String? customWord;
  final String? customMeaning;
  final double easeFactor; // SM-2 Ease Factor (default 2.5)
  final int intervalDays; // SM-2 Interval (default 1)
  final DateTime nextReviewAt;
  final String? source; // manual, ai_generated, rag_document
  final int repetitionCount;
  final DateTime? lastReviewedAt;

  FlashcardModel({
    required this.id,
    required this.deckId,
    this.vocabularyId,
    this.customWord,
    this.customMeaning,
    this.easeFactor = 2.5,
    this.intervalDays = 1,
    required this.nextReviewAt,
    this.source = 'manual',
    this.repetitionCount = 0,
    this.lastReviewedAt,
  });

  factory FlashcardModel.fromJson(Map<String, dynamic> json) {
    return FlashcardModel(
      id: json['id'] as String,
      deckId: json['deck_id'] as String,
      vocabularyId: json['vocabulary_id'] as String?,
      customWord: json['custom_word'] as String?,
      customMeaning: json['custom_meaning'] as String?,
      easeFactor: (json['ease_factor'] as num?)?.toDouble() ?? 2.5,
      intervalDays: json['interval_days'] as int? ?? 1,
      nextReviewAt: DateTime.parse(json['next_review_at'] as String),
      source: json['source'] as String?,
      repetitionCount: json['repetition_count'] as int? ?? 0,
      lastReviewedAt: json['last_reviewed_at'] != null ? DateTime.parse(json['last_reviewed_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'deck_id': deckId,
      'vocabulary_id': vocabularyId,
      'custom_word': customWord,
      'custom_meaning': customMeaning,
      'ease_factor': easeFactor,
      'interval_days': intervalDays,
      'next_review_at': nextReviewAt.toIso8601String(),
      'source': source,
      'repetition_count': repetitionCount,
      'last_reviewed_at': lastReviewedAt?.toIso8601String(),
    };
  }
}
