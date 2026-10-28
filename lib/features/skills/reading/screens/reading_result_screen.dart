import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme.dart';
import '../models/reading_test_model.dart';
import '../models/reading_result_model.dart';
import '../widgets/reading_explanation_card.dart';
import '../../../../shared/widgets/app_back_button.dart';
import '../../../ai_tutor/services/gemini_ai_tutor_service.dart';

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
  bool _isLoadingAiAnalysis = false;
  ReadingDiagnosticResult? _aiDiagnostic;

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
        leading: const AppBackButton(),
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
                          fontWeight: FontWeight.bold,
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

            // 2. AI In-Depth Diagnostic Section
            _buildAiDiagnosticSection(),
            const SizedBox(height: 18),

            // 3. Filter Chips
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

  Future<void> _generateAiAnalysis() async {
    if (_isLoadingAiAnalysis) return;
    setState(() => _isLoadingAiAnalysis = true);

    final allQuestions = widget.test.getAllQuestions();
    final questionSummaries = allQuestions.map((q) {
      final userAns = widget.result.userAnswers[q.number] ?? '';
      final isCorrect = q.isAnswerCorrect(userAns);
      return {
        'number': q.number,
        'type': q.type.name,
        'question': q.prompt,
        'user_answer': userAns.isEmpty ? '(Bỏ qua)' : userAns,
        'correct_answer': q.correctAnswer,
        'is_correct': isCorrect,
        'explanation': q.explanation.paraphraseExplanation,
      };
    }).toList();

    try {
      final diag = await GeminiAiTutorService().evaluateReadingDiagnostic(
        testTitle: widget.test.title,
        correctCount: widget.result.correctCount,
        totalCount: widget.test.totalQuestions,
        bandScore: widget.result.bandScore,
        questionSummaries: questionSummaries,
      );
      if (!mounted) return;
      setState(() {
        _aiDiagnostic = diag;
        _isLoadingAiAnalysis = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoadingAiAnalysis = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Không thể tạo báo cáo AI: $e'),
          backgroundColor: const Color(0xFFEF4444),
        ),
      );
    }
  }

  Widget _buildAiDiagnosticSection() {
    if (_aiDiagnostic == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF0FDF4),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF86EFAC)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.psychology_rounded, color: Color(0xFF16A34A), size: 22),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI Báo Cáo Chuyên Sâu',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF14532D)),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Chẩn đoán bẫy nhận thức, phân loại dạng bài & đối chiếu paraphrase',
                        style: TextStyle(fontSize: 11.5, color: Color(0xFF166534)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _isLoadingAiAnalysis ? null : _generateAiAnalysis,
              icon: _isLoadingAiAnalysis
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.auto_awesome_rounded, size: 16),
              label: Text(
                _isLoadingAiAnalysis ? 'Đang phân tích bài thi...' : 'Tạo Báo Cáo Phân Tích Với AI',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF16A34A),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 42),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
            ),
          ],
        ),
      );
    }

    final diag = _aiDiagnostic!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF86EFAC), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF16A34A).withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.auto_awesome_rounded, color: Color(0xFF16A34A), size: 18),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Báo Cáo Phân Tích Chuyên Sâu (AI)',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF14532D)),
                ),
              ),
              IconButton(
                tooltip: 'Phân tích lại',
                icon: const Icon(Icons.refresh_rounded, size: 20, color: Color(0xFF16A34A)),
                onPressed: _isLoadingAiAnalysis ? null : _generateAiAnalysis,
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Nhận xét tổng quan
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Text(
              diag.overallAssessment,
              style: const TextStyle(fontSize: 13, height: 1.45, color: Color(0xFF334155)),
            ),
          ),
          const SizedBox(height: 14),

          // Tỉ lệ chính xác theo dạng câu hỏi
          if (diag.accuracyByType.isNotEmpty) ...[
            const Text(
              'Hiệu suất theo dạng bài:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: diag.accuracyByType.map((item) {
                final isStrong = item.percentage >= 70;
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isStrong ? const Color(0xFFECFDF5) : const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isStrong ? const Color(0xFFA7F3D0) : const Color(0xFFFDE68A),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item.type,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${item.correct}/${item.total} (${item.percentage}%)',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: isStrong ? const Color(0xFF059669) : const Color(0xFFD97706),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 14),
          ],

          // Bẫy nhận thức
          if (diag.cognitivePitfalls.isNotEmpty) ...[
            const Row(
              children: [
                Icon(Icons.warning_amber_rounded, size: 16, color: Color(0xFFD97706)),
                SizedBox(width: 6),
                Text(
                  'Bẫy nhận thức & Điểm mù suy luận:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF92400E)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: Column(
                children: diag.cognitivePitfalls.map((pitfall) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• ', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFD97706))),
                        Expanded(
                          child: Text(
                            pitfall,
                            style: const TextStyle(fontSize: 12.5, height: 1.4, color: Color(0xFF78350F)),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 14),
          ],

          // Đối chiếu Paraphrase giá trị
          if (diag.valuableParaphrasesItems.isNotEmpty) ...[
            const Row(
              children: [
                Icon(Icons.compare_arrows_rounded, size: 16, color: Color(0xFF2563EB)),
                SizedBox(width: 6),
                Text(
                  'Cặp Paraphrase cốt lõi trong đề:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E3A8A)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...diag.valuableParaphrasesItems.map((pair) {
              return Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '❓ Câu hỏi: "${pair.questionSnippet}"',
                            style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '📖 Bài đọc: "${pair.passageSnippet}"',
                            style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: Color(0xFF059669)),
                          ),
                        ),
                      ],
                    ),
                    if (pair.meaning.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        '💡 Ý nghĩa: ${pair.meaning}',
                        style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Color(0xFF64748B)),
                      ),
                    ],
                  ],
                ),
              );
            }),
            const SizedBox(height: 14),
          ],

          // Lời khuyên hành động
          if (diag.actionableAdvice.isNotEmpty) ...[
            const Text(
              'Chiến thuật cải thiện cho bài thi tiếp theo:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFA7F3D0)),
              ),
              child: Column(
                children: diag.actionableAdvice.map((advice) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_circle_rounded, size: 15, color: Color(0xFF059669)),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            advice,
                            style: const TextStyle(fontSize: 12.5, color: Color(0xFF065F46)),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
