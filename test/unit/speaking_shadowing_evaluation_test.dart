import 'package:flutter_test/flutter_test.dart';
import 'package:studydeck_ai/features/skills/speaking/models/speaking_shadowing_model.dart';

void main() {
  group('Speaking Shadowing Evaluation Tests', () {
    test('ShadowingWordFeedback initializes with correct statuses', () {
      const correctWord = ShadowingWordFeedback(
        word: 'pronunciation',
        isMatched: true,
        confidence: 0.98,
        status: ShadowingWordStatus.correct,
      );
      expect(correctWord.isMatched, isTrue);
      expect(correctWord.status, ShadowingWordStatus.correct);

      const mispronouncedWord = ShadowingWordFeedback(
        word: 'respect',
        isMatched: false,
        confidence: 0.55,
        status: ShadowingWordStatus.mispronounced,
        tip: 'Bật rõ âm đuôi /t/',
      );
      expect(mispronouncedWord.isMatched, isFalse);
      expect(mispronouncedWord.status, ShadowingWordStatus.mispronounced);
      expect(mispronouncedWord.tip, 'Bật rõ âm đuôi /t/');
    });

    test('ShadowingEvaluationResult handles normal successful evaluation', () {
      const result = ShadowingEvaluationResult(
        accuracyScore: 88.0,
        fluencyScore: 85.0,
        completenessScore: 92.0,
        wordFeedbacks: [
          ShadowingWordFeedback(
            word: 'Hello',
            isMatched: true,
            status: ShadowingWordStatus.correct,
          ),
          ShadowingWordFeedback(
            word: 'world',
            isMatched: true,
            status: ShadowingWordStatus.correct,
          ),
        ],
        aiFeedback: 'Phát âm rất tốt, ngữ điệu tự nhiên!',
        noSpeechDetected: false,
        isLowMatch: false,
        audioDurationSeconds: 4,
      );

      expect(result.accuracyScore, 88.0);
      expect(result.fluencyScore, 85.0);
      expect(result.completenessScore, 92.0);
      expect(result.noSpeechDetected, isFalse);
      expect(result.isLowMatch, isFalse);
      expect(result.wordFeedbacks.length, 2);
    });

    test('ShadowingEvaluationResult handles no speech detected scenario', () {
      const result = ShadowingEvaluationResult(
        accuracyScore: 0.0,
        fluencyScore: 0.0,
        completenessScore: 0.0,
        wordFeedbacks: [],
        aiFeedback: 'Không phát hiện giọng đọc tiếng Anh trong bản thu.',
        noSpeechDetected: true,
        isLowMatch: true,
        audioDurationSeconds: 3,
      );

      expect(result.noSpeechDetected, isTrue);
      expect(result.accuracyScore, 0.0);
      expect(result.isLowMatch, isTrue);
    });

    test('ShadowingEvaluationResult handles low match scenario', () {
      const result = ShadowingEvaluationResult(
        accuracyScore: 25.0,
        fluencyScore: 30.0,
        completenessScore: 35.0,
        wordFeedbacks: [],
        aiFeedback: 'Bản thu âm chưa khớp với câu tiếng Anh mẫu.',
        noSpeechDetected: false,
        isLowMatch: true,
        audioDurationSeconds: 5,
      );

      expect(result.noSpeechDetected, isFalse);
      expect(result.isLowMatch, isTrue);
      expect(result.accuracyScore, lessThan(40.0));
    });
  });
}
