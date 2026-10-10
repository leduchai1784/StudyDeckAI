import 'package:flutter_test/flutter_test.dart';
import 'package:studydeck_ai/features/skills/speaking/data/speaking_forecast_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('SpeakingForecastRepository loads all 112 forecast topics from JSON assets', () async {
    await SpeakingForecastRepository.ensureLoaded();
    final topics = SpeakingForecastRepository.getAllTopics();

    // Tổng số chủ đề phải đạt ít nhất 112
    expect(topics.length, greaterThanOrEqualTo(112));

    // 1. Kiểm tra 2 chủ đề Part 1 Bắt buộc (Compulsory)
    final comp1 = topics.firstWhere((t) => t.id == 'speaking_p1_compulsory_1');
    expect(comp1.title, 'Where you live now');
    expect(comp1.isCompulsory, isTrue);
    expect(comp1.partNumber, 1);
    expect(comp1.questions.length, 10);
    expect(comp1.questions.first.questionText, 'Which town or city do you live in now?');

    final comp2 = topics.firstWhere((t) => t.id == 'speaking_p1_compulsory_2');
    expect(comp2.title, 'Work / Study');
    expect(comp2.isCompulsory, isTrue);
    expect(comp2.partNumber, 1);
    expect(comp2.questions.length, 11);

    // 2. Kiểm tra 44 chủ đề Part 1
    final topic1 = topics.firstWhere((t) => t.id == 'speaking_p1_t1');
    expect(topic1.title, 'Computers / Tablets');
    expect(topic1.titleVi, 'Máy tính & Máy tính bảng');
    expect(topic1.categoryTag, 'society_tech');
    expect(topic1.questions.length, 3);
    expect(topic1.questions.first.questionText, 'In what conditions would you use a computer?');

    // 3. Kiểm tra 66 chủ đề Part 2 & 3
    final p2Topic1 = topics.firstWhere((t) => t.id == 'speaking_p23_t1');
    expect(p2Topic1.partNumber, 2);
    expect(p2Topic1.title, contains('Describe a person you only met once'));
    expect(p2Topic1.questions.first.cueCardPrompts, isNotNull);
    expect(p2Topic1.questions.first.cueCardPrompts!.length, greaterThanOrEqualTo(3));
    expect(p2Topic1.questions.length, greaterThan(1)); // Cue card + Part 3 questions

    // 4. Kiểm tra độ phủ của 4 nhóm ngữ nghĩa
    expect(topics.any((t) => t.categoryTag == 'daily_life'), isTrue);
    expect(topics.any((t) => t.categoryTag == 'hobbies_lifestyle'), isTrue);
    expect(topics.any((t) => t.categoryTag == 'society_tech'), isTrue);
    expect(topics.any((t) => t.categoryTag == 'abstract_skills'), isTrue);
  });
}
