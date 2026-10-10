import 'package:flutter_test/flutter_test.dart';
import 'package:studydeck_ai/features/skills/writing/data/writing_translation_repository.dart';
import 'package:studydeck_ai/features/skills/writing/models/writing_translation_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Writing Translation Models & Data Tests', () {
    test('WritingTranslationSentence and Exercise model serialization', () {
      final json = {
        'id': 'buoc1-test',
        'exercise_id': 'buoc1-test',
        'title': 'Test Lesson',
        'topic': {
          'en': 'Test English Topic',
          'question': 'Translate this sentence',
          'taskType': 'Bước 1 – Câu Cơ Bản'
        },
        'band_target': 'Bước 1',
        'sentences': [
          {
            'vi': 'Tôi học tiếng Anh mỗi ngày.',
            'hint': 'I study English every day.',
            'answer': 'I study English every day.'
          }
        ],
        'order_index': 1
      };

      final ex = WritingTranslationExercise.fromJson(json);
      expect(ex.title, 'Test Lesson');
      expect(ex.step, 1);
      expect(ex.sentences.length, 1);
      expect(ex.sentences.first.vi, 'Tôi học tiếng Anh mỗi ngày.');
      expect(ex.sentences.first.answer, 'I study English every day.');
    });

    test('WritingTranslationStepMeta contains all 5 steps', () {
      expect(WritingTranslationStepMeta.allSteps.length, 5);
      for (int i = 1; i <= 5; i++) {
        expect(WritingTranslationStepMeta.allSteps.any((s) => s.step == i), isTrue);
      }
    });

    test('WritingTranslationRepository loads all 5 steps with full coverage', () async {
      final repo = WritingTranslationRepository.instance;

      // Bước 1: 8 topics
      final buoc1 = await repo.getExercisesByStep(1);
      expect(buoc1.length, 8);
      final totalBuoc1Sentences = buoc1.fold<int>(0, (acc, e) => acc + e.sentences.length);
      expect(totalBuoc1Sentences, 200);

      // Bước 2: 15 topics
      final buoc2 = await repo.getExercisesByStep(2);
      expect(buoc2.length, 15);
      final totalBuoc2Sentences = buoc2.fold<int>(0, (acc, e) => acc + e.sentences.length);
      expect(totalBuoc2Sentences, 675);

      // Bước 3: 15 topics
      final buoc3 = await repo.getExercisesByStep(3);
      expect(buoc3.length, 15);
      final totalBuoc3Sentences = buoc3.fold<int>(0, (acc, e) => acc + e.sentences.length);
      expect(totalBuoc3Sentences, 525);

      // Bước 4: 10 topics
      final buoc4 = await repo.getExercisesByStep(4);
      expect(buoc4.length, 10);
      final totalBuoc4Sentences = buoc4.fold<int>(0, (acc, e) => acc + e.sentences.length);
      expect(totalBuoc4Sentences, 243);

      // Bước 5: 3 topics
      final buoc5 = await repo.getExercisesByStep(5);
      expect(buoc5.length, 3);
      final totalBuoc5Sentences = buoc5.fold<int>(0, (acc, e) => acc + e.sentences.length);
      expect(totalBuoc5Sentences, 70);

      // Total across all 5 steps
      final grandTotal = totalBuoc1Sentences +
          totalBuoc2Sentences +
          totalBuoc3Sentences +
          totalBuoc4Sentences +
          totalBuoc5Sentences;
      expect(grandTotal, 1713);
    });

    test('getExerciseById finds exercise across steps', () async {
      final repo = WritingTranslationRepository.instance;
      final ex1 = await repo.getExerciseById('buoc1-simple-present');
      expect(ex1, isNotNull);
      expect(ex1!.title, 'Hiện tại đơn (Simple Present)');

      final ex2 = await repo.getExerciseById('buoc2-education');
      expect(ex2, isNotNull);
      expect(ex2!.title, 'Giáo dục');

      final ex5 = await repo.getExerciseById('buoc5-education');
      expect(ex5, isNotNull);
      expect(ex5!.sentences.length, 47);
    });
  });
}
