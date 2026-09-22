class DictationSentence {
  final int sentenceNumber;
  final String targetText;
  final String hint;
  final String translationVi;

  const DictationSentence({
    required this.sentenceNumber,
    required this.targetText,
    required this.hint,
    required this.translationVi,
  });

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
  final String category; // 'ielts_speaking', 'ted_ed', 'bbc_english', 'easy_english'
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
    required this.meaningA,
    required this.wordB,
    required this.ipaB,
    required this.meaningB,
    required this.targetWord,
    required this.exampleSentence,
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

