class RecommendationModel {
  final String id;
  final String userId;
  final String? vocabularyId;
  final String recommendationType; // review_vocab, retry_quiz, new_lesson
  final double? predictedRetention;
  final String? recommendedContent;
  final bool isDismissed;
  final DateTime? createdAt;

  RecommendationModel({
    required this.id,
    required this.userId,
    this.vocabularyId,
    required this.recommendationType,
    this.predictedRetention,
    this.recommendedContent,
    this.isDismissed = false,
    this.createdAt,
  });

  factory RecommendationModel.fromJson(Map<String, dynamic> json) {
    return RecommendationModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      vocabularyId: json['vocabulary_id'] as String?,
      recommendationType: json['recommendation_type'] as String,
      predictedRetention: (json['predicted_retention'] as num?)?.toDouble(),
      recommendedContent: json['recommended_content'] as String?,
      isDismissed: json['is_dismissed'] as bool? ?? false,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'vocabulary_id': vocabularyId,
      'recommendation_type': recommendationType,
      'predicted_retention': predictedRetention,
      'recommended_content': recommendedContent,
      'is_dismissed': isDismissed,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
