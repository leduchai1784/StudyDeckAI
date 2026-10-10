class DictationSentence {
  final int sentenceNumber;
  final String targetText;
  final String hint;
  final String translationVi;
  final String? audioUrl;
  final double? timeStart;
  final double? timeEnd;

  const DictationSentence({
    required this.sentenceNumber,
    required this.targetText,
    this.hint = '',
    this.translationVi = '',
    this.audioUrl,
    this.timeStart,
    this.timeEnd,
  });

  /// Gợi ý câu: Nếu hint rỗng, tự động tạo chữ cái đầu kèm gạch dưới (VD: "Good morning" -> "G___ m______")
  String get effectiveHint {
    if (hint.isNotEmpty) return hint;
    return generateHint(targetText);
  }

  static String generateHint(String text) {
    return text.split(' ').map((w) {
      if (w.length <= 1) return w;
      return '${w[0]}${'_' * (w.length - 1)}';
    }).join(' ');
  }

  factory DictationSentence.fromJson(Map<String, dynamic> json) {
    final text = json['targetText'] as String? ?? json['text'] as String? ?? '';
    final hintVal = json['hint'] as String?;
    return DictationSentence(
      sentenceNumber: json['sentenceNumber'] as int? ?? json['num'] as int? ?? 1,
      targetText: text,
      hint: (hintVal != null && hintVal.isNotEmpty) ? hintVal : generateHint(text),
      translationVi: json['translationVi'] as String? ?? '',
      audioUrl: json['audioUrl'] as String? ?? json['audio'] as String?,
      timeStart: (json['timeStart'] as num?)?.toDouble() ?? (json['start'] as num?)?.toDouble(),
      timeEnd: (json['timeEnd'] as num?)?.toDouble() ?? (json['end'] as num?)?.toDouble(),
    );
  }

  /// Normalize and check user input against targetText
  bool isAccurate(String userInput) {
    final cleanUser = _normalize(userInput);
    final cleanTarget = _normalize(targetText);
    return cleanUser == cleanTarget;
  }

  /// Calculates word-by-word accuracy ratio using Longest Common Subsequence (0.0 -> 1.0)
  double calculateAccuracy(String userInput) {
    final userWords = _normalize(userInput).split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    final targetWords = _normalize(targetText).split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    if (targetWords.isEmpty) return 1.0;
    if (userWords.isEmpty) return 0.0;

    final m = userWords.length;
    final n = targetWords.length;
    final dp = List.generate(m + 1, (_) => List<int>.filled(n + 1, 0));

    for (int i = 1; i <= m; i++) {
      for (int j = 1; j <= n; j++) {
        if (userWords[i - 1] == targetWords[j - 1]) {
          dp[i][j] = dp[i - 1][j - 1] + 1;
        } else {
          dp[i][j] = dp[i - 1][j] > dp[i][j - 1] ? dp[i - 1][j] : dp[i][j - 1];
        }
      }
    }
    final lcs = dp[m][n];
    return (lcs / targetWords.length).clamp(0.0, 1.0);
  }

  static String _normalize(String s) {
    return s.toLowerCase().replaceAll(RegExp(r'[^\w\s]'), '').trim();
  }
}

class DictationExercise {
  final String id;
  final String title;
  final String bandLevel;
  final String sourceTopic;
  final String category; // 'ielts_speaking', 'ted_ed', 'bbc_english', 'easy_english', 'conversations', 'numbers', 'spelling', 'general_tasks'
  final String description;
  final int durationMinutes;
  final List<DictationSentence> sentences;

  const DictationExercise({
    required this.id,
    required this.title,
    required this.bandLevel,
    required this.sourceTopic,
    this.category = 'ielts_speaking',
    this.description = '',
    required this.durationMinutes,
    required this.sentences,
  });

  factory DictationExercise.fromJson(Map<String, dynamic> json) {
    return DictationExercise(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      bandLevel: json['bandLevel'] as String? ?? 'Band 6.0 - 7.5',
      sourceTopic: json['sourceTopic'] as String? ?? json['topic'] as String? ?? '',
      category: json['category'] as String? ?? 'general_tasks',
      description: json['description'] as String? ?? '',
      durationMinutes: json['durationMinutes'] as int? ?? 5,
      sentences: (json['sentences'] as List<dynamic>? ?? [])
          .map((s) => DictationSentence.fromJson(s as Map<String, dynamic>))
          .toList(),
    );
  }

  int get totalSentences => sentences.length;

  /// Badge thời lượng và số câu chuẩn: "⏱ ~4p · 35 câu"
  String get badgeTimeAndCount => '⏱ ~${durationMinutes}p · $totalSentences câu';

  /// Phân cấp độ: Dễ (<= 20), Vừa (21-35), Khó (36-50)
  String get difficultyTier {
    if (totalSentences <= 20) return 'Dễ';
    if (totalSentences <= 35) return 'Vừa';
    return 'Thử thách';
  }
}

class IpaQuestion {
  final String id;
  final String wordA;
  final String ipaA;
  final String meaningA;
  final String wordB;
  final String ipaB;
  final String meaningB;
  final String targetWord; // Must be wordA or wordB
  final String exampleSentence;

  const IpaQuestion({
    required this.id,
    required this.wordA,
    required this.ipaA,
    this.meaningA = '',
    required this.wordB,
    required this.ipaB,
    this.meaningB = '',
    required this.targetWord,
    this.exampleSentence = '',
  });

  bool isTargetWordA() => targetWord == wordA;
}

enum IpaSoundType { vowel, consonant }

class IpaMinimalPairCategory {
  final String id;
  final String soundPairTitle; // e.g. "/æ/ – /e/"
  final String wordPairLabel; // e.g. "bad / bed"
  final IpaSoundType soundType;
  final String description;
  final List<IpaQuestion> questions;

  const IpaMinimalPairCategory({
    required this.id,
    required this.soundPairTitle,
    required this.wordPairLabel,
    this.soundType = IpaSoundType.vowel,
    required this.description,
    required this.questions,
  });
}

