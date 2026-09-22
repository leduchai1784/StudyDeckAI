class LearningLogModel {
  final String id;
  final String userId;
  final String activityType; // flashcard_review, quiz_attempt, ai_tutor_chat, document_qna, lesson_view
  final String? referenceId;
  final int? durationSeconds;
  final bool? isCorrect;
  final DateTime? createdAt;

  LearningLogModel({
    required this.id,
    required this.userId,
    required this.activityType,
    this.referenceId,
    this.durationSeconds,
    this.isCorrect,
    this.createdAt,
  });

  factory LearningLogModel.fromJson(Map<String, dynamic> json) {
    return LearningLogModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      activityType: json['activity_type'] as String,
      referenceId: json['reference_id'] as String?,
      durationSeconds: json['duration_seconds'] as int?,
      isCorrect: json['is_correct'] as bool?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'activity_type': activityType,
      'reference_id': referenceId,
      'duration_seconds': durationSeconds,
      'is_correct': isCorrect,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
