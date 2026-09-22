import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../../../app/theme.dart';
import '../models/listening_test_model.dart';

class ListeningResultScreen extends StatefulWidget {
  final ListeningTest test;
  final Map<int, String> userAnswers;

  const ListeningResultScreen({
    super.key,
    required this.test,
    required this.userAnswers,
  });

  @override
  State<ListeningResultScreen> createState() => _ListeningResultScreenState();
}

class _ListeningResultScreenState extends State<ListeningResultScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FlutterTts _flutterTts = FlutterTts();
  int? _playingQuestionAudio; // question number currently replaying

  int _correctCount = 0;
  int _incorrectCount = 0;
  int _unansweredCount = 0;
  double _bandScore = 0.0;

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

    for (final sec in widget.test.sections) {
      for (final q in sec.questions) {
        final ans = widget.userAnswers[q.questionNumber];
        if (ans == null || ans.trim().isEmpty) {
          unanswered++;
        } else if (q.checkAnswer(ans)) {
          correct++;
        } else {
          incorrect++;
        }
      }
    }

    _correctCount = correct;
    _incorrectCount = incorrect;
    _unansweredCount = unanswered;
    _bandScore = ListeningTest.calculateBandScore(correct, widget.test.totalQuestions);
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage("en-GB");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.48);

    _flutterTts.setCompletionHandler(() {
      if (mounted) {
        setState(() => _playingQuestionAudio = null);
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
      await _flutterTts.speak(q.transcriptEvidence);
    }
  }

  @override
  Widget build(BuildContext context) {
    final allQuestions = widget.test.sections.expand((sec) => sec.questions).toList();

    return Scaffold(
      backgroundColor: AppTheme.brandBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Kết quả & Lời giải chi tiết',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
        ),
      ),
      body: Column(
        children: [
          // 1. Score Summary Banner
          _buildScoreBanner(),

          // 2. Tabs: "Chi tiết từng câu" vs "Toàn bộ Transcript"
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: const Color(0xFF4F46E5),
              indicatorWeight: 3,
              labelColor: const Color(0xFF4F46E5),
              unselectedLabelColor: const Color(0xFF64748B),
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              tabs: const [
                Tab(text: 'Chi tiết câu hỏi'),
                Tab(text: 'Toàn bộ Transcript'),
              ],
            ),
          ),

          // 3. Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Tab 1: List of Questions with 3-Step Explanations
                ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: allQuestions.length,
                  itemBuilder: (ctx, idx) => _buildSolutionCard(allQuestions[idx]),
                ),

                // Tab 2: Full Transcripts
                ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: widget.test.sections.length,
                  itemBuilder: (ctx, idx) => _buildTranscriptCard(widget.test.sections[idx]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreBanner() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Band Score Badge
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4F46E5), Color(0xFF3B82F6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'BAND',
                  style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
                ),
                Text(
                  _bandScore.toStringAsFixed(1),
                  style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Breakdown stats
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.test.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B)),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildStatChip(
                      icon: Icons.check_circle_rounded,
                      color: const Color(0xFF10B981),
                      text: '$_correctCount đúng',
                    ),
                    const SizedBox(width: 8),
                    _buildStatChip(
                      icon: Icons.cancel_rounded,
                      color: const Color(0xFFEF4444),
                      text: '$_incorrectCount sai',
                    ),
                    const SizedBox(width: 8),
                    _buildStatChip(
                      icon: Icons.remove_circle_outline_rounded,
                      color: const Color(0xFF94A3B8),
                      text: '$_unansweredCount bỏ',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip({required IconData icon, required Color color, required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

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
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isCorrect
              ? const Color(0xFFA7F3D0)
              : (isUnanswered ? const Color(0xFFE2E8F0) : const Color(0xFFFECACA)),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question Title & Status
          Row(
            children: [
              Container(
                width: 26,
                height: 26,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isCorrect
                      ? const Color(0xFF10B981)
                      : (isUnanswered ? const Color(0xFF94A3B8) : const Color(0xFFEF4444)),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${q.questionNumber}',
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  q.questionText,
                  style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
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
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Câu bạn chọn/điền:', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                      const SizedBox(height: 2),
                      Text(
                        isUnanswered ? '(Chưa trả lời)' : userAns,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isCorrect
                              ? const Color(0xFF059669)
                              : (isUnanswered ? const Color(0xFF94A3B8) : const Color(0xFFDC2626)),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(height: 26, width: 1, color: const Color(0xFFCBD5E1)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Đáp án chuẩn IELTS:', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                      const SizedBox(height: 2),
                      Text(
                        q.correctAnswer,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF059669)),
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
              borderRadius: BorderRadius.circular(6),
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
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E40AF)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  q.explanation,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF1E3A8A), height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Audio Stamp Replay Button
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
                isPlaying ? 'Đang phát bằng chứng...' : 'Nghe lại đoạn chứa đáp án (~${q.audioTimestampSeconds}s)',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF4F46E5)),
              ),
              style: OutlinedButton.styleFrom(
                backgroundColor: isPlaying ? const Color(0xFFEEF2FF) : Colors.transparent,
                side: const BorderSide(color: Color(0xFFC7D2FE)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTranscriptCard(ListeningSection sec) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.description_outlined, size: 18, color: Color(0xFF4F46E5)),
              const SizedBox(width: 8),
              Text(
                sec.sectionTitle,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            sec.fullTranscript.trim(),
            style: const TextStyle(fontSize: 12.5, height: 1.5, color: Color(0xFF334155)),
          ),
        ],
      ),
    );
  }
}
