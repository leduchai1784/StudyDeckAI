class QuizResultModel {
  final String id;
  final String quizId;
  final String userId;
  final double score;
  final int totalQuestions;
  final int correctCount;
  final DateTime startedAt;
  final DateTime completedAt;

  QuizResultModel({
    required this.id,
    required this.quizId,
    required this.userId,
    required this.score,
    required this.totalQuestions,
    required this.correctCount,
    required this.startedAt,
    required this.completedAt,
  });

  factory QuizResultModel.fromJson(Map<String, dynamic> json) {
    return QuizResultModel(
      id: json['id'] as String,
      quizId: json['quiz_id'] as String,
      userId: json['user_id'] as String,
      score: (json['score'] as num).toDouble(),
      totalQuestions: json['total_questions'] as int,
      correctCount: json['correct_count'] as int,
      startedAt: DateTime.parse(json['started_at'] as String),
      completedAt: DateTime.parse(json['completed_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quiz_id': quizId,
      'user_id': userId,
      'score': score,
      'total_questions': totalQuestions,
      'correct_count': correctCount,
      'started_at': startedAt.toIso8601String(),
      'completed_at': completedAt.toIso8601String(),
    };
  }
}
