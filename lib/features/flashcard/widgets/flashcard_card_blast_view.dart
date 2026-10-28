import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import '../../../models/edu_word.dart';

/// Đại diện cho một thiên thạch/thẻ từ vựng đang trôi từ vũ trụ xuống
class _FallingTarget {
  final String id;
  final EduWord word;
  final double xPercent; // 0.15 đến 0.85
  double y; // 0.0 (đỉnh) -> 1.0 (đường laser nét đứt)
  final double speed;
  bool isBlasting = false;
  double blastProgress = 0.0;
  bool isCrashed = false;

  _FallingTarget({
    required this.id,
    required this.word,
    required this.xPercent,
    this.y = 0.0,
    required this.speed,
  });
}

enum _CosmicGameState {
  playing,
  waveCleared,
  gameOver,
  victory,
  paused,
}

/// Giao diện chế độ Card Blast phong cách Vũ Trụ Không Gian (Space Typer / Cosmic Blaster)
/// Tái hiện chuẩn xác 1:1 theo ảnh mẫu: Bầu trời sao đêm, thẻ từ capsule phát sáng kèm gợi ý ô chữ,
/// vạch laser đỏ nét đứt, nhân vật mặt trời cầm đại bác ngắm bắn, ô gõ đáp án viền vàng.
class FlashcardCardBlastView extends StatefulWidget {
  final EduWord? currentWord;
  final List<EduWord> allWords;
  final ValueChanged<bool>? onAnswer;
  final void Function(EduWord word, bool isMastered)? onWordResult;
  final VoidCallback? onSpeak;
  final ValueChanged<String>? onSpeakWord;
  final VoidCallback? onChangeMode;
  final VoidCallback? onExit;

  const FlashcardCardBlastView({
    super.key,
    this.currentWord,
    required this.allWords,
    this.onAnswer,
    this.onWordResult,
    this.onSpeak,
    this.onSpeakWord,
    this.onChangeMode,
    this.onExit,
  });

  @override
  State<FlashcardCardBlastView> createState() => _FlashcardCardBlastViewState();
}

