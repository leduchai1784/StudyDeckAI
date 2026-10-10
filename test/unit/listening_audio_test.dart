import 'package:flutter_test/flutter_test.dart';
import 'package:studydeck_ai/features/skills/listening/models/listening_test_model.dart';

void main() {
  group('ListeningSection Audio & Transcript Tests', () {
    test('extracts resolvedAudioUrl from embedded audio stream', () {
      const section = ListeningSection(
        partNumber: 1,
        sectionTitle: 'Part 1',
        sectionInstruction: 'Write ONE WORD',
        fullTranscript: 'Section 1. Audio stream: https://pub-abc.r2.dev/cam13-test1-part1.mp3 Welcome everyone.',
        questions: [],
      );

      expect(section.resolvedAudioUrl, 'https://pub-abc.r2.dev/cam13-test1-part1.mp3');
      expect(section.cleanTranscript, 'Section 1.  Welcome everyone.');
    });

    test('prioritizes explicit audioUrl over embedded stream', () {
      const section = ListeningSection(
        partNumber: 2,
        sectionTitle: 'Part 2',
        sectionInstruction: 'Choose correct letter',
        fullTranscript: 'Audio stream: https://pub-abc.r2.dev/old.mp3',
        audioUrl: 'https://cdn.example.com/explicit.mp3',
        questions: [],
      );

      expect(section.resolvedAudioUrl, 'https://cdn.example.com/explicit.mp3');
    });

    test('falls back to questions transcript evidence when transcript is placeholder', () {
      const section = ListeningSection(
        partNumber: 3,
        sectionTitle: 'Part 3',
        sectionInstruction: 'Answer questions',
        fullTranscript: 'Audio stream: https://pub-abc.r2.dev/part3.mp3',
        questions: [
          ListeningQuestion(
            questionNumber: 21,
            type: QuestionType.multipleChoice,
            questionText: 'What is the main topic?',
            correctAnswer: 'A',
            explanation: 'Evidence points to A',
            audioTimestampSeconds: 45,
            transcriptEvidence: 'The professor started discussing marine biology.',
          ),
        ],
      );

      expect(section.resolvedAudioUrl, 'https://pub-abc.r2.dev/part3.mp3');
      expect(section.cleanTranscript, contains('Q21: The professor started discussing marine biology.'));
    });

    test('checks answers correctly with case insensitivity and alternatives', () {
      const question = ListeningQuestion(
        questionNumber: 1,
        type: QuestionType.gapFill,
        questionText: 'Name: [1]',
        correctAnswer: 'Miller',
        alternativeAnswers: ['miller', 'MILLER'],
        explanation: 'The spelling was confirmed.',
        audioTimestampSeconds: 20,
        transcriptEvidence: 'My name is Miller.',
      );

      expect(question.checkAnswer('Miller'), isTrue);
      expect(question.checkAnswer('miller'), isTrue);
      expect(question.checkAnswer('MILLER'), isTrue);
      expect(question.checkAnswer(' Smith '), isFalse);
      expect(question.checkAnswer(''), isFalse);
    });
  });
}
