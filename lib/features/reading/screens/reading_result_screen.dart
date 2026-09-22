import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../models/reading_test_model.dart';
import '../models/reading_result_model.dart';
import '../widgets/reading_explanation_card.dart';

class ReadingResultScreen extends StatefulWidget {
  final ReadingTest test;
  final ReadingTestResult result;

  const ReadingResultScreen({
    super.key,
    required this.test,
    required this.result,
  });

  @override
  State<ReadingResultScreen> createState() => _ReadingResultScreenState();
}

class _ReadingResultScreenState extends State<ReadingResultScreen> {
  int _selectedFilter = 0; // 0: Tất cả, 1: Câu sai & Bỏ qua, 2: Câu đúng

  String _formatDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m}m ${s}s';
  }

  @override
  Widget build(BuildContext context) {
    final allQuestions = widget.test.getAllQuestions();
    final correctCount = widget.result.correctCount;
    final totalCount = widget.test.totalQuestions;
    final int incorrectCount = allQuestions.where((q) {
      final ans = widget.result.userAnswers[q.number] ?? '';
      return ans.trim().isNotEmpty && !q.isAnswerCorrect(ans);
    }).length;
    final int skippedCount = allQuestions.where((q) {
      final ans = widget.result.userAnswers[q.number] ?? '';
      return ans.trim().isEmpty;
    }).length;

    List<ReadingQuestion> displayedQuestions = allQuestions;
    if (_selectedFilter == 1) {
      // Câu sai & Bỏ qua
      displayedQuestions = allQuestions.where((q) {
        final ans = widget.result.userAnswers[q.number] ?? '';
        return !q.isAnswerCorrect(ans);
      }).toList();
    } else if (_selectedFilter == 2) {
      // Câu đúng
      displayedQuestions = allQuestions.where((q) {
        final ans = widget.result.userAnswers[q.number] ?? '';
        return q.isAnswerCorrect(ans);
      }).toList();
    }

    return Scaffold(
      backgroundColor: AppTheme.brandBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppTheme.brandTextPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Kết Quả & Lời Giải Chi Tiết',
          style: TextStyle(
            fontSize: 16.5,
            fontWeight: FontWeight.bold,
            color: AppTheme.brandTextPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero Score Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppTheme.brandPrimary,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.brandPrimary.withValues(alpha: 0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    widget.test.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFFE0E7FF),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      const Text(
                        'Band ',
                        style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.result.bandScore.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Quick stats pill row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildMiniPill(label: 'Đúng', value: '$correctCount/$totalCount', color: const Color(0xFF86EFAC)),
                      _buildMiniPill(label: 'Sai', value: '$incorrectCount', color: const Color(0xFFFCA5A5)),
                      _buildMiniPill(label: 'Bỏ qua', value: '$skippedCount', color: const Color(0xFFFDE68A)),
                      _buildMiniPill(label: 'Thời gian', value: _formatDuration(widget.result.durationSeconds), color: Colors.white),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // 2. Filter Filter Chips
            Row(
              children: [
                _buildFilterButton(0, 'Tất cả (${allQuestions.length})'),
                const SizedBox(width: 8),
                _buildFilterButton(1, 'Cần xem lại (${incorrectCount + skippedCount})'),
                const SizedBox(width: 8),
                _buildFilterButton(2, 'Đúng ($correctCount)'),
              ],
            ),
            const SizedBox(height: 14),

            // 3. Questions Detailed Explanation List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: displayedQuestions.length,
              itemBuilder: (context, index) {
                final q = displayedQuestions[index];
                final userAns = widget.result.userAnswers[q.number] ?? '';
                return ReadingExplanationCard(
                  question: q,
                  userAnswer: userAns,
                  initiallyExpanded: index == 0,
                );
              },
            ),
            const SizedBox(height: 20),

            // 4. Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      context.pushReplacement(
                        '/reading/practice',
                        extra: {'test': widget.test},
                      );
                    },
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    label: const Text('Làm lại đề này'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.brandPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      side: const BorderSide(color: AppTheme.brandPrimary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.list_alt_rounded, size: 18),
                    label: const Text('Danh sách đề'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.brandPrimary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniPill({required String label, required String value, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 10.5, color: Color(0xFFDAD7FF))),
          Text(
            value,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(int index, String label) {
    final isSelected = _selectedFilter == index;
    return InkWell(
      onTap: () => setState(() => _selectedFilter = index),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.brandPrimary : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppTheme.brandPrimary : const Color(0xFFCBD5E1),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF475569),
          ),
        ),
      ),
    );
  }
}