class _FlashcardCardBlastViewState extends State<FlashcardCardBlastView>
    with TickerProviderStateMixin {
  late Ticker _ticker;
  Duration _lastElapsed = Duration.zero;

  // Trạng thái game
  _CosmicGameState _gameState = _CosmicGameState.playing;
  int _score = 0;
  int _wave = 1;
  int _totalWaves = 1;
  int _combo = 0;
  int _maxCombo = 0;
  int _lives = 3;
  int _blastedCount = 0;
  int _missedCount = 0;

  final List<EduWord> _allDeckWords = [];
  final List<EduWord> _waveQueue = [];
  final List<_FallingTarget> _targets = [];
  final List<EduWord> _failedWords = [];

  // Controllers
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String _typedText = '';

  // Laser beam animation
  Offset? _laserOrigin;
  Offset? _laserDestination;
  double _laserOpacity = 0.0;
  double _bulletProgress = 0.0;

  // Shake animation
  late AnimationController _shakeController;
  late AnimationController _inputShakeController;

  double _spawnTimer = 0.0;

  // Vị trí các ngôi sao cố định trong không gian
  final List<Offset> _stars = List.generate(
    65,
    (index) => Offset(Random(index * 7).nextDouble(), Random(index * 13).nextDouble()),
  );

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _inputShakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _textController.addListener(() {
      if (!mounted || _gameState != _CosmicGameState.playing) return;

      final rawText = _textController.text.trim().toLowerCase();
      if (rawText.isEmpty) {
        if (_typedText.isNotEmpty) {
          setState(() {
            _typedText = '';
          });
        }
        return;
      }

      // Kiểm tra xem rawText có khớp trọn vẹn hoặc khớp tiền tố của mục tiêu nào đang rơi không
      _FallingTarget? fullMatchTarget;
      bool hasPrefixMatch = false;

      for (final target in _targets) {
        if (target.isBlasting || target.isCrashed) continue;
        final cleanTitle = target.word.title.trim().toLowerCase();
        final noSpace = cleanTitle.replaceAll(RegExp(r'\s+'), '');

        // Khớp trọn vẹn toàn bộ từ
        if (cleanTitle == rawText || noSpace == rawText) {
          fullMatchTarget = target;
          hasPrefixMatch = true;
          break;
        }

        // Hoặc khớp từ chữ cái thứ 2 trở đi (người chơi bắt đầu gõ từ ô thứ 2)
        if (cleanTitle.length > 1) {
          final sub = cleanTitle.substring(1);
          final subNoSpace = noSpace.length > 1 ? noSpace.substring(1) : '';
          if (sub == rawText || subNoSpace == rawText) {
            fullMatchTarget = target;
            hasPrefixMatch = true;
            break;
          }
          if (sub.startsWith(rawText) || subNoSpace.startsWith(rawText)) {
            hasPrefixMatch = true;
          }
        }

        if (cleanTitle.startsWith(rawText) || noSpace.startsWith(rawText)) {
          hasPrefixMatch = true;
        }
      }

      if (fullMatchTarget != null) {
        // ĐÃ NHẬP ĐỦ VÀ ĐÚNG TỪ -> BẮN NỔ THẺ NGAY LẬP TỨC!
        _blastTarget(fullMatchTarget);
      } else if (hasPrefixMatch) {
        // Khớp một phần tiền tố -> Cập nhật các ô chữ cái đang rơi
        setState(() {
          _typedText = rawText;
        });
      } else {
        // Gõ ký tự sai không khớp từ nào -> Rung nhẹ và xóa ký tự sai
        _inputShakeController.forward(from: 0);
        if (_typedText.isNotEmpty && rawText.startsWith(_typedText)) {
          _textController.value = TextEditingValue(
            text: _typedText,
            selection: TextSelection.collapsed(offset: _typedText.length),
          );
        } else {
          _textController.clear();
          setState(() {
            _typedText = '';
          });
        }
      }
    });

    _ticker = createTicker(_onTick);
    _initDeck();
  }

  void _initDeck() {
    _allDeckWords.clear();
    if (widget.allWords.isNotEmpty) {
      _allDeckWords.addAll(widget.allWords);
    } else if (widget.currentWord != null) {
      _allDeckWords.add(widget.currentWord!);
    }

    _totalWaves = max(1, (_allDeckWords.length / 5).ceil());
    _resetGame();
  }

  void _resetGame() {
    void applyReset() {
      _ticker.stop();
      _lastElapsed = Duration.zero;
      _score = 0;
      _wave = 1;
      _combo = 0;
      _maxCombo = 0;
      _lives = 3;
      _blastedCount = 0;
      _missedCount = 0;
      _failedWords.clear();
      _targets.clear();
      _textController.clear();
      _laserOpacity = 0.0;
      _bulletProgress = 0.0;

      _setupWave(_wave);
      _gameState = _CosmicGameState.playing;
    }

    if (mounted) {
      setState(applyReset);
    } else {
      applyReset();
    }
    _ticker.start();
  }

  void _setupWave(int waveIndex) {
    _targets.clear();
    _waveQueue.clear();
    _spawnTimer = 0.0;

    const wordsPerWave = 5;
    final startIndex = (waveIndex - 1) * wordsPerWave;
    if (startIndex < _allDeckWords.length) {
      final endIndex = min(startIndex + wordsPerWave, _allDeckWords.length);
      _waveQueue.addAll(_allDeckWords.sublist(startIndex, endIndex));
    } else {
      final shuffled = List<EduWord>.from(_allDeckWords)..shuffle(Random());
      _waveQueue.addAll(shuffled.take(wordsPerWave));
    }

    // Spawn mục tiêu đầu tiên ngay khi bắt đầu Wave
    final double waveSpeed = 0.10 + (waveIndex - 1) * 0.035;
    _spawnTarget(waveSpeed);
  }

  void _onTick(Duration elapsed) {
    if (_gameState != _CosmicGameState.playing) return;

    if (_lastElapsed == Duration.zero) {
      _lastElapsed = elapsed;
      return;
    }

    final dt = ((elapsed - _lastElapsed).inMicroseconds / 1000000.0).clamp(0.0, 0.05);
    _lastElapsed = elapsed;

    setState(() {
      _spawnTimer += dt;

      // Cập nhật đạn tên lửa bay và độ mờ vệt laser
      if (_laserOpacity > 0.0) {
        _bulletProgress = min(1.0, _bulletProgress + dt * 4.5);
        _laserOpacity = max(0.0, _laserOpacity - dt * 2.8);
      }

      // Tần suất spawn mục tiêu
      final double waveSpeed = 0.10 + (_wave - 1) * 0.035;
      final double spawnInterval = max(1.8, 3.2 - (_wave - 1) * 0.5);
      final int maxActiveAllowed = min(3, 1 + _wave);

      if (_waveQueue.isNotEmpty &&
          _spawnTimer >= spawnInterval &&
          _targets.where((t) => !t.isBlasting && !t.isCrashed).length < maxActiveAllowed) {
        _spawnTarget(waveSpeed);
        _spawnTimer = 0.0;
      }

      // Cập nhật vị trí các mục tiêu đang trôi
      for (int i = _targets.length - 1; i >= 0; i--) {
        final target = _targets[i];

        if (target.isBlasting) {
          target.blastProgress += dt * 3.5;
          if (target.blastProgress >= 1.0) {
            _targets.removeAt(i);
          }
          continue;
        }

        if (target.isCrashed) {
          target.blastProgress += dt * 3.0;
          if (target.blastProgress >= 1.0) {
            _targets.removeAt(i);
          }
          continue;
        }

        // Trôi xuống dần
        target.y += target.speed * dt;

        // Chạm vào đường laser nguy hiểm (y >= 1.0)
        if (target.y >= 1.0) {
          target.isCrashed = true;
          _handleTargetCrashed(target);
        }
      }

      // Kiểm tra qua Wave
      if (_waveQueue.isEmpty && _targets.isEmpty && _lives > 0) {
        if (_wave < _totalWaves) {
          _gameState = _CosmicGameState.waveCleared;
          _score += 250 * _wave;
          Future.delayed(const Duration(milliseconds: 1500), () {
            if (mounted && _gameState == _CosmicGameState.waveCleared) {
              setState(() {
                _wave++;
                _setupWave(_wave);
                _gameState = _CosmicGameState.playing;
              });
            }
          });
        } else {
          _gameState = _CosmicGameState.victory;
          _ticker.stop();
          _focusNode.unfocus();
        }
      }
    });
  }

  void _spawnTarget(double speed) {
    if (_waveQueue.isEmpty) return;
    final word = _waveQueue.removeAt(0);

    // Tính tọa độ X so le (Tránh đè lên mục tiêu gần đỉnh)
    final existingTops = _targets
        .where((t) => t.y < 0.3 && !t.isBlasting && !t.isCrashed)
        .map((t) => t.xPercent)
        .toList();

    double candidateX = 0.2 + Random().nextDouble() * 0.6;
    for (int attempts = 0; attempts < 5; attempts++) {
      final overlaps = existingTops.any((x) => (x - candidateX).abs() < 0.25);
      if (!overlaps) break;
      candidateX = 0.2 + Random().nextDouble() * 0.6;
    }

    _targets.add(
      _FallingTarget(
        id: '${word.id}_${DateTime.now().microsecondsSinceEpoch}',
        word: word,
        xPercent: candidateX,
        y: 0.0,
        speed: speed,
      ),
    );
  }

  void _handleTargetCrashed(_FallingTarget target) {
    _lives--;
    _missedCount++;
    _combo = 0;
    _shakeController.forward(from: 0);

    if (!_failedWords.any((w) => w.id == target.word.id)) {
      _failedWords.add(target.word);
    }

    // Báo cáo Spaced Repetition (chưa thuộc)
    widget.onWordResult?.call(target.word, false);
    widget.onAnswer?.call(false);

    if (_lives <= 0) {
      _gameState = _CosmicGameState.gameOver;
      _ticker.stop();
      _focusNode.unfocus();
    }
  }

  void _blastTarget(_FallingTarget target) {
    if (_gameState != _CosmicGameState.playing || target.isBlasting || target.isCrashed) return;

    // BẮN NỔ TRÚNG MỤC TIÊU!
    setState(() {
      target.isBlasting = true;
      _blastedCount++;
      _combo++;
      if (_combo > _maxCombo) _maxCombo = _combo;

      _score += 100 * _combo;
      _textController.clear();
      _typedText = '';
      _laserOpacity = 1.0;
      _bulletProgress = 0.0;
    });

    // Phát âm từ vựng
    if (widget.onSpeakWord != null) {
      widget.onSpeakWord!(target.word.title);
    } else {
      widget.onSpeak?.call();
    }

    // Cập nhật Spaced Repetition thành công
    widget.onWordResult?.call(target.word, true);
    widget.onAnswer?.call(true);
  }

  void _submitWord() {
    if (_gameState != _CosmicGameState.playing) return;

    final input = _textController.text.trim().toLowerCase();
    if (input.isEmpty) return;

    _FallingTarget? matchedTarget;
    for (final target in _targets) {
      if (target.isBlasting || target.isCrashed) continue;
      final cleanTitle = target.word.title.trim().toLowerCase();
      final noSpace = cleanTitle.replaceAll(RegExp(r'\s+'), '');
      final variants = cleanTitle
          .split(RegExp(r'[/,;]'))
          .map((s) => s.replaceAll(RegExp(r'\(.*?\)'), '').trim())
          .where((s) => s.isNotEmpty)
          .toList();

      if (cleanTitle == input || noSpace == input || variants.contains(input)) {
        matchedTarget = target;
        break;
      }
      if (cleanTitle.length > 1) {
        final sub = cleanTitle.substring(1);
        final subNoSpace = noSpace.length > 1 ? noSpace.substring(1) : '';
        if (sub == input || subNoSpace == input) {
          matchedTarget = target;
          break;
        }
      }
    }

    if (matchedTarget != null) {
      _blastTarget(matchedTarget);
    } else {
      _inputShakeController.forward(from: 0);
    }
  }

  void _onKeyTapped(String char) {
    if (_gameState != _CosmicGameState.playing) return;
    HapticFeedback.lightImpact();
    _textController.text = _textController.text + char.toLowerCase();
  }

  void _onBackspaceTapped() {
    if (_gameState != _CosmicGameState.playing) return;
    HapticFeedback.lightImpact();
    if (_textController.text.isNotEmpty) {
      _textController.text = _textController.text.substring(0, _textController.text.length - 1);
    }
  }

  void _onClearTapped() {
    if (_gameState != _CosmicGameState.playing) return;
    HapticFeedback.lightImpact();
    _textController.clear();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _shakeController.dispose();
    _inputShakeController.dispose();
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent && _gameState == _CosmicGameState.playing) {
          if (event.logicalKey == LogicalKeyboardKey.backspace) {
            _onBackspaceTapped();
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.escape) {
            _onClearTapped();
            return KeyEventResult.handled;
          } else if (event.character != null && event.character!.isNotEmpty) {
            final char = event.character!;
            if (RegExp(r'^[a-zA-Z]$').hasMatch(char)) {
              _onKeyTapped(char);
              return KeyEventResult.handled;
            }
          }
        }
        return KeyEventResult.ignored;
      },
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            color: const Color(0xFF070C1D),
            child: Column(
              children: [
                // 1. Thanh HUD trên cùng (ĐIỂM, CẤP, CHUỖI, TỐC ĐỘ, Pause, Hearts, Back)
                _buildTopCosmicHud(),

                // 2. Không gian vũ trụ sao đêm (Sân chơi thiên thạch + Vạch laser + Khẩu pháo mặt trời)
                Expanded(
                  child: AnimatedBuilder(
                    animation: _shakeController,
                    builder: (context, child) {
                      final offset = _shakeController.isAnimating
                          ? sin(_shakeController.value * pi * 4) * 6
                          : 0.0;
                      return Transform.translate(
                        offset: Offset(offset, 0),
                        child: child,
                      );
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Nền gradient vũ trụ sao đêm
                        Positioned.fill(
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0xFF070C1D), // Midnight Blue
                                  Color(0xFF0D142E), // Cosmic Navy
                                  Color(0xFF261021), // Reddish Cosmic Nebula
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Lớp vẽ các vì sao lấp lánh (Starfield)
                        Positioned.fill(
                          child: CustomPaint(
                            painter: _StarfieldPainter(stars: _stars),
                          ),
                        ),

                        // Sân chơi chính: Các mục tiêu rơi tự do
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final arenaHeight = constraints.maxHeight;
                            final arenaWidth = constraints.maxWidth;
                            const dangerLineYRatio = 0.82;
                            final dangerLinePixel = arenaHeight * dangerLineYRatio;

                            // Điểm xuất phát của đạn từ mũi tên lửa
                            _laserOrigin = Offset(arenaWidth / 2, dangerLinePixel - 42);

                            return Stack(
                              clipBehavior: Clip.none,
                              children: [
                                // Vạch laser nét đứt màu đỏ (Danger Line)
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  top: dangerLinePixel,
                                  child: CustomPaint(
                                    size: Size(arenaWidth, 2),
                                    painter: _DashedLinePainter(
                                      color: const Color(0xFFE11D48).withValues(alpha: 0.7),
                                      dashWidth: 7,
                                      dashSpace: 5,
                                    ),
                                  ),
                                ),

                                // Các mục tiêu thiên thạch rơi
                                ..._targets.map((target) {
                                  return _buildTargetWidget(target, arenaWidth, dangerLinePixel);
                                }),

                                // Đạn tên lửa bắn thẳng vào mục tiêu từ vựng
                                if (_laserOpacity > 0.0 && _laserOrigin != null && _laserDestination != null)
                                  Positioned.fill(
                                    child: CustomPaint(
                                      painter: _RocketBulletPainter(
                                        start: _laserOrigin!,
                                        end: _laserDestination!,
                                        opacity: _laserOpacity,
                                        progress: _bulletProgress,
                                      ),
                                    ),
                                  ),

                                // Tên lửa chiến hạm không gian ở chính giữa vạch đỏ
                                Positioned(
                                  left: (arenaWidth / 2) - 30,
                                  top: dangerLinePixel - 46,
                                  child: const _CosmicRocketCannon(),
                                ),
                              ],
                            );
                          },
                        ),

                        // Invisible TextField tương thích với testing và hệ thống (không mở bàn phím mềm)
                        Positioned(
                          left: -200,
                          top: -200,
                          width: 1,
                          height: 1,
                          child: Opacity(
                            opacity: 0.0,
                            child: TextField(
                              controller: _textController,
                              focusNode: _focusNode,
                              autofocus: false,
                              readOnly: false,
                              showCursor: false,
                              keyboardType: TextInputType.none,
                              autocorrect: false,
                              enableSuggestions: false,
                              textInputAction: TextInputAction.none,
                              onSubmitted: (_) => _submitWord(),
                            ),
                          ),
                        ),

                        // Overlay thông báo Wave Cleared
                        if (_gameState == _CosmicGameState.waveCleared)
                          Positioned.fill(
                            child: Container(
                              color: Colors.black.withValues(alpha: 0.5),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.stars_rounded, color: Color(0xFFFBBF24), size: 48),
                                    const SizedBox(height: 8),
                                    Text(
                                      'CẤP ĐỘ $_wave HOÀN THÀNH!',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '+${250 * _wave} Điểm thưởng',
                                      style: const TextStyle(fontSize: 14, color: Color(0xFFFDE68A)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // 3. Bàn phím phụ chỉ gồm chữ cái và phím xóa đặt gọn gàng ở đáy
                if (_gameState == _CosmicGameState.playing || _gameState == _CosmicGameState.waveCleared)
                  _buildCompactKeypad(),
              ],
            ),
          ),

          // Overlay toàn màn hình (Game Over, Victory, Pause)
          if (_gameState == _CosmicGameState.gameOver) _buildGameOverOverlay(),
          if (_gameState == _CosmicGameState.victory) _buildVictoryOverlay(),
          if (_gameState == _CosmicGameState.paused) _buildPauseOverlay(),
        ],
      ),
    );
  }

  /// Bàn phím phụ chữ cái đặt dưới cùng màn hình với kích thước phím bấm thoải mái
  Widget _buildCompactKeypad() {
    const row1 = ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'];
    const row2 = ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'];
    const row3 = ['Z', 'X', 'C', 'V', 'B', 'N', 'M'];

    return Container(
      width: double.infinity,
      color: const Color(0xFF070C1D),
      padding: const EdgeInsets.only(left: 5, right: 5, top: 6, bottom: 10),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Hàng 1: Q W E R T Y U I O P (10 phím, flex 2 mỗi phím = 20)
            Row(
              children: row1.map((letter) => _buildKeyButton(letter, flex: 2)).toList(),
            ),
            const SizedBox(height: 5),

            // Hàng 2: A S D F G H J K L (9 phím flex 2 + 2 lề flex 1 = 20)
            Row(
              children: [
                const Spacer(flex: 1),
                ...row2.map((letter) => _buildKeyButton(letter, flex: 2)),
                const Spacer(flex: 1),
              ],
            ),
            const SizedBox(height: 5),

            // Hàng 3: Xóa hết | Z X C V B N M | Xóa 1 ký tự (Backspace)
            Row(
              children: [
                // Nút Xóa toàn bộ (Reset từ đang gõ dở)
                _buildActionKey(
                  icon: Icons.refresh_rounded,
                  onTap: _onClearTapped,
                  tooltip: 'Làm mới',
                  flex: 3,
                ),
                ...row3.map((letter) => _buildKeyButton(letter, flex: 2)),
                // Nút Backspace (Xóa 1 ký tự cuối)
                _buildActionKey(
                  icon: Icons.backspace_outlined,
                  onTap: _onBackspaceTapped,
                  tooltip: 'Xóa ký tự',
                  flex: 3,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyButton(String letter, {int flex = 2}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1.5),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _onKeyTapped(letter),
            borderRadius: BorderRadius.circular(7),
            splashColor: const Color(0xFFF59E0B).withValues(alpha: 0.35),
            highlightColor: const Color(0xFF1E293B),
            child: Ink(
              height: 45,
              decoration: BoxDecoration(
                color: const Color(0xFF131D38),
                borderRadius: BorderRadius.circular(7),
                border: Border.all(
                  color: const Color(0xFF1E293B),
                  width: 1.0,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33000000),
                    offset: Offset(0, 1.5),
                    blurRadius: 1,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  letter,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionKey({
    required IconData icon,
    required VoidCallback onTap,
    required String tooltip,
    int flex = 3,
  }) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1.5),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(7),
            splashColor: const Color(0xFFEF4444).withValues(alpha: 0.3),
            highlightColor: const Color(0xFF1E293B),
            child: Ink(
              height: 45,
              decoration: BoxDecoration(
                color: const Color(0xFF0C142B),
                borderRadius: BorderRadius.circular(7),
                border: Border.all(
                  color: const Color(0xFF1E293B),
                  width: 1.0,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33000000),
                    offset: Offset(0, 1.5),
                    blurRadius: 1,
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: 18,
                  color: const Color(0xFF94A3B8),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- CÁC THÀNH PHẦN GIAO DIỆN CON ---

  Widget _buildTopCosmicHud() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      color: const Color(0xFF070C1D),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 420;
          return FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.center,
            child: SizedBox(
              width: max(constraints.maxWidth, 390.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Bên trái: ĐIỂM, CẤP, CHUỖI
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildHudStat('ĐIỂM', '$_score', const Color(0xFFFBBF24)),
                      const SizedBox(width: 14),
                      _buildHudStat('CẤP', '$_wave', const Color(0xFF60A5FA)),
                      const SizedBox(width: 14),
                      _buildHudStat(
                        'CHUỖI',
                        '$_combo',
                        Colors.white,
                        subtitle: isNarrow ? null : 'liên tục',
                      ),
                    ],
                  ),

                  // Bên phải: Tốc độ, Pause, Trái tim, Nút Thoát
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Chip tốc độ
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF131D38),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFF1E293B)),
                        ),
                        child: Text(
                          isNarrow ? 'TỐC ĐỘ $_wave' : 'BÌNH THƯỜNG - TỐC ĐỘ $_wave',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF93C5FD),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),

                      // Nút Pause ||
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (_gameState == _CosmicGameState.playing) {
                              _gameState = _CosmicGameState.paused;
                            } else if (_gameState == _CosmicGameState.paused) {
                              _gameState = _CosmicGameState.playing;
                            }
                          });
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: const Color(0xFF131D38),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            _gameState == _CosmicGameState.paused ? Icons.play_arrow_rounded : Icons.pause,
                            size: 16,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),

                      // 3 Trái tim sinh mạng
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(3, (index) {
                          final isAlive = index < _lives;
                          return Padding(
                            padding: const EdgeInsets.only(right: 2),
                            child: Icon(
                              Icons.favorite_rounded,
                              color: isAlive ? const Color(0xFFEF4444) : const Color(0xFF334155),
                              size: 16,
                            ),
                          );
                        }),
                      ),
                      const SizedBox(width: 6),

                      // Nút Thoát / Back ←
                      GestureDetector(
                        onTap: () {
                          if (widget.onExit != null) {
                            widget.onExit!();
                          } else if (widget.onChangeMode != null) {
                            widget.onChangeMode!();
                          } else {
                            Navigator.of(context).maybePop();
                          }
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: const Color(0xFF131D38),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.arrow_back,
                            size: 16,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHudStat(String label, String value, Color color, {String? subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Color(0xFF94A3B8),
            letterSpacing: 0.5,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(width: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildTargetWidget(_FallingTarget target, double arenaWidth, double dangerLinePixel) {
    // Kích thước tối đa của thẻ để không bao giờ tràn khỏi màn hình
    final cardMaxWidth = min(220.0, arenaWidth * 0.62);
    final maxX = max(10.0, arenaWidth - cardMaxWidth - 10.0);
    final targetX = (target.xPercent * (arenaWidth - cardMaxWidth)).clamp(10.0, maxX);
    final targetY = (target.y * dangerLinePixel).clamp(0.0, dangerLinePixel + 30);

    // Lưu điểm đến cho laser khi bắn trúng
    if (target.isBlasting) {
      _laserDestination = Offset(targetX + (cardMaxWidth / 2), targetY + 20);
    }

    final vietnameseMeaning = target.word.viword.isNotEmpty
        ? target.word.viword
        : target.word.description;

    final englishTitle = target.word.title.trim().toLowerCase();
    final firstLetter = englishTitle.isNotEmpty ? englishTitle[0] : '';
    final letterCount = englishTitle.length;

    // Tính số ký tự người chơi đã gõ khớp với mục tiêu này
    int matchedLettersCount = 0;
    if (_typedText.isNotEmpty) {
      if (englishTitle.startsWith(_typedText)) {
        matchedLettersCount = _typedText.length;
      } else if (englishTitle.length > 1 && englishTitle.substring(1).startsWith(_typedText)) {
        matchedLettersCount = 1 + _typedText.length;
      }
    }

    return Positioned(
      left: targetX,
      top: targetY,
      child: Transform.scale(
        scale: target.isBlasting ? 1.0 + target.blastProgress * 0.8 : 1.0,
        child: Opacity(
          opacity: (1.0 - target.blastProgress).clamp(0.0, 1.0),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Tam giác neon chỉ hướng rơi phía trên
                CustomPaint(
                  size: const Size(18, 12),
                  painter: _NeonConePainter(
                    color: const Color(0xFFE11D48).withValues(alpha: 0.8),
                  ),
                ),

                // Capsule hình bầu dục viền đỏ phát sáng
                Container(
                  constraints: BoxConstraints(maxWidth: cardMaxWidth),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: const Color(0xFF280E1B), // Dark crimson inside
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFE11D48), width: 1.8),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFE11D48).withValues(alpha: 0.6),
                        blurRadius: 14,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Text(
                    vietnameseMeaning,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 5),

                // Dãy ô chữ cái (FittedBox để không bao giờ tràn chữ dài)
                AnimatedBuilder(
                  animation: _inputShakeController,
                  builder: (context, child) {
                    final offset = _inputShakeController.isAnimating
                        ? sin(_inputShakeController.value * pi * 4) * 4
                        : 0.0;
                    return Transform.translate(
                      offset: Offset(offset, 0),
                      child: child,
                    );
                  },
                  child: Container(
                    constraints: BoxConstraints(maxWidth: cardMaxWidth),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Ô đầu tiên màu cam chứa chữ cái gợi ý đầu tiên
                          Container(
                            width: 17,
                            height: 20,
                            decoration: BoxDecoration(
                              color: matchedLettersCount >= 1
                                  ? const Color(0xFFF59E0B)
                                  : const Color(0xFFF97316),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: matchedLettersCount >= 1
                                    ? const Color(0xFFFDE047)
                                    : const Color(0xFFFB923C),
                                width: 1.2,
                              ),
                              boxShadow: matchedLettersCount >= 1
                                  ? [
                                      BoxShadow(
                                        color: const Color(0xFFF59E0B).withValues(alpha: 0.6),
                                        blurRadius: 6,
                                        spreadRadius: 1,
                                      ),
                                    ]
                                  : null,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              firstLetter,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 3),

                          // Các ô vuông còn lại (sáng lên khi người chơi gõ đúng các chữ tiếp theo)
                          ...List.generate(max(0, letterCount - 1), (i) {
                            final slotIndex = i + 1;
                            final isFilled = slotIndex < matchedLettersCount;
                            final charAtSlot = slotIndex < englishTitle.length ? englishTitle[slotIndex] : '';

                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 1.5),
                              width: 15,
                              height: 20,
                              decoration: BoxDecoration(
                                color: isFilled
                                    ? const Color(0xFFF59E0B)
                                    : const Color(0xFF0F172A).withValues(alpha: 0.85),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: isFilled ? const Color(0xFFFDE047) : const Color(0xFF334155),
                                  width: 1.0,
                                ),
                                boxShadow: isFilled
                                    ? [
                                        BoxShadow(
                                          color: const Color(0xFFF59E0B).withValues(alpha: 0.5),
                                          blurRadius: 5,
                                          spreadRadius: 0.5,
                                        ),
                                      ]
                                    : null,
                              ),
                              alignment: Alignment.center,
                              child: isFilled
                                  ? Text(
                                      charAtSlot,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Container(
                                      width: 3.5,
                                      height: 3.5,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF475569),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }

  Widget _buildGameOverOverlay() {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withValues(alpha: 0.82),
        alignment: Alignment.center,
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 380),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFEF4444).withValues(alpha: 0.5),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFEF4444).withValues(alpha: 0.2),
                    blurRadius: 24,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.heart_broken_rounded, color: Color(0xFFEF4444), size: 48),
                  const SizedBox(height: 8),
                  const Text(
                    'HẾT MẠNG! (GAME OVER)',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Điểm: $_score PTS  •  Nổ: $_blastedCount  •  Lỡ: $_missedCount\nChuỗi kỷ lục: x$_maxCombo',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12, color: Color(0xFFCBD5E1), height: 1.4),
                  ),
                  const SizedBox(height: 14),

                  if (_failedWords.isNotEmpty) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFEF4444).withValues(alpha: 0.25)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Các từ đã rơi qua vạch (cần ôn lại):',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFFCA5A5)),
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: _failedWords.take(6).map((w) {
                              final meaning = w.viword.isNotEmpty ? w.viword : w.description;
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEF4444).withValues(alpha: 0.25),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: const Color(0xFFEF4444).withValues(alpha: 0.4)),
                                ),
                                child: Text(
                                  '${w.title}: $meaning',
                                  style: const TextStyle(fontSize: 11, color: Colors.white),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],

                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      OutlinedButton.icon(
                        onPressed: _resetGame,
                        icon: const Icon(Icons.refresh_rounded, size: 16, color: Colors.white),
                        label: const Text('Chơi lại', style: TextStyle(color: Colors.white, fontSize: 13)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white54),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        ),
                      ),
                      if (widget.onChangeMode != null)
                        ElevatedButton.icon(
                          onPressed: widget.onChangeMode,
                          icon: const Icon(Icons.swap_horiz_rounded, size: 16),
                          label: const Text('Đổi chế độ', style: TextStyle(fontSize: 13)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3F86E0),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVictoryOverlay() {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withValues(alpha: 0.85),
        alignment: Alignment.center,
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 380),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.5),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFF59E0B).withValues(alpha: 0.2),
                    blurRadius: 24,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.emoji_events_rounded, color: Color(0xFFF59E0B), size: 50),
                  const SizedBox(height: 8),
                  const Text(
                    'CHIẾN THẮNG XUẤT SẮC! 🏆',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Bạn đã hoàn thành tất cả $_blastedCount từ vựng!',
                    style: const TextStyle(fontSize: 13, color: Color(0xFFCBD5E1)),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Tổng điểm: $_score PTS  •  Chuỗi kỷ lục: x$_maxCombo',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFFFDE68A)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      OutlinedButton.icon(
                        onPressed: _resetGame,
                        icon: const Icon(Icons.refresh_rounded, size: 16, color: Colors.white),
                        label: const Text('Chơi lại', style: TextStyle(color: Colors.white, fontSize: 13)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white54),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        ),
                      ),
                      if (widget.onChangeMode != null)
                        ElevatedButton.icon(
                          onPressed: widget.onChangeMode,
                          icon: const Icon(Icons.check_circle_outline, size: 16),
                          label: const Text('Đổi chế độ', style: TextStyle(fontSize: 13)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF10B981),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPauseOverlay() {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withValues(alpha: 0.65),
        alignment: Alignment.center,
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 340),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.pause_circle_outline_rounded, color: Colors.white, size: 46),
                  const SizedBox(height: 8),
                  const Text(
                    'ĐANG TẠM DỪNG',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _gameState = _CosmicGameState.playing;
                          });
                          _focusNode.requestFocus();
                        },
                        icon: const Icon(Icons.play_arrow_rounded, size: 18),
                        label: const Text('Tiếp tục', style: TextStyle(fontSize: 13)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3F86E0),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        ),
                      ),
                      OutlinedButton(
                        onPressed: _resetGame,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white54),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        ),
                        child: const Text('Chơi lại', style: TextStyle(color: Colors.white, fontSize: 13)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// --- CÁC HỌA SĨ CUSTOM PAINTER ---

/// Vẽ các vì sao lấp lánh trong không gian vũ trụ
class _StarfieldPainter extends CustomPainter {
  final List<Offset> stars;
  const _StarfieldPainter({required this.stars});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (int i = 0; i < stars.length; i++) {
      final star = stars[i];
      final pos = Offset(star.dx * size.width, star.dy * size.height);
      final radius = (i % 3 == 0) ? 1.6 : (i % 2 == 0 ? 1.2 : 0.8);
      paint.color = Colors.white.withValues(alpha: (0.3 + (i % 5) * 0.15));
      canvas.drawCircle(pos, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _StarfieldPainter oldDelegate) => false;
}

/// Vẽ đường nét đứt màu đỏ (Laser Barrier)
class _DashedLinePainter extends CustomPainter {
  final Color color;
  final double dashWidth;
  final double dashSpace;

  const _DashedLinePainter({
    required this.color,
    this.dashWidth = 7,
    this.dashSpace = 5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke;

    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter oldDelegate) => false;
}

/// Vẽ hình chóp tam giác neon chỉ hướng rơi
class _NeonConePainter extends CustomPainter {
  final Color color;
  const _NeonConePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..close();

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _NeonConePainter oldDelegate) => false;
}

/// Vẽ đường đạn tên lửa bắn thẳng vào mục tiêu từ vựng
class _RocketBulletPainter extends CustomPainter {
  final Offset start;
  final Offset end;
  final double opacity;
  final double progress;

  const _RocketBulletPainter({
    required this.start,
    required this.end,
    required this.opacity,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (opacity <= 0.0) return;

    final direction = end - start;
    final distance = direction.distance;
    if (distance <= 0) return;

    final currentPos = Offset.lerp(start, end, progress.clamp(0.0, 1.0))!;

    // 1. Vệt khói lửa / vệt năng lượng laser kéo theo sau đạn
    final trailStartProgress = max(0.0, progress - 0.35);
    final trailStart = Offset.lerp(start, end, trailStartProgress)!;

    final trailPaint = Paint()
      ..color = const Color(0xFFF59E0B).withValues(alpha: opacity * 0.7)
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    final trailGlow = Paint()
      ..color = const Color(0xFFEF4444).withValues(alpha: opacity * 0.4)
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(trailStart, currentPos, trailGlow);
    canvas.drawLine(trailStart, currentPos, trailPaint);

    // 2. Đầu đạn tên lửa phát sáng rực rỡ tại currentPos
    final bulletAngle = atan2(direction.dy, direction.dx);
    canvas.save();
    canvas.translate(currentPos.dx, currentPos.dy);
    canvas.rotate(bulletAngle);

    // Vòng hào quang năng lượng đạn
    final bulletGlow = Paint()
      ..color = const Color(0xFFFDE047).withValues(alpha: opacity * 0.9)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(Offset.zero, 8, bulletGlow);

    // Thân viên đạn tên lửa (hình con nhộng / elip dài)
    final bulletBody = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFFFFFFF), Color(0xFFFBBF24), Color(0xFFEF4444)],
      ).createShader(const Rect.fromLTWH(-10, -4, 20, 8));
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset.zero, width: 20, height: 7),
        const Radius.circular(3.5),
      ),
      bulletBody,
    );

    // Lõi trắng sáng của đầu đạn
    final bulletCore = Paint()..color = Colors.white;
    canvas.drawCircle(const Offset(4, 0), 2.5, bulletCore);

    canvas.restore();

    // 3. Hiệu ứng tia lửa va chạm bùng nổ khi đạn gần tới mục tiêu
    if (progress >= 0.7) {
      final impactProgress = ((progress - 0.7) / 0.3).clamp(0.0, 1.0);
      final impactPaint = Paint()
        ..color = const Color(0xFFF59E0B).withValues(alpha: (1.0 - impactProgress) * opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
      canvas.drawCircle(end, impactProgress * 22, impactPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RocketBulletPainter oldDelegate) => true;
}

/// Tên lửa chiến hạm không gian thay thế cho mặt trời
class _CosmicRocketCannon extends StatelessWidget {
  const _CosmicRocketCannon();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 60,
      height: 72,
      child: CustomPaint(
        painter: _RocketCannonPainter(),
      ),
    );
  }
}

