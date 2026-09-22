enum ReadingQuestionType {
  trueFalseNotGiven,
  yesNoNotGiven,
  multipleChoice,
  noteCompletion,
  matchingHeadings,
  sentenceCompletion,
}

class AnswerExplanation {
  final String questionKeyword;
  final String passageLocation;
  final String paraphraseExplanation;

  const AnswerExplanation({
    required this.questionKeyword,
    required this.passageLocation,
    required this.paraphraseExplanation,
  });

  Map<String, dynamic> toJson() => {
        'questionKeyword': questionKeyword,
        'passageLocation': passageLocation,
        'paraphraseExplanation': paraphraseExplanation,
      };

  factory AnswerExplanation.fromJson(Map<String, dynamic> json) =>
      AnswerExplanation(
        questionKeyword: json['questionKeyword'] as String? ?? '',
        passageLocation: json['passageLocation'] as String? ?? '',
        paraphraseExplanation: json['paraphraseExplanation'] as String? ?? '',
      );
}

class ReadingQuestion {
  final int number;
  final ReadingQuestionType type;
  final String prompt;
  final List<String>? options;
  final String correctAnswer;
  final List<String>? acceptableAnswers;
  final AnswerExplanation explanation;

  const ReadingQuestion({
    required this.number,
    required this.type,
    required this.prompt,
    this.options,
    required this.correctAnswer,
    this.acceptableAnswers,
    required this.explanation,
  });

  bool isAnswerCorrect(String userAnswer) {
    final cleanUser = userAnswer.trim().toLowerCase();
    final cleanCorrect = correctAnswer.trim().toLowerCase();
    if (cleanUser == cleanCorrect) return true;
    if (acceptableAnswers != null) {
      return acceptableAnswers!.any((ans) => ans.trim().toLowerCase() == cleanUser);
    }
    return false;
  }
}

class ReadingQuestionGroup {
  final String instructions;
  final ReadingQuestionType type;
  final List<ReadingQuestion> questions;

  const ReadingQuestionGroup({
    required this.instructions,
    required this.type,
    required this.questions,
  });
}

class ReadingPassage {
  final int partNumber;
  final String title;
  final String subtitle;
  final String content;
  final List<ReadingQuestionGroup> questionGroups;

  const ReadingPassage({
    required this.partNumber,
    required this.title,
    required this.subtitle,
    required this.content,
    required this.questionGroups,
  });

  List<ReadingQuestion> getAllQuestions() {
    final List<ReadingQuestion> list = [];
    for (final g in questionGroups) {
      list.addAll(g.questions);
    }
    return list;
  }
}

class ReadingTest {
  final String id;
  final String title;
  final String bookSeries;
  final String bandTarget;
  final int totalQuestions;
  final int durationMinutes;
  final List<ReadingPassage> passages;

  const ReadingTest({
    required this.id,
    required this.title,
    required this.bookSeries,
    required this.bandTarget,
    required this.totalQuestions,
    required this.durationMinutes,
    required this.passages,
  });

  List<ReadingQuestion> getAllQuestions() {
    final List<ReadingQuestion> list = [];
    for (final p in passages) {
      list.addAll(p.getAllQuestions());
    }
    return list;
  }

  ReadingQuestion? getQuestionByNumber(int num) {
    for (final p in passages) {
      for (final g in p.questionGroups) {
        for (final q in g.questions) {
          if (q.number == num) return q;
        }
      }
    }
    return null;
  }
}
