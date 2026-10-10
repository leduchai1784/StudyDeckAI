class WritingTranslationSentence {
  final String vi;
  final String hint;
  final String answer;

  const WritingTranslationSentence({
    required this.vi,
    required this.hint,
    required this.answer,
  });

  factory WritingTranslationSentence.fromJson(Map<String, dynamic> json) {
    return WritingTranslationSentence(
      vi: json['vi'] as String? ?? '',
      hint: json['hint'] as String? ?? '',
      answer: json['answer'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'vi': vi,
    'hint': hint,
    'answer': answer,
  };
}

class WritingTranslationTopicInfo {
  final String en;
  final String question;
  final String taskType;

  const WritingTranslationTopicInfo({
    required this.en,
    required this.question,
    required this.taskType,
  });

  factory WritingTranslationTopicInfo.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const WritingTranslationTopicInfo(
        en: '',
        question: '',
        taskType: '',
      );
    }
    return WritingTranslationTopicInfo(
      en: json['en'] as String? ?? '',
      question: json['question'] as String? ?? '',
      taskType: json['taskType'] as String? ?? '',
    );
  }
}

class WritingTranslationExercise {
  final String id;
  final String exerciseId;
  final String title;
  final WritingTranslationTopicInfo topic;
  final String bandTarget;
  final List<WritingTranslationSentence> sentences;
  final int orderIndex;
  final int step; // 1, 2, 3, 4, 5

  const WritingTranslationExercise({
    required this.id,
    required this.exerciseId,
    required this.title,
    required this.topic,
    required this.bandTarget,
    required this.sentences,
    required this.orderIndex,
    required this.step,
  });

  factory WritingTranslationExercise.fromJson(Map<String, dynamic> json, {int defaultStep = 1}) {
    final rawSentences = json['sentences'] as List<dynamic>? ?? [];
    final sentencesList = rawSentences
        .map((s) => WritingTranslationSentence.fromJson(s as Map<String, dynamic>))
        .toList();

    int stepNum = defaultStep;
    final exId = json['exercise_id'] as String? ?? '';
    if (exId.startsWith('buoc1-')) {
      stepNum = 1;
    } else if (exId.startsWith('buoc2-')) {
      stepNum = 2;
    } else if (exId.startsWith('buoc3-')) {
      stepNum = 3;
    } else if (exId.startsWith('buoc4-')) {
      stepNum = 4;
    } else if (exId.startsWith('buoc5-')) {
      stepNum = 5;
    }

    return WritingTranslationExercise(
      id: json['id'] as String? ?? exId,
      exerciseId: exId,
      title: json['title'] as String? ?? '',
      topic: WritingTranslationTopicInfo.fromJson(json['topic'] as Map<String, dynamic>?),
      bandTarget: json['band_target'] as String? ?? 'Bước $stepNum',
      sentences: sentencesList,
      orderIndex: (json['order_index'] as num?)?.toInt() ?? 1,
      step: stepNum,
    );
  }
}

class WritingTranslationStepMeta {
  final int step;
  final String title;
  final String subtitle;
  final String description;
  final String badge;
  final int totalLessons;

  const WritingTranslationStepMeta({
    required this.step,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.badge,
    required this.totalLessons,
  });

  static const List<WritingTranslationStepMeta> allSteps = [
    WritingTranslationStepMeta(
      step: 1,
      title: 'Bước 1: Cấu trúc câu',
      subtitle: '8 Chủ Đề • 200 Câu',
      description: 'Luyện dịch câu cơ bản S-V-O, nắm chắc 8 thì và cấu trúc ngữ pháp cốt lõi.',
      badge: 'Cơ bản',
      totalLessons: 8,
    ),
    WritingTranslationStepMeta(
      step: 2,
      title: 'Bước 2: Collocations',
      subtitle: '15 Chủ Đề • 675 Câu',
      description: 'Luyện dịch câu chứa các cụm collocations và từ vựng học thuật ghi điểm Band 7.0+.',
      badge: 'Từ vựng & Cụm từ',
      totalLessons: 15,
    ),
    WritingTranslationStepMeta(
      step: 3,
      title: 'Bước 3: Ghép đoạn Band 6.5',
      subtitle: '15 Chủ Đề • 525 Câu',
      description: 'Dịch ghép các câu liên kết chặt chẽ tạo thành đoạn văn học thuật mạch lạc.',
      badge: 'Đoạn văn Band 6.5',
      totalLessons: 15,
    ),
    WritingTranslationStepMeta(
      step: 4,
      title: 'Bước 4: Đoạn văn Band 8.0',
      subtitle: '10 Chủ Đề • 243 Câu',
      description: 'Dịch các đoạn văn học thuật cao cấp với từ vựng C1/C2 và cấu trúc phức tạp.',
      badge: 'Nâng cao Band 8.0',
      totalLessons: 10,
    ),
    WritingTranslationStepMeta(
      step: 5,
      title: 'Bước 5: Dịch Essay hoàn chỉnh',
      subtitle: '3 Bài Luận • 70 Đoạn',
      description: 'Dịch trọn vẹn bài luận IELTS Writing Task 2 mẫu Band 8.5+ theo từng đoạn logic.',
      badge: 'Master Essay',
      totalLessons: 3,
    ),
  ];
}
