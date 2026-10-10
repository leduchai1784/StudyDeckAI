enum QuestionType {
  gapFill,
  multipleChoice,
  matching,
}

class ListeningQuestion {
  final int questionNumber;
  final QuestionType type;
  final String questionText; // e.g. "Customer Name: [1]" or "Where does the conversation take place?"
  final List<String>? options; // ['A. City Hall', 'B. Central Library', 'C. Community Center']
  final String correctAnswer; // e.g. "Miller" or "B"
  final List<String> alternativeAnswers; // e.g. ['miller', 'MILLER']
  final String explanation; // 3-step explanation (Keywords, Distractor, Evidence)
  final int audioTimestampSeconds; // Target timestamp in seconds for audio replay
  final String transcriptEvidence; // The exact sentence in transcript

  const ListeningQuestion({
    required this.questionNumber,
    required this.type,
    required this.questionText,
    this.options,
    required this.correctAnswer,
    this.alternativeAnswers = const [],
    required this.explanation,
    required this.audioTimestampSeconds,
    required this.transcriptEvidence,
  });

  bool checkAnswer(String userAnswer) {
    final cleanUser = userAnswer.trim().toLowerCase();
    final cleanCorrect = correctAnswer.trim().toLowerCase();
    if (cleanUser.isEmpty) return false;
    if (cleanUser == cleanCorrect) return true;
    for (final alt in alternativeAnswers) {
      if (cleanUser == alt.trim().toLowerCase()) return true;
    }
    return false;
  }
}

class ListeningSection {
  final int partNumber; // 1, 2, 3, 4
  final String sectionTitle;
  final String sectionInstruction; // "Write NO MORE THAN TWO WORDS AND/OR A NUMBER for each answer."
  final String fullTranscript;
  final String? audioUrl;
  final List<ListeningQuestion> questions;

  const ListeningSection({
    required this.partNumber,
    required this.sectionTitle,
    required this.sectionInstruction,
    required this.fullTranscript,
    this.audioUrl,
    required this.questions,
  });

  /// Automatically extracts audio stream URL if explicitly provided or embedded in fullTranscript
  String? get resolvedAudioUrl {
    if (audioUrl != null && audioUrl!.trim().isNotEmpty) {
      return audioUrl!.trim();
    }
    final match = RegExp(r'Audio stream:\s*(https?://[^\s<>"]+)').firstMatch(fullTranscript);
    if (match != null) {
      return match.group(1);
    }
    return null;
  }

  /// Clean transcript removing any raw audio URLs and ensuring clean text
  String get cleanTranscript {
    final cleaned = fullTranscript.replaceAll(RegExp(r'Audio stream:\s*https?://[^\s<>"]+'), '').trim();
    if (cleaned.isNotEmpty && !cleaned.startsWith('Section') && !cleaned.contains('audio recorded for Cambridge')) {
      return cleaned;
    }
    if (questions.any((q) => q.transcriptEvidence.trim().isNotEmpty)) {
      final buffer = StringBuffer();
      for (final q in questions) {
        if (q.transcriptEvidence.trim().isNotEmpty) {
          buffer.writeln('Q${q.questionNumber}: ${q.transcriptEvidence.trim()}');
        }
      }
      if (buffer.isNotEmpty) return buffer.toString().trim();
    }
    return cleaned;
  }
}

class ListeningTest {
  final String id;
  final String title;
  final String subtitle;
  final String bandTarget; // "Band 4.0 - 5.0", "Band 6.0 - 6.5", "Band 7.0 - 8.5+"
  final int durationMinutes;
  final List<ListeningSection> sections;

  const ListeningTest({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.bandTarget,
    required this.durationMinutes,
    required this.sections,
  });

  int get totalQuestions => sections.fold(0, (sum, sec) => sum + sec.questions.length);

  static double calculateBandScore(int correctCount, int totalCount) {
    if (totalCount == 0) return 0.0;
    final ratio = correctCount / totalCount;
    if (ratio >= 0.90) return 9.0;
    if (ratio >= 0.85) return 8.5;
    if (ratio >= 0.78) return 8.0;
    if (ratio >= 0.72) return 7.5;
    if (ratio >= 0.65) return 7.0;
    if (ratio >= 0.58) return 6.5;
    if (ratio >= 0.50) return 6.0;
    if (ratio >= 0.42) return 5.5;
    if (ratio >= 0.35) return 5.0;
    if (ratio >= 0.28) return 4.5;
    if (ratio >= 0.20) return 4.0;
    return 3.5;
  }
}
