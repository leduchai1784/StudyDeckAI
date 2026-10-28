import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../app/theme.dart';
import '../../../models/edu_word.dart';
import '../../../services/eduwords_service.dart';
import '../../../services/flashcard_progress_service.dart';
import '../../../services/tts_service.dart';
import '../widgets/flashcard_study_card.dart';
import '../widgets/flashcard_mode_bottom_bar.dart';
import '../widgets/flashcard_study_modes_modal.dart';
import '../widgets/flashcard_typing_view.dart';
import '../widgets/flashcard_quiz_view.dart';
import '../widgets/flashcard_listening_view.dart';
import '../widgets/flashcard_cloze_view.dart';
import '../widgets/flashcard_pronunciation_view.dart';
import '../widgets/flashcard_card_blast_view.dart';
import '../widgets/flashcard_settings_bottom_sheet.dart';

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
  FlashcardStudyMode _currentStudyMode = FlashcardStudyMode.flipCard;

  // Danh sách các chế độ bài tập tương tác dùng cho chế độ "Tổng hợp" (loại trừ flipCard và cardBlast)
  static const List<FlashcardStudyMode> _mixedEligibleModes = [
    FlashcardStudyMode.quiz,
    FlashcardStudyMode.typing,
    FlashcardStudyMode.listening,
    FlashcardStudyMode.cloze,
    FlashcardStudyMode.pronunciation,
  ];

  int _mixedModeOffset = 0;

  /// Lấy chế độ học thực tế cho từng thẻ. Ở chế độ mixed, mỗi thẻ có một dạng bài tập khác nhau.
  FlashcardStudyMode _getEffectiveStudyMode(int index) {
    if (_currentStudyMode != FlashcardStudyMode.mixed) {
      return _currentStudyMode;
    }
    if (_words.isEmpty || index < 0) {
      return FlashcardStudyMode.quiz;
    }
    final modeIndex = (index + _mixedModeOffset) % _mixedEligibleModes.length;
    return _mixedEligibleModes[modeIndex];
  }

  bool _isFrontVietnamese = false;
  bool _showIpa = true;
  bool _showExample = true;

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

    final prefs = await SharedPreferences.getInstance();
    final savedFrontVi = prefs.getBool('flashcard_front_vietnamese') ?? false;
    final savedShowIpa = prefs.getBool('flashcard_show_ipa') ?? true;
    final savedShowExample = prefs.getBool('flashcard_show_example') ?? true;

    if (!mounted) return;

    List<EduWord> initialWords = widget.customWords != null && widget.customWords!.isNotEmpty
        ? List<EduWord>.from(widget.customWords!)
        : List<EduWord>.from(list);

    final originalList = List<EduWord>.from(initialWords);

    final startIdx = (widget.startIndex >= 0 && widget.startIndex < initialWords.length)
        ? widget.startIndex
        : 0;

    setState(() {
      _originalDeckWords = originalList;
      _words = initialWords;
      _currentIndex = startIdx;
      _unmasteredWords.clear();
      _starredWordIds.clear();
      _starredWordIds.addAll(favIds);
      _isFrontVietnamese = savedFrontVi;
      _showIpa = savedShowIpa;
      _showExample = savedShowExample;
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
      _flipController.reset();
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

  void _recordWordResult(EduWord word, bool isMastered) {
    final targetDeckId = (word.customDeckId != null && word.customDeckId!.isNotEmpty)
        ? word.customDeckId!
        : (word.level.isNotEmpty ? word.level : widget.level);

    _progressService.updateCardAnswerGlobal(
      word.id,
      isMastered,
      targetDeckId: targetDeckId,
    );

    if (widget.level != targetDeckId && widget.level != 'SM2_REVIEW') {
      _progressService.updateCardAnswer(widget.level, word.id, isMastered);
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
      if (!_unmasteredWords.any((w) => w.id == word.id)) {
        _unmasteredWords.add(word);
      }
      _reviewCount++;
    } else {
      _unmasteredWords.removeWhere((w) => w.id == word.id);
      _masteredCount++;
    }
  }

  void _goToPreviousCard() {
    if (_currentIndex > 0) {
      _ttsService.stop();
      if (_isFlipped) {
        _flipController.reset();
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
        _flipController.reset();
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
      _mixedModeOffset = Random().nextInt(_mixedEligibleModes.length);
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
        backgroundColor: AppTheme.brandBackground,
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

    // Khi đang trong chế độ Card Blast: Hiển thị toàn màn hình không gian vũ trụ chuyên biệt
    if (_currentStudyMode == FlashcardStudyMode.cardBlast) {
      final currentWord = _words.isNotEmpty ? _words[_currentIndex] : null;
      return Scaffold(
        backgroundColor: const Color(0xFF070C1D),
        body: SafeArea(
          child: FlashcardCardBlastView(
            currentWord: currentWord,
            allWords: _words.isNotEmpty ? _words : _originalDeckWords,
            onWordResult: (word, isMastered) => _recordWordResult(word, isMastered),
            onAnswer: (correct) => _answerCard(correct),
            onSpeakWord: (title) => _playAudio(title),
            onSpeak: () => _playAudio(currentWord?.title ?? ''),
            onChangeMode: () {
              FlashcardStudyModesModal.show(
                context: context,
                currentMode: _currentStudyMode,
                onSelectMode: (mode) {
                  setState(() {
                    _currentStudyMode = mode;
                  });
                },
              );
            },
            onExit: () {
              setState(() {
                _currentStudyMode = FlashcardStudyMode.flipCard;
              });
            },
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

                  // Nút Trộn thẻ nhanh (Quick Shuffle Action)
                  IconButton(
                    icon: const Icon(Icons.shuffle_rounded, color: AppTheme.onSurface, size: 22),
                    tooltip: 'Trộn ngẫu nhiên thẻ',
                    onPressed: _shuffleCards,
                  ),
                  const SizedBox(width: 2),

                  // Nút Cài đặt toàn diện (Tune / Settings)
                  IconButton(
                    icon: const Icon(Icons.tune_rounded, color: AppTheme.onSurface, size: 22),
                    tooltip: 'Cài đặt học tập',
                    onPressed: () => _showStudySettingsBottomSheet(context),
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

  Future<void> _savePreference(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  void _shuffleCards() {
    if (_words.length <= 1) {
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Bộ thẻ cần ít nhất 2 từ để xáo trộn',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusSm)),
          ),
        );
      }
      return;
    }

    setState(() {
      _words.shuffle(Random());
      _currentIndex = 0;
      _mixedModeOffset = Random().nextInt(_mixedEligibleModes.length);
      if (_isFlipped) {
        _flipController.reset();
        _isFlipped = false;
      }
    });

    if (mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            '🔀 Đã trộn ngẫu nhiên thứ tự các thẻ học',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusSm)),
        ),
      );
    }
  }

  void _showStudySettingsBottomSheet(BuildContext context) {
    FlashcardSettingsBottomSheet.show(
      context,
      onShuffle: _shuffleCards,
      isFrontVietnamese: _isFrontVietnamese,
      onChangeFrontLanguage: (val) {
        setState(() {
          _isFrontVietnamese = val;
        });
        _savePreference('flashcard_front_vietnamese', val);
      },
      showIpa: _showIpa,
      onToggleShowIpa: (val) {
        setState(() {
          _showIpa = val;
        });
        _savePreference('flashcard_show_ipa', val);
      },
      showExample: _showExample,
      onToggleShowExample: (val) {
        setState(() {
          _showExample = val;
        });
        _savePreference('flashcard_show_example', val);
      },
      ttsService: _ttsService,
      onSampleSpeak: () {
        if (_words.isNotEmpty && _currentIndex < _words.length) {
          _playAudio(_words[_currentIndex].title);
        }
      },
    );
  }

  Widget _buildReviewContent(Color levelColor) {
    final currentWord = _words[_currentIndex];
    final isStarred = _starredWordIds.contains(currentWord.id);
    final total = _words.length;
    final effectiveMode = _getEffectiveStudyMode(_currentIndex);
    final isKeyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 50;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
      child: Column(
        children: [
          // 1. Thẻ học động theo chế độ đang chọn (có hiệu ứng chuyển cảnh mượt)
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.04, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: KeyedSubtree(
                key: ValueKey('${currentWord.id}_${_currentStudyMode.name}_${effectiveMode.name}'),
                child: _buildStudyModeContent(currentWord, isStarred, levelColor, effectiveMode),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // 2. Thao tác điều hướng & Đánh giá (chỉ dùng cho chế độ Lật thẻ SRS)
          if (effectiveMode == FlashcardStudyMode.flipCard) ...[
            // Row 1: Mũi tên trái, "Chưa nhớ" (Hồng/Đỏ), "Đã nhớ" (Tím), Mũi tên phải
            Row(
              children: [
                // Previous Arrow Button
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceContainerHigh.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm), // 8px
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
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm), // 8px
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEBEA), // Soft pinkish red
                        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
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
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm), // 8px
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppTheme.brandPrimary,
                        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
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
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm), // 8px
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_forward, color: AppTheme.onSurface, size: 20),
                    onPressed: _currentIndex + 1 < total ? _goToNextCard : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Row 2: SM-2 Spaced Repetition Interval Options (4 boxes bo 6px)
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
          ] else if (effectiveMode != FlashcardStudyMode.cardBlast) ...[
            // Thanh chuyển câu đơn giản cho các chế độ Quiz, Typing, Listening, Cloze
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton.icon(
                  onPressed: _currentIndex > 0 ? _goToPreviousCard : null,
                  icon: const Icon(Icons.arrow_back, size: 16),
                  label: const Text('Trước'),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                    ),
                  ),
                ),
                Text(
                  '${_currentIndex + 1} / $total',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.brandTextSecondary,
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: _currentIndex + 1 < total ? _goToNextCard : null,
                  icon: const Icon(Icons.arrow_forward, size: 16),
                  label: const Text('Sau'),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                    ),
                  ),
                ),
              ],
            ),
          ],

          // 3. Card cố định ở đáy: Chế độ luyện tập + Nút Đổi chế độ (Tự động ẩn khi mở bàn phím hoặc trong chế độ Card Blast)
          if (!isKeyboardOpen && effectiveMode != FlashcardStudyMode.cardBlast) ...[
            const SizedBox(height: 14),
            FlashcardModeBottomBar(
              currentMode: _currentStudyMode,
              currentSubMode: _currentStudyMode == FlashcardStudyMode.mixed ? effectiveMode : null,
              onChangeMode: () {
                FlashcardStudyModesModal.show(
                  context: context,
                  currentMode: _currentStudyMode,
                  onSelectMode: (mode) {
                    setState(() {
                      _currentStudyMode = mode;
                    });
                  },
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStudyModeContent(
    EduWord currentWord,
    bool isStarred,
    Color levelColor,
    FlashcardStudyMode mode,
  ) {
    switch (mode) {
      case FlashcardStudyMode.flipCard:
        return FlashcardStudyCard(
          word: currentWord,
          isStarred: isStarred,
          isFlipped: _isFlipped,
          flipAnimation: _flipAnimation,
          onFlip: _flipCard,
          onSpeak: () => _playAudio(currentWord.title),
          onToggleStar: () => _toggleStar(currentWord.id),
          levelBadgeText: '• Từ vựng - ${currentWord.level}',
          isFrontVietnamese: _isFrontVietnamese,
          showIpa: _showIpa,
          showExample: _showExample,
        );

      case FlashcardStudyMode.mixed:
        return _buildStudyModeContent(
          currentWord,
          isStarred,
          levelColor,
          _getEffectiveStudyMode(_currentIndex),
        );

      case FlashcardStudyMode.typing:
        return FlashcardTypingView(
          word: currentWord,
          onAnswer: (correct) => _answerCard(correct),
          onSpeak: () => _playAudio(currentWord.title),
        );

      case FlashcardStudyMode.quiz:
        return FlashcardQuizView(
          currentWord: currentWord,
          allWords: _words,
          onAnswer: (correct) => _answerCard(correct),
          onSpeak: () => _playAudio(currentWord.title),
        );

      case FlashcardStudyMode.listening:
        return FlashcardListeningView(
          word: currentWord,
          onAnswer: (correct) => _answerCard(correct),
          onPlayAudio: (rate) {
            _ttsService.setSpeechRate(rate);
            _playAudio(currentWord.title);
          },
        );

      case FlashcardStudyMode.cloze:
        return FlashcardClozeView(
          word: currentWord,
          onAnswer: (correct) => _answerCard(correct),
          onSpeak: () => _playAudio(currentWord.title),
        );

      case FlashcardStudyMode.pronunciation:
        return FlashcardPronunciationView(
          word: currentWord,
          onAnswer: (correct) => _answerCard(correct),
          onSpeak: () => _playAudio(currentWord.title),
        );

      case FlashcardStudyMode.cardBlast:
        return FlashcardCardBlastView(
          currentWord: currentWord,
          allWords: _words.isNotEmpty ? _words : _originalDeckWords,
          onWordResult: (word, isMastered) => _recordWordResult(word, isMastered),
          onAnswer: (correct) => _answerCard(correct),
          onSpeakWord: (title) => _playAudio(title),
          onSpeak: () => _playAudio(currentWord.title),
          onChangeMode: () {
            FlashcardStudyModesModal.show(
              context: context,
              currentMode: _currentStudyMode,
              onSelectMode: (mode) {
                setState(() {
                  _currentStudyMode = mode;
                });
              },
            );
          },
          onExit: () => context.pop(),
        );
    }
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

}

