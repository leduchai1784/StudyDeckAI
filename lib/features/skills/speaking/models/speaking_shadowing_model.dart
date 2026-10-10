enum ShadowingWordStatus {
  correct,
  mispronounced,
  missing,
  extra,
}

class ShadowingWordFeedback {
  final String word;
  final bool isMatched;
  final double confidence;
  final String? phonetic;
  final String? userSaid;
  final ShadowingWordStatus status;
  final String? tip;

  const ShadowingWordFeedback({
    required this.word,
    required this.isMatched,
    this.confidence = 1.0,
    this.phonetic,
    this.userSaid,
    this.status = ShadowingWordStatus.correct,
    this.tip,
  });

  factory ShadowingWordFeedback.fromMatch({
    required String word,
    required bool isMatch,
    double confidence = 1.0,
    String? phonetic,
    String? userSaid,
    String? tip,
  }) {
    return ShadowingWordFeedback(
      word: word,
      isMatched: isMatch,
      confidence: confidence,
      phonetic: phonetic,
      userSaid: userSaid,
      status: isMatch
          ? ShadowingWordStatus.correct
          : ShadowingWordStatus.mispronounced,
      tip: tip,
    );
  }
}

class ShadowingSentence {
  final String id;
  final String englishText;
  final String vietnameseTranslation;
  final String phonetic;
  final String? audioUrl;
  final List<String> stressWords;

  const ShadowingSentence({
    required this.id,
    required this.englishText,
    required this.vietnameseTranslation,
    required this.phonetic,
    this.audioUrl,
    this.stressWords = const [],
  });
}

class ShadowingExercise {
  final String id;
  final String title;
  final String topic;
  final String category; // 'ielts_speaking', 'conversation', 'ted_ed'
  final String bandTarget; // 'Band 6.5 - 7.5', 'Band 8.0'
  final String description;
  final List<ShadowingSentence> sentences;

  const ShadowingExercise({
    required this.id,
    required this.title,
    required this.topic,
    required this.category,
    required this.bandTarget,
    required this.description,
    required this.sentences,
  });
}

class ShadowingEvaluationResult {
  final double accuracyScore; // 0.0 -> 100.0
  final double fluencyScore; // 0.0 -> 100.0
  final double completenessScore; // 0.0 -> 100.0
  final List<ShadowingWordFeedback> wordFeedbacks;
  final String? recordedAudioPath;
  final String aiFeedback;
  final bool noSpeechDetected;
  final bool isLowMatch;
  final int audioDurationSeconds;

  const ShadowingEvaluationResult({
    required this.accuracyScore,
    required this.fluencyScore,
    this.completenessScore = 100.0,
    required this.wordFeedbacks,
    this.recordedAudioPath,
    required this.aiFeedback,
    this.noSpeechDetected = false,
    this.isLowMatch = false,
    this.audioDurationSeconds = 0,
  });
}
