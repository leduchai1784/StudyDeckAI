class WritingSubmissionModel {
  final String id;
  final String userId;
  final String content;
  final double? score;
  final String? feedback;
  final DateTime? createdAt;

  WritingSubmissionModel({
    required this.id,
    required this.userId,
    required this.content,
    this.score,
    this.feedback,
    this.createdAt,
  });

  factory WritingSubmissionModel.fromJson(Map<String, dynamic> json) {
    return WritingSubmissionModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      content: json['content'] as String,
      score: (json['score'] as num?)?.toDouble(),
      feedback: json['feedback'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'content': content,
      'score': score,
      'feedback': feedback,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
