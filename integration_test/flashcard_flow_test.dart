import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studydeck_ai/features/flashcard/screens/flashcard_review_screen.dart';
import 'package:studydeck_ai/features/flashcard/widgets/flashcard_mode_bottom_bar.dart';
import 'package:studydeck_ai/models/edu_word.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('E2E Integration Test: Flashcard review flow and mode switching on emulator', (tester) async {
    SharedPreferences.setMockInitialValues({});

    final testWords = [
      EduWord(
        id: 1,
        title: 'Spring',
        viword: 'Mùa xuân',
        description: 'The season between winter and summer',
        videscription: 'Mùa giữa mùa đông và mùa hè',
        transcription: '/sprɪŋ/',
        example: 'Flowers bloom in spring.',
        level: 'A1',
      ),
      EduWord(
        id: 2,
        title: 'Summer',
        viword: 'Mùa hè',
        description: 'The warmest season',
        videscription: 'Mùa nóng nhất',
        transcription: '/ˈsʌm.ər/',
        example: 'It is hot in summer.',
        level: 'A1',
      ),
      EduWord(
        id: 3,
        title: 'Autumn',
        viword: 'Mùa thu',
        description: 'The season before winter',
        videscription: 'Mùa trước mùa đông',
        transcription: '/ˈɔː.təm/',
        example: 'Leaves fall in autumn.',
        level: 'A1',
      ),
      EduWord(
        id: 4,
        title: 'Winter',
        viword: 'Mùa đông',
        description: 'The coldest season',
        videscription: 'Mùa lạnh nhất',
        transcription: '/ˈwɪn.tər/',
        example: 'Snow falls in winter.',
        level: 'A1',
      ),
    ];

    // Khởi tạo giao diện FlashcardReviewScreen
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true),
        home: FlashcardReviewScreen(
          level: 'A1',
          levelTitle: 'Bộ Thẻ Cấp A1',
          mode: 'study',
          customWords: testWords,
        ),
      ),
    );

    // Chờ giao diện render và tải xong dữ liệu
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // 1. Kiểm tra từ vựng đầu tiên hiển thị
    expect(find.text('Spring'), findsWidgets);

    // 2. Chạm vào thanh chọn chế độ học (Bottom Bar)
    final modeBar = find.byType(FlashcardModeBottomBar);
    expect(modeBar, findsOneWidget);
    await tester.tap(modeBar);
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // 3. Kiểm tra Modal mở ra và hiển thị chế độ "Tổng hợp" ở cuối
    final mixedModeOption = find.text('Tổng hợp');
    expect(mixedModeOption, findsWidgets);
    await tester.ensureVisible(mixedModeOption.first);
    await tester.pumpAndSettle();

    // 4. Bấm chọn chế độ "Tổng hợp"
    await tester.tap(mixedModeOption.first);
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // 5. Bấm nút Bắt đầu với Tổng hợp
    final startBtn = find.text('Bắt đầu với Tổng hợp');
    await tester.ensureVisible(startBtn);
    await tester.tap(startBtn);
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // 5. Xác nhận giao diện cập nhật sang chế độ Tổng hợp
    expect(find.textContaining('Tổng hợp'), findsWidgets);
  });
}
