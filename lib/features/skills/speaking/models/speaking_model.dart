import 'package:flutter/material.dart';

enum SpeakingPart {
  part1('Part 1: Phỏng vấn ngắn'),
  part2('Part 2: Thuyết trình Cue Card'),
  part3('Part 3: Thảo luận chuyên sâu');

  final String label;
  const SpeakingPart(this.label);
}

enum SpeakingTopicCategory {
  dailyLife(
    key: 'daily_life',
    labelVi: 'Đời sống thường nhật',
    shortLabel: 'Đời sống',
    icon: '🏡',
    primaryColor: Color(0xFF059669),
    badgeBg: Color(0xFFECFDF5),
  ),
  hobbiesLifestyle(
    key: 'hobbies_lifestyle',
    labelVi: 'Sở thích & Phong cách sống',
    shortLabel: 'Sở thích',
    icon: '🎨',
    primaryColor: Color(0xFFEA580C),
    badgeBg: Color(0xFFFFF7ED),
  ),
  societyTech(
    key: 'society_tech',
    labelVi: 'Xã hội & Công nghệ',
    shortLabel: 'Xã hội & CN',
    icon: '🌐',
    primaryColor: Color(0xFF2563EB),
    badgeBg: Color(0xFFEFF6FF),
  ),
  abstractSkills(
    key: 'abstract_skills',
    labelVi: 'Tâm lý & Tư duy trừu tượng',
    shortLabel: 'Tư duy & Kỹ năng',
    icon: '🧠',
    primaryColor: Color(0xFF7C3AED),
    badgeBg: Color(0xFFFAF5FF),
  );

  final String key;
  final String labelVi;
  final String shortLabel;
  final String icon;
  final Color primaryColor;
  final Color badgeBg;

  const SpeakingTopicCategory({
    required this.key,
    required this.labelVi,
    required this.shortLabel,
    required this.icon,
    required this.primaryColor,
    required this.badgeBg,
  });

  static SpeakingTopicCategory fromKey(String key) {
    switch (key) {
      case 'daily_life':
        return SpeakingTopicCategory.dailyLife;
      case 'hobbies_lifestyle':
        return SpeakingTopicCategory.hobbiesLifestyle;
      case 'society_tech':
        return SpeakingTopicCategory.societyTech;
      case 'abstract_skills':
        return SpeakingTopicCategory.abstractSkills;
      default:
        return SpeakingTopicCategory.dailyLife;
    }
  }
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
  final String categoryTag; // 'daily_life', 'hobbies_lifestyle', 'society_tech', 'abstract_skills'
  final String bandTarget;
  final String tagLabel; // 'BẮT BUỘC THI', 'HOT TREND', 'PART 2 & 3'
  final int partNumber; // 1 (Part 1) hoặc 2 (Part 2 & 3)
  final bool isCompulsory; // true nếu là chủ đề Part 1 bắt buộc
  final int viewsCount;
  final List<SpeakingQuestion> questions;

  const SpeakingTopic({
    required this.id,
    required this.quarter,
    required this.title,
    required this.titleVi,
    required this.categoryTag,
    required this.bandTarget,
    this.tagLabel = 'DỰ ĐOÁN QUÝ 3',
    this.partNumber = 1,
    this.isCompulsory = false,
    this.viewsCount = 12400,
    required this.questions,
  });

  int get questionCount => questions.length;
  SpeakingTopicCategory get category => SpeakingTopicCategory.fromKey(categoryTag);
}

class SpeakingRouletteCard {
  final String id;
  final SpeakingPart part;
  final String topicName;
  final String question;
  final List<String> cuePoints;
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
  final String criterion;
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
    required this.suggestedVocab,
  });
}
