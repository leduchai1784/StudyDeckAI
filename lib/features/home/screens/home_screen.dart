import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../../models/nks_user.dart';
import '../../../services/eduwords_service.dart';
import '../../../services/flashcard_progress_service.dart';
import '../../../services/roadmap_progress_service.dart';
import '../../../services/user_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserService _userService = UserService();
  final FlashcardProgressService _progressService = FlashcardProgressService();
  final RoadmapProgressService _roadmapService = RoadmapProgressService();
  final EduwordsService _eduwordsService = EduwordsService();

  NksUserModel? _user;
  int _streakDays = 1;
  RoadmapDailyGoalSummary? _roadmapSummary;
  FlashcardDueSummary? _dueSummary;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  Future<void> _fetchDashboardData() async {
    // 1. User Info from API
    try {
      final res = await _userService.getUserInfo();
      if (res['success'] == true) {
        final userMap = _userService.parseUserData(res);
        if (userMap != null) {
          _user = NksUserModel.fromJson(userMap);
        }
      }
    } catch (_) {}

    // 2. Real-time Streak from FlashcardProgressService
    try {
      final streak = await _progressService.getStreakDays();
      if (mounted) {
        setState(() => _streakDays = streak);
      }
    } catch (_) {}

    // 3. Roadmap Daily Goal Summary (Based on Onboarding Survey & Completed Lessons)
    try {
      final roadmap = await _roadmapService.getDailyGoalSummary();
      if (mounted) {
        setState(() => _roadmapSummary = roadmap);
      }
    } catch (_) {}

    // 4. Global SM-2 Due Flashcards Summary (Unmastered & Periodic Due Cards)
    try {
      final groupedWords = await _eduwordsService.fetchWordsByLevel();
      final due = await _progressService.getGlobalDueFlashcardsSummary(groupedWords: groupedWords);
      if (mounted) {
        setState(() => _dueSummary = due);
      }
    } catch (_) {}

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final String fullName = _user?.fullName ?? 'bạn';
    final String? avatarUrl = _user?.formattedAvatarUrl;

    return Scaffold(
      backgroundColor: AppTheme.brandBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar Header with Real User Name, Avatar & Live Streak
              _buildTopBarHeader(fullName, avatarUrl),
              const SizedBox(height: 18),

              // 1. Thẻ Mục Tiêu Hôm Nay (Theme Vuông 8px)
              _buildTodayGoalCard(),

              // 2. Thẻ Nhắc Nhở Ôn Tập SM-2 (Tự động ẩn khi đã ôn hết, chỉ hiện khi có thẻ đến hạn)
              if ((_dueSummary?.totalDueCount ?? 0) > 0) ...[
                const SizedBox(height: 12),
                _buildSpacedRepetitionAlertCard(),
              ],
              const SizedBox(height: 20),

              // 3. Khối Luyện Tập Kỹ Năng (2x2 Grid Theme Vuông 8px)
              _buildSkillPracticeSection(),
              const SizedBox(height: 20),

              // 4. Khối Lộ Trình Học AI Đề Xuất (Theme Vuông 8px)
              _buildAiRecommendedPathSection(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return 'CN';
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length == 1) {
      final single = parts.first;
      return single.length >= 2
          ? single.substring(0, 2).toUpperCase()
          : single.toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  // Header Top Bar
  Widget _buildTopBarHeader(String fullName, String? avatarUrl) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => context.push('/profile'),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppTheme.tintIndigoBg,
                  backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
                  child: avatarUrl == null
                      ? Text(
                          _getInitials(fullName),
                          style: const TextStyle(
                            color: AppTheme.tintIndigoText,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _isLoading ? 'Xin chào...' : 'Xin chào, $fullName! 👋',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.brandTextPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Mục tiêu Tiếng Anh AI',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.5,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Live Streak Badge (Theme vuông radius-xs 6px / radius-sm 8px theo design-system)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppTheme.brandAccentLight,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: AppTheme.brandAccent.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.local_fire_department_rounded, size: 16, color: AppTheme.brandAccent),
              const SizedBox(width: 4),
              Text(
                '$_streakDays Ngày',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.tintAmberText,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 1. Thẻ Mục Tiêu Hôm Nay (Động hoá theo Khảo sát Onboarding & Bài học Lộ trình)
  Widget _buildTodayGoalCard() {
    final summary = _roadmapSummary;
    final int completed = summary?.completedLessons ?? 0;
    final int target = summary?.targetLessons ?? 2;
    final double progress = summary?.progressPercent ?? 0.0;
    final bool isAchieved = completed >= target && target > 0;
    final String subtitle = isAchieved
        ? '🎉 Tuyệt vời! Bạn đã hoàn thành mục tiêu hôm nay. Chạm để học thêm bài mới!'
        : (summary?.subtitle ?? 'Còn 2 bài học lộ trình nữa để hoàn thành mục tiêu hôm nay!');
    final String nextRoute = summary?.nextLessonRoute ?? '/grammar/lesson';
    final String nextId = summary?.nextLessonId ?? 'grm_word_forms';

    return Container(
      decoration: BoxDecoration(
        gradient: isAchieved
            ? const LinearGradient(
                colors: [Color(0xFF059669), Color(0xFF10B981)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : const LinearGradient(
                colors: [Color(0xFF3525CD), Color(0xFF5B45E0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: isAchieved
                ? const Color(0xFF059669).withValues(alpha: 0.28)
                : const Color(0xFF3525CD).withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: () async {
            await context.push(nextRoute, extra: {'lessonId': nextId});
            _fetchDashboardData();
          },
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isAchieved ? Icons.emoji_events_rounded : Icons.flag_rounded,
                          color: isAchieved ? const Color(0xFFFDE047) : Colors.white,
                          size: 22,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Mục tiêu hôm nay',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                      decoration: BoxDecoration(
                        color: isAchieved
                            ? Colors.white.withValues(alpha: 0.28)
                            : Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isAchieved) ...[
                            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 12),
                            const SizedBox(width: 4),
                          ],
                          Text(
                            isAchieved
                                ? '✓ Đạt $completed/$target bài (100%)'
                                : '$completed / $target bài học',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 11.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: Colors.white.withValues(alpha: 0.25),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        subtitle,
                        style: TextStyle(
                          color: isAchieved ? const Color(0xFFECFDF5) : const Color(0xFFE0E7FF),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 12),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 2. Thẻ Nhắc Nhở Ôn Tập SM-2 (Động hoá: Thẻ chưa nhớ & Thẻ học lâu đến hạn)
  Widget _buildSpacedRepetitionAlertCard() {
    final summary = _dueSummary;
    final int totalDue = summary?.totalDueCount ?? 0;
    final int unmastered = summary?.unmasteredCount ?? 0;
    final int periodicDue = summary?.periodicDueCount ?? 0;
    final dueWords = summary?.dueWords ?? [];

    final bool hasCardsDue = totalDue > 0;
    if (!hasCardsDue) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE2E2EA),
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: hasCardsDue ? const Color(0xFFFAEEDA) : const Color(0xFFDCFCE7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              hasCardsDue ? Icons.alarm_rounded : Icons.verified_rounded,
              color: hasCardsDue ? const Color(0xFFB45309) : const Color(0xFF16A34A),
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasCardsDue
                      ? '$totalDue Thẻ Flashcard cần ôn tập ngay!'
                      : 'Trí nhớ đang ở trạng thái tối ưu! 🌟',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppTheme.brandTextPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  hasCardsDue
                      ? (unmastered > 0 && periodicDue > 0
                          ? 'Gồm $unmastered thẻ chưa nhớ & $periodicDue thẻ đến hạn ôn định kỳ theo SM-2.'
                          : (unmastered > 0
                              ? 'Gồm $unmastered thẻ chưa nhớ cần củng cố lại trí nhớ.'
                              : 'Gồm $periodicDue thẻ đến hạn ôn định kỳ theo chu kỳ SM-2.'))
                      : 'Tất cả thẻ đã ôn hoặc chưa có thẻ quên cần ôn gấp.',
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () async {
              if (hasCardsDue && dueWords.isNotEmpty) {
                await context.push('/flashcard-review', extra: {
                  'level': 'SM2_REVIEW',
                  'levelTitle': 'Ôn tập thông minh SM-2',
                  'mode': 'smart_review',
                  'customWords': dueWords,
                });
              } else {
                await context.push('/flashcards');
              }
              _fetchDashboardData();
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              backgroundColor: hasCardsDue ? AppTheme.brandPrimary : const Color(0xFF16A34A),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              hasCardsDue ? 'Ôn ngay' : 'Học từ mới',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 3. Khối Luyện Tập Kỹ Năng (2x2 Grid Pastel Tints chuẩn design-system.md)
  Widget _buildSkillPracticeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Luyện tập kỹ năng',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: AppTheme.brandTextPrimary,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildSkillCard(
                title: 'Listening',
                subtitle: '100+ đề',
                icon: Icons.headphones_rounded,
                bgColor: const Color(0xFFEFF6FF),
                iconColor: const Color(0xFF2563EB),
                titleColor: const Color(0xFF1E1B4B),
                subtitleColor: const Color(0xFF6B7280),
                onTap: () => context.push('/skill/listening'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildSkillCard(
                title: 'Reading',
                subtitle: '100+ đề',
                icon: Icons.menu_book_rounded,
                bgColor: const Color(0xFFECFDF5),
                iconColor: const Color(0xFF059669),
                titleColor: const Color(0xFF1E1B4B),
                subtitleColor: const Color(0xFF6B7280),
                onTap: () => context.push('/skill/reading'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildSkillCard(
                title: 'Speaking',
                subtitle: '100+ đề',
                icon: Icons.mic_none_rounded,
                bgColor: const Color(0xFFFFF7ED),
                iconColor: const Color(0xFFD97706),
                titleColor: const Color(0xFF1E1B4B),
                subtitleColor: const Color(0xFF6B7280),
                onTap: () => context.push('/skill/speaking'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildSkillCard(
                title: 'Writing',
                subtitle: '100+ đề',
                icon: Icons.edit_outlined,
                bgColor: const Color(0xFFEEF2FF),
                iconColor: const Color(0xFF4F46E5),
                titleColor: const Color(0xFF1E1B4B),
                subtitleColor: const Color(0xFF6B7280),
                onTap: () => context.push('/skill/writing'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSkillCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color bgColor,
    required Color iconColor,
    required Color titleColor,
    required Color subtitleColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: iconColor, size: 24),
                const SizedBox(height: 14),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: subtitleColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 4. Khối Lộ Trình Học AI Đề Xuất (Theme Vuông 8px, Kích Thước Bằng Nhau)
  Widget _buildAiRecommendedPathSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Lộ Trình Học AI Đề Xuất',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: AppTheme.brandTextPrimary,
          ),
        ),
        const SizedBox(height: 10),
        _buildAiPathCard(
          icon: Icons.menu_book_rounded,
          iconBg: const Color(0xFFE0F2FE),
          iconColor: const Color(0xFF0284C7),
          title: 'Kho Ngữ Pháp IELTS (25 Chủ Đề)',
          subtitle: 'Lý thuyết toàn tập & bài tập trắc nghiệm giải thích chi tiết theo chuẩn Cambridge.',
          onTap: () {
            context.go('/learning');
          },
        ),
        const SizedBox(height: 10),
        _buildAiPathCard(
          icon: Icons.layers_rounded,
          iconBg: const Color(0xFFEEEDFE),
          iconColor: AppTheme.brandPrimary,
          title: 'Bộ Thẻ Từ Vựng Flashcards',
          subtitle: 'Ôn tập 500+ từ vựng Giao tiếp & Business theo phương pháp lặp lại ngắt quãng.',
          onTap: () async {
            await context.push('/flashcards');
            _fetchDashboardData();
          },
        ),
        const SizedBox(height: 10),
        _buildAiPathCard(
          icon: Icons.smart_toy_rounded,
          iconBg: const Color(0xFFEAF2FE),
          iconColor: const Color(0xFF2563EB),
          title: 'Hệ Thống Trí Tuệ AI Tutor',
          subtitle: 'Chat và thực hành nói tiếng Anh 1-1 với trợ lý AI phân tích phát âm real-time.',
          onTap: () => context.push('/ai-tutor'),
        ),
        const SizedBox(height: 10),
        _buildAiPathCard(
          icon: Icons.description_rounded,
          iconBg: const Color(0xFFFDF1DD),
          iconColor: const Color(0xFFB45309),
          title: 'Trợ Lý RAG Hỏi Đáp Tài Liệu',
          subtitle: 'Tải lên PDF/tài liệu tiếng Anh để AI trích xuất từ vựng và tạo câu hỏi tự động.',
          onTap: () => context.push('/documents'),
        ),
      ],
    );
  }

  Widget _buildAiPathCard({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          height: 86,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppTheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E2EA)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(icon, color: iconColor, size: 22),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.brandTextPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF6B7280),
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
