import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../app/theme.dart';
import '../models/speaking_model.dart';
import '../data/speaking_forecast_repository.dart';
import 'speaking_practice_screen.dart';
import '../../../../shared/widgets/app_back_button.dart';

class SpeakingPart23Screen extends StatefulWidget {
  const SpeakingPart23Screen({super.key});

  @override
  State<SpeakingPart23Screen> createState() => _SpeakingPart23ScreenState();
}

class _SpeakingPart23ScreenState extends State<SpeakingPart23Screen> {
  final String _selectedQuarter = 'Q3-2026';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  List<SpeakingTopic> _topics = [];
  bool _isLoading = true;
  final Set<String> _expandedTopicIds = {};

  @override
  void initState() {
    super.initState();
    _loadTopics();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadTopics() async {
    await SpeakingForecastRepository.ensureLoaded();
    if (mounted) {
      final loaded = SpeakingForecastRepository.getAllTopics()
          .where((t) => t.partNumber == 2)
          .toList();
      setState(() {
        _topics = loaded;
        _isLoading = false;
        if (loaded.isNotEmpty) {
          _expandedTopicIds.add(loaded.first.id);
        }
      });
    }
  }

  void _copyTopicData(SpeakingTopic topic) {
    final cueQ = topic.questions.firstWhere(
      (q) => q.part == SpeakingPart.part2,
      orElse: () => topic.questions.first,
    );
    final p3Questions = topic.questions.where((q) => q.part == SpeakingPart.part3).toList();

    final buffer = StringBuffer();
    buffer.writeln('PART 2 CUE CARD: ${topic.title}');
    buffer.writeln('Dịch nghĩa: ${topic.titleVi}');
    buffer.writeln('---------------------------');
    buffer.writeln('You should say:');
    if (cueQ.cueCardPrompts != null) {
      for (final p in cueQ.cueCardPrompts!) {
        buffer.writeln('  • $p');
      }
    }
    if (p3Questions.isNotEmpty) {
      buffer.writeln('\nPART 3 QUESTIONS:');
      for (int i = 0; i < p3Questions.length; i++) {
        buffer.writeln('Q${i + 1}. ${p3Questions[i].questionText}');
      }
    }

    Clipboard.setData(ClipboardData(text: buffer.toString()));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã sao chép chủ đề Part 2+3 "${topic.title}" vào bộ nhớ tạm'),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF1E293B),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allP23Topics = _topics.isNotEmpty
        ? _topics
        : SpeakingForecastRepository.getAllTopics().where((t) => t.partNumber == 2).toList();

    // 1. Quý
    var displayed = allP23Topics.where((t) => t.quarter == _selectedQuarter).toList();

    // 2. Search
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      displayed = displayed.where((t) {
        return t.title.toLowerCase().contains(q) ||
            t.titleVi.toLowerCase().contains(q) ||
            t.questions.any((item) =>
                item.questionText.toLowerCase().contains(q) ||
                (item.cueCardPrompts ?? []).any((p) => p.toLowerCase().contains(q)));
      }).toList();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: const AppBackButton(),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Part 3: Thuyết Trình & Thảo Luận',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.brandTextPrimary,
              ),
            ),
            Text(
              '66 đề Cue Card độc thoại 2p & câu hỏi Part 3',
              style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
            ),
          ],
        ),
      ),
      body: _isLoading && _topics.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [


                  // 2. Search Bar
                  TextField(
                    controller: _searchController,
                    onChanged: (val) => setState(() => _searchQuery = val.trim()),
                    decoration: InputDecoration(
                      hintText: 'Tìm đề Part 2+3 (Describe a person, gift, movie...)...',
                      hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                      prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF94A3B8), size: 20),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.close_rounded, size: 18, color: Color(0xFF94A3B8)),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                      filled: true,
                      fillColor: Colors.white,
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF7C3AED), width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 3. Kết Quả Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Danh sách 66 chủ đề (${displayed.length})',
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.brandTextSecondary,
                        ),
                      ),
                      if (_searchQuery.isNotEmpty)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _searchQuery = '';
                              _searchController.clear();
                            });
                          },
                          child: const Text(
                            'Xóa tìm kiếm',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF7C3AED),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // 4. Danh Sách Topic Cards
                  if (displayed.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(36),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.search_off_rounded, size: 44, color: Color(0xFF94A3B8)),
                          const SizedBox(height: 10),
                          Text(
                            'Không tìm thấy chủ đề nào cho "$_searchQuery"',
                            style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: displayed.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final topic = displayed[index];
                        final isExpanded = _expandedTopicIds.contains(topic.id);
                        return _buildTopicCard(topic, isExpanded);
                      },
                    ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }



  Widget _buildTopicCard(SpeakingTopic topic, bool isExpanded) {
    final cueQ = topic.questions.firstWhere(
      (q) => q.part == SpeakingPart.part2,
      orElse: () => topic.questions.first,
    );
    final prompts = cueQ.cueCardPrompts ?? [];
    final p3Questions = topic.questions.where((q) => q.part == SpeakingPart.part3).toList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFDDD6FE)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C3AED).withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Badges
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDE9FE),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'PART 2 + 3',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF6D28D9),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Text(
                        'Cue Card + ${p3Questions.length} câu Part 3',
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF475569),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Title & Action Buttons
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            topic.title,
                            style: const TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0F172A),
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            topic.titleVi,
                            style: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SpeakingPracticeScreen(
                                  topic: topic,
                                  initialQuestionIndex: 0,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.play_arrow_rounded, size: 14, color: Color(0xFF1E293B)),
                          label: const Text(
                            'Luyện tập',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFBBF24),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(color: Color(0xFFD97706), width: 1),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        IconButton(
                          icon: const Icon(Icons.copy_rounded, size: 16, color: Color(0xFF64748B)),
                          tooltip: 'Sao chép nội dung',
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(6),
                          onPressed: () => _copyTopicData(topic),
                        ),
                        IconButton(
                          icon: Icon(
                            isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                            size: 20,
                            color: const Color(0xFF475569),
                          ),
                          tooltip: isExpanded ? 'Thu gọn' : 'Xem chi tiết',
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(6),
                          onPressed: () {
                            setState(() {
                              if (isExpanded) {
                                _expandedTopicIds.remove(topic.id);
                              } else {
                                _expandedTopicIds.add(topic.id);
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Content Accordion: Cue Card Box + Part 3 Questions
          if (isExpanded) ...[
            const Divider(height: 1, color: Color(0xFFF1F5F9)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              color: const Color(0xFFFAFAFA),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hộp Cue Card You should say
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFBEB),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFFDE68A)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFB45309),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'PART 2 CUE CARD',
                                style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'Chuẩn bị: 1 phút • Trình bày: 2 phút',
                              style: TextStyle(fontSize: 11, color: Color(0xFF78350F)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (prompts.isNotEmpty) ...[
                          const Text(
                            'You should say:',
                            style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF92400E)),
                          ),
                          const SizedBox(height: 4),
                          ...prompts.map(
                            (p) => Padding(
                              padding: const EdgeInsets.only(bottom: 3),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('• ', style: TextStyle(color: Color(0xFFB45309), fontWeight: FontWeight.bold)),
                                  Expanded(
                                    child: Text(
                                      p,
                                      style: const TextStyle(fontSize: 12, color: Color(0xFF78350F), height: 1.3),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Part 3 Questions
                  if (p3Questions.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        const Icon(Icons.forum_outlined, size: 14, color: Color(0xFF6D28D9)),
                        const SizedBox(width: 5),
                        Text(
                          'Part 3 Follow-up Questions (${p3Questions.length}):',
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF475569),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...p3Questions.map((q) {
                      final originalIndex = topic.questions.indexOf(q);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SpeakingPracticeScreen(
                                  topic: topic,
                                  initialQuestionIndex: originalIndex >= 0 ? originalIndex : 0,
                                ),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Q. ',
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFEA580C),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    q.questionText,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF1E293B),
                                      height: 1.35,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Icon(
                                  Icons.mic_none_rounded,
                                  size: 15,
                                  color: Color(0xFF94A3B8),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
