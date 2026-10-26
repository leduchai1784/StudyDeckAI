import 'package:flutter/material.dart';
import '../../../app/theme.dart';
import '../../../models/edu_word.dart';

/// Giao diện chế độ Luyện nghe từ vựng (Listening Mode)
/// Nghe audio chuẩn 1.0x và chậm 0.75x, ẩn từ vựng và gõ chính tả
/// Thiết kế chống tràn màn hình khi bàn phím ảo hiển thị
class FlashcardListeningView extends StatefulWidget {
  final EduWord word;
  final ValueChanged<bool> onAnswer;
  final Function(double rate) onPlayAudio;

  const FlashcardListeningView({
    super.key,
    required this.word,
    required this.onAnswer,
    required this.onPlayAudio,
  });

  @override
  State<FlashcardListeningView> createState() => _FlashcardListeningViewState();
}

class _FlashcardListeningViewState extends State<FlashcardListeningView> {
  final TextEditingController _textController = TextEditingController();
  bool _showMeaningHint = false;
  bool? _isCorrect;
  bool _submitted = false;
  double _lastRate = 0.5;

  @override
  void initState() {
    super.initState();
    widget.onPlayAudio(0.5); // 1.0x
  }

  @override
  void didUpdateWidget(covariant FlashcardListeningView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.word.id != widget.word.id) {
      _textController.clear();
      _showMeaningHint = false;
      _isCorrect = null;
      _submitted = false;
      widget.onPlayAudio(0.5);
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _checkAnswer() {
    if (_submitted) return;
    final input = _textController.text.trim().toLowerCase();
    final target = widget.word.title.trim().toLowerCase();
    final correct = input == target;

    setState(() {
      _isCorrect = correct;
      _submitted = true;
    });

    widget.onPlayAudio(0.5);
    widget.onAnswer(correct);
  }

  void _play(double rate) {
    setState(() => _lastRate = rate);
    widget.onPlayAudio(rate);
  }

  @override
  Widget build(BuildContext context) {
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
          // Header: Tag Luyện nghe
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusXs),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.headphones_rounded, size: 14, color: Color(0xFF2563EB)),
                    SizedBox(width: 4),
                    Text(
                      'Luyện nghe chính tả',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                  ],
                ),
              ),
              if (_showMeaningHint)
                Flexible(
                  child: Text(
                    widget.word.viword,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.brandPrimary,
                    ),
                  ),
                ),
            ],
          ),

          // Body: Cuộn an toàn chống tràn khi bàn phím mở
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 12),

                    // Icon Tai nghe phát sóng âm với animation nhịp nhàng
                    InkWell(
                      onTap: () => _play(_lastRate),
                      borderRadius: BorderRadius.circular(40),
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2563EB).withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.graphic_eq_rounded,
                          size: 38,
                          color: Color(0xFF2563EB),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // 2 nút phát âm: Chuẩn 1.0x & Chậm 0.75x
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _play(0.5), // chuẩn 1.0x
                          icon: const Icon(Icons.volume_up_rounded, size: 18),
                          label: const Text('Nghe 1.0x'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                            ),
                            elevation: 0,
                          ),
                        ),
                        const SizedBox(width: 10),
                        OutlinedButton.icon(
                          onPressed: () => _play(0.35), // chậm 0.75x
                          icon: const Icon(Icons.slow_motion_video_rounded, size: 18),
                          label: const Text('Chậm 0.75x'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF2563EB),
                            side: const BorderSide(color: Color(0xFF2563EB)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Ô nhập từ vựng nghe được
                    TextField(
                      controller: _textController,
                      textAlign: TextAlign.center,
                      autofocus: false,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.brandTextPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Gõ từ tiếng Anh bạn vừa nghe...',
                        hintStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                          color: AppTheme.brandTextMuted,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        filled: true,
                        fillColor: AppTheme.brandBackground,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                          borderSide: const BorderSide(color: AppTheme.brandBorder),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                          borderSide: const BorderSide(color: AppTheme.brandBorder),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                          borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
                        ),
                      ),
                      onChanged: (val) => setState(() {}),
                      onSubmitted: (_) => _checkAnswer(),
                    ),

                    // Hiển thị kết quả đúng / sai
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: _submitted
                          ? Container(
                              key: const ValueKey('listening_result'),
                              width: double.infinity,
                              margin: const EdgeInsets.only(top: 12),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: _isCorrect == true ? AppTheme.tintGreenBg : const Color(0xFFFFEBEA),
                                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                              ),
                              child: Text(
                                _isCorrect == true
                                    ? 'Chính xác! ${widget.word.title} ${widget.word.formattedTranscription}'
                                    : 'Đáp án: ${widget.word.title} • Nghĩa: ${widget.word.viword}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: _isCorrect == true
                                      ? AppTheme.tintGreenText
                                      : const Color(0xFFD32F2F),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Nút Gợi ý nghĩa & Nút Kiểm tra
          Row(
            children: [
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    _showMeaningHint = !_showMeaningHint;
                  });
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  ),
                  side: const BorderSide(color: AppTheme.brandBorder),
                ),
                child: Text(
                  _showMeaningHint ? 'Ẩn nghĩa' : 'Gợi ý nghĩa',
                  style: const TextStyle(fontSize: 12, color: AppTheme.brandTextPrimary),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: _textController.text.trim().isEmpty ? null : _checkAnswer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppTheme.brandBorder,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    _submitted ? 'Đã nộp bài' : 'Kiểm tra',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
