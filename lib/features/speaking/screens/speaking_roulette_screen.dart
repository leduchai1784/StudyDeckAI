import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import '../../../../services/tts_service.dart';
import '../models/speaking_model.dart';
import '../data/speaking_mock_data.dart';
import 'speaking_practice_screen.dart';

class SpeakingRouletteScreen extends StatefulWidget {
  const SpeakingRouletteScreen({super.key});

  @override
  State<SpeakingRouletteScreen> createState() => _SpeakingRouletteScreenState();
}

class _SpeakingRouletteScreenState extends State<SpeakingRouletteScreen> {
  int _selectedPartIndex = 0; // 0: All, 1: Part 1, 2: Part 2, 3: Part 3
  late SpeakingRouletteCard _currentCard;
  bool _showSampleAnswer = false;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _currentCard = SpeakingMockData.rouletteCards.first;
  }

  void _spinTheDeck() {
    const allCards = SpeakingMockData.rouletteCards;
    List<SpeakingRouletteCard> pool = allCards;

    if (_selectedPartIndex == 1) {
      pool = allCards.where((c) => c.part == SpeakingPart.part1).toList();
    } else if (_selectedPartIndex == 2) {
      pool = allCards.where((c) => c.part == SpeakingPart.part2).toList();
    } else if (_selectedPartIndex == 3) {
      pool = allCards.where((c) => c.part == SpeakingPart.part3).toList();
    }

    if (pool.isEmpty) pool = allCards;

    // Pick random card different from current if possible
    SpeakingRouletteCard nextCard;
    if (pool.length > 1) {
      do {
        nextCard = pool[_random.nextInt(pool.length)];
      } while (nextCard.id == _currentCard.id);
    } else {
      nextCard = pool.first;
    }

    setState(() {
      _currentCard = nextCard;
      _showSampleAnswer = false;
    });
  }

  void _showVocabDetail(SpeakingVocabItem vocab) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFEEF2FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.menu_book_rounded, color: AppTheme.brandPrimary, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vocab.word,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                  ),
                  Text(
                    '${vocab.ipa} • ${vocab.type}',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.volume_up_rounded, color: AppTheme.brandPrimary),
              onPressed: () => TtsService().speak(vocab.word),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Nghĩa tiếng Việt:', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
            const SizedBox(height: 3),
            Text(
              vocab.meaning,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 12),
            const Text('Ví dụ ngữ cảnh IELTS:', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
            const SizedBox(height: 3),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Text(
                vocab.example,
                style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic, color: Color(0xFF334155), height: 1.35),
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.brandPrimary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Đã hiểu'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.brandBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppTheme.brandTextPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Speaking Roulette',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.brandTextPrimary,
              ),
            ),
            Text(
              'Bốc thẻ ngẫu nhiên & phản xạ',
              style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.casino_rounded, color: AppTheme.brandPrimary),
            tooltip: 'Bốc thẻ khác',
            onPressed: _spinTheDeck,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Part Selector Tabs
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  _buildPartTab('Tất cả', 0),
                  _buildPartTab('Part 1', 1),
                  _buildPartTab('Part 2', 2),
                  _buildPartTab('Part 3', 3),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 2. Interactive 3D Card Display
            _buildRouletteCardWidget(),
            const SizedBox(height: 18),

            // 3. Action: Spin Again Button
            ElevatedButton.icon(
              onPressed: _spinTheDeck,
              icon: const Icon(Icons.casino_rounded, size: 20, color: Colors.white),
              label: const Text(
                'Bốc Thẻ Câu Hỏi Khác 🎲',
                style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.brandPrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 1,
              ),
            ),
            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }

  Widget _buildPartTab(String label, int index) {
    final isSelected = _selectedPartIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedPartIndex = index;
          });
          _spinTheDeck();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(7),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? AppTheme.brandPrimary : const Color(0xFF64748B),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRouletteCardWidget() {
    Color badgeColor = const Color(0xFFEEF2FF);
    Color badgeTextColor = AppTheme.brandPrimary;
    String partLabel = 'PART 1 INTERVIEW';

    if (_currentCard.part == SpeakingPart.part2) {
      badgeColor = const Color(0xFFFEF3C7);
      badgeTextColor = const Color(0xFFD97706);
      partLabel = 'PART 2 CUE CARD';
    } else if (_currentCard.part == SpeakingPart.part3) {
      badgeColor = const Color(0xFFFEE2E2);
      badgeTextColor = const Color(0xFFDC2626);
      partLabel = 'PART 3 DISCUSSION';
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return ScaleTransition(scale: animation, child: child);
      },
      child: Container(
        key: ValueKey(_currentCard.id),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Part & Topic
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    partLabel,
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                      color: badgeTextColor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _currentCard.topicName,
                    textAlign: TextAlign.end,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Question
            Text(
              _currentCard.question,
              style: const TextStyle(
                fontSize: 16.5,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E293B),
                height: 1.35,
              ),
            ),
            const SizedBox(height: 14),

            // 1. Things you could talk about (Dàn ý triển khai)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.lightbulb_outline_rounded, size: 16, color: Color(0xFFD97706)),
                      SizedBox(width: 6),
                      Text(
                        'Things you could talk about:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF92400E),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ..._currentCard.cuePoints.map((point) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• ', style: TextStyle(color: AppTheme.brandPrimary, fontWeight: FontWeight.bold)),
                          Expanded(
                            child: Text(
                              point,
                              style: const TextStyle(fontSize: 12.5, color: Color(0xFF334155), height: 1.3),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // 2. Useful Vocabulary in context (Tra cứu tức thì)
            const Text(
              'Useful Vocabulary (Chạm để xem định nghĩa):',
              style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: _currentCard.contextualVocab.map((vocab) {
                return InkWell(
                  onTap: () => _showVocabDetail(vocab),
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4.5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF2FF),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFC7D2FE)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.search_rounded, size: 12, color: AppTheme.brandPrimary),
                        const SizedBox(width: 4),
                        Text(
                          vocab.word,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.brandPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 14),

            // 3. Sample Answer Accordion
            InkWell(
              onTap: () => setState(() => _showSampleAnswer = !_showSampleAnswer),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.stars_rounded, size: 16, color: Color(0xFFF59E0B)),
                    const SizedBox(width: 6),
                    const Text(
                      'Câu trả lời mẫu Band 8.0+',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
                    ),
                    const Spacer(),
                    Icon(
                      _showSampleAnswer ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                      size: 18,
                      color: const Color(0xFF64748B),
                    ),
                  ],
                ),
              ),
            ),
            if (_showSampleAnswer) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF86EFAC)),
                ),
                child: Text(
                  _currentCard.sampleAnswer,
                  style: const TextStyle(fontSize: 13, color: Color(0xFF166534), height: 1.45),
                ),
              ),
            ],
            const SizedBox(height: 16),

            // 4. Button to Practice Answer with AI
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Create a temporary topic representing this roulette card
                  final topic = SpeakingTopic(
                    id: 'roulette_${_currentCard.id}',
                    quarter: 'Q3-2026',
                    title: _currentCard.topicName,
                    titleVi: _currentCard.topicName,
                    categoryTag: 'part1_topic',
                    bandTarget: 'Band 7.0+',
                    questions: [
                      SpeakingQuestion(
                        id: _currentCard.id,
                        part: _currentCard.part,
                        questionText: _currentCard.question,
                        ideaHints: _currentCard.cuePoints,
                        usefulVocab: _currentCard.contextualVocab,
                        sampleAnswerBand8: _currentCard.sampleAnswer,
                      ),
                    ],
                  );

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
                icon: const Icon(Icons.mic_rounded, size: 16, color: Colors.white),
                label: const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text('Luyện Trả Lời Câu Này Với AI ➔', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
