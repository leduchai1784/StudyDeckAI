import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../../models/edu_word.dart';
import '../../../services/eduwords_service.dart';
import '../../../services/flashcard_progress_service.dart';
import '../../../services/tts_service.dart';

class FlashcardReviewScreen extends StatefulWidget {
  final String level;
  final String levelTitle;
  final String mode; // 'study', 'review_all', 'smart_review'
  final List<EduWord>? customWords;
  final int startIndex;

  const FlashcardReviewScreen({
    super.key,
    this.level = 'A1',
    this.levelTitle = 'Bộ Thẻ Cấp A1',
    this.mode = 'study',
    this.customWords,
    this.startIndex = 0,
  });

  @override
  State<FlashcardReviewScreen> createState() => _FlashcardReviewScreenState();
}

class _FlashcardReviewScreenState extends State<FlashcardReviewScreen>
    with SingleTickerProviderStateMixin {
  final EduwordsService _eduwordsService = EduwordsService();
  final FlashcardProgressService _progressService = FlashcardProgressService();
  final TtsService _ttsService = TtsService();
  List<EduWord> _words = [];
  List<EduWord> _originalDeckWords = [];
  final List<EduWord> _unmasteredWords = [];
  bool _isLoading = true;
  int _currentIndex = 0;
  bool _isFlipped = false;
  int _masteredCount = 0;
  int _reviewCount = 0;
  bool _isCompleted = false;
  final Set<int> _starredWordIds = {};

  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );
    _ttsService.init();
    _loadWords();
  }

  @override
  void dispose() {
    _ttsService.stop();
    _flipController.dispose();
    super.dispose();
  }

  Future<void> _loadWords() async {
    setState(() => _isLoading = true);
    final grouped = await _eduwordsService.fetchWordsByLevel();
    final favIds = await _progressService.getFavoriteWordIds();
    final levelKey = widget.level.toUpperCase();
    final list = grouped[levelKey] ?? [];

    if (!mounted) return;

    final initialWords = widget.customWords != null && widget.customWords!.isNotEmpty
        ? List<EduWord>.from(widget.customWords!)
        : List<EduWord>.from(list);

    final startIdx = (widget.startIndex >= 0 && widget.startIndex < initialWords.length)
        ? widget.startIndex
        : 0;

    setState(() {
      _originalDeckWords = List.from(list);
      _words = initialWords;
      _currentIndex = startIdx;
      _unmasteredWords.clear();
      _starredWordIds.clear();
      _starredWordIds.addAll(favIds);
      _isLoading = false;
    });

    _triggerAutoPlayIfEnabled();
  }

  void _flipCard() {
    if (_isFlipped) {
      _flipController.reverse();
    } else {
      _flipController.forward();
    }
    setState(() {
      _isFlipped = !_isFlipped;
    });
  }

  Future<void> _toggleStar(int wordId) async {
    final isStarred = await _progressService.toggleFavoriteWordId(wordId);
    setState(() {
      if (isStarred) {
        _starredWordIds.add(wordId);
      } else {
        _starredWordIds.remove(wordId);
      }
    });

    if (mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isStarred
                ? '⭐ Đã lưu vào Bộ thẻ Cá nhân & Từ vựng yêu thích'
                : '🗑️ Đã bỏ lưu từ vựng khỏi Bộ thẻ Cá nhân',
          ),
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _playAudio(String text) {
    _ttsService.speak(text);
  }

  void _triggerAutoPlayIfEnabled() {
    if (_ttsService.autoPlay && _words.isNotEmpty && _currentIndex < _words.length && !_isCompleted) {
      _ttsService.speak(_words[_currentIndex].title);
    }
  }

  void _answerCard(bool isMastered) {
    _ttsService.stop();
    if (_isFlipped) {
      _flipController.reverse();
      _isFlipped = false;
    }

    if (_words.isNotEmpty && _currentIndex < _words.length) {
      final currentWord = _words[_currentIndex];
      final targetDeckId = (currentWord.customDeckId != null && currentWord.customDeckId!.isNotEmpty)
          ? currentWord.customDeckId!
          : (currentWord.level.isNotEmpty ? currentWord.level : widget.level);

      _progressService.updateCardAnswerGlobal(
        currentWord.id,
        isMastered,
        targetDeckId: targetDeckId,
      );

      if (widget.level != targetDeckId && widget.level != 'SM2_REVIEW') {
        _progressService.updateCardAnswer(widget.level, currentWord.id, isMastered);
      }

      if (widget.mode == 'study') {
        _progressService.recordDeckCardStudied(
          widget.level,
          _originalDeckWords.length,
          _currentIndex,
          isMastered,
        );
      }

      if (!isMastered) {
        if (!_unmasteredWords.any((w) => w.id == currentWord.id)) {
          _unmasteredWords.add(currentWord);
        }
      } else {
        _unmasteredWords.removeWhere((w) => w.id == currentWord.id);
      }
    }

    if (isMastered) {
      _masteredCount++;
    } else {
      _reviewCount++;
    }

    if (_currentIndex + 1 < _words.length) {
      setState(() {
        _currentIndex++;
      });
      _triggerAutoPlayIfEnabled();
    } else {
      setState(() {
        _isCompleted = true;
      });
      _onDeckCompleted();
    }
  }

  Future<void> _onDeckCompleted() async {
    if (widget.mode == 'study') {
      await _progressService.recordDeckCompletion(
        widget.level,
        _originalDeckWords.isNotEmpty ? _originalDeckWords.length : _words.length,
      );
    } else {
      await _progressService.incrementDeckReviewCount(widget.level);
    }
  }

  void _goToPreviousCard() {
    if (_currentIndex > 0) {
      _ttsService.stop();
      if (_isFlipped) {
        _flipController.reverse();
        _isFlipped = false;
      }
      setState(() {
        _currentIndex--;
      });
      _triggerAutoPlayIfEnabled();
    }
  }

  void _goToNextCard() {
    if (_currentIndex + 1 < _words.length) {
      _ttsService.stop();
      if (_isFlipped) {
        _flipController.reverse();
        _isFlipped = false;
      }
      setState(() {
        _currentIndex++;
      });
      _triggerAutoPlayIfEnabled();
    }
  }

  void _restartDeck() {
    _ttsService.stop();
    setState(() {
      _words = List.from(_originalDeckWords);
      _unmasteredWords.clear();
      _currentIndex = 0;
      _isFlipped = false;
      _masteredCount = 0;
      _reviewCount = 0;
      _isCompleted = false;
    });
    if (_flipController.isCompleted) {
      _flipController.reset();
    }
    _triggerAutoPlayIfEnabled();
  }

  Future<void> _reviewUnmasteredOnly() async {
    _ttsService.stop();
    List<EduWord> toReview = List.from(_unmasteredWords);
    if (toReview.isEmpty) {
      final masteredIds = await _progressService.getMasteredWordIds(widget.level);
      toReview = _originalDeckWords.where((w) => !masteredIds.contains(w.id)).toList();
    }

    if (toReview.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🎉 Tuyệt vời! Bạn không có từ nào cần ôn lại.'),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );
      }
      return;
    }

    setState(() {
      _words = toReview;
      _unmasteredWords.clear();
      _currentIndex = 0;
      _isFlipped = false;
      _masteredCount = 0;
      _reviewCount = 0;
      _isCompleted = false;
    });
    if (_flipController.isCompleted) {
      _flipController.reset();
    }
    _triggerAutoPlayIfEnabled();
  }

  Color _getLevelColor(String level) {
    switch (level.toUpperCase()) {
      case 'A1':
        return const Color(0xFF10B981);
      case 'A2':
        return const Color(0xFF0EA5E9);
      case 'B1':
        return const Color(0xFF6366F1);
      case 'B2':
        return const Color(0xFF8B5CF6);
      case 'C1':
        return const Color(0xFFF59E0B);
      case 'C2':
        return const Color(0xFFEC4899);
      default:
        return AppTheme.primaryContainer;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppTheme.surface,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final levelColor = _getLevelColor(widget.level);

    // Khi đã hoàn thành (Completion State): Không hiển thị thanh tiến độ ở trên cùng
    if (_isCompleted) {
      return Scaffold(
        backgroundColor: AppTheme.surface,
        body: SafeArea(
          child: Column(
            children: [
              // Nút đóng ở góc trên bên trái (không kèm thanh tiến độ hay số đếm)
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                  child: IconButton(
                    icon: const Icon(Icons.close, color: AppTheme.onSurface, size: 24),
                    onPressed: () => context.pop(),
                  ),
                ),
              ),
              Expanded(
                child: _buildCompletionState(levelColor),
              ),
            ],
          ),
        ),
      );
    }

    final total = _words.length;
    final progress = total > 0 ? (_currentIndex + 1) / total : 0.0;

    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Top Header Bar (Close X, Progress bar, Counter, More Vert)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: AppTheme.onSurface, size: 24),
                    onPressed: () => context.pop(),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: AppTheme.brandBorder,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.brandPrimary),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    '${_currentIndex + 1}/$total',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppTheme.brandPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.more_vert, color: AppTheme.onSurface, size: 24),
                    onPressed: () => _showAudioSettingsBottomSheet(context),
                  ),
                ],
              ),
            ),

            // 2. Main Content
            Expanded(
              child: _words.isEmpty
                  ? _buildEmptyState()
                  : _buildReviewContent(levelColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.style_outlined, size: 64, color: AppTheme.outline),
          const SizedBox(height: 16),
          Text(
            'Chưa có từ vựng cho cấp ${widget.level}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.pop(),
            child: const Text('Quay lại danh sách'),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionState(Color levelColor) {
    final total = _words.length;
    final percent = total > 0 ? ((_masteredCount / total) * 100).round() : 0;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.outlineVariant.withValues(alpha: 0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: levelColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.emoji_events, size: 56, color: levelColor),
              ),
              const SizedBox(height: 16),
              const Text(
                'Xuất Sắc! 🎉',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.onSurface),
              ),
              const SizedBox(height: 8),
              Text(
                'Bạn đã hoàn thành bộ thẻ ${widget.levelTitle}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 14),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildResultStat('Đã thuộc', '$_masteredCount', const Color(0xFF10B981)),
                  _buildResultStat('Cần ôn', '$_reviewCount', AppTheme.error),
                  _buildResultStat('Tỷ lệ', '$percent%', levelColor),
                ],
              ),
              const SizedBox(height: 24),

              // Nút "Ôn lại từ chưa nhớ"
              if (_unmasteredWords.isNotEmpty)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _reviewUnmasteredOnly,
                    icon: const Icon(Icons.replay_rounded, color: Colors.white, size: 20),
                    label: Text(
                      'Ôn lại ${_unmasteredWords.length} từ chưa nhớ',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE65100),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 1,
                    ),
                  ),
                )
              else
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _reviewUnmasteredOnly,
                    icon: const Icon(Icons.replay_rounded, color: AppTheme.outline, size: 20),
                    label: const Text(
                      'Ôn lại từ chưa nhớ',
                      style: TextStyle(
                        color: AppTheme.outline,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: AppTheme.outlineVariant.withValues(alpha: 0.5)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _restartDeck,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Học lại'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await _onDeckCompleted();
                        if (!mounted) return;
                        context.pop(true);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryContainer,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Hoàn tất', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.onSurfaceVariant)),
      ],
    );
  }

  void _showAudioSettingsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceContainerLowest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return ValueListenableBuilder<int>(
          valueListenable: _ttsService.settingsVersionNotifier,
          builder: (context, _, child) {
            final currentVoice = _ttsService.voice;
            final isAutoPlay = _ttsService.autoPlay;
            final currentRate = _ttsService.speechRate;

            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle Bar
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppTheme.outlineVariant.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Header Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Cài đặt phát âm Flashcard',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.onSurface,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 20, color: AppTheme.outline),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // 1. CHỌN GIỌNG ĐỌC (UK / US)
                    const Text(
                      'GIỌNG ĐỌC PHÁT ÂM',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.outline,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Voice options matching reference design
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.outlineVariant.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        children: [
                          _buildVoiceOptionItem(
                            title: 'Giọng Anh (UK)',
                            subtitle: 'British English (en-GB)',
                            isSelected: currentVoice == TtsVoice.uk,
                            onTap: () {
                              _ttsService.setVoice(TtsVoice.uk);
                              if (_words.isNotEmpty && _currentIndex < _words.length) {
                                _ttsService.speak(_words[_currentIndex].title);
                              }
                            },
                          ),
                          const Divider(height: 1, indent: 16, endIndent: 16),
                          _buildVoiceOptionItem(
                            title: 'Giọng Mỹ (US)',
                            subtitle: 'American English (en-US)',
                            isSelected: currentVoice == TtsVoice.us,
                            onTap: () {
                              _ttsService.setVoice(TtsVoice.us);
                              if (_words.isNotEmpty && _currentIndex < _words.length) {
                                _ttsService.speak(_words[_currentIndex].title);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // 2. TỰ ĐỘNG ĐỌC (Auto-play)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.outlineVariant.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.play_circle_outline, color: AppTheme.brandPrimary, size: 22),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tự động đọc khi chuyển thẻ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.brandTextPrimary,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Phát âm từ vựng ngay khi xuất hiện',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.brandTextSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch.adaptive(
                            value: isAutoPlay,
                            activeTrackColor: AppTheme.brandPrimary,
                            onChanged: (val) {
                              _ttsService.setAutoPlay(val);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // 3. TỐC ĐỘ ĐỌC (Thanh kéo âm Slider)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'TỐC ĐỘ ĐỌC',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.brandTextSecondary,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.chipIndigoBg,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${(currentRate * 2).toStringAsFixed(1)}x',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.brandPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppTheme.brandSurface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.brandBorder),
                      ),
                      child: Column(
                        children: [
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: AppTheme.brandPrimary,
                              inactiveTrackColor: AppTheme.brandBorder,
                              thumbColor: AppTheme.brandPrimary,
                              overlayColor: AppTheme.brandPrimary.withValues(alpha: 0.15),
                              trackHeight: 5,
                              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                            ),
                            child: Slider(
                              value: currentRate.clamp(0.25, 0.8),
                              min: 0.25,
                              max: 0.8,
                              divisions: 11,
                              onChanged: (val) {
                                _ttsService.setSpeechRate(val);
                              },
                              onChangeEnd: (val) {
                                if (_words.isNotEmpty && _currentIndex < _words.length) {
                                  _ttsService.speak(_words[_currentIndex].title);
                                }
                              },
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 14.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Chậm (0.5x)',
                                  style: TextStyle(fontSize: 11, color: AppTheme.onSurfaceVariant),
                                ),
                                Text(
                                  'Chuẩn (1.0x)',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.brandPrimary),
                                ),
                                Text(
                                  'Nhanh (1.6x)',
                                  style: TextStyle(fontSize: 11, color: AppTheme.onSurfaceVariant),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildVoiceOptionItem({
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.chipIndigoBg : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected ? AppTheme.brandPrimary : AppTheme.brandTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? AppTheme.brandPrimary : AppTheme.brandTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check, color: AppTheme.brandPrimary, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewContent(Color levelColor) {
    final currentWord = _words[_currentIndex];
    final isStarred = _starredWordIds.contains(currentWord.id);
    final total = _words.length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
      child: Column(
        children: [
          // 1. The Interactive Flashcard Box
          Expanded(
            child: GestureDetector(
              onTap: _flipCard,
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
                    child: angle >= pi / 2
                        ? Transform(
                            transform: Matrix4.identity()..rotateY(pi),
                            alignment: Alignment.center,
                            child: _buildCardBack(currentWord, isStarred, levelColor),
                          )
                        : _buildCardFront(currentWord, isStarred, levelColor),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 2. Control & Rating Buttons Section
          // Row 1: Left Arrow, "Chưa nhớ" (Pink/Red), "Đã nhớ" (Blue), Right Arrow
          Row(
            children: [
              // Previous Arrow Button
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceContainerHigh.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppTheme.onSurface, size: 20),
                  onPressed: _currentIndex > 0 ? _goToPreviousCard : null,
                ),
              ),
              const SizedBox(width: 10),

              // "Chưa nhớ" Button
              Expanded(
                child: InkWell(
                  onTap: () => _answerCard(false),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEBEA), // Soft pinkish red
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Chưa nhớ',
                      style: TextStyle(
                        color: Color(0xFFD32F2F),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // "Đã nhớ" Button
              Expanded(
                child: InkWell(
                  onTap: () => _answerCard(true),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppTheme.brandPrimary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Đã nhớ',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Next Arrow Button
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceContainerHigh.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_forward, color: AppTheme.onSurface, size: 20),
                  onPressed: _currentIndex + 1 < total ? _goToNextCard : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Row 2: SM-2 Spaced Repetition Interval Options (4 boxes)
          Row(
            children: [
              _buildSm2Box('Lặp lại', '< 1 ngày', const Color(0xFFD32F2F), () => _answerCard(false)),
              const SizedBox(width: 8),
              _buildSm2Box('Khó', '3 ngày', AppTheme.onSurface, () => _answerCard(false)),
              const SizedBox(width: 8),
              _buildSm2Box('Tốt', '5 ngày', AppTheme.brandPrimary, () => _answerCard(true)),
              const SizedBox(width: 8),
              _buildSm2Box('Dễ', '8 ngày', AppTheme.onSurface, () => _answerCard(true)),
            ],
          ),
          ],
        ),
      );
  }

  Widget _buildSm2Box(String label, String time, Color timeColor, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: AppTheme.outlineVariant.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 11, color: AppTheme.outline, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 2),
              Text(
                time,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: timeColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // MẶT TRƯỚC THẺ (FRONT SIDE)
  Widget _buildCardFront(EduWord word, bool isStarred, Color levelColor) {
    final ipa = word.formattedTranscription;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.outlineVariant.withValues(alpha: 0.3), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top Row: Pill Badge & Speaker + Star Icons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E8FF),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '• Từ vựng - ${word.level}',
                  style: const TextStyle(
                    color: Color(0xFF6B21A8),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              Row(
                children: [
                  ValueListenableBuilder<bool>(
                    valueListenable: _ttsService.isSpeakingNotifier,
                    builder: (context, isSpeaking, _) {
                      return IconButton(
                        icon: Icon(
                          isSpeaking ? Icons.volume_up : Icons.volume_up_outlined,
                          color: isSpeaking ? AppTheme.brandPrimary : AppTheme.brandTextMuted,
                          size: 24,
                        ),
                        onPressed: () => _playAudio(word.title),
                        tooltip: 'Phát âm từ vựng',
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      isStarred ? Icons.star : Icons.star_border_rounded,
                      color: isStarred ? const Color(0xFFFFB300) : AppTheme.onSurfaceVariant,
                      size: 24,
                    ),
                    onPressed: () => _toggleStar(word.id),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),

          // Main English Word
          Text(
            word.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: AppTheme.onSurface,
              letterSpacing: -0.5,
            ),
          ),
          if (ipa.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              ipa,
              style: AppTheme.ipaStyle(
                fontSize: 18,
                color: AppTheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
          const SizedBox(height: 20),

          // Tag Prompt
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF6F2FF),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.touch_app_outlined, size: 16, color: Color(0xFF4F46E5)),
                SizedBox(width: 6),
                Text(
                  'Chạm thẻ để xem giải nghĩa',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4F46E5),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),

          // Bottom Divider & Caption
          const Divider(color: AppTheme.outlineVariant, height: 1),
          const SizedBox(height: 12),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.swap_horiz, size: 16, color: AppTheme.outline),
              SizedBox(width: 6),
              Text(
                'Chạm bất kỳ đâu trên thẻ để lật',
                style: TextStyle(fontSize: 12, color: AppTheme.outline),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // MẶT SAU THẺ (BACK SIDE)
  Widget _buildCardBack(EduWord word, bool isStarred, Color levelColor) {
    final ipa = word.formattedTranscription;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.primaryContainer.withValues(alpha: 0.4), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Pill Badge & Speaker + Star Icons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E8FF),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '• Nghĩa & Giải thích - ${word.level}',
                  style: const TextStyle(
                    color: Color(0xFF6B21A8),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              Row(
                children: [
                  ValueListenableBuilder<bool>(
                    valueListenable: _ttsService.isSpeakingNotifier,
                    builder: (context, isSpeaking, _) {
                      return IconButton(
                        icon: Icon(
                          isSpeaking ? Icons.volume_up : Icons.volume_up_outlined,
                          color: isSpeaking ? AppTheme.brandPrimary : AppTheme.brandTextMuted,
                          size: 24,
                        ),
                        onPressed: () => _playAudio(word.title),
                        tooltip: 'Phát âm từ vựng',
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      isStarred ? Icons.star : Icons.star_border_rounded,
                      color: isStarred ? const Color(0xFFFFB300) : AppTheme.onSurfaceVariant,
                      size: 24,
                    ),
                    onPressed: () => _toggleStar(word.id),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Scrollable Body Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Vietnamese Word / Meaning
                  Text(
                    word.viword.isNotEmpty ? word.viword : 'Chưa có nghĩa',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.brandPrimary,
                    ),
                  ),
                  if (ipa.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      ipa,
                      style: AppTheme.ipaStyle(fontSize: 14, color: AppTheme.onSurfaceVariant),
                    ),
                  ],
                  const SizedBox(height: 16),

                  // English Definition
                  if (word.description.isNotEmpty) ...[
                    const Text(
                      'Định nghĩa (English):',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.outline),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      word.description,
                      style: const TextStyle(fontSize: 14, height: 1.4, color: AppTheme.onSurface),
                    ),
                    const SizedBox(height: 14),
                  ],

                  // Vietnamese Description
                  if (word.videscription.isNotEmpty) ...[
                    const Text(
                      'Giải thích chi tiết:',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.outline),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      word.videscription,
                      style: const TextStyle(fontSize: 13, height: 1.4, color: AppTheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 14),
                  ],

                  // Example Sentence with Pronounce Button
                  if (word.example.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Ví dụ câu mẫu:',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.outline),
                        ),
                        InkWell(
                          onTap: () => _playAudio(word.example),
                          borderRadius: BorderRadius.circular(4),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            child: Row(
                              children: [
                                Icon(Icons.volume_up_outlined, size: 16, color: AppTheme.brandPrimary),
                                SizedBox(width: 4),
                                Text(
                                  'Nghe câu',
                                  style: TextStyle(fontSize: 11, color: AppTheme.brandPrimary, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '"${word.example}"',
                        style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic, height: 1.4),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Bottom Divider & Caption
          const Divider(color: AppTheme.outlineVariant, height: 1),
          const SizedBox(height: 12),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.swap_horiz, size: 16, color: AppTheme.outline),
              SizedBox(width: 6),
              Text(
                'Chạm bất kỳ đâu trên thẻ để lật',
                style: TextStyle(fontSize: 12, color: AppTheme.outline),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
