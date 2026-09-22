import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../../models/edu_word.dart';
import '../../../models/user_deck_progress.dart';
import '../../../services/eduwords_service.dart';
import '../../../services/flashcard_progress_service.dart';

class DeckDetailScreen extends StatefulWidget {
  final String deckId;
  final String deckTitle;

  const DeckDetailScreen({
    super.key,
    required this.deckId,
    required this.deckTitle,
  });

  @override
  State<DeckDetailScreen> createState() => _DeckDetailScreenState();
}

class _DeckDetailScreenState extends State<DeckDetailScreen> {
  final EduwordsService _eduwordsService = EduwordsService();
  final FlashcardProgressService _progressService = FlashcardProgressService();

  bool _isLoading = true;
  List<EduWord> _allWords = [];
  UserDeckProgress? _progress;
  List<QuizSession> _quizSessions = [];

  @override
  void initState() {
    super.initState();
    _loadDeckData();
  }

  Future<void> _loadDeckData() async {
    setState(() => _isLoading = true);

    final upperKey = widget.deckId.toUpperCase();
    final grouped = await _eduwordsService.fetchWordsByLevel();
    final words = grouped[upperKey] ?? [];

    final progress = await _progressService.getDeckProgress(upperKey);
    final quizSessions = await _progressService.getQuizSessions(upperKey);

    if (mounted) {
      setState(() {
        _allWords = words;
        _progress = progress;
        _quizSessions = quizSessions;
        _isLoading = false;
      });
    }
  }

  void _startReviewAll() {
    final upperKey = widget.deckId.toUpperCase();
    context.push(
      '/flashcard-review',
      extra: {
        'level': upperKey,
        'levelTitle': '${widget.deckTitle} (Ôn lại toàn bộ)',
        'mode': 'review_all',
        'customWords': _allWords,
      },
    ).then((_) => _loadDeckData());
  }

  void _startQuiz() {
    final upperKey = widget.deckId.toUpperCase();
    context.push(
      '/deck-quiz',
      extra: {
        'deckId': upperKey,
        'deckTitle': widget.deckTitle,
      },
    ).then((_) => _loadDeckData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.brandBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.brandSurface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.brandTextPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          widget.deckTitle,
          style: const TextStyle(
            color: AppTheme.brandTextPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppTheme.brandTextMuted),
            onPressed: _loadDeckData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Completion Header Card
                    _buildCompletionHeaderCard(),
                    const SizedBox(height: 18),

                    // 2. Quick Stats Grid
                    _buildStatsRow(),
                    const SizedBox(height: 22),

                    // 3. Title Section
                    const Text(
                      'LỰA CHỌN ÔN TẬP & LUYỆN TẬP',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.brandTextSecondary,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Thẻ 1: Ôn lại toàn bộ
                    _buildActionCard(
                      icon: Icons.sync_rounded,
                      iconColor: AppTheme.brandPrimary,
                      badgeTag: 'Tất cả thẻ',
                      badgeColor: AppTheme.chipIndigoBg,
                      badgeTextColor: AppTheme.brandPrimary,
                      title: 'Ôn lại toàn bộ',
                      subtitle:
                          'Luyện tập lại tất cả ${_allWords.length} flashcard từ đầu. Tiến độ 100% của bộ thẻ vẫn được bảo toàn.',
                      extraInfo: '${_allWords.length} thẻ flashcard',
                      onTap: _startReviewAll,
                    ),
                    const SizedBox(height: 12),

                    // Thẻ 2: Làm bài kiểm tra
                    _buildActionCard(
                      icon: Icons.quiz_outlined,
                      iconColor: const Color(0xFF0D9488),
                      badgeTag: 'Trắc nghiệm',
                      badgeColor: const Color(0xFFCCFBF1),
                      badgeTextColor: const Color(0xFF0F766E),
                      title: 'Làm bài kiểm tra',
                      subtitle:
                          'Thử thách trí nhớ với 10-20 câu hỏi trắc nghiệm nhanh, chấm điểm và đánh giá mức độ ghi nhớ.',
                      extraInfo: _quizSessions.isNotEmpty
                          ? 'Điểm cao nhất: ${_quizSessions.map((e) => e.score).reduce((a, b) => a > b ? a : b).toInt()}/100'
                          : 'Chưa có bài kiểm tra nào',
                      onTap: _startQuiz,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
    );
  }

  // 1. Header Card with Completion Badge
  Widget _buildCompletionHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.brandSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.brandBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Green Check Circle
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppTheme.tintGreenBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AppTheme.brandSuccess,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppTheme.tintGreenBg,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            '✓ ĐÃ HOÀN THÀNH',
                            style: TextStyle(
                              color: AppTheme.tintGreenText,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Bạn đã hoàn thành 100% bộ thẻ này!',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.brandTextPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: AppTheme.brandBorder),
          const SizedBox(height: 12),
          const Text(
            'Học tập ngắt quãng (Spaced Repetition) sẽ giúp lưu giữ từ vựng vào trí nhớ dài hạn. Hãy chọn chế độ ôn tập phù hợp bên dưới.',
            style: TextStyle(
              fontSize: 12.5,
              color: AppTheme.brandTextSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // 2. Quick stats row
  Widget _buildStatsRow() {
    final totalCards = _allWords.length;
    final reviewCount = _progress?.reviewCount ?? 0;
    final lastScore = _quizSessions.isNotEmpty ? '${_quizSessions.first.score.toInt()}%' : '--';

    return Row(
      children: [
        Expanded(
          child: _buildMiniStat(
            title: 'Tổng số thẻ',
            value: '$totalCards',
            icon: Icons.layers_outlined,
            iconColor: AppTheme.brandPrimary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildMiniStat(
            title: 'Tiến độ',
            value: '100%',
            icon: Icons.verified_outlined,
            iconColor: AppTheme.brandSuccess,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildMiniStat(
            title: 'Lần ôn tập',
            value: '$reviewCount lần',
            icon: Icons.repeat_rounded,
            iconColor: AppTheme.tintIndigoText,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildMiniStat(
            title: 'Điểm test',
            value: lastScore,
            icon: Icons.analytics_outlined,
            iconColor: AppTheme.tintAmberText,
          ),
        ),
      ],
    );
  }

  Widget _buildMiniStat({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: AppTheme.brandSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.brandBorder),
      ),
      child: Column(
        children: [
          Icon(icon, size: 18, color: iconColor),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppTheme.brandTextPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 10,
              color: AppTheme.brandTextMuted,
            ),
          ),
        ],
      ),
    );
  }

  // 3. Action Card Builder (Direct Click)
  Widget _buildActionCard({
    required IconData icon,
    required Color iconColor,
    required String badgeTag,
    required Color badgeColor,
    required Color badgeTextColor,
    required String title,
    required String subtitle,
    required String extraInfo,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.brandSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.brandBorder,
              width: 1.0,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon in box
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 14),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title + Tag Badge Row
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.brandTextPrimary,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: badgeColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            badgeTag,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: badgeTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: AppTheme.brandTextSecondary,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.info_outline, size: 13, color: AppTheme.brandTextMuted),
                        const SizedBox(width: 4),
                        Text(
                          extraInfo,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.brandTextMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // Forward Arrow Button
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 13,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
