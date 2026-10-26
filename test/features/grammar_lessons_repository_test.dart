import 'package:flutter_test/flutter_test.dart';
import 'package:studydeck_ai/features/grammar/data/grammar_lessons_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GrammarLessonsRepository Tests', () {
    final repository = GrammarLessonsRepository.instance;

    setUp(() {
      repository.clearCache();
    });

    test('Loads all 31 grammar lessons from assets/data/grammar_lessons.json', () async {
      final lessons = await repository.getAllLessons();
      expect(lessons.length, 31);
    });

    test('Filters 25 reference lessons (Toàn tập 25 chủ đề)', () async {
      final refLessons = await repository.getReferenceLessons();
      expect(refLessons.length, 25);
      for (final l in refLessons) {
        expect(l.category, 'reference');
      }
    });

    test('Filters 6 advanced lessons (Nâng cao theo Band)', () async {
      final advLessons = await repository.getAdvancedLessons();
      expect(advLessons.length, 6);
      for (final l in advLessons) {
        expect(l.category, 'advanced');
      }
    });

    test('Finds lesson by ID and Slug', () async {
      final byId = await repository.getLessonById('grm_01_word_forms');
      expect(byId, isNotNull);
      expect(byId!.titleEn, 'Word Forms');
      expect(byId.theorySections, isNotEmpty);
      expect(byId.questions, isNotEmpty);

      final bySlug = await repository.getLessonById('grm-tenses');
      expect(bySlug, isNotNull);
      expect(bySlug!.titleEn, 'English Tenses');

      final notFound = await repository.getLessonById('non_existent_random_id');
      expect(notFound, isNull);
    });

    test('All lessons have valid theory sections and question banks', () async {
      final lessons = await repository.getAllLessons();
      for (final l in lessons) {
        expect(l.id, isNotEmpty);
        expect(l.slug, isNotEmpty);
        expect(l.title, isNotEmpty);
        expect(l.theorySections, isNotEmpty, reason: 'Lesson ${l.id} should have theorySections');
        expect(l.questions, isNotEmpty, reason: 'Lesson ${l.id} should have questions');

        for (final q in l.questions) {
          expect(q.id, isNotEmpty);
          expect(q.questionText, isNotEmpty);
          expect(q.options.length, 4, reason: 'Question ${q.id} in ${l.id} should have 4 options');
          expect(q.correctIndex, inInclusiveRange(0, 3));
          expect(q.explanation, isNotEmpty);
        }
      }
    });

    test('In-memory cache returns cached instance on subsequent calls', () async {
      final firstCall = await repository.getAllLessons();
      final secondCall = await repository.getAllLessons();
      expect(identical(firstCall, secondCall), isTrue);
    });
  });
}
