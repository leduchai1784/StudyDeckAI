import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../../../app/theme.dart';
import '../models/dictation_model.dart';
import '../data/listening_mock_data.dart';

class ListeningIpaScreen extends StatefulWidget {
  final String? initialSoundPairId;

  const ListeningIpaScreen({
    super.key,
    this.initialSoundPairId,
  });

  @override
  State<ListeningIpaScreen> createState() => _ListeningIpaScreenState();
}

class _ListeningIpaScreenState extends State<ListeningIpaScreen> {
  final FlutterTts _flutterTts = FlutterTts();

  // Accent: UK ('en-GB') or US ('en-US')
  String _selectedAccent = 'en-GB'; // 'en-GB' or 'en-US'

  // Categories list
  late List<IpaMinimalPairCategory> _allCategories;
  int _categoryFilterIndex = 0; // 0: Tất cả, 1: Nguyên âm, 2: Phụ âm

  // Active Practice State
  IpaMinimalPairCategory? _activePair;
  int _currentQuestionIndex = 0;
  String? _selectedWord;
  bool _isPlayingAudio = false;
  int _correctCount = 0;
  bool _isResultScreen = false;

  // Track missed questions for review: List of Map {question, userSelectedWord}
  final List<Map<String, dynamic>> _missedQuestions = [];

  @override
  void initState() {
    super.initState();
    _allCategories = ListeningMockData.ipaCategories;

    if (widget.initialSoundPairId != null) {
      final found = _allCategories.firstWhere(
        (c) => c.id == widget.initialSoundPairId,
        orElse: () => _allCategories.first,
      );
      _startPractice(found);
    }

    _initTts();
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage(_selectedAccent);
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.42);

    _flutterTts.setCompletionHandler(() {
      if (mounted) setState(() => _isPlayingAudio = false);
    });
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  void _setAccent(String langCode) async {
    setState(() => _selectedAccent = langCode);
    await _flutterTts.setLanguage(langCode);
    if (_activePair != null && !_isResultScreen && _selectedWord == null) {
      _playTargetAudio();
    }
  }

  void _startPractice(IpaMinimalPairCategory pair) {
    setState(() {
      _activePair = pair;
      _currentQuestionIndex = 0;
      _selectedWord = null;
      _correctCount = 0;
      _isResultScreen = false;
      _missedQuestions.clear();
    });
    _playTargetAudio();
  }

  void _backToOverview() {
    _flutterTts.stop();
    setState(() {
      _activePair = null;
      _isResultScreen = false;
      _selectedWord = null;
      _missedQuestions.clear();
    });
  }

  IpaQuestion? get _currentQuestion {
    if (_activePair == null) return null;
    if (_currentQuestionIndex >= _activePair!.questions.length) return null;
    return _activePair!.questions[_currentQuestionIndex];
  }

  void _playTargetAudio() async {
    final q = _currentQuestion;
    if (q == null) return;
    await _flutterTts.stop();
    setState(() => _isPlayingAudio = true);
    await _flutterTts.speak(q.targetWord);
  }

  void _speakWord(String word) async {
    await _flutterTts.stop();
    await _flutterTts.speak(word);
  }

  void _onSelectOption(String word) {
    if (_selectedWord != null) return; // already answered

    final q = _currentQuestion!;
    final isCorrect = word == q.targetWord;

    setState(() {
      _selectedWord = word;
      if (isCorrect) {
        _correctCount++;
      } else {
        _missedQuestions.add({
          'question': q,
          'userChoice': word,
        });
      }
    });
  }

