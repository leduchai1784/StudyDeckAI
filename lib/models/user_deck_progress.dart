import 'package:flutter/material.dart';

enum DeckStatus {
  notStarted('Chưa học'),
  inProgress('Đang học'),
  completed('Đã hoàn thành'),
  reviewing('Đang ôn tập');

  final String label;
  const DeckStatus(this.label);

  Color get badgeColor {
    switch (this) {
      case DeckStatus.completed:
        return const Color(0xFFD1FAE5); // Soft green
      case DeckStatus.inProgress:
        return const Color(0xFFFEF3C7); // Soft amber
      case DeckStatus.reviewing:
        return const Color(0xFFE0E7FF); // Soft indigo
      case DeckStatus.notStarted:
        return const Color(0xFFF1F5F9); // Slate grey
    }
  }

  Color get badgeTextColor {
    switch (this) {
      case DeckStatus.completed:
        return const Color(0xFF059669); // Dark green
      case DeckStatus.inProgress:
        return const Color(0xFFD97706); // Dark amber
      case DeckStatus.reviewing:
        return const Color(0xFF4338CA); // Dark indigo
      case DeckStatus.notStarted:
        return const Color(0xFF64748B); // Slate text
    }
  }
}

class UserDeckProgress {
  final String userId;
  final String deckId;
  final int totalCards;
  final int completedCards;
  final double progress; // 0.0 to 100.0
  final DeckStatus status;
  final DateTime? startedAt;
  final DateTime? lastStudiedAt;
  final DateTime? completedAt;
  final int reviewCount;
  final int lastStudiedIndex;

  UserDeckProgress({
    this.userId = 'default_user',
    required this.deckId,
    required this.totalCards,
    this.completedCards = 0,
    this.progress = 0.0,
    this.status = DeckStatus.notStarted,
    this.startedAt,
    this.lastStudiedAt,
    this.completedAt,
    this.reviewCount = 0,
    this.lastStudiedIndex = 0,
  });

  bool get isCompleted => status == DeckStatus.completed || progress >= 100.0;

  UserDeckProgress copyWith({
    String? userId,
    String? deckId,
    int? totalCards,
    int? completedCards,
    double? progress,
    DeckStatus? status,
    DateTime? startedAt,
    DateTime? lastStudiedAt,
    DateTime? completedAt,
    int? reviewCount,
    int? lastStudiedIndex,
  }) {
    return UserDeckProgress(
      userId: userId ?? this.userId,
      deckId: deckId ?? this.deckId,
      totalCards: totalCards ?? this.totalCards,
      completedCards: completedCards ?? this.completedCards,
      progress: progress ?? this.progress,
      status: status ?? this.status,
      startedAt: startedAt ?? this.startedAt,
      lastStudiedAt: lastStudiedAt ?? this.lastStudiedAt,
      completedAt: completedAt ?? this.completedAt,
      reviewCount: reviewCount ?? this.reviewCount,
      lastStudiedIndex: lastStudiedIndex ?? this.lastStudiedIndex,
    );
  }

  factory UserDeckProgress.fromJson(Map<String, dynamic> json) {
    DeckStatus status = DeckStatus.notStarted;
    final statusStr = json['status'] as String?;
    if (statusStr != null) {
      status = DeckStatus.values.firstWhere(
        (e) => e.name == statusStr,
        orElse: () => DeckStatus.notStarted,
      );
    }

    return UserDeckProgress(
      userId: json['user_id'] as String? ?? 'default_user',
      deckId: json['deck_id'] as String,
      totalCards: json['total_cards'] as int? ?? 0,
      completedCards: json['completed_cards'] as int? ?? 0,
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      status: status,
      startedAt: json['started_at'] != null ? DateTime.tryParse(json['started_at'] as String) : null,
      lastStudiedAt: json['last_studied_at'] != null ? DateTime.tryParse(json['last_studied_at'] as String) : null,
      completedAt: json['completed_at'] != null ? DateTime.tryParse(json['completed_at'] as String) : null,
      reviewCount: json['review_count'] as int? ?? 0,
      lastStudiedIndex: json['last_studied_index'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'deck_id': deckId,
      'total_cards': totalCards,
      'completed_cards': completedCards,
      'progress': progress,
      'status': status.name,
      'started_at': startedAt?.toIso8601String(),
      'last_studied_at': lastStudiedAt?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'review_count': reviewCount,
      'last_studied_index': lastStudiedIndex,
    };
  }
}

class CardLearningStat {
  final int wordId;
  final String deckId;
  final int incorrectCount;
  final int correctCount;
  final int masteryLevel; // 0 to 3
  final DateTime? lastReviewedAt;
  final DateTime? nextReviewDue;
  final bool isMastered;

  CardLearningStat({
    required this.wordId,
    required this.deckId,
    this.incorrectCount = 0,
    this.correctCount = 0,
    this.masteryLevel = 0,
    this.lastReviewedAt,
    this.nextReviewDue,
    this.isMastered = false,
  });

  CardLearningStat copyWith({
    int? wordId,
    String? deckId,
    int? incorrectCount,
    int? correctCount,
    int? masteryLevel,
    DateTime? lastReviewedAt,
    DateTime? nextReviewDue,
    bool? isMastered,
  }) {
    return CardLearningStat(
      wordId: wordId ?? this.wordId,
      deckId: deckId ?? this.deckId,
      incorrectCount: incorrectCount ?? this.incorrectCount,
      correctCount: correctCount ?? this.correctCount,
      masteryLevel: masteryLevel ?? this.masteryLevel,
      lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
      nextReviewDue: nextReviewDue ?? this.nextReviewDue,
      isMastered: isMastered ?? this.isMastered,
    );
  }

  factory CardLearningStat.fromJson(Map<String, dynamic> json) {
    return CardLearningStat(
      wordId: json['word_id'] as int,
      deckId: json['deck_id'] as String? ?? '',
      incorrectCount: json['incorrect_count'] as int? ?? 0,
      correctCount: json['correct_count'] as int? ?? 0,
      masteryLevel: json['mastery_level'] as int? ?? 0,
      lastReviewedAt: json['last_reviewed_at'] != null ? DateTime.tryParse(json['last_reviewed_at'] as String) : null,
      nextReviewDue: json['next_review_due'] != null ? DateTime.tryParse(json['next_review_due'] as String) : null,
      isMastered: json['is_mastered'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'word_id': wordId,
      'deck_id': deckId,
      'incorrect_count': incorrectCount,
      'correct_count': correctCount,
      'mastery_level': masteryLevel,
      'last_reviewed_at': lastReviewedAt?.toIso8601String(),
      'next_review_due': nextReviewDue?.toIso8601String(),
      'is_mastered': isMastered,
    };
  }
}

class QuizSession {
  final String id;
  final String deckId;
  final int totalQuestions;
  final int correctAnswers;
  final double score; // 0 to 100
  final DateTime completedAt;

  QuizSession({
    required this.id,
    required this.deckId,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.score,
    required this.completedAt,
  });

  factory QuizSession.fromJson(Map<String, dynamic> json) {
    return QuizSession(
      id: json['id'] as String,
      deckId: json['deck_id'] as String,
      totalQuestions: json['total_questions'] as int? ?? 0,
      correctAnswers: json['correct_answers'] as int? ?? 0,
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
      completedAt: DateTime.tryParse(json['completed_at'] as String? ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'deck_id': deckId,
      'total_questions': totalQuestions,
      'correct_answers': correctAnswers,
      'score': score,
      'completed_at': completedAt.toIso8601String(),
    };
  }
}
