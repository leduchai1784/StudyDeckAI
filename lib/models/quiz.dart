class QuizModel {
  final String id;
  final String? lessonId;
  final String title;
  final String? quizType; // multiple_choice, fill_blank, matching
  final String? createdBy; // system, ai_generated
  final DateTime? createdAt;

  QuizModel({
    required this.id,
    this.lessonId,
    required this.title,
    this.quizType = 'multiple_choice',
    this.createdBy = 'system',
    this.createdAt,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      id: json['id'] as String,
      lessonId: json['lesson_id'] as String?,
      title: json['title'] as String,
      quizType: json['quiz_type'] as String?,
      createdBy: json['created_by'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lesson_id': lessonId,
      'title': title,
      'quiz_type': quizType,
      'created_by': createdBy,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
