import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../../../app/theme.dart';
import '../models/listening_test_model.dart';
import 'listening_result_screen.dart';

class ListeningTestScreen extends StatefulWidget {
  final ListeningTest test;
  final int? targetPartNumber;
  final bool isRealTest;

  const ListeningTestScreen({
    super.key,
    required this.test,
    this.targetPartNumber,
    this.isRealTest = false,
  });

  @override
  State<ListeningTestScreen> createState() => _ListeningTestScreenState();
}

class _ListeningTestScreenState extends State<ListeningTestScreen> {
  // TTS Audio Engine
  final FlutterTts _flutterTts = FlutterTts();
  bool _isPlaying = false;
  double _playbackSpeed = 1.0;
  int _currentSeconds = 0;
  final int _totalDurationSeconds = 180; // Estimated 3 mins per part
  Timer? _playbackTimer;

  // Real test timer (30 mins countdown)
  int _realTestRemainingSeconds = 1800; // 30 minutes
  Timer? _examTimer;

  // Answers & UI State
  final Map<int, String> _userAnswers = {};
  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _questionKeys = {};

  // Current active section
  int _currentSectionIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.targetPartNumber != null) {
      final foundIdx = widget.test.sections.indexWhere((s) => s.partNumber == widget.targetPartNumber);
      if (foundIdx != -1) {
        _currentSectionIndex = foundIdx;
      }
    }
    if (widget.isRealTest) {
      _startExamTimer();
    }
    _initTts();
    _initQuestionKeys();
  }

  void _startExamTimer() {
    _examTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_realTestRemainingSeconds > 0) {
          _realTestRemainingSeconds--;
        } else {
          _examTimer?.cancel();
          _autoSubmitOnTimeUp();
        }
      });
    });
  }

  void _autoSubmitOnTimeUp() {
    _flutterTts.stop();
    _playbackTimer?.cancel();
    _examTimer?.cancel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ListeningResultScreen(
          test: widget.test,
          userAnswers: _userAnswers,
        ),
      ),
    );
  }

  void _initQuestionKeys() {
    for (final sec in widget.test.sections) {
      for (final q in sec.questions) {
        _questionKeys[q.questionNumber] = GlobalKey();
      }
    }
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage("en-GB"); // IELTS UK accent
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.48 * _playbackSpeed);

    _flutterTts.setCompletionHandler(() {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _playbackTimer?.cancel();
        });
      }
    });
  }

  @override
  void dispose() {
    _flutterTts.stop();
    _playbackTimer?.cancel();
    _examTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _togglePlayPause() async {
    if (_isPlaying) {
      await _flutterTts.stop();
      _playbackTimer?.cancel();
      setState(() => _isPlaying = false);
    } else {
      final currentSec = widget.test.sections[_currentSectionIndex];
      await _flutterTts.setSpeechRate(0.48 * _playbackSpeed);
      await _flutterTts.speak(currentSec.fullTranscript);
      setState(() => _isPlaying = true);

      _playbackTimer?.cancel();
      _playbackTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) return;
        setState(() {
          if (_currentSeconds < _totalDurationSeconds) {
            _currentSeconds++;
          } else {
            _playbackTimer?.cancel();
            _isPlaying = false;
          }
        });
      });
    }
  }

  void _seekBy(int seconds) {
    setState(() {
      _currentSeconds = (_currentSeconds + seconds).clamp(0, _totalDurationSeconds);
    });
  }

  void _setSpeed(double speed) async {
    setState(() => _playbackSpeed = speed);
    await _flutterTts.setSpeechRate(0.48 * speed);
  }

  void _scrollToQuestion(int qNum) {
    final key = _questionKeys[qNum];
    if (key != null && key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  void _confirmSubmit() {
    final totalQ = widget.test.totalQuestions;
    final answeredQ = _userAnswers.length;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: const Row(
          children: [
            Icon(Icons.assignment_turned_in_rounded, color: Color(0xFF4F46E5), size: 24),
            SizedBox(width: 8),
            Text('Nộp bài thi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
          ],
        ),
        content: Text(
          answeredQ < totalQ
              ? 'Bạn đã trả lời $answeredQ/$totalQ câu hỏi. Bạn có chắc chắn muốn nộp bài ngay để xem điểm và lời giải không?'
              : 'Bạn đã hoàn thành đủ $totalQ câu hỏi. Nộp bài ngay để xem kết quả quy đổi Band Score?',
          style: const TextStyle(fontSize: 13.5, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tiếp tục làm bài', style: TextStyle(color: Color(0xFF6B7280))),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _flutterTts.stop();
              _playbackTimer?.cancel();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ListeningResultScreen(
                    test: widget.test,
                    userAnswers: _userAnswers,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4F46E5),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Nộp bài & Xem điểm'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentSec = widget.test.sections[_currentSectionIndex];
    final totalQ = widget.test.totalQuestions;
    final answeredQ = _userAnswers.length;

    return Scaffold(
      backgroundColor: AppTheme.brandBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.test.title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
            ),
            Text(
              widget.test.subtitle,
              style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
            ),
          ],
        ),
        actions: [
          if (widget.isRealTest)
            Container(
              margin: const EdgeInsets.only(right: 6),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFFFCA5A5)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.timer_outlined, size: 14, color: Color(0xFFDC2626)),
                  const SizedBox(width: 4),
                  Text(
                    _formatTime(_realTestRemainingSeconds),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFDC2626),
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: TextButton.icon(
              onPressed: _confirmSubmit,
              icon: const Icon(Icons.check_circle_outline_rounded, size: 18, color: Color(0xFF4F46E5)),
              label: const Text(
                'Nộp bài',
                style: TextStyle(color: Color(0xFF4F46E5), fontWeight: FontWeight.bold, fontSize: 13.5),
              ),
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFEEF2FF),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Sticky Audio Player Bar
          _buildAudioPlayerBar(),

          // 2. Section Selector Tabs (Part 1, Part 2...)
          if (widget.test.sections.length > 1) _buildSectionTabs(),

          // 3. Questions Interactive Content
          Expanded(
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
              children: [
                // Instructions Box
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline_rounded, size: 18, color: Color(0xFF3B82F6)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentSec.sectionTitle,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              currentSec.sectionInstruction,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF475569),
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // List of Questions
                ...currentSec.questions.map((q) => _buildQuestionItem(q)),
              ],
            ),
          ),
        ],
      ),

      // 4. Bottom Floating Question Navigator
      bottomNavigationBar: _buildBottomNavigator(answeredQ, totalQ),
    );
  }

  Widget _buildAudioPlayerBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Replay -5s
              IconButton(
                icon: const Icon(Icons.replay_5_rounded, size: 22, color: Color(0xFF4B5563)),
                tooltip: 'Lùi 5s',
                onPressed: () => _seekBy(-5),
              ),

              // Play / Pause
              GestureDetector(
                onTap: _togglePlayPause,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4F46E5),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4F46E5).withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ),

              // Forward +5s
              IconButton(
                icon: const Icon(Icons.forward_5_rounded, size: 22, color: Color(0xFF4B5563)),
                tooltip: 'Tiến 5s',
                onPressed: () => _seekBy(5),
              ),

              // Time labels
              const SizedBox(width: 4),
              Text(
                _formatTime(_currentSeconds),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1E293B)),
              ),
              const Text(' / ', style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
              Text(
                _formatTime(_totalDurationSeconds),
                style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),

              const Spacer(),

              // Speed Selector
              PopupMenuButton<double>(
                initialValue: _playbackSpeed,
                onSelected: _setSpeed,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '${_playbackSpeed}x',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down_rounded, size: 16, color: Color(0xFF64748B)),
                    ],
                  ),
                ),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 0.75, child: Text('0.75x (Chậm)')),
                  const PopupMenuItem(value: 1.0, child: Text('1.0x (Chuẩn)')),
                  const PopupMenuItem(value: 1.25, child: Text('1.25x (Nhanh)')),
                  const PopupMenuItem(value: 1.5, child: Text('1.5x (Rất nhanh)')),
                ],
              ),
            ],
          ),

          // Seekbar Slider
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
              activeTrackColor: const Color(0xFF4F46E5),
              inactiveTrackColor: const Color(0xFFE2E8F0),
              thumbColor: const Color(0xFF4F46E5),
            ),
            child: Slider(
              value: _currentSeconds.toDouble(),
              max: _totalDurationSeconds.toDouble(),
              onChanged: (val) {
                setState(() => _currentSeconds = val.toInt());
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTabs() {
    return Container(
      height: 42,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: widget.test.sections.asMap().entries.map((entry) {
          final idx = entry.key;
          final sec = entry.value;
          final isSelected = idx == _currentSectionIndex;

          return GestureDetector(
            onTap: () {
              setState(() {
                _currentSectionIndex = idx;
                _currentSeconds = 0;
              });
              if (_isPlaying) _togglePlayPause();
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFEEF2FF) : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFFE2E8F0),
                ),
              ),
              child: Text(
                'Part ${sec.partNumber}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFF64748B),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildQuestionItem(ListeningQuestion q) {
    final isAnswered = _userAnswers.containsKey(q.questionNumber) &&
        _userAnswers[q.questionNumber]!.trim().isNotEmpty;

    return Container(
      key: _questionKeys[q.questionNumber],
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isAnswered ? const Color(0xFFC7D2FE) : const Color(0xFFE2E8F0),
          width: isAnswered ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 26,
                height: 26,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isAnswered ? const Color(0xFF4F46E5) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${q.questionNumber}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isAnswered ? Colors.white : const Color(0xFF475569),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  q.questionText,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Interactive Answer Inputs
          if (q.type == QuestionType.gapFill)
            TextField(
              decoration: InputDecoration(
                hintText: 'Nhập câu trả lời...',
                hintStyle: const TextStyle(fontSize: 12.5, color: Color(0xFF94A3B8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(color: Color(0xFF4F46E5), width: 1.5),
                ),
              ),
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              onChanged: (val) {
                setState(() {
                  if (val.trim().isEmpty) {
                    _userAnswers.remove(q.questionNumber);
                  } else {
                    _userAnswers[q.questionNumber] = val;
                  }
                });
              },
            )
          else if (q.type == QuestionType.multipleChoice && q.options != null)
            Column(
              children: q.options!.map((opt) {
                final optLetter = opt.substring(0, 1); // e.g. "A", "B", "C"
                final isSelected = _userAnswers[q.questionNumber] == optLetter;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _userAnswers[q.questionNumber] = optLetter;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFEEF2FF) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFFE2E8F0),
                        width: isSelected ? 1.5 : 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                          size: 18,
                          color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFF94A3B8),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            opt,
                            style: TextStyle(
                              fontSize: 12.5,
                              color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFF334155),
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigator(int answered, int total) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: Color(0xFFE5E7EB))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Open Grid Sheet Button
            OutlinedButton.icon(
              onPressed: _showQuestionNavigatorSheet,
              icon: const Icon(Icons.grid_view_rounded, size: 18, color: Color(0xFF4F46E5)),
              label: Text(
                'Đã làm: $answered/$total',
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4F46E5),
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFC7D2FE)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
            const SizedBox(width: 12),

            // Submit Button
            Expanded(
              child: ElevatedButton(
                onPressed: _confirmSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  'Nộp bài thi',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuestionNavigatorSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Bảng điều hướng câu hỏi',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E293B)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: widget.test.sections.expand((sec) => sec.questions).map((q) {
                  final hasAns = _userAnswers.containsKey(q.questionNumber) &&
                      _userAnswers[q.questionNumber]!.trim().isNotEmpty;
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(ctx);
                      _scrollToQuestion(q.questionNumber);
                    },
                    child: Container(
                      width: 42,
                      height: 42,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: hasAns ? const Color(0xFF4F46E5) : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: hasAns ? const Color(0xFF4F46E5) : const Color(0xFFCBD5E1),
                        ),
                      ),
                      child: Text(
                        '${q.questionNumber}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: hasAns ? Colors.white : const Color(0xFF475569),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