  void _onNextQuestion() {
    final total = _activePair!.questions.length;
    if (_currentQuestionIndex < total - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedWord = null;
      });
      _playTargetAudio();
    } else {
      setState(() => _isResultScreen = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_activePair != null) {
      return _isResultScreen ? _buildResultScreen() : _buildPracticeRoom();
    }
    return _buildOverviewHub();
  }

  // ==========================================
  // 1. OVERVIEW / HUB SCREEN
  // ==========================================
  Widget _buildOverviewHub() {
    List<IpaMinimalPairCategory> filteredList = _allCategories;
    if (_categoryFilterIndex == 1) {
      filteredList = _allCategories.where((c) => c.soundType == IpaSoundType.vowel).toList();
    } else if (_categoryFilterIndex == 2) {
      filteredList = _allCategories.where((c) => c.soundType == IpaSoundType.consonant).toList();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Luyện Tai Phân Biệt Âm',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
        ),
        actions: [
          _buildAccentSelectorHeader(),
          const SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Intro Card (Retro-styled with border & shadow)
            _buildIntroHeroCard(),
            const SizedBox(height: 16),

            // 3 Stats Boxes (42 Cặp âm, 407 Câu luyện, 2 Giọng)
            _buildStatsRow(),
            const SizedBox(height: 20),

            // Category Filter Tabs
            _buildCategoryFilterTabs(),
            const SizedBox(height: 16),

            // Pairs Count Label
            Text(
              '${filteredList.length} cặp âm phân biệt',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF64748B),
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 10),

            // 2-Column Responsive Grid of Minimal Pair Cards
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.15,
              ),
              itemBuilder: (ctx, idx) => _buildPairCard(filteredList[idx]),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildAccentSelectorHeader() {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildAccentToggleItem(label: '🇬🇧 UK', langCode: 'en-GB'),
          _buildAccentToggleItem(label: '🇺🇸 US', langCode: 'en-US'),
        ],
      ),
    );
  }

  Widget _buildAccentToggleItem({required String label, required String langCode}) {
    final isSelected = _selectedAccent == langCode;
    return GestureDetector(
      onTap: () => _setAccent(langCode),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  )
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? AppTheme.brandPrimary : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }

  Widget _buildIntroHeroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: const Color(0xFF16A34A)),
                ),
                child: const Text(
                  'MINIMAL PAIRS · IPA',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF166534),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const Spacer(),
              const Icon(Icons.volume_up_outlined, size: 18, color: Color(0xFF4F46E5)),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'LUYỆN TAI PHÂN BIỆT ÂM',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w900,
              color: Color(0xFF0F172A),
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Nghe một từ, chọn đúng từ vừa nghe. Hai từ chỉ khác nhau đúng một âm — nếu tai chưa tách được bad với bed, thì miệng cũng chưa nói tách được.',
            style: TextStyle(fontSize: 12.5, color: Color(0xFF475569), height: 1.45),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(child: _buildStatTile('42', 'CẶP ÂM')),
        const SizedBox(width: 8),
        Expanded(child: _buildStatTile('407', 'CÂU LUYỆN')),
        const SizedBox(width: 8),
        Expanded(child: _buildStatTile('2', 'GIỌNG ANH')),
      ],
    );
  }

  Widget _buildStatTile(String number, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFCBD5E1),
            offset: Offset(2, 2),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            number,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilterTabs() {
    final tabs = [
      'Tất cả',
      'Nguyên âm (11 cặp)',
      'Phụ âm (31 cặp)',
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tabs.asMap().entries.map((entry) {
          final idx = entry.key;
          final label = entry.value;
          final isSelected = _categoryFilterIndex == idx;

          return GestureDetector(
            onTap: () => setState(() => _categoryFilterIndex = idx),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.brandPrimary : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: isSelected ? AppTheme.brandPrimary : const Color(0xFFE2E8F0)),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : const Color(0xFF475569),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPairCard(IpaMinimalPairCategory pair) {
    return GestureDetector(
      onTap: () => _startPractice(pair),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top Amber Pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF08A), // amber-200
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: const Color(0xFFEAB308)),
              ),
              child: Text(
                pair.soundPairTitle,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF713F12),
                ),
              ),
            ),

            // Word pair title (e.g. bad / bed)
            Text(
              pair.wordPairLabel,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: Color(0xFF0F172A),
              ),
            ),

            // Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${pair.questions.length} CÂU →',
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
                ),
                Icon(
                  pair.soundType == IpaSoundType.vowel ? Icons.music_note_rounded : Icons.record_voice_over_outlined,
                  size: 14,
                  color: const Color(0xFF94A3B8),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 2. PRACTICE ROOM (10 QUESTIONS)
  // ==========================================
  Widget _buildPracticeRoom() {
    final q = _currentQuestion!;
    final totalQ = _activePair!.questions.length;
    final isAnswered = _selectedWord != null;
    final isCorrect = isAnswered && _selectedWord == q.targetWord;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: TextButton.icon(
          onPressed: _backToOverview,
          icon: const Icon(Icons.arrow_back_ios_new, size: 14, color: Color(0xFF1E293B)),
          label: const Text(
            'Tất cả cặp',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
          ),
          style: TextButton.styleFrom(padding: const EdgeInsets.only(left: 12)),
        ),
        leadingWidth: 110,
        title: Text(
          _activePair!.soundPairTitle,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
        ),
        centerTitle: true,
        actions: [
          _buildAccentSelectorHeader(),
          const SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          // Progress Header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'CÂU ${_currentQuestionIndex + 1} / $totalQ',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF475569),
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      'Đúng: $_correctCount',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF16A34A),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (_currentQuestionIndex + 1) / totalQ,
                    minHeight: 5,
                    backgroundColor: const Color(0xFFE2E8F0),
                    valueColor: const AlwaysStoppedAnimation(Color(0xFF0F172A)),
                  ),
                ),
              ],
            ),
          ),

          // Main Practice Area
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  // Speaker Box
                  _buildSpeakerAudioCard(),
                  const SizedBox(height: 24),

                  // 2 Large Options (Word + IPA)
                  Row(
                    children: [
                      Expanded(
                        child: _buildChoiceCard(
                          word: q.wordA,
                          ipa: q.ipaA,
                          meaning: q.meaningA,
                          targetWord: q.targetWord,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildChoiceCard(
                          word: q.wordB,
                          ipa: q.ipaB,
                          meaning: q.meaningB,
                          targetWord: q.targetWord,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Example Sentence Reference
                  if (isAnswered)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.format_quote_rounded, size: 18, color: Color(0xFF64748B)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              q.exampleSentence,
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontStyle: FontStyle.italic,
                                color: Color(0xFF334155),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Bottom Action Feedback Bar
          if (isAnswered) _buildBottomFeedbackBar(isCorrect, totalQ),
        ],
      ),
    );
  }

  Widget _buildSpeakerAudioCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFE2E8F0),
            offset: Offset(2, 2),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: _playTargetAudio,
            child: Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(38),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F172A).withValues(alpha: 0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                _isPlayingAudio ? Icons.graphic_eq_rounded : Icons.volume_up_rounded,
                color: Colors.white,
                size: 38,
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'BẤM ĐỂ NGHE · RỒI CHỌN TỪ BẠN NGHE ĐƯỢC',
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w800,
              color: Color(0xFF475569),
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChoiceCard({
    required String word,
    required String ipa,
    required String meaning,
    required String targetWord,
  }) {
    final isAnswered = _selectedWord != null;
    final isSelected = _selectedWord == word;
    final isTarget = word == targetWord;

    Color bgColor = Colors.white;
    Color borderColor = const Color(0xFFE2E8F0);
    Color textColor = AppTheme.brandTextPrimary;

    if (isAnswered) {
      if (isTarget) {
        bgColor = const Color(0xFFDCFCE7); // green-100
        borderColor = const Color(0xFF16A34A); // green-600
        textColor = const Color(0xFF166534);
      } else if (isSelected) {
        bgColor = const Color(0xFFFEE2E2); // red-100
        borderColor = const Color(0xFFDC2626); // red-600
        textColor = const Color(0xFF991B1B);
      } else {
        bgColor = const Color(0xFFF8FAFC);
        borderColor = const Color(0xFFCBD5E1);
      }
    }

    return Column(
      children: [
        GestureDetector(
          onTap: () => _onSelectOption(word),
          child: Container(
            height: 140,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor, width: isAnswered && (isTarget || isSelected) ? 2.0 : 1.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  word,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  ipa,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isAnswered && isTarget ? const Color(0xFF15803D) : const Color(0xFF4F46E5),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  meaning,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                ),
              ],
            ),
          ),
        ),

        // Side-by-side Audio Comparison Button (Appears only after answering)
        if (isAnswered) ...[
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 36,
            child: OutlinedButton.icon(
              onPressed: () => _speakWord(word),
              icon: const Icon(Icons.volume_up_rounded, size: 15, color: Color(0xFF0F172A)),
              label: const Text(
                'Nghe từ này',
                style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(color: Color(0xFFCBD5E1), width: 1.2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                padding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildBottomFeedbackBar(bool isCorrect, int totalQ) {
    final q = _currentQuestion!;
    final isLast = _currentQuestionIndex == totalQ - 1;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: Color(0xFFE2E8F0))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Status Indicator & Explanation
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Icon(
                        isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                        size: 18,
                        color: isCorrect ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isCorrect ? 'CHÍNH XÁC!' : 'CHƯA ĐÚNG!',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w900,
                          color: isCorrect ? const Color(0xFF166534) : const Color(0xFF991B1B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Từ vừa đọc là "${q.targetWord}". Nghe lại cả hai để so sánh.',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11.5, color: Color(0xFF475569)),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Next Question / View Results Button
            ElevatedButton(
              onPressed: _onNextQuestion,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F172A),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              ),
              child: Text(
                isLast ? 'XEM KẾT QUẢ' : 'CÂU TIẾP →',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 3. COMPLETION / RESULTS SCREEN
  // ==========================================
  Widget _buildResultScreen() {
    final totalQ = _activePair!.questions.length;
    final percentage = (totalQ > 0) ? (_correctCount / totalQ) : 0.0;

    String feedbackText = 'Tuyệt vời! Tai bạn phân biệt âm này rất chuẩn xác.';
    if (percentage < 0.6) {
      feedbackText = 'Cặp âm này khá thử thách. Hãy bấm nghe lại các câu còn nhầm bên dưới để luyện tai nhé!';
    } else if (percentage < 0.9) {
      feedbackText = 'Đã nghe ra phần lớn. Làm lại một lượt nữa để âm ngấm chắc hơn nhé.';
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Color(0xFF1E293B)),
          onPressed: _backToOverview,
        ),
        title: Text(
          'KẾT QUẢ · ${_activePair!.soundPairTitle.toUpperCase()}',
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Score Banner Box
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    '$_correctCount / $totalQ',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: percentage,
                      minHeight: 8,
                      backgroundColor: const Color(0xFFE2E8F0),
                      valueColor: AlwaysStoppedAnimation(
                        percentage >= 0.8 ? const Color(0xFF16A34A) : const Color(0xFF4F46E5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    feedbackText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 13, color: Color(0xFF475569), height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Missed Questions Breakdown (CÂU CÒN NHẦM)
            if (_missedQuestions.isNotEmpty) ...[
              const Text(
                'CÂU CÒN NHẦM',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0F172A),
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              ..._missedQuestions.map((item) {
                final q = item['question'] as IpaQuestion;
                final userChoice = item['userChoice'] as String;
                final isA = q.isTargetWordA();
                final correctIpa = isA ? q.ipaA : q.ipaB;

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFCBD5E1)),
                  ),
                  child: Row(
                    children: [
                      // Audio replay
                      IconButton(
                        icon: const Icon(Icons.volume_up_rounded, size: 20, color: Color(0xFF4F46E5)),
                        onPressed: () => _speakWord(q.targetWord),
                      ),
                      const SizedBox(width: 8),

                      // Correct Word & IPA
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${q.targetWord}  $correctIpa',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            Text(
                              'BẠN CHỌN: ${userChoice.toUpperCase()}',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFDC2626),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 16),
            ],

            // Action Buttons
            ElevatedButton.icon(
              onPressed: () => _startPractice(_activePair!),
              icon: const Icon(Icons.replay_rounded, size: 18),
              label: const Text('LÀM LẠI CẶP NÀY', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F172A),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                elevation: 0,
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: _backToOverview,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFCBD5E1)),
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              ),
              child: const Text(
                'CHỌN CẶP ÂM KHÁC',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF334155)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
