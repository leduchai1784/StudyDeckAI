import 'package:flutter_test/flutter_test.dart';
import 'package:studydeck_ai/features/skills/speaking/data/speaking_forecast_repository.dart';
import 'package:studydeck_ai/features/skills/speaking/models/speaking_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Speaking 3 Dedicated Parts Data Isolation Tests', () {
    setUpAll(() async {
      await SpeakingForecastRepository.ensureLoaded();
    });

    test('Part 1 topics filter isolates 46 topics (2 compulsory + 44 forecast)', () {
      final allTopics = SpeakingForecastRepository.getAllTopics();
      final p1Topics = allTopics.where((t) => t.partNumber == 1 && t.quarter == 'Q3-2026').toList();

      expect(p1Topics.length, 46);

      final compulsory = p1Topics.where((t) => t.isCompulsory && t.id.contains('compulsory')).toList();
      expect(compulsory.length, 2);

      final forecast = p1Topics.where((t) => !t.id.contains('compulsory')).toList();
      expect(forecast.length, 44);

      // Verify all Part 1 questions have part1 enum
      for (final topic in p1Topics) {
        expect(topic.questions.every((q) => q.part == SpeakingPart.part1), isTrue);
      }
    });

    test('Part 2 topics filter isolates 66 Cue Cards with prompts', () {
      final allTopics = SpeakingForecastRepository.getAllTopics();
      final p2Topics = allTopics.where((t) => t.partNumber == 2 && t.quarter == 'Q3-2026').toList();

      expect(p2Topics.length, 66);

      for (final topic in p2Topics) {
        final cueQ = topic.questions.firstWhere((q) => q.part == SpeakingPart.part2);
        expect(cueQ.cueCardPrompts, isNotNull);
        expect(cueQ.cueCardPrompts!.isNotEmpty, isTrue);
        expect(cueQ.audioDurationSeconds, 120); // 2 minutes
      }
    });

    test('Part 3 topics filter isolates 66 topics with discussion questions', () {
      final allTopics = SpeakingForecastRepository.getAllTopics();
      final p3Topics = allTopics
          .where((t) => t.partNumber == 2 && t.quarter == 'Q3-2026' && t.questions.any((q) => q.part == SpeakingPart.part3))
          .toList();

      expect(p3Topics.length, 66);

      int totalP3Questions = 0;
      for (final topic in p3Topics) {
        final p3Questions = topic.questions.where((q) => q.part == SpeakingPart.part3).toList();
        expect(p3Questions.isNotEmpty, isTrue);
        totalP3Questions += p3Questions.length;
      }
      expect(totalP3Questions, greaterThanOrEqualTo(200));
    });
    test('Part 1 Compulsory isolates exactly 2 topics (Where you live now & Work / Study) with 21 questions', () {
      final allTopics = SpeakingForecastRepository.getAllTopics();
      final compulsory = allTopics.where((t) => t.isCompulsory && t.partNumber == 1).toList();

      expect(compulsory.length, 2);
      expect(compulsory.any((t) => t.title.toLowerCase().contains('where you live')), isTrue);
      expect(compulsory.any((t) => t.title.toLowerCase().contains('work') || t.title.toLowerCase().contains('study')), isTrue);

      final totalQuestions = compulsory.fold<int>(0, (sum, t) => sum + t.questions.length);
      expect(totalQuestions, 21);
    });

    test('Part 1 Topics isolates exactly 44 topics with 196 questions', () {
      final allTopics = SpeakingForecastRepository.getAllTopics();
      final part1Topics = allTopics
          .where((t) => t.partNumber == 1 && !t.isCompulsory && t.quarter == 'Q3-2026')
          .toList();

      expect(part1Topics.length, 44);
      final totalQuestions = part1Topics.fold<int>(0, (sum, t) => sum + t.questions.length);
      expect(totalQuestions, 196);
    });

    test('Part 2 + 3 isolates exactly 66 topics, all containing Cue Card and Part 3 discussion questions', () {
      final allTopics = SpeakingForecastRepository.getAllTopics();
      final part23Topics = allTopics
          .where((t) => t.partNumber == 2 && t.quarter == 'Q3-2026')
          .toList();

      expect(part23Topics.length, 66);
      int totalP3Questions = 0;
      for (final topic in part23Topics) {
        // Must have Cue Card
        final cueCard = topic.questions.where((q) => q.part == SpeakingPart.part2).toList();
        expect(cueCard.length, 1);
        expect(cueCard.first.cueCardPrompts, isNotNull);
        expect(cueCard.first.cueCardPrompts!.isNotEmpty, isTrue);

        // Must have Part 3 discussion questions
        final p3 = topic.questions.where((q) => q.part == SpeakingPart.part3).toList();
        expect(p3.isNotEmpty, isTrue);
        totalP3Questions += p3.length;
      }
      expect(totalP3Questions, 293);
    });
  });
}
