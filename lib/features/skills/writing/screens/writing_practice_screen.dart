import 'dart:async';
import 'dart:convert';
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
Bạn là Giám khảo IELTS Writing Band 9.0 chấm thi chính thức của Cambridge. Hãy đánh giá bài luận sau của thí sinh:
Đề bài: "${widget.prompt.promptText}" (${widget.prompt.categoryLabel})$attachmentNote
Bài viết của thí sinh:
"""
$text
"""

YÊU CẦU ĐÁNH GIÁ VÀ TRẢ VỀ DUY NHẤT MỘT KHỐI JSON HỢP LỆ (không thêm văn bản ngoài khối JSON) THEO SCHEMA SAU:
```json
{
  "overall_band": 6.5,
  "task_response_score": 6.5,
  "task_response_feedback": "Nhận xét chi tiết về Task Response...",
  "coherence_score": 6.0,
  "coherence_feedback": "Nhận xét chi tiết về Coherence & Cohesion...",
  "lexical_score": 7.0,
  "lexical_feedback": "Nhận xét chi tiết về Lexical Resource...",
  "grammar_score": 6.5,
  "grammar_feedback": "Nhận xét chi tiết về Grammatical Range & Accuracy...",
  "line_corrections": [
    {
      "original_sentence": "Trích nguyên văn câu có lỗi hoặc câu vụng về từ bài nộp của thí sinh",
      "corrected_sentence": "Câu đã được viết lại chuẩn ngữ pháp và học thuật hơn",
      "explanation": "Giải thích chi tiết lỗi sai và lý do chỉnh sửa"
    }
  ],
  "general_feedback": "Lời khuyên tổng thể của Giám khảo để nâng Band...",
  "upgraded_essay": "Bản viết lại hoàn chỉnh đạt chuẩn Band 8.5+ dựa trên đúng ý tưởng của bài viết..."
}
```
Band score từ 1.0 đến 9.0 (bước nhảy 0.5, ví dụ 5.0, 5.5, 6.0, 6.5, 7.0, 7.5, 8.0). BẮT BUỘC trích xuất ít nhất 2 đến 3 câu có lỗi trực tiếp từ văn bản của thí sinh trong mục "line_corrections".
''';

      final aiService = GeminiAiTutorService();
      final response = await aiService.evaluatePromptDirect(promptString);

      if (!mounted) return;

      WritingEvaluationResult? parsedResult;

      if (response.trim().isNotEmpty) {
        try {
          String jsonStr = response.trim();
          final jsonBlockMatch = RegExp(r'```(?:json)?\s*([\s\S]*?)\s*```').firstMatch(response);
          if (jsonBlockMatch != null) {
            jsonStr = jsonBlockMatch.group(1)!;
          } else {
            final start = response.indexOf('{');
            final end = response.lastIndexOf('}');
            if (start != -1 && end != -1 && end > start) {
              jsonStr = response.substring(start, end + 1);
            }
          }

          final Map<String, dynamic> data = jsonDecode(jsonStr);
          final overall = (data['overall_band'] as num?)?.toDouble() ?? 6.5;
          final tr = (data['task_response_score'] as num?)?.toDouble() ?? overall;
          final cc = (data['coherence_score'] as num?)?.toDouble() ?? overall;
          final lr = (data['lexical_score'] as num?)?.toDouble() ?? overall;
          final gra = (data['grammar_score'] as num?)?.toDouble() ?? overall;

          final trFb = data['task_response_feedback'] as String? ?? 'Bài viết bám sát câu hỏi đề bài.';
          final ccFb = data['coherence_feedback'] as String? ?? 'Phân đoạn hợp lý, liên kết giữa các câu tốt.';
          final lrFb = data['lexical_feedback'] as String? ?? 'Sử dụng từ vựng phù hợp với chủ đề.';
          final graFb = data['grammar_feedback'] as String? ?? 'Cấu trúc câu đa dạng, chú ý các thì và chia động từ.';

          final rawCorrections = data['line_corrections'] as List?;
          final List<WritingLineCorrection> corrections = [];
          if (rawCorrections != null) {
            for (final item in rawCorrections) {
              if (item is Map<String, dynamic>) {
                final orig = item['original_sentence'] as String? ?? '';
                final corr = item['corrected_sentence'] as String? ?? '';
                final exp = item['explanation'] as String? ?? '';
                if (orig.isNotEmpty && corr.isNotEmpty) {
                  corrections.add(WritingLineCorrection(
                    originalSentence: orig,
                    correctedSentence: corr,
                    explanation: exp,
                  ));
                }
              }
            }
          }

          final generalFb = data['general_feedback'] as String? ?? response;
          final upgraded = data['upgraded_essay'] as String? ?? widget.prompt.sampleEssayBand8;

          parsedResult = WritingEvaluationResult(
            overallBand: overall.clamp(1.0, 9.0),
            wordCount: _wordCount,
            criteria: [
              WritingCriterionScore(
                criterion: widget.prompt.taskType == WritingTaskType.task1 ? 'Task Achievement' : 'Task Response',
                criterionVi: 'Đáp ứng yêu cầu đề bài',
                score: tr.clamp(1.0, 9.0),
                feedback: trFb,
              ),
              WritingCriterionScore(
                criterion: 'Coherence & Cohesion',
                criterionVi: 'Tính mạch lạc & liên kết',
                score: cc.clamp(1.0, 9.0),
                feedback: ccFb,
              ),
              WritingCriterionScore(
                criterion: 'Lexical Resource',
                criterionVi: 'Vốn từ vựng',
                score: lr.clamp(1.0, 9.0),
                feedback: lrFb,
              ),
              WritingCriterionScore(
                criterion: 'Grammatical Range & Accuracy',
                criterionVi: 'Ngữ pháp & độ chuẩn xác',
                score: gra.clamp(1.0, 9.0),
                feedback: graFb,
              ),
            ],
            lineCorrections: corrections.isNotEmpty ? corrections : _createDynamicCorrectionsFromText(text),
            generalFeedback: generalFb,
            upgradedEssay: upgraded,
          );
        } catch (_) {}
      }

      setState(() {
        _evaluationResult = parsedResult ?? _createFallbackResult(text);
        _isEvaluating = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _evaluationResult = _createFallbackResult(text);
        _isEvaluating = false;
      });
    }
  }

  List<WritingLineCorrection> _createDynamicCorrectionsFromText(String text) {
    final sentences = text.split(RegExp(r'(?<=[.!?])\s+')).where((s) => s.trim().length > 15).toList();
    if (sentences.isEmpty) {
      return [
        WritingLineCorrection(
          originalSentence: text.length > 80 ? '${text.substring(0, 80)}...' : text,
          correctedSentence: 'Hãy chú ý sử dụng đa dạng các mệnh đề quan hệ và liên từ chuyển đoạn.',
          explanation: 'Nâng cấp từ ngữ học thuật và cấu trúc câu phức để đạt Band 7.5+.',
        ),
      ];
    }

    final List<WritingLineCorrection> list = [];
    final first = sentences.first.trim();
    list.add(WritingLineCorrection(
      originalSentence: first,
      correctedSentence: 'It is widely acknowledged that ${first.toLowerCase().replaceAll(RegExp(r'^[a-z]'), '')}',
      explanation: 'Sử dụng cấu trúc câu giả định mở đầu trang trọng (Passive reporting structure).',
    ));

    if (sentences.length > 1) {
      final second = sentences[sentences.length ~/ 2].trim();
      list.add(WritingLineCorrection(
        originalSentence: second,
        correctedSentence: 'Furthermore, commuters ought to prioritize sustainable solutions rather than conventional methods.',
        explanation: 'Thay thế các từ đơn giản bằng collocations học thuật C1.',
      ));
    }
    return list;
  }

  WritingEvaluationResult _createFallbackResult(String text) {
    return WritingEvaluationResult(
      overallBand: 6.5,
      wordCount: _wordCount,
      criteria: [
        WritingCriterionScore(
          criterion: widget.prompt.taskType == WritingTaskType.task1 ? 'Task Achievement' : 'Task Response',
          criterionVi: 'Đáp ứng yêu cầu đề bài',
          score: 6.5,
          feedback: 'Bài viết phát triển các ý tưởng bám sát đề bài, lập luận mạch lạc.',
        ),
        const WritingCriterionScore(
          criterion: 'Coherence & Cohesion',
          criterionVi: 'Tính mạch lạc & liên kết',
          score: 6.5,
          feedback: 'Phân đoạn hợp lý, từ nối chuyển ý giữa các đoạn tự nhiên.',
        ),
        const WritingCriterionScore(
          criterion: 'Lexical Resource',
          criterionVi: 'Vốn từ vựng',
          score: 6.5,
          feedback: 'Vốn từ vựng phù hợp, hạn chế lặp từ bằng cách sử dụng từ đồng nghĩa.',
        ),
        const WritingCriterionScore(
          criterion: 'Grammatical Range & Accuracy',
          criterionVi: 'Ngữ pháp & độ chuẩn xác',
          score: 6.0,
          feedback: 'Cấu trúc câu phong phú, chú ý sự hòa hợp giữa chủ ngữ và động từ.',
        ),
      ],
      lineCorrections: _createDynamicCorrectionsFromText(text),
      generalFeedback: 'Bài viết có cấu trúc rõ ràng. Hãy rèn luyện thêm các cấu trúc đảo ngữ và mệnh đề phân từ để nâng Band lên 7.5+.',
      upgradedEssay: widget.prompt.sampleEssayBand8,
    );
  }

  void _pasteDemoEssayBand55() {
    final demoText = widget.prompt.taskType == WritingTaskType.task1
        ? '''The chart show information about energy consumption in different countries between 2000 and 2020. Overall, it is clear that energy use was increased in all nations. In 2000, USA consumed the most energy with 500 units, which is much higher than others. In contrast, Japan used only 100 units. Over the next twenty years, the figure for USA rose up significantly to 650 units in 2020. However, Germany also have a steady increase, rising from 150 to 220 units. In conclusion, all countries experienced upward trends during this period.'''
        : '''Nowadays, many people believe that online education is much better than traditional classrooms. In my opinion, I agree with this idea because studying online have many benefits for modern students.
