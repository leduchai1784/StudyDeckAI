enum SpeakingPart {
  part1('Part 1: Phỏng vấn ngắn'),
  part2('Part 2: Thuyết trình Cue Card'),
  part3('Part 3: Thảo luận chuyên sâu');

  final String label;
  const SpeakingPart(this.label);
}

class SpeakingVocabItem {
  final String word;
  final String ipa;
  final String type; // n, v, adj, idiom, collocation
  final String meaning;
  final String example;

  const SpeakingVocabItem({
    required this.word,
    required this.ipa,
    this.type = 'adj',
    required this.meaning,
    required this.example,
  });
}

class SpeakingQuestion {
  final String id;
  final SpeakingPart part;
  final String questionText;
  final List<String>? cueCardPrompts; // Cho Part 2: You should say...
  final List<String> ideaHints; // A.R.E.A framework hints
  final List<SpeakingVocabItem> usefulVocab;
  final String sampleAnswerBand8;
  final int audioDurationSeconds;

  const SpeakingQuestion({
    required this.id,
    required this.part,
    required this.questionText,
    this.cueCardPrompts,
    required this.ideaHints,
    required this.usefulVocab,
    required this.sampleAnswerBand8,
    this.audioDurationSeconds = 45,
  });
}

class SpeakingTopic {
  final String id;
  final String quarter; // 'Q3-2026', 'Q2-2026'
  final String title;
  final String titleVi;
  final String categoryTag; // 'part1_required', 'part1_topic', 'part2_3', 'hot_trend'
  final String bandTarget;
  final String tagLabel; // 'MỚI DỰ ĐOÁN', 'THI NHIỀU', 'HOT TREND'
  final int viewsCount;
  final List<SpeakingQuestion> questions;

  const SpeakingTopic({
    required this.id,
    required this.quarter,
    required this.title,
    required this.titleVi,
    required this.categoryTag,
    required this.bandTarget,
    this.tagLabel = 'MỚI DỰ ĐOÁN',
    this.viewsCount = 12400,
    required this.questions,
  });

  int get questionCount => questions.length;
}

class SpeakingRouletteCard {
  final String id;
  final SpeakingPart part;
  final String topicName;
  final String question;
  final List<String> cuePoints; // Things you could talk about
  final List<SpeakingVocabItem> contextualVocab;
  final String sampleAnswer;

  const SpeakingRouletteCard({
    required this.id,
    required this.part,
    required this.topicName,
    required this.question,
    required this.cuePoints,
    required this.contextualVocab,
    required this.sampleAnswer,
  });
}

class SpeakingCriterionScore {
  final String criterion; // Fluency & Coherence, Lexical Resource, Grammar, Pronunciation
  final String criterionVi;
  final double score;
  final String feedback;
  final List<String> strengths;
  final List<String> improvements;

  const SpeakingCriterionScore({
    required this.criterion,
    required this.criterionVi,
    required this.score,
    required this.feedback,
    this.strengths = const [],
    this.improvements = const [],
  });
}

class SpeakingEvaluationResult {
  final double overallBand;
  final List<SpeakingCriterionScore> criteria;
  final String generalFeedback;
  final String originalUserText;
  final String upgradedAnswer;
  final List<SpeakingVocabItem> suggestedVocab;

  const SpeakingEvaluationResult({
    required this.overallBand,
    required this.criteria,
    required this.generalFeedback,
    required this.originalUserText,
    required this.upgradedAnswer,
    this.suggestedVocab = const [],
  });
}
