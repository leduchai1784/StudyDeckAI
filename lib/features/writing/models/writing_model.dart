enum WritingTaskType {
  task1,
  task2,
  builder,
}

extension WritingTaskTypeExtension on WritingTaskType {
  String get label {
    switch (this) {
      case WritingTaskType.task1:
        return 'Task 1 (Báo cáo biểu đồ)';
      case WritingTaskType.task2:
        return 'Task 2 (Bài luận)';
      case WritingTaskType.builder:
        return 'Writing Builder';
    }
  }
}

enum WritingCategory {
  // Task 1
  barChart,
  lineGraph,
  pieChart,
  table,
  map,
  process,
  mixedGraph,
  // Task 2
  opinion,
  discussBoth,
  problemSolution,
  advantagesDisadvantages,
  twoPart,
}

extension WritingCategoryExtension on WritingCategory {
  String get label {
    switch (this) {
      case WritingCategory.barChart:
        return 'Bar Chart';
      case WritingCategory.lineGraph:
        return 'Line Graph';
      case WritingCategory.pieChart:
        return 'Pie Chart';
      case WritingCategory.table:
        return 'Table';
      case WritingCategory.map:
        return 'Map';
      case WritingCategory.process:
        return 'Process';
      case WritingCategory.mixedGraph:
        return 'Mixed Graph';
      case WritingCategory.opinion:
        return 'Opinion Essay';
      case WritingCategory.discussBoth:
        return 'Discuss Both Views';
      case WritingCategory.problemSolution:
        return 'Problem & Solution';
      case WritingCategory.advantagesDisadvantages:
        return 'Advantages & Disadvantages';
      case WritingCategory.twoPart:
        return 'Two-part Question';
    }
  }

  String get labelVi {
    switch (this) {
      case WritingCategory.barChart:
        return 'Biểu đồ cột';
      case WritingCategory.lineGraph:
        return 'Biểu đồ đường';
      case WritingCategory.pieChart:
        return 'Biểu đồ tròn';
      case WritingCategory.table:
        return 'Bảng số liệu';
      case WritingCategory.map:
        return 'Bản đồ';
      case WritingCategory.process:
        return 'Quy trình';
      case WritingCategory.mixedGraph:
        return 'Biểu đồ kết hợp';
      case WritingCategory.opinion:
        return 'Bày tỏ quan điểm';
      case WritingCategory.discussBoth:
        return 'Thảo luận 2 quan điểm';
      case WritingCategory.problemSolution:
        return 'Nguyên nhân & Giải pháp';
      case WritingCategory.advantagesDisadvantages:
        return 'Lợi ích & Tác hại';
      case WritingCategory.twoPart:
        return 'Câu hỏi kép';
    }
  }
}

class WritingVocabItem {
  final String word;
  final String ipa;
  final String type;
  final String meaning;
  final String example;

  const WritingVocabItem({
    required this.word,
    required this.ipa,
    required this.type,
    required this.meaning,
    required this.example,
  });
}

class BrainstormSection {
  final String title;
  final List<String> points;

  const BrainstormSection({
    required this.title,
    required this.points,
  });
}

class WritingAiBrainstorm {
  final String strategy;
  final List<BrainstormSection> sections;

  const WritingAiBrainstorm({
    required this.strategy,
    required this.sections,
  });
}

class WritingPrompt {
  final String id;
  final WritingTaskType taskType;
  final WritingCategory category;
  final String categoryLabel;
  final String title;
  final String promptText;
  final String? imageUrl;
  final int minWords;
  final int timeMinutes;
  final String targetBand;
  final int viewsCount;
  final WritingAiBrainstorm? aiBrainstorm;
  final String sampleEssayBand8;
  final List<WritingVocabItem> usefulVocab;

  const WritingPrompt({
    required this.id,
    required this.taskType,
    required this.category,
    required this.categoryLabel,
    required this.title,
    required this.promptText,
    this.imageUrl,
    this.minWords = 250,
    this.timeMinutes = 40,
    this.targetBand = 'Band 7.5+',
    this.viewsCount = 1200,
    this.aiBrainstorm,
    required this.sampleEssayBand8,
    this.usefulVocab = const [],
  });
}

class WritingCriterionScore {
  final String criterion;
  final String criterionVi;
  final double score;
  final String feedback;

  const WritingCriterionScore({
    required this.criterion,
    required this.criterionVi,
    required this.score,
    required this.feedback,
  });
}

class WritingLineCorrection {
  final String originalSentence;
  final String correctedSentence;
  final String explanation;

  const WritingLineCorrection({
    required this.originalSentence,
    required this.correctedSentence,
    required this.explanation,
  });
}

class WritingEvaluationResult {
  final double overallBand;
  final List<WritingCriterionScore> criteria;
  final List<WritingLineCorrection> lineCorrections;
  final String generalFeedback;
  final String upgradedEssay;
  final int wordCount;

  const WritingEvaluationResult({
    required this.overallBand,
    required this.criteria,
    required this.lineCorrections,
    required this.generalFeedback,
    required this.upgradedEssay,
    required this.wordCount,
  });
}

class WritingTranslationItem {
  final String id;
  final int step; // 1: Cấu trúc câu, 2: Collocations & Vocab
  final String category;
  final String vietnameseSentence;
  final String englishSample;
  final List<String> keyCollocations;
  final String explanation;

  const WritingTranslationItem({
    required this.id,
    required this.step,
    required this.category,
    required this.vietnameseSentence,
    required this.englishSample,
    this.keyCollocations = const [],
    required this.explanation,
  });
}
