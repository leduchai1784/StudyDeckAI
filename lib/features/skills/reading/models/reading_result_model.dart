class ReadingTestResult {
  final String testId;
  final String testTitle;
  final DateTime completedAt;
  final int durationSeconds;
  final int correctCount;
  final int totalQuestions;
  final double bandScore;
  final Map<int, String> userAnswers;

  const ReadingTestResult({
    required this.testId,
    required this.testTitle,
    required this.completedAt,
    required this.durationSeconds,
    required this.correctCount,
    required this.totalQuestions,
    required this.bandScore,
    required this.userAnswers,
  });

  double get accuracyPercentage =>
      totalQuestions > 0 ? (correctCount / totalQuestions) * 100 : 0.0;

  static double calculateBandScore(int correct) {
    if (correct >= 39) return 9.0;
    if (correct >= 37) return 8.5;
    if (correct >= 35) return 8.0;
    if (correct >= 33) return 7.5;
    if (correct >= 30) return 7.0;
    if (correct >= 27) return 6.5;
    if (correct >= 23) return 6.0;
    if (correct >= 19) return 5.5;
    if (correct >= 15) return 5.0;
    if (correct >= 13) return 4.5;
    if (correct >= 10) return 4.0;
    if (correct >= 8) return 3.5;
    if (correct >= 6) return 3.0;
    if (correct >= 4) return 2.5;
    return 2.0;
  }

  Map<String, dynamic> toJson() => {
        'testId': testId,
        'testTitle': testTitle,
        'completedAt': completedAt.toIso8601String(),
        'durationSeconds': durationSeconds,
        'correctCount': correctCount,
        'totalQuestions': totalQuestions,
        'bandScore': bandScore,
        'userAnswers': userAnswers.map((k, v) => MapEntry(k.toString(), v)),
      };

  factory ReadingTestResult.fromJson(Map<String, dynamic> json) {
    final rawAnswers = json['userAnswers'] as Map<String, dynamic>? ?? {};
    final Map<int, String> answers = {};
    rawAnswers.forEach((k, v) {
      final intKey = int.tryParse(k);
      if (intKey != null) {
        answers[intKey] = v.toString();
      }
    });

    return ReadingTestResult(
      testId: json['testId'] as String? ?? '',
      testTitle: json['testTitle'] as String? ?? '',
      completedAt: DateTime.tryParse(json['completedAt'] as String? ?? '') ??
          DateTime.now(),
      durationSeconds: json['durationSeconds'] as int? ?? 0,
      correctCount: json['correctCount'] as int? ?? 0,
      totalQuestions: json['totalQuestions'] as int? ?? 40,
      bandScore: (json['bandScore'] as num?)?.toDouble() ?? 0.0,
      userAnswers: answers,
    );
  }
}
