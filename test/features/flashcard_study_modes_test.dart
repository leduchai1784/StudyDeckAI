import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studydeck_ai/features/flashcard/widgets/flashcard_study_card.dart';
import 'package:studydeck_ai/features/flashcard/widgets/flashcard_settings_bottom_sheet.dart';
import 'package:studydeck_ai/features/flashcard/widgets/flashcard_mode_bottom_bar.dart';
import 'package:studydeck_ai/features/flashcard/widgets/flashcard_study_modes_modal.dart';
import 'package:studydeck_ai/features/flashcard/widgets/flashcard_typing_view.dart';
import 'package:studydeck_ai/features/flashcard/widgets/flashcard_quiz_view.dart';
import 'package:studydeck_ai/features/flashcard/widgets/flashcard_listening_view.dart';
import 'package:studydeck_ai/features/flashcard/widgets/flashcard_cloze_view.dart';
import 'package:studydeck_ai/features/flashcard/widgets/flashcard_pronunciation_view.dart';
import 'package:studydeck_ai/features/flashcard/widgets/flashcard_card_blast_view.dart';
import 'package:studydeck_ai/models/edu_word.dart';

void main() {
  final sampleWord = EduWord(
    id: 1,
    title: 'Spring',
    viword: 'Mùa xuân',
    description: 'The season between winter and summer',
    videscription: 'Mùa giữa mùa đông và mùa hè',
    transcription: '/sprɪŋ/',
    example: 'Flowers bloom in spring.',
    level: 'A1',
  );

  final otherWords = [
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

  group('Flashcard Mode Bottom Bar Tests', () {
    testWidgets('Renders current mode title and triggers onChangeMode', (tester) async {
      bool changed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlashcardModeBottomBar(
              currentMode: FlashcardStudyMode.flipCard,
              onChangeMode: () {
                changed = true;
              },
            ),
          ),
        ),
      );

      expect(find.text('Chế độ luyện tập'), findsOneWidget);
      expect(find.text('Đang học: Lật thẻ (SRS)'), findsOneWidget);
      expect(find.text('Đổi chế độ'), findsOneWidget);

      await tester.tap(find.text('Đổi chế độ'));
      expect(changed, isTrue);
    });

    testWidgets('Renders mixed mode with currentSubMode label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlashcardModeBottomBar(
              currentMode: FlashcardStudyMode.mixed,
              currentSubMode: FlashcardStudyMode.quiz,
              onChangeMode: () {},
            ),
          ),
        ),
      );

      expect(find.text('Chế độ luyện tập'), findsOneWidget);
      expect(find.text('Đang học: Tổng hợp • Quiz 4 đáp án'), findsOneWidget);
    });
  });

  group('Flashcard Study Modes Modal Tests', () {
    testWidgets('Displays 8 study modes and allows selection including Card Blast and mixed mode', (tester) async {
      FlashcardStudyMode? selectedMode;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlashcardStudyModesModal(
              currentMode: FlashcardStudyMode.flipCard,
              onSelectMode: (mode) {
                selectedMode = mode;
              },
            ),
          ),
        ),
      );

      expect(find.text('Chế độ luyện tập'), findsOneWidget);
      expect(find.text('Lật thẻ'), findsOneWidget);
      expect(find.text('Gõ từ'), findsOneWidget);
      expect(find.text('Quiz trắc nghiệm'), findsOneWidget);
      expect(find.text('Luyện nghe'), findsOneWidget);
      expect(find.text('Điền vào chỗ trống'), findsOneWidget);
      expect(find.text('Luyện phát âm AI'), findsOneWidget);
      expect(find.text('Card Blast'), findsOneWidget);
      expect(find.text('Tổng hợp'), findsOneWidget);

      // Cuộn tới và chọn chế độ Card Blast
      final blastOption = find.text('Card Blast');
      await tester.ensureVisible(blastOption);
      await tester.pumpAndSettle();
      await tester.tap(blastOption);
      await tester.pumpAndSettle();
      expect(find.text('Bắt đầu với Card Blast'), findsOneWidget);

      // Cuộn tới và chọn chế độ Tổng hợp
      final mixedOption = find.text('Tổng hợp');
      await tester.ensureVisible(mixedOption);
      await tester.pumpAndSettle();
      await tester.tap(mixedOption);
      await tester.pumpAndSettle();

      // Nút bắt đầu cập nhật tên chế độ
      final startBtn = find.text('Bắt đầu với Tổng hợp');
      expect(startBtn, findsOneWidget);
      await tester.ensureVisible(startBtn);
      await tester.pumpAndSettle();
      await tester.tap(startBtn);
      expect(selectedMode, equals(FlashcardStudyMode.mixed));
    });
  });

  group('Flashcard Typing View Tests', () {
    testWidgets('Gives hint and checks correct answer', (tester) async {
      bool? isCorrect;
      bool spoke = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlashcardTypingView(
              word: sampleWord,
              onAnswer: (correct) => isCorrect = correct,
              onSpeak: () => spoke = true,
            ),
          ),
        ),
      );

      expect(find.text('Mùa xuân'), findsOneWidget);

      // Bấm nút Gợi ý
      await tester.tap(find.text('Gợi ý'));
      await tester.pump();
      expect(find.widgetWithText(AnimatedContainer, 'S'), findsOneWidget);

      // Gõ đáp án đúng
      await tester.enterText(find.byType(TextField), 'spring');
      await tester.pump();

      await tester.tap(find.text('Kiểm tra'));
      await tester.pump();

      expect(spoke, isTrue);
      expect(find.text('Chính xác! Xuất sắc 🎉'), findsOneWidget);
      expect(find.text('Tiếp tục'), findsOneWidget);

      // Bấm nút Tiếp tục để hoàn tất và chuyển thẻ
      await tester.tap(find.text('Tiếp tục'));
      await tester.pump();
      expect(isCorrect, isTrue);
    });
  });

  group('Flashcard Quiz View Tests', () {
    testWidgets('Generates 4 options and accepts correct answer', (tester) async {
      bool? isCorrect;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlashcardQuizView(
              currentWord: sampleWord,
              allWords: [sampleWord, ...otherWords],
              onAnswer: (correct) => isCorrect = correct,
              onSpeak: () {},
            ),
          ),
        ),
      );

      expect(find.text('Spring'), findsOneWidget);
      expect(find.text('Mùa xuân'), findsOneWidget);

      // Bấm vào đáp án đúng "Mùa xuân"
      await tester.tap(find.text('Mùa xuân'));
      await tester.pump();

      expect(isCorrect, isTrue);
    });
  });

  group('Flashcard Listening View Tests', () {
    testWidgets('Plays audio and validates listening input', (tester) async {
      bool? isCorrect;
      double? playedRate;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlashcardListeningView(
              word: sampleWord,
              onAnswer: (correct) => isCorrect = correct,
              onPlayAudio: (rate) => playedRate = rate,
            ),
          ),
        ),
      );

      // Tự động play khi init
      expect(playedRate, equals(0.5));
      expect(find.text('Luyện nghe chính tả'), findsOneWidget);

      // Bấm nút chậm 0.75x
      await tester.tap(find.text('Chậm 0.75x'));
      await tester.pump();
      expect(playedRate, equals(0.35));

      // Bấm nút gợi ý nghĩa
      await tester.tap(find.text('Gợi ý nghĩa'));
      await tester.pump();
      expect(find.text('Mùa xuân'), findsOneWidget);

      // Gõ đáp án và nộp
      await tester.enterText(find.byType(TextField), 'spring');
      await tester.pump();
      await tester.tap(find.text('Kiểm tra'));
      await tester.pumpAndSettle();

      expect(isCorrect, isTrue);
      expect(find.textContaining('Chính xác!'), findsOneWidget);
    });
  });

  group('Flashcard Cloze View Tests', () {
    testWidgets('Generates cloze sentence and checks answer', (tester) async {
      bool? isCorrect;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlashcardClozeView(
              word: sampleWord,
              onAnswer: (correct) => isCorrect = correct,
              onSpeak: () {},
            ),
          ),
        ),
      );

      expect(find.text('Điền vào chỗ trống'), findsOneWidget);
      expect(find.textContaining('[ ______ ]'), findsOneWidget);

      // Nhập đáp án
      await tester.enterText(find.byType(TextField), 'spring');
      await tester.pump();
      await tester.tap(find.text('Kiểm tra'));
      await tester.pumpAndSettle();

      expect(isCorrect, isTrue);
      expect(find.textContaining('Chính xác!'), findsOneWidget);
    });
  });

  group('Flashcard Study Card Customization Tests', () {
    testWidgets('Renders front card with English word and IPA by default', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlashcardStudyCard(
              word: sampleWord,
              isStarred: false,
              isFlipped: false,
              flipAnimation: const AlwaysStoppedAnimation(0.0),
              onFlip: () {},
              onSpeak: () {},
              onToggleStar: () {},
              isFrontVietnamese: false,
              showIpa: true,
              showExample: true,
            ),
          ),
        ),
      );

      expect(find.text('Spring'), findsOneWidget);
      expect(find.text('/sprɪŋ/'), findsOneWidget);
      expect(find.text('Chạm thẻ để xem giải nghĩa'), findsOneWidget);
    });

    testWidgets('Renders front card with Vietnamese word when isFrontVietnamese is true', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlashcardStudyCard(
              word: sampleWord,
              isStarred: false,
              isFlipped: false,
              flipAnimation: const AlwaysStoppedAnimation(0.0),
              onFlip: () {},
              onSpeak: () {},
              onToggleStar: () {},
              isFrontVietnamese: true,
              showIpa: true,
              showExample: true,
            ),
          ),
        ),
      );

      expect(find.text('Mùa xuân'), findsOneWidget);
      expect(find.text('/sprɪŋ/'), findsNothing);
      expect(find.text('Chạm thẻ để xem từ tiếng Anh'), findsOneWidget);
    });

    testWidgets('Hides IPA when showIpa is false', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlashcardStudyCard(
              word: sampleWord,
              isStarred: false,
              isFlipped: false,
              flipAnimation: const AlwaysStoppedAnimation(0.0),
              onFlip: () {},
              onSpeak: () {},
              onToggleStar: () {},
              isFrontVietnamese: false,
              showIpa: false,
              showExample: true,
            ),
          ),
        ),
      );

      expect(find.text('Spring'), findsOneWidget);
      expect(find.text('/sprɪŋ/'), findsNothing);
    });

    testWidgets('Renders back card with and without example based on showExample', (tester) async {
      // 1. With example
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlashcardStudyCard(
              word: sampleWord,
              isStarred: false,
              isFlipped: true,
              flipAnimation: const AlwaysStoppedAnimation(1.0),
              onFlip: () {},
              onSpeak: () {},
              onToggleStar: () {},
              isFrontVietnamese: false,
              showIpa: true,
              showExample: true,
            ),
          ),
        ),
      );

      expect(find.text('VÍ DỤ:'), findsOneWidget);
      expect(find.text('Flowers bloom in spring.'), findsOneWidget);

      // 2. Without example
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlashcardStudyCard(
              word: sampleWord,
              isStarred: false,
              isFlipped: true,
              flipAnimation: const AlwaysStoppedAnimation(1.0),
              onFlip: () {},
              onSpeak: () {},
              onToggleStar: () {},
              isFrontVietnamese: false,
              showIpa: true,
              showExample: false,
            ),
          ),
        ),
      );

      expect(find.text('VÍ DỤ:'), findsNothing);
    });
  });

  group('Flashcard Settings Bottom Sheet Tests', () {
    testWidgets('Opens settings sheet and renders all customization options', (tester) async {
      bool frontLangChanged = false;
      bool shuffleTriggered = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    FlashcardSettingsBottomSheet.show(
                      context,
                      onShuffle: () {
                        shuffleTriggered = true;
                      },
                      isFrontVietnamese: false,
                      onChangeFrontLanguage: (val) => frontLangChanged = val,
                      showIpa: true,
                      onToggleShowIpa: (_) {},
                      showExample: true,
                      onToggleShowExample: (_) {},
                    );
                  },
                  child: const Text('Mở Cài Đặt'),
                );
              },
            ),
          ),
        ),
      );

      // Mở modal
      await tester.tap(find.text('Mở Cài Đặt'));
      await tester.pumpAndSettle();

      expect(find.text('Cài đặt học tập Flashcard'), findsOneWidget);
      expect(find.text('Trộn ngẫu nhiên thẻ'), findsOneWidget);
      expect(find.text('Trộn ngay'), findsOneWidget);
      expect(find.text('Mặt trước của thẻ'), findsOneWidget);
      expect(find.text('Tiếng Anh (Mặc định)'), findsOneWidget);
      expect(find.text('Tiếng Việt'), findsOneWidget);
      expect(find.text('Hiển thị phiên âm IPA'), findsOneWidget);
      expect(find.text('Hiển thị câu ví dụ ngữ cảnh'), findsOneWidget);

      // Nhấn nút Trộn ngay
      await tester.tap(find.text('Trộn ngay'));
      await tester.pump();
      expect(shuffleTriggered, isTrue);

      // Chuyển mặt trước sang Tiếng Việt
      await tester.tap(find.text('Tiếng Việt'));
      await tester.pump();
      expect(frontLangChanged, isTrue);
    });
  });

  group('Flashcard Pronunciation View Tests', () {
    testWidgets('Renders word, IPA, and handles mic interactions', (tester) async {
      bool answered = false;
      bool spoken = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlashcardPronunciationView(
              word: sampleWord,
              onAnswer: (val) {
                answered = val;
              },
              onSpeak: () {
                spoken = true;
              },
            ),
          ),
        ),
      );

      expect(spoken, isTrue);
      expect(find.text('Spring'), findsOneWidget);
      expect(find.text('/sprɪŋ/'), findsOneWidget);
      expect(find.text('Mùa xuân'), findsOneWidget);
      expect(find.text('Luyện phát âm AI'), findsOneWidget);
      expect(find.text('Chạm micro để phát âm từ này'), findsOneWidget);

      // Chạm micro để thu âm
      await tester.tap(find.byIcon(Icons.mic_rounded).last);
      await tester.pump(const Duration(milliseconds: 200));

      // Chạm stop để kết thúc thu âm và phân tích
      await tester.tap(find.byIcon(Icons.stop_rounded));
      await tester.pump(const Duration(milliseconds: 300));

      // Xác nhận hiển thị nút Tiếp tục và gọi onAnswer
      expect(find.text('Tiếp tục'), findsOneWidget);
      await tester.tap(find.text('Tiếp tục'));
      await tester.pump();
      expect(answered, isTrue);
    });
  });

  group('Flashcard Card Blast View Tests', () {
    testWidgets('Renders options, selects correct answer and triggers blast combo', (tester) async {
      bool? isCorrect;
      bool spoke = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlashcardCardBlastView(
              currentWord: sampleWord,
              allWords: [sampleWord, ...otherWords],
              onAnswer: (correct) => isCorrect = correct,
              onSpeak: () => spoke = true,
            ),
          ),
        ),
      );
      await tester.pump();

      expect(spoke, isTrue);
      expect(find.text('Card Blast'), findsOneWidget);
      expect(find.text('Spring'), findsOneWidget);

      // Nhấn chọn đáp án đúng "Mùa xuân"
      final correctOption = find.text('Mùa xuân');
      expect(correctOption, findsOneWidget);
      await tester.tap(correctOption);
      await tester.pump();

      expect(isCorrect, isTrue);
      expect(find.text('BLAST! +100 Điểm phản xạ cực nhanh! ⚡'), findsOneWidget);
    });

    testWidgets('Handles timeout when no answer is selected within 7s', (tester) async {
      bool? isCorrect;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlashcardCardBlastView(
              currentWord: sampleWord,
              allWords: [sampleWord, ...otherWords],
              onAnswer: (correct) => isCorrect = correct,
              onSpeak: () {},
            ),
          ),
        ),
      );
      await tester.pump();

      // Cho thời gian trôi 8 giây để kích hoạt hết giờ (Blast fuse nổ)
      await tester.pump(const Duration(seconds: 8));
      await tester.pump();

      expect(isCorrect, isFalse);
      expect(find.text('💥 Hết giờ! Cố gắng phản xạ nhanh hơn ở thẻ sau nhé!'), findsOneWidget);
    });
  });
}
