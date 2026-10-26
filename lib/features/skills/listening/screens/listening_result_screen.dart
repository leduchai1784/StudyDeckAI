import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../app/theme.dart';
import '../models/listening_test_model.dart';
import '../../../../shared/widgets/app_back_button.dart';
import 'listening_test_screen.dart';

enum QuestionFilter { all, incorrect, unanswered, correct }

class ListeningResultScreen extends StatefulWidget {
  final ListeningTest test;
  final Map<int, String> userAnswers;
  final int? timeSpentSeconds;

  const ListeningResultScreen({
    super.key,
    required this.test,
    required this.userAnswers,
    this.timeSpentSeconds,
  });

  @override
  State<ListeningResultScreen> createState() => _ListeningResultScreenState();
}

class _ListeningResultScreenState extends State<ListeningResultScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FlutterTts _flutterTts = FlutterTts();
  int? _playingQuestionAudio; // question number currently playing
  int? _playingSectionNumber; // part number currently playing full transcript
  QuestionFilter _currentFilter = QuestionFilter.all;
  String _selectedAccent = 'en-GB'; // 'en-GB' or 'en-US'

  int _correctCount = 0;
  int _incorrectCount = 0;
  int _unansweredCount = 0;
  double _bandScore = 0.0;

  // Breakdown by question type
  final Map<QuestionType, ({int correct, int total})> _typeStats = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _calculateStats();
    _initTts();
  }

  void _calculateStats() {
    int correct = 0;
    int incorrect = 0;
    int unanswered = 0;

    final Map<QuestionType, int> typeCorrect = {};
    final Map<QuestionType, int> typeTotal = {};

    for (final sec in widget.test.sections) {
      for (final q in sec.questions) {
        typeTotal[q.type] = (typeTotal[q.type] ?? 0) + 1;

        final ans = widget.userAnswers[q.questionNumber];
        if (ans == null || ans.trim().isEmpty) {
          unanswered++;
        } else if (q.checkAnswer(ans)) {
          correct++;
          typeCorrect[q.type] = (typeCorrect[q.type] ?? 0) + 1;
        } else {
          incorrect++;
        }
      }
    }

    _correctCount = correct;
    _incorrectCount = incorrect;
    _unansweredCount = unanswered;
    _bandScore = ListeningTest.calculateBandScore(correct, widget.test.totalQuestions);

    for (final type in typeTotal.keys) {
      _typeStats[type] = (
        correct: typeCorrect[type] ?? 0,
        total: typeTotal[type] ?? 0,
      );
    }
  }

  Future<void> _initTts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString('studydeck_listening_accent');
      if (saved != null && (saved == 'en-GB' || saved == 'en-US')) {
        _selectedAccent = saved;
      }
    } catch (_) {}

    await _flutterTts.setLanguage(_selectedAccent);
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.48);

    _flutterTts.setCompletionHandler(() {
      if (mounted) {
        setState(() {
          _playingQuestionAudio = null;
          _playingSectionNumber = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  void _replayEvidenceAudio(ListeningQuestion q) async {
    if (_playingQuestionAudio == q.questionNumber) {
      await _flutterTts.stop();
      setState(() => _playingQuestionAudio = null);
    } else {
      await _flutterTts.stop();
      setState(() => _playingQuestionAudio = q.questionNumber);
      await _flutterTts.setLanguage(_selectedAccent);
      await _flutterTts.speak(q.transcriptEvidence);
    }
  }

  String _formatTime(int? seconds) {
    if (seconds == null || seconds <= 0) return '00:00';
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  String _getEncouragementMessage() {
    if (_bandScore >= 8.0) {
      return 'Xuất sắc! Khả năng nghe và phản xạ IELTS của bạn rất vững vàng!';
    } else if (_bandScore >= 6.5) {
      return 'Khá tốt! Bạn chỉ cần luyện thêm bẫy từ nối để bứt phá lên 8.0+!';
    } else if (_bandScore >= 5.0) {
      return 'Khởi đầu tốt! Tập trung nghe từ khóa và đọc trước câu hỏi để nâng điểm!';
    } else {
      return 'Không sao đâu, ai giỏi IELTS cũng từng "lụm" điểm như này!';
    }
  }

  String _getTypeTitle(QuestionType type) {
    switch (type) {
      case QuestionType.gapFill:
        return 'Điền bảng / Ghi chú';
      case QuestionType.multipleChoice:
        return 'Trắc nghiệm (Multiple Choice)';
      case QuestionType.matching:
        return 'Nối thông tin (Matching)';
    }
  }

  String _getTypeStrategy(QuestionType type) {
    switch (type) {
      case QuestionType.gapFill:
        return 'Cách xử lý: Đi theo cột hoặc theo dòng thông tin; chú ý giới hạn số từ (NO MORE THAN X WORDS) và đuôi số nhiều (-s).';
      case QuestionType.multipleChoice:
        return 'Cách xử lý: Đọc lướt phương án trước khi audio chạy; trong lúc nghe chỉ gạch bỏ phương án nhiễu, không phân vân.';
      case QuestionType.matching:
        return 'Cách xử lý: Ghi ký hiệu tốc ký khi nghe, nối lại sau — nối ngay trong lúc nghe dễ bị mất nhịp câu kế tiếp.';
    }
  }

  List<ListeningQuestion> _getFilteredQuestions(List<ListeningQuestion> questions) {
    switch (_currentFilter) {
      case QuestionFilter.all:
        return questions;
      case QuestionFilter.incorrect:
        return questions.where((q) {
          final ans = widget.userAnswers[q.questionNumber];
          return ans != null && ans.trim().isNotEmpty && !q.checkAnswer(ans);
        }).toList();
      case QuestionFilter.unanswered:
        return questions.where((q) {
          final ans = widget.userAnswers[q.questionNumber];
          return ans == null || ans.trim().isEmpty;
        }).toList();
      case QuestionFilter.correct:
        return questions.where((q) {
          final ans = widget.userAnswers[q.questionNumber];
          return ans != null && ans.trim().isNotEmpty && q.checkAnswer(ans);
        }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final allQuestions = widget.test.sections.expand((sec) => sec.questions).toList();
    final filteredQuestions = _getFilteredQuestions(allQuestions);

    return Scaffold(
      backgroundColor: AppTheme.brandBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: const AppBackButton(),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'BÁO CÁO KẾT QUẢ',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
                letterSpacing: 0.5,
              ),
            ),
            Text(
              widget.test.title,
              style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Tab bar on top
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppTheme.brandPrimary,
              indicatorWeight: 3,
              labelColor: AppTheme.brandPrimary,
              unselectedLabelColor: const Color(0xFF64748B),
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              tabs: const [
                Tab(text: 'Bài giải chi tiết'),
                Tab(text: 'Toàn bộ Script'),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // TAB 1: BÁO CÁO & BÀI GIẢI CHI TIẾT
                ListView(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
                  children: [
                    // 1. Overall Score & Stats Card
                    _buildOverallScoreCard(),
                    const SizedBox(height: 14),

                    // 2. Section "DẠNG BẠN ĐANG YẾU"
                    _buildWeakTypeAnalysisCard(),
                    const SizedBox(height: 16),

                    // 3. Filter Row for Questions
                    _buildQuestionFilterChips(allQuestions.length),
                    const SizedBox(height: 14),

                    // 4. Questions List
                    if (filteredQuestions.isEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 36),
                        alignment: Alignment.center,
                        child: const Text(
                          'Không có câu hỏi nào theo bộ lọc này.',
                          style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                        ),
                      )
                    else
                      ...filteredQuestions.map((q) => _buildSolutionCard(q)),
                  ],
                ),

                // TAB 2: TOÀN BỘ TRANSCRIPT
                ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                  itemCount: widget.test.sections.length,
                  itemBuilder: (ctx, idx) => _buildTranscriptCard(widget.test.sections[idx]),
                ),
              ],
            ),
          ),

          // Bottom Action Bar
          _buildBottomActionBar(),
        ],
      ),
    );
  }

  // 1. Overall Score Card
  Widget _buildOverallScoreCard() {
    final totalQ = widget.test.totalQuestions;
    final correctPct = totalQ > 0 ? (_correctCount / totalQ * 100).toStringAsFixed(1) : '0';
    final incorrectPct = totalQ > 0 ? (_incorrectCount / totalQ * 100).toStringAsFixed(1) : '0';
    final unansweredPct = totalQ > 0 ? (_unansweredCount / totalQ * 100).toStringAsFixed(1) : '0';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Motivation Quote
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.auto_awesome, size: 18, color: Color(0xFFF59E0B)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _getEncouragementMessage(),
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF334155),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 14),

          // Band Score & Stats
          Row(
            children: [
              // Band Score Badge
              Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4F46E5), Color(0xFF3B82F6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4F46E5).withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'BAND IELTS',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _bandScore.toStringAsFixed(1),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),

              // 4 Stat Badges
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildMetricTile(
                            label: 'câu đúng',
                            value: '$_correctCount',
                            subValue: '$correctPct%',
                            color: const Color(0xFF10B981),
                            icon: Icons.check_circle_rounded,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildMetricTile(
                            label: 'câu sai',
                            value: '$_incorrectCount',
                            subValue: '$incorrectPct%',
                            color: const Color(0xFFEF4444),
                            icon: Icons.cancel_rounded,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildMetricTile(
                            label: 'bỏ qua',
                            value: '$_unansweredCount',
                            subValue: '$unansweredPct%',
                            color: const Color(0xFF64748B),
                            icon: Icons.remove_circle_outline_rounded,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildMetricTile(
                            label: 'thời gian',
                            value: _formatTime(widget.timeSpentSeconds),
                            subValue: 'phút',
                            color: const Color(0xFF6366F1),
                            icon: Icons.timer_outlined,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile({
    required String label,
    required String value,
    required String subValue,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 12, color: color),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color),
              ),
              const SizedBox(width: 4),
              Text(
                subValue,
                style: TextStyle(fontSize: 10, color: color.withValues(alpha: 0.8)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 2. Weak Type Analysis Card
  Widget _buildWeakTypeAnalysisCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
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
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.analytics_outlined, size: 16, color: Color(0xFF4F46E5)),
              ),
              const SizedBox(width: 8),
              const Text(
                'DẠNG BẠN ĐANG YẾU',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Types breakdown list
          ..._typeStats.entries.map((entry) {
            final type = entry.key;
            final correct = entry.value.correct;
            final total = entry.value.total;
            final ratio = total > 0 ? (correct / total) : 0.0;
            final isWeak = ratio < 0.7;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _getTypeTitle(type),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF334155),
                        ),
                      ),
                      Text(
                        '$correct/$total',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isWeak ? const Color(0xFFEF4444) : const Color(0xFF10B981),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: ratio,
                      minHeight: 6,
                      backgroundColor: const Color(0xFFE2E8F0),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isWeak ? const Color(0xFFEF4444) : const Color(0xFF10B981),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Bạn đúng $correct/$total ở dạng này — ${isWeak ? 'thấp hơn mặt bằng chung của bài.' : 'vững vàng, tiếp tục phát huy!'}',
                    style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Text(
                      _getTypeStrategy(type),
                      style: const TextStyle(fontSize: 11.5, color: Color(0xFF475569), height: 1.35),
                    ),
                  ),
                ],
              ),
            );
          }),

          // Unanswered Alert if any
          if (_unansweredCount > 0)
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline, size: 16, color: Color(0xFFD97706)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Bạn bỏ trống $_unansweredCount câu. Lần sau đến những phút cuối hãy điền hết những câu còn trống rồi mới quay lại câu khó — câu trống chắc chắn 0 điểm, câu đoán thì không!',
                      style: const TextStyle(fontSize: 11.5, color: Color(0xFFB45309), height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // 3. Question Filter Chips
  Widget _buildQuestionFilterChips(int totalCount) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip('Tất cả ($totalCount)', QuestionFilter.all),
          const SizedBox(width: 8),
          _buildFilterChip('Câu sai ($_incorrectCount)', QuestionFilter.incorrect, color: const Color(0xFFEF4444)),
          const SizedBox(width: 8),
          _buildFilterChip('Chưa làm ($_unansweredCount)', QuestionFilter.unanswered, color: const Color(0xFF64748B)),
          const SizedBox(width: 8),
          _buildFilterChip('Câu đúng ($_correctCount)', QuestionFilter.correct, color: const Color(0xFF10B981)),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, QuestionFilter filter, {Color? color}) {
    final isSelected = _currentFilter == filter;
    final activeColor = color ?? const Color(0xFF4F46E5);

    return InkWell(
      onTap: () => setState(() => _currentFilter = filter),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? activeColor : const Color(0xFFCBD5E1),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : const Color(0xFF475569),
          ),
        ),
      ),
    );
  }

  // 4. Solution Card for each question
  Widget _buildSolutionCard(ListeningQuestion q) {
    final userAns = widget.userAnswers[q.questionNumber];
    final isUnanswered = userAns == null || userAns.trim().isEmpty;
    final isCorrect = !isUnanswered && q.checkAnswer(userAns);
    final isPlaying = _playingQuestionAudio == q.questionNumber;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCorrect
              ? const Color(0xFFA7F3D0)
              : (isUnanswered ? const Color(0xFFE2E8F0) : const Color(0xFFFECACA)),
          width: 1.2,
        ),
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
          // Header: Question Number Badge & Question Text
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isCorrect
                      ? const Color(0xFF10B981)
                      : (isUnanswered ? const Color(0xFF94A3B8) : const Color(0xFFEF4444)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Q${q.questionNumber}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      q.questionText,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _getTypeTitle(q.type),
                      style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // User Answer vs Correct Answer
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Câu bạn chọn/điền:',
                        style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Icon(
                            isCorrect
                                ? Icons.check_circle_rounded
                                : (isUnanswered ? Icons.remove_circle_outline_rounded : Icons.cancel_rounded),
                            size: 14,
                            color: isCorrect
                                ? const Color(0xFF059669)
                                : (isUnanswered ? const Color(0xFF94A3B8) : const Color(0xFFDC2626)),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              isUnanswered ? '(Chưa trả lời)' : userAns,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isCorrect
                                    ? const Color(0xFF059669)
                                    : (isUnanswered ? const Color(0xFF94A3B8) : const Color(0xFFDC2626)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(height: 30, width: 1, color: const Color(0xFFCBD5E1)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Đáp án chuẩn IELTS:',
                        style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        q.correctAnswer,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF059669),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 3-Step Explanation
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFBFDBFE)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.lightbulb_outline_rounded, size: 16, color: Color(0xFF2563EB)),
                    SizedBox(width: 6),
                    Text(
                      'Phân tích & Lời giải 3 bước:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E40AF),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  q.explanation,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF1E3A8A), height: 1.45),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Audio Timestamp Replay Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _replayEvidenceAudio(q),
              icon: Icon(
                isPlaying ? Icons.stop_rounded : Icons.play_circle_outline_rounded,
                size: 18,
                color: const Color(0xFF4F46E5),
              ),
              label: Text(
                isPlaying
                    ? 'Đang phát bằng chứng...'
                    : 'Nghe lại đoạn audio chứa đáp án (~${q.audioTimestampSeconds}s)',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4F46E5),
                ),
              ),
              style: OutlinedButton.styleFrom(
                backgroundColor: isPlaying ? const Color(0xFFEEF2FF) : Colors.transparent,
                side: const BorderSide(color: Color(0xFFC7D2FE)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(vertical: 9),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getDisplayTranscript(ListeningSection sec) {
    return sec.cleanTranscript;
  }

  void _replaySectionAudio(ListeningSection sec) async {
    if (_playingSectionNumber == sec.partNumber) {
      await _flutterTts.stop();
      setState(() => _playingSectionNumber = null);
    } else {
      await _flutterTts.stop();
      setState(() {
        _playingQuestionAudio = null;
        _playingSectionNumber = sec.partNumber;
      });
      await _flutterTts.setLanguage(_selectedAccent);
      final text = sec.cleanTranscript;
      final textToSpeak = text.length > 3500 ? text.substring(0, 3500) : text;
      await _flutterTts.speak(textToSpeak);
    }
  }

  // 5. Full Transcript Card
  Widget _buildTranscriptCard(ListeningSection sec) {
    final transcriptText = _getDisplayTranscript(sec);
    final isPlaying = _playingSectionNumber == sec.partNumber;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPlaying ? const Color(0xFF818CF8) : const Color(0xFFE2E8F0),
          width: isPlaying ? 1.5 : 1.0,
        ),
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'PART ${sec.partNumber}',
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4F46E5),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  sec.sectionTitle.replaceAll(RegExp(r'^Part \d+:\s*'), ''),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  isPlaying ? Icons.stop_circle_rounded : Icons.play_circle_fill_rounded,
                  color: const Color(0xFF4F46E5),
                  size: 26,
                ),
                tooltip: isPlaying ? 'Dừng đọc' : 'Nghe toàn bộ Part này (TTS)',
                onPressed: () => _replaySectionAudio(sec),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 12),
          SelectableText(
            transcriptText,
            style: const TextStyle(
              fontSize: 13,
              height: 1.65,
              color: Color(0xFF334155),
              letterSpacing: 0.15,
            ),
          ),
        ],
      ),
    );
  }

  // 6. Bottom Action Bar
  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: Color(0xFFE2E8F0))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Button 1: Return to Hub
            Expanded(
              flex: 1,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_rounded, size: 16, color: Color(0xFF475569)),
                label: const Text(
                  'Danh sách đề',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF475569),
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFCBD5E1)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 10),

            // Button 2: Retake test in practice mode
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ListeningTestScreen(
                        test: widget.test,
                        isRealTest: false,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.refresh_rounded, size: 16, color: Colors.white),
                label: const Text(
                  'Làm lại đề này (Luyện tập)',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.brandPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
