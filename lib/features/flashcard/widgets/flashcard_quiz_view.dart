import 'dart:math';
import 'package:flutter/material.dart';
import '../../../app/theme.dart';
import '../../../models/edu_word.dart';

/// Giao diện chế độ Quiz trắc nghiệm 4 đáp án
/// Phản xạ nhanh, đổi màu trực quan khi chọn, cuộn mượt mà trên mọi thiết bị
class FlashcardQuizView extends StatefulWidget {
  final EduWord currentWord;
  final List<EduWord> allWords;
  final ValueChanged<bool> onAnswer;
  final VoidCallback onSpeak;

  const FlashcardQuizView({
    super.key,
    required this.currentWord,
    required this.allWords,
    required this.onAnswer,
    required this.onSpeak,
  });

  @override
  State<FlashcardQuizView> createState() => _FlashcardQuizViewState();
}

class _FlashcardQuizViewState extends State<FlashcardQuizView> {
  late List<String> _options;
  int? _selectedIndex;
  bool _hasAnswered = false;

  @override
  void initState() {
    super.initState();
    _generateOptions();
  }

  @override
  void didUpdateWidget(covariant FlashcardQuizView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentWord.id != widget.currentWord.id) {
      _generateOptions();
    }
  }

  void _generateOptions() {
    _selectedIndex = null;
    _hasAnswered = false;

    final correctAnswer = widget.currentWord.viword.isNotEmpty
        ? widget.currentWord.viword
        : widget.currentWord.description;

    // Lấy 3 đáp án nhiễu từ các từ khác trong deck
    final otherWords = widget.allWords
        .where((w) => w.id != widget.currentWord.id && w.viword.isNotEmpty)
        .toList();
    otherWords.shuffle(Random());

    final distractors = otherWords
        .take(3)
        .map((w) => w.viword)
        .toList();

    // Trường hợp deck ít từ, thêm lựa chọn dự phòng
    while (distractors.length < 3) {
      distractors.add('Nghĩa khác ${distractors.length + 1}');
    }

    final list = [correctAnswer, ...distractors];
    list.shuffle(Random());
    _options = list;
  }

  void _handleSelect(int index) {
    if (_hasAnswered) return;

    final selectedText = _options[index];
    final correctAnswer = widget.currentWord.viword.isNotEmpty
        ? widget.currentWord.viword
        : widget.currentWord.description;

    final isCorrect = selectedText.trim() == correctAnswer.trim();

    setState(() {
      _selectedIndex = index;
      _hasAnswered = true;
    });

    widget.onAnswer(isCorrect);
  }

  @override
  Widget build(BuildContext context) {
    final correctAnswer = widget.currentWord.viword.isNotEmpty
        ? widget.currentWord.viword
        : widget.currentWord.description;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.brandSurface,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd), // 12px
        border: Border.all(color: AppTheme.brandBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          // Header: Tag Quiz + Loa
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusXs),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.help_outline_rounded, size: 14, color: Color(0xFFF59E0B)),
                    SizedBox(width: 4),
                    Text(
                      'Quiz Trắc nghiệm',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF59E0B),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.volume_up_rounded, color: AppTheme.brandPrimary, size: 24),
                onPressed: widget.onSpeak,
                tooltip: 'Phát âm',
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Từ vựng cần tìm nghĩa
          Text(
            widget.currentWord.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppTheme.brandTextPrimary,
            ),
          ),
          if (widget.currentWord.formattedTranscription.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              widget.currentWord.formattedTranscription,
              style: AppTheme.ipaStyle(fontSize: 16, color: AppTheme.onSurfaceVariant),
            ),
          ],

          const SizedBox(height: 16),

          // 4 ô đáp án lựa chọn - Có thể cuộn an toàn chống tràn
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: _options.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final option = _options[index];
                final isSelected = _selectedIndex == index;
                final isThisCorrect = option.trim() == correctAnswer.trim();

                Color bgColor = AppTheme.brandSurface;
                Color borderColor = AppTheme.brandBorder;
                Color textColor = AppTheme.brandTextPrimary;
                Widget? trailingIcon;

                if (_hasAnswered) {
                  if (isThisCorrect) {
                    bgColor = AppTheme.tintGreenBg;
                    borderColor = AppTheme.brandSuccess;
                    textColor = AppTheme.tintGreenText;
                    trailingIcon = const Icon(Icons.check_circle_rounded, color: AppTheme.brandSuccess, size: 20);
                  } else if (isSelected) {
                    bgColor = const Color(0xFFFFEBEA);
                    borderColor = const Color(0xFFD32F2F);
                    textColor = const Color(0xFFD32F2F);
                    trailingIcon = const Icon(Icons.cancel_rounded, color: Color(0xFFD32F2F), size: 20);
                  }
                }

                return InkWell(
                  onTap: () => _handleSelect(index),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm), // 8px
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                      border: Border.all(
                        color: borderColor,
                        width: isSelected || (_hasAnswered && isThisCorrect) ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? borderColor
                                : AppTheme.brandBackground,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            String.fromCharCode(65 + index), // A, B, C, D
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : AppTheme.brandTextSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            option,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              color: textColor,
                              height: 1.3,
                            ),
                          ),
                        ),
                        if (trailingIcon != null) trailingIcon,
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
