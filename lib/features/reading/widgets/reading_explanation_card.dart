import 'package:flutter/material.dart';
import '../../../app/theme.dart';
import '../models/reading_test_model.dart';

class ReadingExplanationCard extends StatefulWidget {
  final ReadingQuestion question;
  final String userAnswer;
  final bool initiallyExpanded;

  const ReadingExplanationCard({
    super.key,
    required this.question,
    required this.userAnswer,
    this.initiallyExpanded = false,
  });

  @override
  State<ReadingExplanationCard> createState() => _ReadingExplanationCardState();
}

class _ReadingExplanationCardState extends State<ReadingExplanationCard> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final bool isAnswered = widget.userAnswer.trim().isNotEmpty;
    final bool isCorrect = widget.question.isAnswerCorrect(widget.userAnswer);

    Color statusBg = const Color(0xFFFEF2F2);
    Color statusBorder = const Color(0xFFFCA5A5);
    Color statusColor = const Color(0xFFDC2626);
    IconData statusIcon = Icons.cancel_outlined;
    String statusLabel = 'Chưa đúng';

    if (isCorrect) {
      statusBg = const Color(0xFFF0FDF4);
      statusBorder = const Color(0xFF86EFAC);
      statusColor = const Color(0xFF16A34A);
      statusIcon = Icons.check_circle_outline_rounded;
      statusLabel = 'Chính xác';
    } else if (!isAnswered) {
      statusBg = const Color(0xFFFFFBEB);
      statusBorder = const Color(0xFFFDE68A);
      statusColor = const Color(0xFFD97706);
      statusIcon = Icons.help_outline_rounded;
      statusLabel = 'Chưa làm';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusBorder.withValues(alpha: 0.6), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusBg,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: statusBorder),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(statusIcon, color: statusColor, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              'Câu ${widget.question.number}: $statusLabel',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                                color: statusColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        _isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                        color: const Color(0xFF94A3B8),
                        size: 22,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.question.prompt,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.brandTextPrimary,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Answers comparison
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Đáp án của bạn:', style: TextStyle(fontSize: 10.5, color: Color(0xFF64748B))),
                              Text(
                                isAnswered ? widget.userAnswer : '(Trống)',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.bold,
                                  color: isCorrect
                                      ? const Color(0xFF16A34A)
                                      : (isAnswered ? const Color(0xFFDC2626) : const Color(0xFF94A3B8)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0FDF4),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: const Color(0xFFBBF7D0)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Đáp án chuẩn:', style: TextStyle(fontSize: 10.5, color: Color(0xFF15803D))),
                              Text(
                                widget.question.correctAnswer,
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF16A34A),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Collapsible 3-Step Cambridge Explanation
          if (_isExpanded) ...[
            const Divider(height: 1, color: Color(0xFFF1F5F9)),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(
                color: Color(0xFFFAFAFC),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'GIẢI THÍCH CHI TIẾT THEO CHUẨN CAMBRIDGE',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: AppTheme.brandPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // STEP 1: KEYWORD
                  _buildExplanationStep(
                    stepNumber: '1',
                    badge: 'Từ Khóa Câu Hỏi',
                    badgeBg: const Color(0xFFFEF3C7),
                    badgeColor: const Color(0xFFB45309),
                    content: widget.question.explanation.questionKeyword,
                  ),
                  const SizedBox(height: 8),

                  // STEP 2: LOCATION
                  _buildExplanationStep(
                    stepNumber: '2',
                    badge: 'Vị Trí Đoạn Bài',
                    badgeBg: const Color(0xFFE0F2FE),
                    badgeColor: const Color(0xFF0369A1),
                    content: widget.question.explanation.passageLocation,
                    isQuote: true,
                  ),
                  const SizedBox(height: 8),

                  // STEP 3: PARAPHRASE & LOGIC
                  _buildExplanationStep(
                    stepNumber: '3',
                    badge: 'Phân Tích & Paraphrase',
                    badgeBg: const Color(0xFFEEEDFE),
                    badgeColor: AppTheme.brandPrimary,
                    content: widget.question.explanation.paraphraseExplanation,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildExplanationStep({
    required String stepNumber,
    required String badge,
    required Color badgeBg,
    required Color badgeColor,
    required String content,
    bool isQuote = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: badgeBg,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Bước $stepNumber: $badge',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: badgeColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: isQuote ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            border: isQuote ? Border.all(color: const Color(0xFFE2E8F0)) : null,
          ),
          child: Text(
            content,
            style: TextStyle(
              fontSize: 12.5,
              color: const Color(0xFF334155),
              fontStyle: isQuote ? FontStyle.italic : FontStyle.normal,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}
