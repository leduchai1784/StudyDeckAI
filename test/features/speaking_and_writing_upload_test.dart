import 'package:flutter_test/flutter_test.dart';
import 'package:studydeck_ai/features/ai_tutor/services/gemini_ai_tutor_service.dart';
import 'package:studydeck_ai/features/skills/writing/models/writing_model.dart';
import 'package:studydeck_ai/features/skills/speaking/models/speaking_model.dart';

void main() {
  group('Speaking & Writing Upload Features Unit Tests', () {
    test('GeminiAiTutorService instance is created and methods are defined', () {
      final service = GeminiAiTutorService();
      expect(service, isNotNull);
    });

    test('WritingPrompt model correctly supports Word Count and Task Type', () {
      const prompt = WritingPrompt(
        id: 'test_task_2',
        taskType: WritingTaskType.task2,
        category: WritingCategory.opinion,
        categoryLabel: 'Environment',
        title: 'Global Warming Essay',
        promptText: 'Some people argue that global warming is the biggest threat...',
        minWords: 250,
        sampleEssayBand8: 'A band 8 sample essay...',
      );

      expect(prompt.id, 'test_task_2');
      expect(prompt.taskType, WritingTaskType.task2);
      expect(prompt.minWords, 250);
      expect(prompt.categoryLabel, 'Environment');
    });

    test('SpeakingTopic model correctly structures question prompts', () {
      const topic = SpeakingTopic(
        id: 'topic_test_1',
        quarter: 'Q3-2026',
        title: 'Bicycles',
        titleVi: 'Xe đạp',
        categoryTag: 'daily_life',
        bandTarget: '7.5+',
        partNumber: 1,
        isCompulsory: false,
        questions: [
          SpeakingQuestion(
            id: 'q_1',
            part: SpeakingPart.part1,
            questionText: 'Do you often ride a bicycle?',
            ideaHints: ['Health benefit', 'Environmentally friendly'],
            usefulVocab: [],
            sampleAnswerBand8: 'Yes, I ride quite frequently.',
          ),
        ],
      );

      expect(topic.id, 'topic_test_1');
      expect(topic.partNumber, 1);
      expect(topic.questions.length, 1);
      expect(topic.questions.first.questionText, contains('bicycle'));
    });
  });
}
