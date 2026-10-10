import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../app/theme.dart';
import '../models/speaking_model.dart';
import '../data/speaking_forecast_repository.dart';
import 'speaking_practice_screen.dart';
import '../../../../shared/widgets/app_back_button.dart';

class SpeakingForecastScreen extends StatefulWidget {
  const SpeakingForecastScreen({super.key});

  @override
  State<SpeakingForecastScreen> createState() => _SpeakingForecastScreenState();
}

class _SpeakingForecastScreenState extends State<SpeakingForecastScreen> {
  final String _selectedQuarter = 'Q3-2026';

  // Part filter: 'compulsory' (2), 'part1_topic' (44), 'part2_3' (66)
  String _selectedPartFilter = 'compulsory';

  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  List<SpeakingTopic> _topics = [];
  bool _isLoading = true;

  // Set lưu trữ các topic ID đang mở rộng (Accordion)
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
      final loaded = SpeakingForecastRepository.getAllTopics();
      setState(() {
        _topics = loaded;
        _isLoading = false;
        // Mặc định mở rộng chủ đề bắt buộc đầu tiên để người dùng thấy ngay câu hỏi
        final firstCompulsory = loaded.where((t) => t.isCompulsory && t.partNumber == 1).firstOrNull;
        if (firstCompulsory != null) {
          _expandedTopicIds.add(firstCompulsory.id);
        }
      });
    }
  }

  /// Lọc danh sách theo Quý và Part Filter
  List<SpeakingTopic> _getQuarterAndPartTopics(List<SpeakingTopic> allTopics) {
    // 1. Quý
    var list = allTopics.where((t) => t.quarter == _selectedQuarter).toList();

    // 2. Part
    switch (_selectedPartFilter) {
      case 'compulsory':
        return list.where((t) => t.isCompulsory && t.partNumber == 1).toList();
      case 'part1_topic':
        return list.where((t) => t.partNumber == 1 && !t.id.contains('compulsory')).toList();
      case 'part2_3':
        return list.where((t) => t.partNumber == 2).toList();
      case 'all':
      default:
        return list;
    }
  }



  void _copyTopicQuestions(SpeakingTopic topic) {
    final buffer = StringBuffer();
    buffer.writeln('${topic.title} (${topic.titleVi})');
    buffer.writeln('---------------------------');
    for (int i = 0; i < topic.questions.length; i++) {
      final q = topic.questions[i];
      if (q.cueCardPrompts != null && q.cueCardPrompts!.isNotEmpty) {
        buffer.writeln('Part 2 Cue Card: ${q.questionText}');
        buffer.writeln('You should say:');
        for (final p in q.cueCardPrompts!) {
          buffer.writeln('  • $p');
        }
      } else {
        buffer.writeln('Q${i + 1}. ${q.questionText}');
      }
    }

    Clipboard.setData(ClipboardData(text: buffer.toString()));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã sao chép câu hỏi chủ đề "${topic.title}" vào bộ nhớ tạm'),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF1E293B),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _startMockExam() {
    final allTopics = _topics.isNotEmpty ? _topics : SpeakingForecastRepository.getAllTopics();
    final random = Random();

    // Bốc 1 chủ đề Part 1 bắt buộc
    final compTopics = allTopics.where((t) => t.isCompulsory && t.partNumber == 1).toList();
    final compTopic = compTopics.isNotEmpty ? compTopics[random.nextInt(compTopics.length)] : null;

    // Bốc 1 chủ đề Part 1 ngẫu nhiên
    final p1Topics = allTopics.where((t) => t.partNumber == 1 && !t.id.contains('compulsory')).toList();
    final p1Topic = p1Topics.isNotEmpty ? p1Topics[random.nextInt(p1Topics.length)] : null;

    // Bốc 1 chủ đề Part 2+3 ngẫu nhiên
    final p2Topics = allTopics.where((t) => t.partNumber == 2).toList();
    final p2Topic = p2Topics.isNotEmpty ? p2Topics[random.nextInt(p2Topics.length)] : null;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEE2E2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text('🔥', style: TextStyle(fontSize: 22)),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'THI THẬT CỰC CĂNG (Mock Exam)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFDC2626),
                          ),
                        ),
                        Text(
                          'Mô phỏng 100% phòng thi IELTS thực tế với Giám khảo AI',
                          style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    _buildMockItemRow(
                      icon: '📌',
                      part: 'Part 1 Bắt buộc',
                      topicName: compTopic?.title ?? 'Where you live now',
                      count: '3 câu',
                    ),
                    const Divider(height: 12, color: Color(0xFFE2E8F0)),
                    _buildMockItemRow(
                      icon: '🎲',
                      part: 'Part 1 Chủ đề',
                      topicName: p1Topic?.title ?? 'Technology & Gadgets',
                      count: '3 câu',
                    ),
                    const Divider(height: 12, color: Color(0xFFE2E8F0)),
                    _buildMockItemRow(
                      icon: '🎯',
                      part: 'Part 2 & 3',
                      topicName: p2Topic?.title ?? 'Describe a person you met',
                      count: 'Cue Card + 3 câu thảo luận',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  // Lắp ráp bài thi Mock Exam
                  final mockQuestions = <SpeakingQuestion>[];
                  if (compTopic != null) {
                    mockQuestions.addAll(compTopic.questions.take(3));
                  }
                  if (p1Topic != null) {
                    mockQuestions.addAll(p1Topic.questions.take(3));
                  }
                  if (p2Topic != null) {
                    mockQuestions.addAll(p2Topic.questions.take(4));
                  }

                  final examTopic = SpeakingTopic(
                    id: 'ielts_mock_exam_${DateTime.now().millisecondsSinceEpoch}',
                    quarter: _selectedQuarter,
                    title: 'IELTS Real Mock Exam (${p2Topic?.title ?? "General"})',
                    titleVi: 'Bài thi thử mô phỏng phòng thi thật IELTS',
                    categoryTag: 'daily_life',
                    bandTarget: 'Band 0 - 9.0',
                    tagLabel: 'MOCK EXAM THI THẬT',
                    partNumber: 2,
                    isCompulsory: true,
                    questions: mockQuestions,
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SpeakingPracticeScreen(
                        topic: examTopic,
                        initialQuestionIndex: 0,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.record_voice_over_rounded, color: Colors.white, size: 18),
                label: const Text(
                  'BƯỚC VÀO PHÒNG THI NGAY',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDC2626),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMockItemRow({
    required String icon,
    required String part,
    required String topicName,
    required String count,
  }) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 14)),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(part, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
              Text(
                topicName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFFE2E8F0),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            count,
            style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final allTopics = _topics.isNotEmpty ? _topics : SpeakingForecastRepository.getAllTopics();

    // 1. Quý topics
    final quarterAllTopics = allTopics.where((t) => t.quarter == _selectedQuarter).toList();

    // 2. Part topics
    final baseTopics = _getQuarterAndPartTopics(allTopics);

    // 3. Search Filter
    var displayed = baseTopics;
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      displayed = displayed.where((t) {
        return t.title.toLowerCase().contains(q) ||
            t.titleVi.toLowerCase().contains(q) ||
            t.questions.any((item) => item.questionText.toLowerCase().contains(q));
      }).toList();
    }

    // Đếm số lượng topic theo từng Part trong Quý
    final countCompulsory = quarterAllTopics.where((t) => t.isCompulsory && t.partNumber == 1).length;
    final countPart1 = quarterAllTopics.where((t) => t.partNumber == 1 && !t.id.contains('compulsory')).length;
    final countPart23 = quarterAllTopics.where((t) => t.partNumber == 2).length;

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
              'Forecast Speaking 2026',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.brandTextPrimary,
              ),
            ),
            Text(
              'Bộ đề dự đoán thi thật theieltsdictionary',
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


                  // 2. Part Filter Bar (Phong cách theieltsdictionary.com/practice/speaking/forecast)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        // PART 1 BẮT BUỘC (2)
                        _buildPartFilterButton(
                          key: 'compulsory',
                          label: 'PART 1 BẮT BUỘC ($countCompulsory)',
                          activeBgColor: const Color(0xFFFBBF24), // Màu vàng nổi bật như ảnh
                          activeTextColor: const Color(0xFF1E293B),
                          activeBorderColor: const Color(0xFFD97706),
                        ),
                        const SizedBox(width: 8),

                        // PART 1 CHỦ ĐỀ (44)
                        _buildPartFilterButton(
                          key: 'part1_topic',
                          label: 'PART 1 CHỦ ĐỀ ($countPart1)',
                          activeBgColor: AppTheme.brandPrimary,
                          activeTextColor: Colors.white,
                          activeBorderColor: AppTheme.brandPrimary,
                        ),
                        const SizedBox(width: 8),

                        // PART 2 + 3 (66)
                        _buildPartFilterButton(
                          key: 'part2_3',
                          label: 'PART 2 + 3 ($countPart23)',
                          activeBgColor: const Color(0xFF7C3AED),
                          activeTextColor: Colors.white,
                          activeBorderColor: const Color(0xFF6D28D9),
                        ),
                        const SizedBox(width: 8),



                        // Nút THI THẬT CỰC CĂNG (Đỏ cam nổi bật như ảnh)
                        InkWell(
                          onTap: _startMockExam,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                              ),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: const Color(0xFFB91C1C), width: 1.5),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFDC2626).withValues(alpha: 0.3),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('🔥 ', style: TextStyle(fontSize: 13)),
                                Text(
                                  'THI THẬT CỰC CĂNG',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 3. Search Bar
                  TextField(
                    controller: _searchController,
                    onChanged: (val) => setState(() => _searchQuery = val.trim()),
                    decoration: InputDecoration(
                      hintText: 'Tìm chủ đề hoặc câu hỏi (Where you live, Routine, Music...)...',
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
                        borderSide: const BorderSide(color: AppTheme.brandPrimary, width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),



                  // 5. Header Kết Quả
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Danh sách chủ đề (${displayed.length})',
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
                            'Đặt lại bộ lọc',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.brandPrimary,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // 6. Danh Sách Topic Cards
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
                            _searchQuery.isNotEmpty
                                ? 'Không tìm thấy chủ đề nào cho "$_searchQuery"'
                                : 'Chưa có chủ đề nào trong bộ lọc này',
                            style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          TextButton.icon(
                            onPressed: () {
                              setState(() {
                                _searchQuery = '';
                                _searchController.clear();
                              });
                            },
                            icon: const Icon(Icons.refresh_rounded, size: 16),
                            label: const Text('Xóa từ khóa tìm kiếm'),
                          ),
                        ],
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: displayed.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final topic = displayed[index];
                        final isExpanded = _expandedTopicIds.contains(topic.id);
                        return _buildTopicCard(topic, index, isExpanded);
                      },
                    ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }


  Widget _buildPartFilterButton({
    required String key,
    required String label,
    required Color activeBgColor,
    required Color activeTextColor,
    required Color activeBorderColor,
  }) {
    final isSelected = _selectedPartFilter == key;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedPartFilter = key;
        });
      },
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? activeBgColor : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? activeBorderColor : const Color(0xFFCBD5E1),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: activeBgColor.withValues(alpha: 0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: isSelected ? activeTextColor : const Color(0xFF334155),
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }

  /// Card Chủ Đề theo thiết kế The IELTS Dictionary (Header gọn gàng + Accordion xem câu hỏi)
  Widget _buildTopicCard(SpeakingTopic topic, int index, bool isExpanded) {
    final category = topic.category;
    final isCompulsory = topic.isCompulsory && topic.partNumber == 1;
    final isPart23 = topic.partNumber == 2;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isCompulsory ? const Color(0xFFFCD34D) : const Color(0xFFE2E8F0),
          width: isCompulsory ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header Card (Chứa Tiêu đề + Nút Luyện Tập + Nút Copy + Chevron toggle)
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hàng Badges trên cùng
                Row(
                  children: [
                    // Badge Part
                    if (isCompulsory) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFFFDE68A)),
                        ),
                        child: const Text(
                          '📌 BẮT BUỘC THI',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFFB45309),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                    ] else if (isPart23) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDE9FE),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFFDDD6FE)),
                        ),
                        child: const Text(
                          '🎯 PART 2 & 3',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF6D28D9),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                    ] else ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'PART 1 CHỦ ĐỀ',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF475569),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                    ],

                    // Badge Nhóm Ngữ Nghĩa
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: category.badgeBg,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(category.icon, style: const TextStyle(fontSize: 10.5)),
                          const SizedBox(width: 3.5),
                          Text(
                            category.shortLabel,
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.bold,
                              color: category.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    // Số lượng câu
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Text(
                        isPart23
                            ? 'Cue Card + ${topic.questions.length - 1} p3'
                            : '${topic.questions.length} câu',
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

                // Tiêu đề & Nút thao tác
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tiêu đề tiếng Anh & tiếng Việt
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

                    // Cụm nút thao tác (Luyện tập, Copy, Expand)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Nút ▶ Luyện tập (Phong cách vàng như theieltsdictionary)
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

                        // Nút Copy
                        IconButton(
                          icon: const Icon(Icons.copy_rounded, size: 16, color: Color(0xFF64748B)),
                          tooltip: 'Sao chép câu hỏi',
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(6),
                          onPressed: () => _copyTopicQuestions(topic),
                        ),

                        // Nút Toggle Accordion
                        IconButton(
                          icon: Icon(
                            isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                            size: 20,
                            color: const Color(0xFF475569),
                          ),
                          tooltip: isExpanded ? 'Thu gọn' : 'Xem câu hỏi',
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

          // 2. Nội dung mở rộng Accordion (Danh sách câu hỏi với chữ Q. màu cam)
          if (isExpanded) ...[
            const Divider(height: 1, color: Color(0xFFF1F5F9)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              color: const Color(0xFFFAFAFA),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // NẾU LÀ PART 2 & 3: Hiển thị hộp vàng Cue Card "You should say:"
                  if (isPart23) ...[
                    _buildCueCardBox(topic),
                    const SizedBox(height: 12),
                    // Tiêu đề câu hỏi Part 3
                    Row(
                      children: [
                        const Icon(Icons.forum_outlined, size: 14, color: Color(0xFF6D28D9)),
                        const SizedBox(width: 5),
                        Text(
                          'Part 3 Follow-up Questions (${topic.questions.length - 1}):',
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF475569),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],

                  // Danh sách câu hỏi (Part 1 hoặc Part 3 questions)
                  ..._buildQuestionItems(topic, isPart23),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Khung hiển thị Part 2 Cue Card (Phong cách The IELTS Dictionary)
  Widget _buildCueCardBox(SpeakingTopic topic) {
    final cueQ = topic.questions.firstWhere(
      (q) => q.part == SpeakingPart.part2,
      orElse: () => topic.questions.first,
    );
    final prompts = cueQ.cueCardPrompts ?? [];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB), // Vàng kem nhạt
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
                'Thời gian chuẩn bị: 1 phút • Trình bày: 2 phút',
                style: TextStyle(fontSize: 11, color: Color(0xFF78350F)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            cueQ.questionText,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFF78350F),
            ),
          ),
          if (prompts.isNotEmpty) ...[
            const SizedBox(height: 8),
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
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
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
              icon: const Icon(Icons.mic_rounded, size: 13, color: Color(0xFFB45309)),
              label: const Text(
                'Luyện bài nói Cue Card này',
                style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFFB45309)),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Danh sách các câu hỏi hiển thị dạng: Q. [Nội dung câu hỏi] với tiền tố Q. màu cam
  List<Widget> _buildQuestionItems(SpeakingTopic topic, bool isPart23) {
    // Nếu là Part 2 & 3, chỉ lấy các câu Part 3
    final questionsToShow = isPart23
        ? topic.questions.where((q) => q.part == SpeakingPart.part3).toList()
        : topic.questions;

    return questionsToShow.map((q) {
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
                // Tiền tố Q. màu cam nổi bật đúng như The IELTS Dictionary
                const Text(
                  'Q. ',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFEA580C), // Cam đậm
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
    }).toList();
  }
}