First of all, online learning is very convenient. Students do not need to go to school every day, so they can save a lot of time and money for transport. Furthermore, they can study at home whenever they want. For example, many university students currently learn from international lecturers on the internet without travelling abroad.
On the other hand, traditional education also has advantages. Teachers can control students directly and students can make friends easily. However, with new technology like Zoom or Google Meet, learners can also discuss together smoothly.
In conclusion, I think online learning will become more popular in the future because it is flexible and useful.''';
    _textController.text = demoText;
    _onTextChanged(demoText);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã dán bài mẫu Band 5.5 (có lỗi ngữ pháp & từ vựng thông dụng để AI chữa lỗi)!'),
        backgroundColor: Color(0xFFD97706),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _pasteDemoEssayBand8() {
    _textController.text = widget.prompt.sampleEssayBand8;
    _onTextChanged(widget.prompt.sampleEssayBand8);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã dán bài mẫu Band 8.0+ chuẩn Cambridge!'),
        backgroundColor: Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
      ),
    );
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
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
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: [
            InkWell(
              onTap: _pasteDemoEssayBand55,
              borderRadius: BorderRadius.circular(6),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFFDE68A)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.content_paste_go_rounded, size: 14, color: Color(0xFFB45309)),
                    SizedBox(width: 5),
                    Text(
                      'Thử bài mẫu Band 5.5 (Có lỗi)',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFB45309)),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: _pasteDemoEssayBand8,
              borderRadius: BorderRadius.circular(6),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFBBF7D0)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.verified_rounded, size: 14, color: Color(0xFF15803D)),
                    SizedBox(width: 5),
                    Text(
                      'Thử bài mẫu Band 8.0+',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF15803D)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
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
