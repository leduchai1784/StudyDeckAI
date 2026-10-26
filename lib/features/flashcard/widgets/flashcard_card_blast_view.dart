import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../../app/theme.dart';
import '../../../models/edu_word.dart';

/// Giao diện chế độ Card Blast (Phản xạ tốc độ cao)
/// Đếm ngược thời gian (Blast Fuse 7s), nổ combo khi chọn đúng, phản xạ chớp nhoáng
class FlashcardCardBlastView extends StatefulWidget {
  final EduWord currentWord;
  final List<EduWord> allWords;
  final ValueChanged<bool> onAnswer;
  final VoidCallback onSpeak;

  const FlashcardCardBlastView({
    super.key,
    required this.currentWord,
    required this.allWords,
    required this.onAnswer,
    required this.onSpeak,
  });

  @override
  State<FlashcardCardBlastView> createState() => _FlashcardCardBlastViewState();
}

class _FlashcardCardBlastViewState extends State<FlashcardCardBlastView>
    with SingleTickerProviderStateMixin {
  late List<String> _options;
  int? _selectedIndex;
  bool _hasAnswered = false;

  static const int _totalSeconds = 7;
  double _remainingSeconds = _totalSeconds.toDouble();
  Timer? _countdownTimer;

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 6).chain(CurveTween(curve: Curves.elasticIn)).animate(_shakeController);

    _generateOptions();
    _startCountdown();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onSpeak();
    });
  }

  @override
  void didUpdateWidget(covariant FlashcardCardBlastView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentWord.id != widget.currentWord.id) {
      _countdownTimer?.cancel();
      _generateOptions();
      _startCountdown();
      widget.onSpeak();
    }
  }

  void _generateOptions() {
    _selectedIndex = null;
    _hasAnswered = false;
    _remainingSeconds = _totalSeconds.toDouble();

    final correctAnswer = widget.currentWord.viword.isNotEmpty
        ? widget.currentWord.viword
        : widget.currentWord.description;

    final otherWords = widget.allWords
        .where((w) => w.id != widget.currentWord.id && w.viword.isNotEmpty)
        .toList();
    otherWords.shuffle(Random());

    final distractors = otherWords.take(3).map((w) => w.viword).toList();
    while (distractors.length < 3) {
      distractors.add('Nghĩa khác ${distractors.length + 1}');
    }

    final list = [correctAnswer, ...distractors];
    list.shuffle(Random());
    _options = list;
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!mounted) return;
      if (_hasAnswered) {
        timer.cancel();
        return;
      }

      setState(() {
        _remainingSeconds = max(0, _remainingSeconds - 0.1);
      });

      if (_remainingSeconds <= 0) {
        timer.cancel();
        _handleTimeout();
      }
    });
  }

  void _handleTimeout() {
    if (_hasAnswered) return;
    setState(() {
      _hasAnswered = true;
      _selectedIndex = -1; // -1 biểu thị hết giờ
    });
    _shakeController.forward(from: 0);
    widget.onAnswer(false);
  }

  void _handleSelect(int index) {
    if (_hasAnswered) return;
    _countdownTimer?.cancel();

    final selectedText = _options[index];
    final correctAnswer = widget.currentWord.viword.isNotEmpty
        ? widget.currentWord.viword
        : widget.currentWord.description;

    final isCorrect = selectedText.trim() == correctAnswer.trim();

    setState(() {
      _selectedIndex = index;
      _hasAnswered = true;
    });

    if (!isCorrect) {
      _shakeController.forward(from: 0);
    }

    widget.onAnswer(isCorrect);
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final correctAnswer = widget.currentWord.viword.isNotEmpty
        ? widget.currentWord.viword
        : widget.currentWord.description;

    final timeRatio = (_remainingSeconds / _totalSeconds).clamp(0.0, 1.0);
    final Color timerColor = timeRatio > 0.5
        ? const Color(0xFF10B981) // Green
        : (timeRatio > 0.25 ? const Color(0xFFF59E0B) : const Color(0xFFEF4444)); // Orange/Red

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.brandSurface,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd), // 12px
        border: Border.all(
          color: _hasAnswered && _selectedIndex != null && _selectedIndex! >= 0 && _options[_selectedIndex!] == correctAnswer
              ? const Color(0xFF10B981).withValues(alpha: 0.6)
              : AppTheme.brandBorder,
          width: _hasAnswered ? 1.5 : 1.0,
        ),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Header: Tag Card Blast & Đồng hồ ngòi nổ
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEA580C).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.local_fire_department_rounded, size: 15, color: Color(0xFFEA580C)),
                    SizedBox(width: 4),
                    Text(
                      'Card Blast',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFEA580C),
                      ),
                    ),
                  ],
                ),
              ),

              // Countdown text
              Row(
                children: [
                  Icon(
                    timeRatio <= 0.25 ? Icons.alarm_on_rounded : Icons.timer_outlined,
                    size: 16,
                    color: timerColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${_remainingSeconds.toStringAsFixed(1)}s',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: timerColor,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),

          // 2. Blast Fuse Bar (Thanh đếm ngược thời gian)
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: timeRatio,
              minHeight: 6,
              backgroundColor: AppTheme.brandBorder.withValues(alpha: 0.5),
              valueColor: AlwaysStoppedAnimation<Color>(timerColor),
            ),
          ),

          const SizedBox(height: 16),

          // 3. Từ vựng trung tâm
          AnimatedBuilder(
            animation: _shakeAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(_shakeController.isAnimating ? sin(_shakeAnimation.value * pi) * 6 : 0, 0),
                child: child,
              );
            },
            child: Column(
              children: [
                Text(
                  widget.currentWord.title,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.brandTextPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                if (widget.currentWord.transcription.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    widget.currentWord.transcription,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFEA580C),
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 4. Lưới 4 đáp án Blast Pads
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: _options.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final option = _options[index];
                final isSelected = _selectedIndex == index;
                final isTarget = option.trim() == correctAnswer.trim();

                Color borderColor = AppTheme.brandBorder;
                Color bgColor = AppTheme.brandSurface;
                Color textColor = AppTheme.brandTextPrimary;
                Widget? trailingIcon;

                if (_hasAnswered) {
                  if (isTarget) {
                    borderColor = const Color(0xFF10B981);
                    bgColor = const Color(0xFF10B981).withValues(alpha: 0.08);
                    textColor = const Color(0xFF047857);
                    trailingIcon = const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 20);
                  } else if (isSelected) {
                    borderColor = const Color(0xFFEF4444);
                    bgColor = const Color(0xFFEF4444).withValues(alpha: 0.08);
                    textColor = const Color(0xFFB91C1C);
                    trailingIcon = const Icon(Icons.cancel_rounded, color: Color(0xFFEF4444), size: 20);
                  }
                }

                final letters = ['A', 'B', 'C', 'D'];
                final label = index < letters.length ? letters[index] : '${index + 1}';

                return InkWell(
                  onTap: _hasAnswered ? null : () => _handleSelect(index),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                      border: Border.all(color: borderColor, width: isSelected || (_hasAnswered && isTarget) ? 1.8 : 1.0),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (isTarget ? const Color(0xFF10B981) : const Color(0xFFEF4444))
                                : AppTheme.brandBorder.withValues(alpha: 0.4),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            label,
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
                              fontWeight: isSelected || (_hasAnswered && isTarget) ? FontWeight.w600 : FontWeight.normal,
                              color: textColor,
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

          // 5. Thông báo kết quả chớp nhoáng
          if (_hasAnswered) ...[
            const SizedBox(height: 8),
            if (_selectedIndex == -1) ...[
              const Text(
                '💥 Hết giờ! Cố gắng phản xạ nhanh hơn ở thẻ sau nhé!',
                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFFEF4444)),
              ),
            ] else if (_options[_selectedIndex!] == correctAnswer) ...[
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bolt_rounded, size: 18, color: Color(0xFFEA580C)),
                  SizedBox(width: 4),
                  Text(
                    'BLAST! +100 Điểm phản xạ cực nhanh! ⚡',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF047857)),
                  ),
                ],
              ),
            ] else ...[
              const Text(
                'Chưa chính xác! Chú ý đáp án màu xanh nhé.',
                style: TextStyle(fontSize: 12.5, color: Color(0xFFB91C1C)),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
