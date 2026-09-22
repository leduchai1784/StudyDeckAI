class QuizAnswerModel {
  final String id;
  final String quizResultId;
  final String questionId;
  final String userAnswer;
  final bool isCorrect;

  QuizAnswerModel({
    required this.id,
    required this.quizResultId,
    required this.questionId,
    required this.userAnswer,
    required this.isCorrect,
  });

  factory QuizAnswerModel.fromJson(Map<String, dynamic> json) {
    return QuizAnswerModel(
      id: json['id'] as String,
      quizResultId: json['quiz_result_id'] as String,
      questionId: json['question_id'] as String,
      userAnswer: json['user_answer'] as String,
      isCorrect: json['is_correct'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quiz_result_id': quizResultId,
      'question_id': questionId,
      'user_answer': userAnswer,
      'is_correct': isCorrect,
    };
  }
}