class _RocketCannonPainter extends CustomPainter {
  const _RocketCannonPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;

    // 1. Ngọn lửa phản lực phụt ra từ đuôi tên lửa (Thruster exhaust fire)
    final outerFlame = Path()
      ..moveTo(cx - 7, 52)
      ..quadraticBezierTo(cx - 12, 62, cx, size.height - 2)
      ..quadraticBezierTo(cx + 12, 62, cx + 7, 52)
      ..close();
    final flamePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFF59E0B), Color(0xFFEF4444), Colors.transparent],
      ).createShader(Rect.fromLTWH(cx - 12, 52, 24, 20));
    canvas.drawPath(outerFlame, flamePaint);

    // Lõi lửa vàng sáng bên trong
    final innerFlame = Path()
      ..moveTo(cx - 4, 52)
      ..quadraticBezierTo(cx - 5, 59, cx, 64)
      ..quadraticBezierTo(cx + 5, 59, cx + 4, 52)
      ..close();
    final innerFlamePaint = Paint()..color = const Color(0xFFFEF08A);
    canvas.drawPath(innerFlame, innerFlamePaint);

    // 2. Cánh đuôi hai bên (Fins)
    final leftFin = Path()
      ..moveTo(cx - 10, 36)
      ..lineTo(cx - 24, 52)
      ..lineTo(cx - 10, 50)
      ..close();
    final finPaint = Paint()..color = const Color(0xFFE11D48); // Đỏ thắm phi thuyền
    canvas.drawPath(leftFin, finPaint);

    final rightFin = Path()
      ..moveTo(cx + 10, 36)
      ..lineTo(cx + 24, 52)
      ..lineTo(cx + 10, 50)
      ..close();
    canvas.drawPath(rightFin, finPaint);

    // Viền cánh đậm
    final finBorder = Paint()
      ..color = const Color(0xFF9F1239)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawPath(leftFin, finBorder);
    canvas.drawPath(rightFin, finBorder);

    // 3. Ống xả động cơ (Nozzle)
    final nozzleRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(cx - 7, 49, 14, 6),
      const Radius.circular(2),
    );
    final nozzlePaint = Paint()..color = const Color(0xFF334155);
    canvas.drawRRect(nozzleRect, nozzlePaint);

    // 4. Thân tên lửa (Fuselage) hình khí động học
    final bodyPath = Path()
      ..moveTo(cx, 4) // Mũi tên lửa nhọn
      ..cubicTo(cx + 16, 18, cx + 13, 44, cx + 9, 50)
      ..lineTo(cx - 9, 50)
      ..cubicTo(cx - 13, 44, cx - 16, 18, cx, 4)
      ..close();

    final bodyPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Color(0xFFE2E8F0),
          Color(0xFFFFFFFF),
          Color(0xFFCBD5E1),
        ],
      ).createShader(Rect.fromLTWH(cx - 14, 4, 28, 46));
    canvas.drawPath(bodyPath, bodyPaint);

    // Viền thân tên lửa
    final bodyBorder = Paint()
      ..color = const Color(0xFF64748B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    canvas.drawPath(bodyPath, bodyBorder);

    // 5. Mũi tên lửa màu đỏ nổi bật (Nose cone)
    final nosePath = Path()
      ..moveTo(cx, 4)
      ..cubicTo(cx + 8, 12, cx + 9, 16, cx + 8, 18)
      ..lineTo(cx - 8, 18)
      ..cubicTo(cx - 9, 16, cx - 8, 12, cx, 4)
      ..close();
    final nosePaint = Paint()..color = const Color(0xFFE11D48);
    canvas.drawPath(nosePath, nosePaint);

    // Vành nòng pháo laser ở đỉnh mũi tên lửa
    final barrelPaint = Paint()..color = const Color(0xFFFBBF24);
    canvas.drawCircle(Offset(cx, 4), 2.5, barrelPaint);

    // 6. Cửa sổ buồng lái phi hành gia (Cockpit window kính vòm xanh)
    final windowCenter = Offset(cx, 28);
    final windowOuter = Paint()..color = const Color(0xFF0F172A);
    canvas.drawCircle(windowCenter, 6.5, windowOuter);

    final windowInner = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.3, -0.3),
        colors: [Color(0xFF67E8F9), Color(0xFF0284C7)],
      ).createShader(Rect.fromCircle(center: windowCenter, radius: 5.5));
    canvas.drawCircle(windowCenter, 5.5, windowInner);

    // Đốm sáng phản chiếu trên kính buồng lái
    final glintPaint = Paint()..color = Colors.white.withValues(alpha: 0.85);
    canvas.drawCircle(Offset(cx - 1.8, 26.2), 1.6, glintPaint);

    // 7. Sọc trang trí công nghệ màu cam trên thân
    final stripePaint = Paint()
      ..color = const Color(0xFFF59E0B)
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(cx - 8, 38), Offset(cx + 8, 38), stripePaint);
  }

  @override
  bool shouldRepaint(covariant _RocketCannonPainter oldDelegate) => false;
}
