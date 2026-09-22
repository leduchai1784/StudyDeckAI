class QuestionModel {
  final String id;
  final String quizId;
  final String? vocabularyId;
  final String? questionType; // multiple_choice, fill_blank, matching
  final String content;
  final dynamic options; // JSON object / List of options
  final String correctAnswer;

  QuestionModel({
    required this.id,
    required this.quizId,
    this.vocabularyId,
    this.questionType,
    required this.content,
    this.options,
    required this.correctAnswer,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'] as String,
      quizId: json['quiz_id'] as String,
      vocabularyId: json['vocabulary_id'] as String?,
      questionType: json['question_type'] as String?,
      content: json['content'] as String,
      options: json['options'],
      correctAnswer: json['correct_answer'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quiz_id': quizId,
      'vocabulary_id': vocabularyId,
      'question_type': questionType,
      'content': content,
      'options': options,
      'correct_answer': correctAnswer,
    };
  }
}
