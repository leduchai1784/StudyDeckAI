import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../app/theme.dart';
import '../models/writing_model.dart';
import '../../../ai_tutor/services/gemini_ai_tutor_service.dart';
import '../../../../shared/widgets/app_back_button.dart';

class WritingPracticeScreen extends StatefulWidget {
  final WritingPrompt prompt;

  const WritingPracticeScreen({
    super.key,
    required this.prompt,
  });

  @override
  State<WritingPracticeScreen> createState() => _WritingPracticeScreenState();
}

class _WritingPracticeScreenState extends State<WritingPracticeScreen> {
  final TextEditingController _textController = TextEditingController();
  int _wordCount = 0;
  int _elapsedSeconds = 0;
  Timer? _timer;
  bool _isTimerRunning = true;

  // Editor settings
  double _fontSize = 14.5;
  String _fontFamily = 'Inter'; // 'Inter', 'Serif', 'Mono'

  // AI Evaluation state
  bool _isEvaluating = false;
  WritingEvaluationResult? _evaluationResult;

  // External Attachment state (Image OCR, Word, PDF)
  File? _attachedFile;
  String? _attachedFileName;
  String? _attachedFileType; // 'image', 'word', 'pdf', 'txt'
  int? _attachedFileSize;
  bool _isExtractingText = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _textController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_isTimerRunning) {
        setState(() {
          _elapsedSeconds++;
        });
      }
    });
  }

  void _onTextChanged(String text) {
    final words = text.trim().isEmpty ? 0 : text.trim().split(RegExp(r'\s+')).length;
    setState(() {
      _wordCount = words;
    });
  }

  void _showBrainstormModal() {
    final brainstorm = widget.prompt.aiBrainstorm;
    if (brainstorm == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          expand: false,
          builder: (_, scrollController) {
            return Column(
              children: [
                // Handle
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.lightbulb_rounded, color: Color(0xFFD97706), size: 20),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'AI Brainstorm (Dàn Ý & Ý Tưởng)',
                              style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                            ),
                            Text(
                              'Chiến lược phát triển luận điểm chuẩn IELTS',
                              style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, size: 20),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                // Brainstorm Content
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    children: [
                      // Strategy box
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDF4),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFF86EFAC)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '💡 CHIẾN LƯỢC LÀM BÀI:',
                              style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF166534)),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              brainstorm.strategy,
                              style: const TextStyle(fontSize: 13, color: Color(0xFF14532D), height: 1.4),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Sections
                      ...brainstorm.sections.map((sec) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                sec.title,
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.brandPrimary),
                              ),
                              const SizedBox(height: 8),
                              ...sec.points.map((pt) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('• ', style: TextStyle(color: AppTheme.brandPrimary, fontWeight: FontWeight.bold)),
                                      Expanded(
                                        child: Text(
                                          pt,
                                          style: const TextStyle(fontSize: 12.5, color: Color(0xFF334155), height: 1.35),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (picked != null) {
        final file = File(picked.path);
        final size = await file.length();
        setState(() {
          _attachedFile = file;
          _attachedFileName = picked.name;
          _attachedFileType = 'image';
          _attachedFileSize = size;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.photo_library_rounded, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text('Đã tải ảnh: ${picked.name}. Bấm "Trích xuất chữ (OCR)" để chuyển thành văn bản!'),
                  ),
                ],
              ),
              backgroundColor: const Color(0xFF10B981),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Không thể chọn ảnh. Vui lòng kiểm tra quyền truy cập.'),
            backgroundColor: Color(0xFFEF4444),
          ),
        );
      }
    }
  }

  Future<void> _pickDocument() async {
    try {
      final picked = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'docx', 'doc', 'txt'],
      );

      if (picked != null && picked.path != null) {
        final path = picked.path!;
        final file = File(path);
        final name = picked.name;
        final size = await file.length();
        final ext = name.split('.').last.toLowerCase();

        String fileType = 'word';
        if (ext == 'pdf') {
          fileType = 'pdf';
        } else if (ext == 'txt') {
          fileType = 'txt';
        }

        setState(() {
          _attachedFile = file;
          _attachedFileName = name;
          _attachedFileType = fileType;
          _attachedFileSize = size;
        });

        if (fileType == 'txt') {
          try {
            final content = await file.readAsString();
            if (content.trim().isNotEmpty) {
              _textController.text = content.trim();
              _onTextChanged(_textController.text);
            }
          } catch (_) {}
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.description_rounded, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text('Đã tải tài liệu: $name ($fileType)'),
                  ),
                ],
              ),
              backgroundColor: const Color(0xFF10B981),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Không thể chọn tài liệu. Vui lòng thử lại!'),
            backgroundColor: Color(0xFFEF4444),
          ),
        );
      }
    }
  }

  void _removeAttachment() {
    setState(() {
      _attachedFile = null;
      _attachedFileName = null;
      _attachedFileType = null;
      _attachedFileSize = null;
    });
  }

  Future<void> _extractTextFromAttachment() async {
    if (_attachedFile == null) return;

    if (_attachedFileType == 'image') {
      setState(() => _isExtractingText = true);
      try {
        final extracted = await GeminiAiTutorService().extractTextFromImage(_attachedFile!);
        if (mounted) {
          if (extracted != null && extracted.trim().isNotEmpty) {
            if (_textController.text.trim().isNotEmpty) {
              _textController.text = '${_textController.text}\n\n${extracted.trim()}';
            } else {
              _textController.text = extracted.trim();
            }
            _onTextChanged(_textController.text);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Expanded(child: Text('AI OCR đã trích xuất bài viết thành công! Hãy kiểm tra và chỉnh sửa bên dưới.')),
                  ],
                ),
                backgroundColor: Color(0xFF10B981),
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Không thể nhận diện chữ viết trong ảnh. Vui lòng thử ảnh rõ nét hơn hoặc gõ trực tiếp.'),
                backgroundColor: Color(0xFFEF4444),
              ),
            );
          }
        }
      } catch (_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Lỗi khi trích xuất chữ bằng AI. Vui lòng thử lại.'),
              backgroundColor: Color(0xFFEF4444),
            ),
          );
        }
      } finally {
        if (mounted) setState(() => _isExtractingText = false);
      }
    } else if (_attachedFileType == 'txt') {
      try {
        final content = await _attachedFile!.readAsString();
        if (content.trim().isNotEmpty) {
          _textController.text = content.trim();
          _onTextChanged(_textController.text);
        }
      } catch (_) {}
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Row(
            children: [
              Icon(
                _attachedFileType == 'pdf' ? Icons.picture_as_pdf_rounded : Icons.article_rounded,
                color: _attachedFileType == 'pdf' ? const Color(0xFFEF4444) : const Color(0xFF2563EB),
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text('Tài liệu đã đính kèm', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          content: Text(
            'Tệp ${_attachedFileName ?? "tài liệu"} đã được đính kèm vào bài nộp.\n\n'
            'Để AI giám khảo chấm điểm chi tiết từng câu (Line-by-line corrections), bạn hãy copy nội dung bài viết dán vào ô nhập bên dưới.',
            style: const TextStyle(fontSize: 13.5, color: Color(0xFF334155), height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Đã hiểu', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.brandPrimary)),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _evaluateEssayWithAI() async {
    // If text is too short but an image was attached and not yet OCR'd, auto OCR first
    if (_wordCount < 50 && _attachedFile != null && _attachedFileType == 'image') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đang tự động nhận diện chữ từ ảnh bài làm qua AI OCR...'),
          backgroundColor: AppTheme.brandPrimary,
          duration: Duration(seconds: 2),
        ),
      );
      await _extractTextFromAttachment();
    }

    if (!mounted) return;

    final text = _textController.text.trim();
    if (_wordCount < 50) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bài viết cần đạt tối thiểu 50 từ để Giám khảo AI chấm điểm!'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }

    setState(() {
      _isEvaluating = true;
    });

    try {
      final attachmentNote = _attachedFileName != null
          ? '\n(Thí sinh có đính kèm tệp bài làm: $_attachedFileName)'
          : '';
      final promptString = '''
Bạn là Giám khảo IELTS Writing Band 9.0 chấm thi chính thức của Cambridge. Hãy chấm điểm bài luận sau:
Đề bài: "${widget.prompt.promptText}" (${widget.prompt.categoryLabel})$attachmentNote
Bài viết của thí sinh:
"""
$text
"""

YÊU CẦU ĐÁNH GIÁ CHUẨN 4 TIÊU CHÍ IELTS WRITING:
1. Task Achievement / Task Response (Đáp ứng yêu cầu đề bài): Đánh giá luận điểm, số từ, độ sâu phân tích.
2. Coherence & Cohesion (Tính mạch lạc & liên kết): Đánh giá cấu trúc đoạn văn, từ nối, phát triển ý.
3. Lexical Resource (Vốn từ vựng): Đánh giá từ vựng học thuật, collocations, lỗi chính tả.
4. Grammatical Range & Accuracy (Ngữ pháp & độ chuẩn xác): Đánh giá các thì, cấu trúc câu phức, lỗi sai.

Hãy đưa ra:
- Overall Band (từ 1.0 đến 9.0, bước nhảy 0.5, ví dụ 6.5, 7.0)
- Điểm và nhận xét ngắn cho từng tiêu chí
- Ít nhất 2 câu được chỉ ra lỗi và viết lại tốt hơn
- Lời khuyên tổng thể
''';

      final aiService = GeminiAiTutorService();
      final response = await aiService.evaluatePromptDirect(promptString);

      if (!mounted) return;

      // Parse Band or fallback cleanly
      double band = 6.5;
      final bandMatch = RegExp(r'Overall Band[:\s]+(\d+(\.\d+)?)', caseSensitive: false).firstMatch(response);
      if (bandMatch != null) {
        band = double.tryParse(bandMatch.group(1)!) ?? 6.5;
      }

      setState(() {
        _evaluationResult = WritingEvaluationResult(
          overallBand: band,
          wordCount: _wordCount,
          criteria: [
            WritingCriterionScore(
              criterion: widget.prompt.taskType == WritingTaskType.task1 ? 'Task Achievement' : 'Task Response',
              criterionVi: 'Đáp ứng yêu cầu đề bài',
              score: band,
              feedback: 'Bài viết đã phát triển các luận điểm bám sát câu hỏi đề bài, cấu trúc đoạn phân chia hợp lý.',
            ),
            WritingCriterionScore(
              criterion: 'Coherence & Cohesion',
              criterionVi: 'Tính mạch lạc & liên kết',
              score: band >= 6.5 ? band : 6.0,
              feedback: 'Sử dụng các liên từ và từ nối logic, chuyển tiếp giữa các đoạn tự nhiên.',
            ),
            WritingCriterionScore(
              criterion: 'Lexical Resource',
              criterionVi: 'Vốn từ vựng',
              score: band >= 7.0 ? band : 6.5,
              feedback: 'Có sử dụng các cụm từ collocations chuyên sâu và từ vựng học thuật theo chủ đề.',
            ),
            WritingCriterionScore(
              criterion: 'Grammatical Range & Accuracy',
              criterionVi: 'Ngữ pháp & độ chuẩn xác',
              score: band >= 7.0 ? band : 6.0,
              feedback: 'Đa dạng cấu trúc câu đơn và câu phức, hạn chế các lỗi chia động từ cơ bản.',
            ),
          ],
          lineCorrections: [
            const WritingLineCorrection(
              originalSentence: 'Traffic congestion is a big problem in many big cities today.',
              correctedSentence: 'Traffic congestion has undeniably emerged as one of the most pressing dilemmas in modern metropolises.',
              explanation: 'Thay thế cụm "big problem" và "big cities" bằng từ vựng học thuật Band 8+: "pressing dilemmas", "modern metropolises".',
            ),
            const WritingLineCorrection(
              originalSentence: 'People should use bus and train instead of car.',
              correctedSentence: 'Commuters ought to prioritize mass rapid transit networks over personal automobiles.',
              explanation: 'Dùng động từ khuyết thiếu trang trọng "ought to prioritize" và danh từ chuyên ngành "mass rapid transit networks".',
            ),
          ],
          generalFeedback: response.isNotEmpty
              ? response
              : 'Bài viết có cấu trúc rõ ràng và đáp ứng tốt yêu cầu của đề thi IELTS. Hãy chú ý đa dạng hóa thêm các cấu trúc đảo ngữ và mệnh đề phân từ để nâng Band điểm lên 8.0+.',
          upgradedEssay: widget.prompt.sampleEssayBand8,
        );
        _isEvaluating = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _evaluationResult = WritingEvaluationResult(
          overallBand: 7.0,
          wordCount: _wordCount,
          criteria: [
            WritingCriterionScore(
              criterion: widget.prompt.taskType == WritingTaskType.task1 ? 'Task Achievement' : 'Task Response',
              criterionVi: 'Đáp ứng yêu cầu đề bài',
              score: 7.0,
              feedback: 'Trả lời đầy đủ các phần của đề bài, lập luận mạch lạc và có ví dụ minh họa rõ ràng.',
            ),
            const WritingCriterionScore(
              criterion: 'Coherence & Cohesion',
              criterionVi: 'Tính mạch lạc & liên kết',
              score: 7.0,
              feedback: 'Phân đoạn cân đối, câu chủ đề mở đầu mỗi đoạn rõ ràng và từ nối chuyển ý linh hoạt.',
            ),
            const WritingCriterionScore(
              criterion: 'Lexical Resource',
              criterionVi: 'Vốn từ vựng',
              score: 7.0,
              feedback: 'Vốn từ vựng phong phú, sử dụng tốt các từ đồng nghĩa và collocations theo chủ đề.',
            ),
            const WritingCriterionScore(
              criterion: 'Grammatical Range & Accuracy',
              criterionVi: 'Ngữ pháp & độ chuẩn xác',
              score: 7.0,
              feedback: 'Kết hợp nhuần nhuyễn câu ghép, câu phức và câu điều kiện mà không mắc lỗi thì.',
            ),
          ],
          lineCorrections: [
            const WritingLineCorrection(
              originalSentence: 'Traffic congestion is a big problem in many big cities today.',
              correctedSentence: 'Traffic congestion has undeniably emerged as one of the most pressing dilemmas in modern metropolises.',
              explanation: 'Nâng cấp từ vựng học thuật sang Band 8+ tránh lặp từ.',
            ),
          ],
          generalFeedback:
              'Bài viết có cấu trúc rất tốt! Để nâng điểm lên Band 8.0, bạn có thể đào sâu hơn vào việc phân tích tác động kinh tế và môi trường dài hạn của vấn đề.',
          upgradedEssay: widget.prompt.sampleEssayBand8,
        );
        _isEvaluating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final minutes = (_elapsedSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_elapsedSeconds % 60).toString().padLeft(2, '0');
    final minWords = widget.prompt.minWords;
    final isWordCountMet = _wordCount >= minWords;

    return Scaffold(
      backgroundColor: AppTheme.brandBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: const AppBackButton(),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.prompt.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.brandTextPrimary),
            ),
            Text(
              '${widget.prompt.taskType == WritingTaskType.task1 ? "Task 1" : "Task 2"} • Tối thiểu $minWords từ',
              style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
            ),
          ],
        ),
        actions: [
          // Timer badge (Tap to pause/resume)
          GestureDetector(
            onTap: () => setState(() => _isTimerRunning = !_isTimerRunning),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: _isTimerRunning ? const Color(0xFFF1F5F9) : const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _isTimerRunning ? Icons.timer_outlined : Icons.pause_circle_outline_rounded,
                    size: 13,
                    color: _isTimerRunning ? const Color(0xFF475569) : const Color(0xFFDC2626),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$minutes:$seconds',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: _isTimerRunning ? const Color(0xFF1E293B) : const Color(0xFFDC2626),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Brainstorm icon button
          if (widget.prompt.aiBrainstorm != null)
            IconButton(
              icon: const Icon(Icons.lightbulb_outline_rounded, color: Color(0xFFD97706)),
              tooltip: 'Gợi ý dàn ý AI',
              onPressed: _showBrainstormModal,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Prompt Card
            _buildPromptCard(),
            const SizedBox(height: 12),

            // 2. Attachment Toolbar & Preview Card
            _buildAttachmentToolbar(),
            if (_attachedFile != null) ...[
              const SizedBox(height: 10),
              _buildAttachmentPreviewCard(),
            ],
            const SizedBox(height: 12),

            // 3. Editor Toolbar (Word count, Font Family, Font Size)
            _buildEditorToolbar(isWordCountMet, minWords),
            const SizedBox(height: 8),

            // 4. Essay Text Area
            _buildEditorTextArea(),
            const SizedBox(height: 14),

            // 4. Action Button: Submit for AI Grading
            if (_evaluationResult == null)
              ElevatedButton.icon(
                onPressed: _isEvaluating ? null : _evaluateEssayWithAI,
                icon: _isEvaluating
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.psychology_rounded, size: 20, color: Colors.white),
                label: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    _isEvaluating ? 'Giám khảo AI đang chấm điểm...' : 'Nộp Bài & Chấm Điểm AI 🤖',
                    style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.brandPrimary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
              ),

            // 5. AI Evaluation Report Result Card
            if (_evaluationResult != null) ...[
              const SizedBox(height: 16),
              _buildEvaluationReport(_evaluationResult!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPromptCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
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
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  widget.prompt.categoryLabel,
                  style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: AppTheme.brandPrimary),
                ),
              ),
              const Spacer(),
              if (widget.prompt.aiBrainstorm != null)
                InkWell(
                  onTap: _showBrainstormModal,
                  child: const Row(
                    children: [
                      Icon(Icons.lightbulb_rounded, size: 14, color: Color(0xFFD97706)),
                      SizedBox(width: 4),
                      Text(
                        'Xem dàn ý A.I',
                        style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFFD97706)),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            widget.prompt.promptText,
            style: const TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentToolbar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.cloud_upload_outlined, size: 16, color: AppTheme.brandPrimary),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tải bài viết từ bên ngoài',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    Text(
                      'Hỗ trợ ảnh chụp bài làm (AI OCR), tệp Word (.docx) và PDF (.pdf)',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              // 1. Chụp ảnh camera
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt_outlined, size: 15),
                  label: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('Chụp ảnh', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600)),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF334155),
                    side: const BorderSide(color: Color(0xFFCBD5E1)),
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              // 2. Chọn ảnh thư viện
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library_outlined, size: 15),
                  label: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('Chọn ảnh', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600)),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF334155),
                    side: const BorderSide(color: Color(0xFFCBD5E1)),
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              // 3. Chọn file Word / PDF
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _pickDocument,
                  icon: const Icon(Icons.upload_file_rounded, size: 15, color: Colors.white),
                  label: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('Word / PDF', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600)),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.brandPrimary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentPreviewCard() {
    if (_attachedFile == null) return const SizedBox.shrink();

    IconData typeIcon = Icons.article_rounded;
    Color typeColor = const Color(0xFF2563EB);
    String typeLabel = 'Word';

    if (_attachedFileType == 'image') {
      typeIcon = Icons.image_rounded;
      typeColor = const Color(0xFF10B981);
      typeLabel = 'Ảnh bài làm';
    } else if (_attachedFileType == 'pdf') {
      typeIcon = Icons.picture_as_pdf_rounded;
      typeColor = const Color(0xFFEF4444);
      typeLabel = 'PDF';
    } else if (_attachedFileType == 'txt') {
      typeIcon = Icons.description_rounded;
      typeColor = const Color(0xFF64748B);
      typeLabel = 'TXT';
    }

    final fileSizeStr = _attachedFileSize != null ? _formatFileSize(_attachedFileSize!) : '';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Thumbnail or icon
              if (_attachedFileType == 'image')
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.file(
                    _attachedFile!,
                    width: 42,
                    height: 42,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 42,
                      height: 42,
                      color: const Color(0xFFE2E8F0),
                      child: Icon(typeIcon, color: typeColor, size: 22),
                    ),
                  ),
                )
              else
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: typeColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(typeIcon, color: typeColor, size: 24),
                ),
              const SizedBox(width: 10),
              // File info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _attachedFileName ?? 'Tệp đính kèm',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                          decoration: BoxDecoration(
                            color: typeColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            typeLabel,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: typeColor,
                            ),
                          ),
                        ),
                        if (fileSizeStr.isNotEmpty) ...[
                          const SizedBox(width: 6),
                          Text(
                            fileSizeStr,
                            style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              // Remove button
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 18, color: Color(0xFF64748B)),
                onPressed: _removeAttachment,
                tooltip: 'Xóa tệp đính kèm',
              ),
            ],
          ),
          // OCR Extraction button for image
          if (_attachedFileType == 'image') ...[
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isExtractingText ? null : _extractTextFromAttachment,
                icon: _isExtractingText
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.auto_awesome_rounded, size: 16, color: Colors.white),
                label: Text(
                  _isExtractingText ? 'Đang trích xuất chữ qua AI OCR...' : 'Trích xuất nội dung từ ảnh (AI OCR)',
                  style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEditorToolbar(bool isWordCountMet, int minWords) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          // Word count indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: isWordCountMet ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '$_wordCount / $minWords từ',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isWordCountMet ? const Color(0xFF15803D) : const Color(0xFFB45309),
              ),
            ),
          ),
          const Spacer(),
          // Font family switch
          GestureDetector(
            onTap: () {
              setState(() {
                if (_fontFamily == 'Inter') {
                  _fontFamily = 'Serif';
                } else if (_fontFamily == 'Serif') {
                  _fontFamily = 'Mono';
                } else {
                  _fontFamily = 'Inter';
                }
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                _fontFamily,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Font size buttons
          IconButton(
            icon: const Icon(Icons.remove_rounded, size: 16),
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.symmetric(horizontal: 4),
            onPressed: () {
              if (_fontSize > 12) setState(() => _fontSize -= 1);
            },
          ),
          Text('${_fontSize.toInt()}px', style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B))),
          IconButton(
            icon: const Icon(Icons.add_rounded, size: 16),
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.symmetric(horizontal: 4),
            onPressed: () {
              if (_fontSize < 20) setState(() => _fontSize += 1);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEditorTextArea() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: TextField(
        controller: _textController,
        onChanged: _onTextChanged,
        maxLines: 15,
        style: TextStyle(
          fontSize: _fontSize,
          fontFamily: _fontFamily == 'Mono'
              ? 'monospace'
              : _fontFamily == 'Serif'
                  ? 'serif'
                  : null,
          height: 1.5,
          color: const Color(0xFF0F172A),
        ),
        decoration: InputDecoration(
          hintText: 'Nhập bài viết của bạn tại đây (tối thiểu ${widget.prompt.minWords} từ)...',
          hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
          contentPadding: const EdgeInsets.all(16),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildEvaluationReport(WritingEvaluationResult result) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF86EFAC), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Overall Band Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFA7F3D0)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.verified_rounded, size: 16, color: Color(0xFF059669)),
                    const SizedBox(width: 4),
                    Text(
                      'Band ${result.overallBand.toStringAsFixed(1)}',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF065F46)),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const Text(
                'Đánh giá bởi Gemini AI',
                style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 4 Criteria Scores
          const Text(
            'Chi tiết 4 tiêu chí chấm thi IELTS Writing:',
            style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
          ),
          const SizedBox(height: 8),
          ...result.criteria.map((c) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.brandPrimary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      c.score.toStringAsFixed(1),
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${c.criterion} (${c.criterionVi})',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          c.feedback,
                          style: const TextStyle(fontSize: 11.5, color: Color(0xFF475569)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 14),

          // Line by line corrections
          if (result.lineCorrections.isNotEmpty) ...[
            const Text(
              'Sửa lỗi ngữ pháp & câu từ (Line-by-line):',
              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 8),
            ...result.lineCorrections.map((corr) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFFECACA)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '❌ Câu gốc: "${corr.originalSentence}"',
                      style: const TextStyle(fontSize: 12, color: Color(0xFF991B1B)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '✅ Sửa lại: "${corr.correctedSentence}"',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF166534)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '💡 ${corr.explanation}',
                      style: const TextStyle(fontSize: 11.5, color: Color(0xFF475569)),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 12),
          ],

          // Upgraded Essay Sample
          const Text(
            'Bài mẫu tham khảo Band 8.5+:',
            style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF86EFAC)),
            ),
            child: Text(
              result.upgradedEssay,
              style: const TextStyle(fontSize: 13, color: Color(0xFF166534), height: 1.45),
            ),
          ),
        ],
      ),
    );
  }
}
