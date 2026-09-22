import 'package:flutter/material.dart';
import '../../../app/theme.dart';

class ReadingMatrixJumpModal extends StatelessWidget {
  final int totalQuestions;
  final Map<int, String> answers;
  final int currentQuestionNumber;
  final ValueChanged<int> onSelectQuestion;
  final VoidCallback onSubmit;

  const ReadingMatrixJumpModal({
    super.key,
    required this.totalQuestions,
    required this.answers,
    required this.currentQuestionNumber,
    required this.onSelectQuestion,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    int answeredCount = 0;
    for (int i = 1; i <= totalQuestions; i++) {
      if ((answers[i] ?? '').trim().isNotEmpty) {
        answeredCount++;
      }
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Title & Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Danh Sách Câu Hỏi',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.brandTextPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: answeredCount == totalQuestions
                      ? const Color(0xFFDCFCE7)
                      : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Đã làm: $answeredCount/$totalQuestions',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: answeredCount == totalQuestions
                        ? const Color(0xFF15803D)
                        : const Color(0xFF475569),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Legend
          Row(
            children: [
              _buildLegend(color: const Color(0xFF10B981), label: 'Đã làm'),
              const SizedBox(width: 14),
              _buildLegend(color: const Color(0xFFE2E8F0), label: 'Chưa làm'),
              const SizedBox(width: 14),
              _buildLegend(color: AppTheme.brandPrimary, label: 'Đang xem'),
            ],
          ),
          const SizedBox(height: 14),

          // Grid of numbers 1 to totalQuestions
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 280),
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(totalQuestions, (index) {
                  final qNum = index + 1;
                  final isAnswered = (answers[qNum] ?? '').trim().isNotEmpty;
                  final isCurrent = qNum == currentQuestionNumber;

                  Color bg = const Color(0xFFF1F5F9);
                  Color text = const Color(0xFF475569);
                  Border? border;

                  if (isCurrent) {
                    bg = AppTheme.brandPrimary;
                    text = Colors.white;
                  } else if (isAnswered) {
                    bg = const Color(0xFFDCFCE7);
                    text = const Color(0xFF15803D);
                    border = Border.all(color: const Color(0xFF86EFAC));
                  }

                  return InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      onSelectQuestion(qNum);
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 44,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: bg,
                        borderRadius: BorderRadius.circular(8),
                        border: border,
                      ),
                      child: Text(
                        '$qNum',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: text,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Submit button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                onSubmit();
              },
              icon: const Icon(Icons.check_circle_outline, size: 18),
              label: Text(
                answeredCount == totalQuestions
                    ? 'Nộp bài ngay'
                    : 'Nộp bài (Còn ${totalQuestions - answeredCount} câu trống)',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.brandPrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend({required Color color, required String label}) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
        ),
      ],
    );
  }
}
