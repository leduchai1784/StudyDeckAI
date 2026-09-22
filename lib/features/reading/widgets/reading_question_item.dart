import 'package:flutter/material.dart';
import '../../../app/theme.dart';
import '../models/reading_test_model.dart';

class ReadingQuestionItem extends StatelessWidget {
  final ReadingQuestion question;
  final String currentAnswer;
  final ValueChanged<String> onAnswerChanged;

  const ReadingQuestionItem({
    super.key,
    required this.question,
    required this.currentAnswer,
    required this.onAnswerChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool isAnswered = currentAnswer.trim().isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isAnswered ? AppTheme.brandPrimary.withValues(alpha: 0.4) : const Color(0xFFE2E8F0),
          width: isAnswered ? 1.4 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question Header: Number + Prompt
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isAnswered ? AppTheme.brandPrimary : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Câu ${question.number}',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                    color: isAnswered ? Colors.white : const Color(0xFF64748B),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  question.prompt,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.brandTextPrimary,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Render Question Inputs
          _buildInputWidget(context),
        ],
      ),
    );
  }

  Widget _buildInputWidget(BuildContext context) {
    switch (question.type) {
      case ReadingQuestionType.trueFalseNotGiven:
        return _buildChoiceRow(['TRUE', 'FALSE', 'NOT GIVEN']);
      case ReadingQuestionType.yesNoNotGiven:
        return _buildChoiceRow(['YES', 'NO', 'NOT GIVEN']);
      case ReadingQuestionType.multipleChoice:
        return _buildMultipleChoiceList();
      case ReadingQuestionType.matchingHeadings:
      case ReadingQuestionType.sentenceCompletion:
        if (question.options != null && question.options!.isNotEmpty) {
          return _buildMultipleChoiceList();
        }
        return _buildTextInput();
      case ReadingQuestionType.noteCompletion:
        return _buildTextInput();
    }
  }

  // Row of Chips for TRUE/FALSE/NOT GIVEN
  Widget _buildChoiceRow(List<String> options) {
    return Row(
      children: options.map((opt) {
        final isSelected = currentAnswer.toUpperCase() == opt.toUpperCase();
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: InkWell(
              onTap: () => onAnswerChanged(opt),
              borderRadius: BorderRadius.circular(8),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(vertical: 9),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.brandPrimary : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? AppTheme.brandPrimary : const Color(0xFFCBD5E1),
                    width: isSelected ? 1.5 : 1.0,
                  ),
                ),
                child: Text(
                  opt,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : const Color(0xFF475569),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // Vertical list of Multiple Choice options (A, B, C, D)
  Widget _buildMultipleChoiceList() {
    final opts = question.options ?? [];
    return Column(
      children: opts.map((opt) {
        // Extract letter prefix if present (e.g. "A. It has already...")
        final letter = opt.isNotEmpty ? opt.split('.').first.trim().toUpperCase() : '';
        final isSelected = currentAnswer.toUpperCase() == letter || currentAnswer.toUpperCase() == opt.toUpperCase();

        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: InkWell(
            onTap: () => onAnswerChanged(letter.isNotEmpty ? letter : opt),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.chipIndigoBg : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? AppTheme.brandPrimary : const Color(0xFFE2E8F0),
                  width: isSelected ? 1.5 : 1.0,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? AppTheme.brandPrimary : Colors.white,
                      border: Border.all(
                        color: isSelected ? AppTheme.brandPrimary : const Color(0xFF94A3B8),
                      ),
                    ),
                    child: Text(
                      letter,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : const Color(0xFF475569),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      opt,
                      style: TextStyle(
                        fontSize: 13,
                        color: isSelected ? AppTheme.brandPrimary : const Color(0xFF334155),
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // Text Input for Fill in the Blanks / Note Completion
  Widget _buildTextInput() {
    return TextFormField(
      initialValue: currentAnswer,
      onChanged: onAnswerChanged,
      decoration: InputDecoration(
        hintText: 'Nhập câu trả lời...',
        hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppTheme.brandPrimary),
        ),
        suffixIcon: currentAnswer.isNotEmpty
            ? const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 18)
            : null,
      ),
      style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
    );
  }
}
