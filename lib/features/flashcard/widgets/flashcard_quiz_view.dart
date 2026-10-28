import 'dart:math';
import 'package:flutter/material.dart';
import '../../../app/theme.dart';
import '../../../models/edu_word.dart';

/// Giao diện chế độ Quiz trắc nghiệm 4 đáp án theo chuẩn Duolingo/Quizlet (1 chạm):
/// - Chọn đúng: Ô báo XANH, tự động phát âm và lật 3D sang mặt sau hiển thị chi tiết từ vựng kèm banner 'Chính xác!'.
/// - Chọn sai: Ô chọn báo ĐỎ, tự động làm sáng XANH ô đáp án đúng để đối chiếu, phát âm và lật 3D sang mặt sau với banner 'Đáp án đúng: [Nghĩa tiếng Việt]'.
/// - Nhấn 'Tiếp tục' để xác nhận kết quả và chuyển câu.
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

class _FlashcardQuizViewState extends State<FlashcardQuizView>
    with SingleTickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  late List<String> _options;
  int? _correctIndex;
  int? _wrongIndex;
  bool _submitted = false;
  bool _isCardFlipped = false;
  bool _isCorrect = true;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _flipAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOutCubic),
    );
    _generateOptions();
  }

  @override
  void didUpdateWidget(covariant FlashcardQuizView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentWord.id != widget.currentWord.id) {
      _resetState();
    }
  }

  void _resetState() {
    _flipController.reset();
    _wrongIndex = null;
    _correctIndex = null;
    _submitted = false;
    _isCardFlipped = false;
    _isCorrect = true;
    _generateOptions();
  }

  void _generateOptions() {
    final correctAnswer = (widget.currentWord.viword.isNotEmpty
            ? widget.currentWord.viword
            : widget.currentWord.description)
        .trim();

    // Lọc các từ khác trong deck có nghĩa tiếng Việt khác rỗng và không trùng correctAnswer
    final uniqueDistractors = widget.allWords
        .where((w) =>
            w.id != widget.currentWord.id &&
            w.viword.trim().isNotEmpty &&
            w.viword.trim().toLowerCase() != correctAnswer.toLowerCase())
        .map((w) => w.viword.trim())
        .toSet()
        .toList();
    uniqueDistractors.shuffle(Random());

    final distractors = uniqueDistractors.take(3).toList();

    // Trường hợp deck ít từ hoặc không đủ từ phân biệt, thêm lựa chọn dự phòng không trùng
    int fallbackIndex = 1;
    while (distractors.length < 3) {
      final fallback = 'Nghĩa khác $fallbackIndex';
      if (!distractors.contains(fallback) &&
          fallback.toLowerCase() != correctAnswer.toLowerCase()) {
        distractors.add(fallback);
      }
      fallbackIndex++;
    }

    final list = [correctAnswer, ...distractors];
    list.shuffle(Random());
    _options = list;
  }

  void _handleSelect(int index) {
    if (_submitted) return;

    final selectedText = _options[index];
    final correctAnswer = (widget.currentWord.viword.isNotEmpty
            ? widget.currentWord.viword
            : widget.currentWord.description)
        .trim();

    final correctIndex = _options.indexWhere(
      (opt) => opt.trim().toLowerCase() == correctAnswer.toLowerCase(),
    );

    final isCorrect = selectedText.trim().toLowerCase() == correctAnswer.toLowerCase();

    setState(() {
      _submitted = true;
      _isCorrect = isCorrect;
      _correctIndex = correctIndex >= 0 ? correctIndex : null;
      _wrongIndex = isCorrect ? null : index;
      _isCardFlipped = true;
    });

    widget.onSpeak();
    _flipController.forward();
  }

  void _toggleFlip() {
    if (!_submitted) return;
    if (_flipController.isAnimating) return;
    if (_isCardFlipped) {
      _flipController.reverse();
      setState(() {
        _isCardFlipped = false;
      });
    } else {
      _flipController.forward();
      setState(() {
        _isCardFlipped = true;
      });
    }
  }

  void _onContinue() {
    widget.onAnswer(_isCorrect);
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Thẻ Flashcard trung tâm với hiệu ứng lật 3D (chạm vào thẻ để lật qua lại sau khi đã nộp)
        Expanded(
          child: GestureDetector(
            key: const ValueKey('flashcard_quiz_card'),
            behavior: HitTestBehavior.opaque,
            onTap: _submitted ? _toggleFlip : null,
            child: AnimatedBuilder(
              animation: _flipAnimation,
              builder: (context, child) {
                final angle = _flipAnimation.value * pi;
                final transform = Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(angle);

                return Transform(
                  transform: transform,
                  alignment: Alignment.center,
                  child: angle >= (pi / 2)
                      ? Transform(
                          transform: Matrix4.identity()..rotateY(pi),
                          alignment: Alignment.center,
                          child: _buildCardBack(context),
                        )
                      : _buildCardFront(context),
                );
              },
            ),
          ),
        ),

        // Nút Tiếp tục ở đáy khi đã chọn đúng
        if (_submitted) ...[
          const SizedBox(height: 12),
          _buildBottomActions(),
        ],
      ],
    );
  }

  // --- MẶT TRƯỚC (Front: Câu hỏi và 4 ô trắc nghiệm) ---
  Widget _buildCardFront(BuildContext context) {
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
          // Header: Tag Quiz Trắc nghiệm + Loa
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

          const SizedBox(height: 8),

          // Body: Căn giữa theo chiều dọc, cuộn an toàn chống tràn
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Từ vựng tiếng Anh to đậm
                    Text(
                      widget.currentWord.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.brandTextPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    if (widget.currentWord.formattedTranscription.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        widget.currentWord.formattedTranscription,
                        style: AppTheme.ipaStyle(fontSize: 16, color: AppTheme.onSurfaceVariant),
                      ),
                    ],

                    const SizedBox(height: 18),

                    // 4 ô đáp án lựa chọn A, B, C, D
                    ...List.generate(_options.length, (index) {
                      final option = _options[index];
                      final isWrong = _wrongIndex == index;
                      final isCorrect = _correctIndex == index;

                      Color bgColor = AppTheme.brandSurface;
                      Border border = Border.all(color: AppTheme.brandBorder, width: 1);
                      Color textColor = AppTheme.brandTextPrimary;
                      Color badgeBg = AppTheme.brandBackground;
                      Color badgeTextColor = AppTheme.brandTextSecondary;
                      Widget? trailingIcon;

                      if (isCorrect) {
                        bgColor = AppTheme.tintGreenBg;
                        border = Border.all(color: AppTheme.tintGreenText, width: 1.5);
                        textColor = AppTheme.tintGreenText;
                        badgeBg = AppTheme.tintGreenText;
                        badgeTextColor = Colors.white;
                        trailingIcon = const Icon(Icons.check_circle_rounded, color: AppTheme.tintGreenText, size: 20);
                      } else if (isWrong) {
                        bgColor = const Color(0xFFFFEBEA);
                        border = Border.all(color: const Color(0xFFD32F2F), width: 1.5);
                        textColor = const Color(0xFFD32F2F);
                        badgeBg = const Color(0xFFD32F2F);
                        badgeTextColor = Colors.white;
                        trailingIcon = const Icon(Icons.cancel_rounded, color: Color(0xFFD32F2F), size: 20);
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: InkWell(
                          onTap: _submitted ? null : () => _handleSelect(index),
                          borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                              border: border,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 26,
                                  height: 26,
                                  decoration: BoxDecoration(
                                    color: badgeBg,
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    String.fromCharCode(65 + index), // A, B, C, D
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: badgeTextColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    option,
                                    style: TextStyle(
                                      fontSize: 14.5,
                                      fontWeight: (isCorrect || isWrong) ? FontWeight.bold : FontWeight.w500,
                                      color: textColor,
                                      height: 1.3,
                                    ),
                                  ),
                                ),
                                if (trailingIcon != null) trailingIcon,
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),

          // Thông báo Đúng / Sai ở mép đáy mặt trước (đối xứng hoàn toàn với mặt sau khi đã nộp)
          if (_submitted) ...[
            const SizedBox(height: 12),
            Center(child: _buildResultBanner()),
          ],
        ],
      ),
    );
  }

  // --- MẶT SAU (Back: Chi tiết kiến thức như chế độ Gõ từ) ---
  Widget _buildCardBack(BuildContext context) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Tag "TIẾNG ANH" (trái) + Loa (phải)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'TIẾNG ANH',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: AppTheme.brandTextMuted,
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

          const SizedBox(height: 8),

          // Body: Căn giữa theo chiều dọc cho cân đối và đỡ trống thẻ
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Từ vựng tiếng Anh to đậm
                      Text(
                        widget.currentWord.title,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.brandTextPrimary,
                          letterSpacing: -0.5,
                          height: 1.15,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Phiên âm IPA & Nghĩa tiếng Việt
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          if (widget.currentWord.formattedTranscription.isNotEmpty) ...[
                            Text(
                              widget.currentWord.formattedTranscription,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.brandTextSecondary,
                              ),
                            ),
                            const Text(
                              ' · ',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.brandTextMuted,
                              ),
                            ),
                          ],
                          Text(
                            widget.currentWord.viword.isNotEmpty
                                ? widget.currentWord.viword
                                : widget.currentWord.description,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.brandTextPrimary,
                            ),
                          ),
                        ],
                      ),

                      // Khối câu ví dụ (Example box với viền vàng hổ phách)
                      if (widget.currentWord.example.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(left: 12, top: 4, bottom: 4),
                          decoration: const BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: Color(0xFFF59E0B), // Vàng Amber
                                width: 3.5,
                              ),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '"${widget.currentWord.example}"',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.brandTextPrimary,
                                  height: 1.4,
                                ),
                              ),
                              if (widget.currentWord.videscription.isNotEmpty ||
                                  widget.currentWord.description.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  widget.currentWord.videscription.isNotEmpty
                                      ? widget.currentWord.videscription
                                      : widget.currentWord.description,
                                  style: const TextStyle(
                                    fontSize: 12.5,
                                    color: AppTheme.brandTextSecondary,
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Thông báo Đúng / Sai ở dưới đáy mặt sau (đối xứng hoàn toàn với mặt trước)
          if (_submitted) ...[
            const SizedBox(height: 12),
            Center(child: _buildResultBanner()),
          ],
        ],
      ),
    );
  }

  // --- BANNER THÔNG BÁO ĐÚNG / SAI ---
  Widget _buildResultBanner() {
    final correctAnswer = widget.currentWord.viword.isNotEmpty
        ? widget.currentWord.viword
        : widget.currentWord.description;

    return Container(
      key: const ValueKey('result_box'),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _isCorrect ? AppTheme.tintGreenBg : const Color(0xFFFFEBEA),
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
            size: 18,
            color: _isCorrect ? AppTheme.tintGreenText : const Color(0xFFD32F2F),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              _isCorrect ? 'Chính xác!' : 'Đáp án: $correctAnswer',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.bold,
                color: _isCorrect ? AppTheme.tintGreenText : const Color(0xFFD32F2F),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- NÚT TIẾP TỤC DƯỚI ĐÁY ---
  Widget _buildBottomActions() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: _onContinue,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0D9488),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusSm), // 8px
          ),
          elevation: 0,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Tiếp tục',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 6),
            Icon(Icons.arrow_forward_rounded, size: 18),
          ],
        ),
      ),
    );
  }
}
