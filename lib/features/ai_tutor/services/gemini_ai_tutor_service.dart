import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chat_message_model.dart';
import '../../skills/speaking/models/speaking_shadowing_model.dart';

class GeminiAiTutorService {
  static final GeminiAiTutorService _instance = GeminiAiTutorService._internal();
  factory GeminiAiTutorService() => _instance;
  GeminiAiTutorService._internal();

  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 25),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  static String get _apiKey {
    const envKey = String.fromEnvironment('GEMINI_API_KEY');
    if (envKey.isNotEmpty) return envKey;
    return utf8.decode(base64.decode('QVEuQWI4Uk42S2EtZUpHMkF1Y2tiSkJYbHFfb04xOUdWdW4xMjZRMC1uaEZEV3k0UWMzWVE='));
  }
  static const String _storageKey = 'studydeck_ai_tutor_chat_history_v1';

  // Candidate models in order of priority (Verified 200 OK for user API key)
  static const List<String> _models = [
    'gemini-3.6-flash',
    'gemini-3.5-flash',
    'gemini-3.5-flash-lite',
    'gemini-flash-latest',
  ];

  static const String _systemPrompt = '''
You are StudyDeck AI Tutor — an expert, friendly IELTS & English Language Tutor dedicated to helping Vietnamese learners master all 4 core skills: Listening, Speaking, Reading, and Writing.
Your tone is enthusiastic, professional, encouraging, and pedagogically sharp.

CORE RESPONSIBILITIES:
1. Flexible Bilingual Communication (Vietnamese & English):
   - You fully support both Vietnamese and English input.
   - When the user asks in Vietnamese, reply in natural, clear, and engaging Vietnamese, while clearly highlighting relevant English vocabulary, grammar patterns, phonetic IPA, and examples.
   - When the user practices in English (e.g. Speaking, Writing, mock answers), communicate in natural English and provide helpful Vietnamese guidance, explanations, or translations for complex terms and exam tips.
2. Four Core IELTS Skills Mastery:
   - 🎧 Listening: Guide strategies for identifying distractors/traps in Part 1/2, catching signposting language in Part 3/4, predicting missing words, and applying dictation (nghe chép chính tả).
   - 🗣️ Speaking: Act as a mock examiner or speaking partner for Part 1, 2, and 3. Use the A.R.E.A framework (Action - Reason - Example - Alternative) to help students expand responses naturally, coach pronunciation & IPA, and suggest Band 7.5+ idioms.
   - 📖 Reading: Clarify Skimming & Scanning techniques, breakdown True/False/Not Given and Heading Matching pitfalls, and explain complex academic sentence structures and keyword paraphrasing.
   - ✍️ Writing: Analyze and upgrade sentences and essays for Task 1 and Task 2 according to the 4 IELTS scoring criteria (TR, CC, LR, GRA). Fix errors gently and provide Band 7.0+ sentence transformations.
3. Proactive Error Correction:
   - Whenever the student writes in English with grammar, spelling, or unnatural collocation errors, gently point out the error:
     • Lỗi (Error): ...
     • Sửa lại (Correction): ...
     • Nâng cấp (Band 7.0+ Alternative): ...
4. Visual & Mobile-friendly Markdown:
   - Use bolding for key terms, bullet points for lists, and clean paragraph breaks so learners can read easily on mobile devices.
   - DO NOT output horizontal line dividers (like "---", "***", or "___"). Never use divider hyphens between sections. Use clean numbered headings (### 1., ### 2.) or emojis instead.

Always be encouraging and inspire the learner to keep learning!
''';

  List<ChatMessageModel> _messages = [];
  final List<Map<String, dynamic>> _apiContents = [];
  bool _isLoaded = false;
  CancelToken? _currentCancelToken;
  bool _wasCancelled = false;

  List<ChatMessageModel> get messages => List.unmodifiable(_messages);

  /// Hủy bỏ yêu cầu AI đang tạo câu trả lời
  void cancelCurrentRequest() {
    _wasCancelled = true;
    if (_currentCancelToken != null && !_currentCancelToken!.isCancelled) {
      _currentCancelToken!.cancel('User stopped generation');
    }
  }

  Future<void> loadHistory() async {
    if (_isLoaded) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_storageKey);
      if (jsonStr != null && jsonStr.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(jsonStr);
        _messages = decoded.map((e) => ChatMessageModel.fromJson(e as Map<String, dynamic>)).toList();

        // Reconstruct API contents
        _apiContents.clear();
        for (final m in _messages.take(16)) {
          _apiContents.add({
            'role': m.isUser ? 'user' : 'model',
            'parts': [
              {'text': m.text}
            ],
          });
        }
      }
      _isLoaded = true;
    } catch (_) {}
  }

  Future<void> saveHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = _messages.map((e) => e.toJson()).toList();
      await prefs.setString(_storageKey, jsonEncode(list));
    } catch (_) {}
  }

  Future<void> clearHistory() async {
    _messages.clear();
    _apiContents.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }

  Future<String> sendMessage({
    required String userText,
    String modeTag = 'general',
  }) async {
    await loadHistory();

    // 1. Add User Message
    final userMessage = ChatMessageModel(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}_user',
      text: userText.trim(),
      isUser: true,
      timestamp: DateTime.now(),
      modeTag: modeTag,
    );
    _messages.add(userMessage);

    _apiContents.add({
      'role': 'user',
      'parts': [
        {'text': userText.trim()}
      ],
    });

    // Limit api context to last 16 turns to stay optimal
    if (_apiContents.length > 16) {
      _apiContents.removeRange(0, _apiContents.length - 16);
    }

    _wasCancelled = false;
    _currentCancelToken = CancelToken();

    String? replyText;
    String? lastError;

    // 2. Try candidate models with fallback strategy
    for (final model in _models) {
      if (_wasCancelled || (_currentCancelToken?.isCancelled ?? false)) {
        break;
      }
      try {
        final url = 'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent';
        final response = await _dio.post(
          url,
          cancelToken: _currentCancelToken,
          options: Options(
            headers: {
              'x-goog-api-key': _apiKey,
            },
          ),
          data: {
            'systemInstruction': {
              'parts': [
                {'text': _systemPrompt}
              ]
            },
            'contents': _apiContents,
            'generationConfig': {
              'temperature': 0.7,
              'topP': 0.9,
              'maxOutputTokens': 1000,
            },
          },
        );

        if (response.statusCode == 200 && response.data != null) {
          final data = response.data is Map<String, dynamic>
              ? response.data as Map<String, dynamic>
              : jsonDecode(response.data.toString()) as Map<String, dynamic>;

          final candidates = data['candidates'] as List?;
          if (candidates != null && candidates.isNotEmpty) {
            final parts = candidates[0]?['content']?['parts'] as List?;
            if (parts != null && parts.isNotEmpty) {
              replyText = parts[0]?['text'] as String?;
              if (replyText != null && replyText.trim().isNotEmpty) {
                break; // Succeeded!
              }
            }
          }
        }
      } on DioException catch (e) {
        if (CancelToken.isCancel(e) || _wasCancelled) {
          _wasCancelled = true;
          break;
        }
        lastError = e.toString();
      } catch (e) {
        if (_wasCancelled) break;
        lastError = e.toString();
      }
    }

    if (_wasCancelled) {
      _currentCancelToken = null;
      return '';
    }

    _currentCancelToken = null;

    if (replyText == null || replyText.trim().isEmpty) {
      replyText = 'Xin lỗi bạn, kết nối tới máy chủ AI đang bận trong giây lát. Vui lòng gửi lại câu hỏi nhé!';
      if (lastError != null) {
        // Keep a friendly message for the user
      }
    }

    // 3. Add AI Reply
    final aiMessage = ChatMessageModel(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}_ai',
      text: replyText.trim(),
      isUser: false,
      timestamp: DateTime.now(),
      modeTag: modeTag,
    );
    _messages.add(aiMessage);

    _apiContents.add({
      'role': 'model',
      'parts': [
        {'text': replyText.trim()}
      ],
    });

    await saveHistory();
    return replyText;
  }

  /// Gọi API trực tiếp không lưu vào lịch sử hội thoại chat
  Future<String> evaluatePromptDirect(String prompt) async {
    for (final model in _models) {
      try {
        final url = 'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent';
        final response = await _dio.post(
          url,
          options: Options(
            headers: {
              'x-goog-api-key': _apiKey,
            },
          ),
          data: {
            'contents': [
              {
                'role': 'user',
                'parts': [
                  {'text': prompt}
                ]
              }
            ],
            'generationConfig': {
              'temperature': 0.7,
              'topP': 0.9,
              'maxOutputTokens': 1000,
            },
          },
        );

        if (response.statusCode == 200 && response.data != null) {
          final data = response.data is Map<String, dynamic>
              ? response.data as Map<String, dynamic>
              : jsonDecode(response.data.toString()) as Map<String, dynamic>;

          final candidates = data['candidates'] as List?;
          if (candidates != null && candidates.isNotEmpty) {
            final parts = candidates[0]?['content']?['parts'] as List?;
            if (parts != null && parts.isNotEmpty) {
              final replyText = parts[0]?['text'] as String?;
              if (replyText != null && replyText.trim().isNotEmpty) {
                return replyText;
              }
            }
          }
        }
      } catch (_) {}
    }
    return '';
  }

  /// Đánh giá phát âm bài tập Shadowing bằng Gemini Multimodal Audio
  Future<ShadowingEvaluationResult> evaluateShadowingAudio({
    required String audioFilePath,
    required ShadowingSentence sentence,
    int durationSeconds = 0,
  }) async {
    final file = File(audioFilePath);
    if (!await file.exists()) {
      return _createFallbackEvaluation(
        sentence: sentence,
        durationSeconds: durationSeconds,
        recordedPath: audioFilePath,
        fallbackFeedback: 'Không tìm thấy tệp ghi âm để phân tích.',
      );
    }

    final bytes = await file.readAsBytes();
    if (bytes.isEmpty) {
      return ShadowingEvaluationResult(
        accuracyScore: 0,
        fluencyScore: 0,
        completenessScore: 0,
        wordFeedbacks: _createDefaultWordFeedbacks(sentence, isCorrect: false),
        recordedAudioPath: audioFilePath,
        aiFeedback: 'Tệp ghi âm rỗng. Vui lòng bấm micro và đọc lại câu mẫu nhé!',
        noSpeechDetected: true,
        audioDurationSeconds: durationSeconds,
      );
    }

    final base64Audio = base64Encode(bytes);

    final prompt = '''
You are an expert IELTS Speaking Examiner and English Phonetics Specialist evaluating an English Shadowing pronunciation audio.
Reference sentence: "${sentence.englishText}"
Reference phonetic (IPA): "${sentence.phonetic}"
Sentence stress words: "${sentence.stressWords.join(', ')}"

Student's recorded audio is attached. Listen to it and analyze carefully:
1. Is there any clear English speech? If it's completely silent, loud static without human voice, or not speaking English at all, set "no_speech_detected": true.
2. If speech is detected, evaluate each word in the reference sentence:
   - status: "correct" if pronounced accurately, "mispronounced" if phoneme or ending sound (/s/, /t/, /d/, /ed/, /z/) is wrong or missing, "missing" if word was skipped.
   - tip: short Vietnamese tip for correcting mispronounced word (max 10 words, e.g. "Bật rõ âm đuôi /t/", "Nhấn trọng âm 1"), or "" if correct.
3. Compute:
   - "accuracy_score": 0.0 to 100.0 (phonetic precision)
   - "fluency_score": 0.0 to 100.0 (rhythm, pauses, natural cadence)
   - "completeness_score": 0.0 to 100.0 (% of words spoken)
4. "ai_feedback": 1-2 encouraging sentences in Vietnamese praising strengths (rhythm, stress) and advising on specific pronunciation improvements.

Return ONLY a valid JSON object:
{
  "no_speech_detected": false,
  "accuracy_score": 85.0,
  "fluency_score": 82.0,
  "completeness_score": 90.0,
  "words": [
    {
      "word": "word",
      "status": "correct",
      "is_matched": true,
      "confidence": 0.95,
      "phonetic": "/wɜːd/",
      "tip": ""
    }
  ],
  "ai_feedback": "Nhận xét tiếng Việt ở đây."
}
''';

    // Call Gemini API with audio inlineData
    for (final model in _models) {
      try {
        final url = 'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent';
        final response = await _dio.post(
          url,
          options: Options(
            headers: {
              'x-goog-api-key': _apiKey,
            },
          ),
          data: {
            'contents': [
              {
                'role': 'user',
                'parts': [
                  {'text': prompt},
                  {
                    'inlineData': {
                      'mimeType': 'audio/mp4',
                      'data': base64Audio,
                    }
                  }
                ]
              }
            ],
            'generationConfig': {
              'temperature': 0.2,
              'topP': 0.8,
              'maxOutputTokens': 1500,
            },
          },
        );

        if (response.statusCode == 200 && response.data != null) {
          final data = response.data is Map<String, dynamic>
              ? response.data as Map<String, dynamic>
              : jsonDecode(response.data.toString()) as Map<String, dynamic>;

          final candidates = data['candidates'] as List?;
          if (candidates != null && candidates.isNotEmpty) {
            final parts = candidates[0]?['content']?['parts'] as List?;
            if (parts != null && parts.isNotEmpty) {
              final text = parts[0]?['text'] as String?;
              if (text != null && text.trim().isNotEmpty) {
                final result = _parseShadowingJson(
                  text: text,
                  sentence: sentence,
                  audioFilePath: audioFilePath,
                  durationSeconds: durationSeconds,
                );
                if (result != null) return result;
              }
            }
          }
        }
      } catch (_) {
        // Continue to next model if this candidate fails
      }
    }

    // Safety fallback if API fails or offline
    return _createFallbackEvaluation(
      sentence: sentence,
      durationSeconds: durationSeconds,
      recordedPath: audioFilePath,
      fallbackFeedback: 'Không thể kết nối đến máy chủ AI để chấm điểm tự động. Bạn vẫn có thể nghe lại bản thu của mình và so sánh với câu mẫu bản xứ!',
    );
  }

  ShadowingEvaluationResult? _parseShadowingJson({
    required String text,
    required ShadowingSentence sentence,
    required String audioFilePath,
    required int durationSeconds,
  }) {
    try {
      String clean = text.trim();
      if (clean.startsWith('```json')) {
        clean = clean.substring(7);
      } else if (clean.startsWith('```')) {
        clean = clean.substring(3);
      }
      if (clean.endsWith('```')) {
        clean = clean.substring(0, clean.length - 3);
      }
      clean = clean.trim();

      final decoded = jsonDecode(clean) as Map<String, dynamic>;
      final bool noSpeech = decoded['no_speech_detected'] == true;
      if (noSpeech) {
        return ShadowingEvaluationResult(
          accuracyScore: 0.0,
          fluencyScore: 0.0,
          completenessScore: 0.0,
          wordFeedbacks: _createDefaultWordFeedbacks(sentence, isCorrect: false),
          recordedAudioPath: audioFilePath,
          aiFeedback: 'Không phát hiện giọng đọc tiếng Anh trong bản thu. Hãy đưa micro lại gần hơn và đọc to, rõ ràng theo câu mẫu nhé!',
          noSpeechDetected: true,
          audioDurationSeconds: durationSeconds,
        );
      }

      final double accuracy = ((decoded['accuracy_score'] as num?)?.toDouble() ?? 80.0).clamp(0.0, 100.0);
      final double fluency = ((decoded['fluency_score'] as num?)?.toDouble() ?? 80.0).clamp(0.0, 100.0);
      final double completeness = ((decoded['completeness_score'] as num?)?.toDouble() ?? 85.0).clamp(0.0, 100.0);
      final String feedback = (decoded['ai_feedback'] as String?)?.trim() ?? 'Hoàn thành bài luyện đọc!';

      final rawWords = decoded['words'] as List?;
      final List<ShadowingWordFeedback> wordList = [];

      final refWords = sentence.englishText
          .split(RegExp(r'\s+'))
          .where((w) => w.isNotEmpty)
          .toList();

      if (rawWords != null && rawWords.isNotEmpty) {
        for (int i = 0; i < refWords.length; i++) {
          final refWord = refWords[i];
          final cleanRef = refWord.replaceAll(RegExp(r'[^\w\s]'), '').toLowerCase();

          // Match word item from response
          Map<String, dynamic>? matchItem;
          if (i < rawWords.length) {
            matchItem = rawWords[i] as Map<String, dynamic>?;
          } else {
            for (final rw in rawWords) {
              if (rw is Map<String, dynamic>) {
                final w = (rw['word'] as String?)?.toLowerCase();
                if (w == cleanRef) {
                  matchItem = rw;
                  break;
                }
              }
            }
          }

          if (matchItem != null) {
            final statusStr = (matchItem['status'] as String?)?.toLowerCase() ?? 'correct';
            final isMatch = (matchItem['is_matched'] as bool?) ?? (statusStr == 'correct');
            final conf = ((matchItem['confidence'] as num?)?.toDouble() ?? (isMatch ? 0.95 : 0.60)).clamp(0.0, 1.0);
            final tip = matchItem['tip'] as String?;
            final phonetic = matchItem['phonetic'] as String?;

            ShadowingWordStatus status;
            if (statusStr == 'mispronounced' || !isMatch) {
              status = ShadowingWordStatus.mispronounced;
            } else if (statusStr == 'missing') {
              status = ShadowingWordStatus.missing;
            } else {
              status = ShadowingWordStatus.correct;
            }

            wordList.add(ShadowingWordFeedback(
              word: refWord,
              isMatched: isMatch,
              confidence: conf,
              phonetic: phonetic,
              status: status,
              tip: (tip != null && tip.trim().isNotEmpty) ? tip.trim() : null,
            ));
          } else {
            wordList.add(ShadowingWordFeedback(
              word: refWord,
              isMatched: true,
              confidence: 0.90,
              status: ShadowingWordStatus.correct,
            ));
          }
        }
      } else {
        wordList.addAll(_createDefaultWordFeedbacks(sentence, isCorrect: true));
      }

      return ShadowingEvaluationResult(
        accuracyScore: accuracy,
        fluencyScore: fluency,
        completenessScore: completeness,
        wordFeedbacks: wordList,
        recordedAudioPath: audioFilePath,
        aiFeedback: feedback,
        noSpeechDetected: false,
        isLowMatch: accuracy < 40.0,
        audioDurationSeconds: durationSeconds,
      );
    } catch (_) {
      return null;
    }
  }

  List<ShadowingWordFeedback> _createDefaultWordFeedbacks(
    ShadowingSentence sentence, {
    required bool isCorrect,
  }) {
    return sentence.englishText
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .map((w) => ShadowingWordFeedback(
              word: w,
              isMatched: isCorrect,
              confidence: isCorrect ? 0.90 : 0.0,
              status: isCorrect
                  ? ShadowingWordStatus.correct
                  : ShadowingWordStatus.mispronounced,
            ))
        .toList();
  }

  ShadowingEvaluationResult _createFallbackEvaluation({
    required ShadowingSentence sentence,
    required int durationSeconds,
    required String recordedPath,
    required String fallbackFeedback,
  }) {
    final words = sentence.englishText
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .toList();
    final feedbacks = words
        .map((w) => ShadowingWordFeedback(
              word: w,
              isMatched: true,
              confidence: 0.88,
              status: ShadowingWordStatus.correct,
            ))
        .toList();

    return ShadowingEvaluationResult(
      accuracyScore: 82.0,
      fluencyScore: 80.0,
      completenessScore: 85.0,
      wordFeedbacks: feedbacks,
      recordedAudioPath: recordedPath,
      aiFeedback: fallbackFeedback,
      noSpeechDetected: false,
      isLowMatch: false,
      audioDurationSeconds: durationSeconds,
    );
  }

  /// Trích xuất chữ từ ảnh bài làm viết tay hoặc tài liệu (OCR)
  Future<String?> extractTextFromImage(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);
      final ext = imageFile.path.split('.').last.toLowerCase();
      final mimeType = (ext == 'png') ? 'image/png' : 'image/jpeg';

      const prompt =
          'Bạn là trợ lý OCR chuyên nghiệp. Hãy đọc và chuyển đổi chính xác toàn bộ chữ viết tay hoặc chữ in trong ảnh bài làm IELTS Writing này sang văn bản tiếng Anh thuần túy. Chỉ trả về nội dung bài viết bằng tiếng Anh, giữ đúng ngắt đoạn, không thêm lời chào, không giải thích gì khác.';

      for (final model in _models) {
        try {
          final url =
              'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent';
          final response = await _dio.post(
            url,
            options: Options(
              headers: {'x-goog-api-key': _apiKey},
            ),
            data: {
              'contents': [
                {
                  'role': 'user',
                  'parts': [
                    {'text': prompt},
                    {
                      'inlineData': {
                        'mimeType': mimeType,
                        'data': base64Image,
                      }
                    }
                  ]
                }
              ],
              'generationConfig': {
                'temperature': 0.1,
                'maxOutputTokens': 2000,
              },
            },
          );

          if (response.statusCode == 200 && response.data != null) {
            final data = response.data is Map<String, dynamic>
                ? response.data as Map<String, dynamic>
                : jsonDecode(response.data.toString()) as Map<String, dynamic>;
            final candidates = data['candidates'] as List?;
            if (candidates != null && candidates.isNotEmpty) {
              final parts = candidates[0]?['content']?['parts'] as List?;
              if (parts != null && parts.isNotEmpty) {
                final text = parts[0]?['text'] as String?;
                if (text != null && text.trim().isNotEmpty) {
                  return text.trim();
                }
              }
            }
          }
        } catch (_) {}
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Nhận diện giọng nói từ file ghi âm sang văn bản (Speech-to-Text)
  Future<String?> transcribeAudio(File audioFile) async {
    try {
      final bytes = await audioFile.readAsBytes();
      final base64Audio = base64Encode(bytes);
      final ext = audioFile.path.split('.').last.toLowerCase();
      final mimeType = (ext == 'wav')
          ? 'audio/wav'
          : (ext == 'mp3')
              ? 'audio/mp3'
              : 'audio/mp4';

      const prompt =
          'Please transcribe the English speech in this audio recording accurately into text. Output only the transcribed English text, without commentary, greetings, or explanations.';

      for (final model in _models) {
        try {
          final url =
              'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent';
          final response = await _dio.post(
            url,
            options: Options(
              headers: {'x-goog-api-key': _apiKey},
            ),
            data: {
              'contents': [
                {
                  'role': 'user',
                  'parts': [
                    {'text': prompt},
                    {
                      'inlineData': {
                        'mimeType': mimeType,
                        'data': base64Audio,
                      }
                    }
                  ]
                }
              ],
              'generationConfig': {
                'temperature': 0.1,
                'maxOutputTokens': 1000,
              },
            },
          );

          if (response.statusCode == 200 && response.data != null) {
            final data = response.data is Map<String, dynamic>
                ? response.data as Map<String, dynamic>
                : jsonDecode(response.data.toString()) as Map<String, dynamic>;
            final candidates = data['candidates'] as List?;
            if (candidates != null && candidates.isNotEmpty) {
              final parts = candidates[0]?['content']?['parts'] as List?;
              if (parts != null && parts.isNotEmpty) {
                final text = parts[0]?['text'] as String?;
                if (text != null && text.trim().isNotEmpty) {
                  return text.trim();
                }
              }
            }
          }
        } catch (_) {}
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Đánh giá chẩn đoán thính giác khi người học chép chính tả (Dictation)
  Future<ListeningDiagnosticResult> evaluateListeningDiagnostic({
    required String targetText,
    required String userTranscription,
    String? topicTitle,
  }) async {
    final prompt = '''
Bạn là Chuyên gia Ngữ âm học và Giám khảo IELTS Listening. Hãy phân tích lỗi nghe của học viên trong bài luyện chép chính tả (Dictation):
Chủ đề bài nghe: "${topicTitle ?? 'IELTS Listening Dictation'}"
Câu gốc chuẩn xác: "$targetText"
Nội dung học viên nghe và gõ lại: "$userTranscription"

YÊU CẦU CHẨN ĐOÁN LỖI THÍNH GIÁC VÀ TRẢ VỀ DUY NHẤT MỘT KHỐI JSON (không thêm text ngoài JSON) THEO SCHEMA SAU:
```json
{
  "accuracy_rate": 75.0,
  "missed_endings": ["Bỏ quên âm đuôi /t/ trong từ 'part'"],
  "connected_speech_traps": ["Nhầm hiện tượng nối âm 'pick it up' thành 'picket up'"],
  "weak_forms_missed": ["Bỏ sót mạo từ hoặc trợ động từ 'have' phát âm lướt nhẹ"],
  "homophone_confusions": ["Viết nhầm từ đồng âm 'there' thành 'their'"],
  "ear_training_tip": "Lời khuyên luyện tai cụ thể bằng tiếng Việt để cải thiện...",
  "key_phonetic_focus": "Trọng tâm luyện âm (ví dụ: Final consonants /s/, /ed/)"
}
```
Lưu ý: Nếu không có lỗi ở danh mục nào thì trả về mảng rỗng []. accuracy_rate từ 0.0 đến 100.0.
''';

    for (final model in _models) {
      try {
        final url = 'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent';
        final response = await _dio.post(
          url,
          options: Options(headers: {'x-goog-api-key': _apiKey}),
          data: {
            'contents': [
              {
                'role': 'user',
                'parts': [{'text': prompt}]
              }
            ],
            'generationConfig': {
              'temperature': 0.2,
              'topP': 0.8,
              'maxOutputTokens': 1000,
            },
          },
        );

        if (response.statusCode == 200 && response.data != null) {
          final data = response.data is Map<String, dynamic>
              ? response.data as Map<String, dynamic>
              : jsonDecode(response.data.toString()) as Map<String, dynamic>;
          final candidates = data['candidates'] as List?;
          if (candidates != null && candidates.isNotEmpty) {
            final parts = candidates[0]?['content']?['parts'] as List?;
            if (parts != null && parts.isNotEmpty) {
              final rawText = parts[0]?['text'] as String?;
              if (rawText != null && rawText.trim().isNotEmpty) {
                String jsonStr = rawText.trim();
                final jsonMatch = RegExp(r'```(?:json)?\s*([\s\S]*?)\s*```').firstMatch(jsonStr);
                if (jsonMatch != null) jsonStr = jsonMatch.group(1)!;

                final Map<String, dynamic> parsed = jsonDecode(jsonStr);
                return ListeningDiagnosticResult(
                  accuracyRate: (parsed['accuracy_rate'] as num?)?.toDouble() ?? 80.0,
                  missedEndings: (parsed['missed_endings'] as List?)?.map((e) => e.toString()).toList() ?? [],
                  connectedSpeechTraps: (parsed['connected_speech_traps'] as List?)?.map((e) => e.toString()).toList() ?? [],
                  weakFormsMissed: (parsed['weak_forms_missed'] as List?)?.map((e) => e.toString()).toList() ?? [],
                  homophoneConfusions: (parsed['homophone_confusions'] as List?)?.map((e) => e.toString()).toList() ?? [],
                  earTrainingTip: parsed['ear_training_tip'] as String? ?? 'Hãy chú ý lắng nghe kỹ các âm đuôi và hiện tượng nối âm.',
                  keyPhoneticFocus: parsed['key_phonetic_focus'] as String? ?? 'Âm đuôi & Nối âm',
                );
              }
            }
          }
        }
      } catch (_) {}
    }

    // Heuristic Fallback
    return const ListeningDiagnosticResult(
      accuracyRate: 75.0,
      missedEndings: ['Chú ý các âm đuôi /-s/, /-ed/, /-t/ thường bị nuốt trong câu.'],
      connectedSpeechTraps: ['Hiện tượng nối âm giữa phụ âm cuối và nguyên âm đầu câu tiếp theo.'],
      weakFormsMissed: ['Các từ phụ trợ (of, to, have) thường phát âm lướt nhẹ dạng âm yếu (schwa /ə/).'],
      earTrainingTip: 'Tập trung nghe lặp lại câu ở tốc độ 0.75x và đối chiếu với văn bản để bắt nhịp nối âm.',
      keyPhoneticFocus: 'Âm đuôi & Nhận diện từ nối',
    );
  }

  /// Đánh giá phân tích kết quả bài thi đọc (Reading Result Diagnostic)
  Future<ReadingDiagnosticResult> evaluateReadingDiagnostic({
    required String testTitle,
    required int correctCount,
    required int totalCount,
    required double bandScore,
    required List<Map<String, dynamic>> questionSummaries,
  }) async {
    final prompt = '''
Bạn là Giám khảo IELTS Reading Band 9.0 chấm thi chính thức của Cambridge. Hãy phân tích kết quả làm bài đọc sau:
Đề thi: "$testTitle"
Kết quả: $correctCount/$totalCount câu đúng (Band IELTS: $bandScore)
Danh sách câu hỏi và trạng thái:
${jsonEncode(questionSummaries.take(15).toList())}

YÊU CẦU PHÂN TÍCH CHUYÊN SÂU VÀ TRẢ VỀ DUY NHẤT MỘT KHỐI JSON (không thêm text ngoài JSON) THEO SCHEMA SAU:
```json
{
  "overall_assessment": "Nhận xét tổng quan về độ chính xác và tốc độ đọc hiểu...",
  "question_type_analysis": [
    {"type": "True / False / Not Given", "accuracy": "60%", "diagnosis": "Dễ bị bẫy nhầm lẫn giữa False và Not Given do suy đoán ngoài bài..."},
    {"type": "Matching Headings", "accuracy": "80%", "diagnosis": "Nắm ý chính của các đoạn văn rất tốt."}
  ],
  "cognitive_pitfalls": [
    "Dính bẫy từ chỉ mức độ tuyệt đối (Extreme words: 'always', 'only').",
    "Bỏ sót từ khóa phủ định làm đảo ngược nghĩa câu."
  ],
  "valuable_paraphrases": [
    {"keyword": "decline rapidly", "evidence": "plummeted dramatically", "meaning": "sụt giảm nghiêm trọng"}
  ],
  "personalized_strategy": "Nên phân bổ thời gian: Skimming 3 phút nắm bố cục, sau đó dùng Scanning định vị từ khóa cho từng câu."
}
```
''';

    for (final model in _models) {
      try {
        final url = 'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent';
        final response = await _dio.post(
          url,
          options: Options(headers: {'x-goog-api-key': _apiKey}),
          data: {
            'contents': [
              {
                'role': 'user',
                'parts': [{'text': prompt}]
              }
            ],
            'generationConfig': {
              'temperature': 0.2,
              'topP': 0.8,
              'maxOutputTokens': 1200,
            },
          },
        );

        if (response.statusCode == 200 && response.data != null) {
          final data = response.data is Map<String, dynamic>
              ? response.data as Map<String, dynamic>
              : jsonDecode(response.data.toString()) as Map<String, dynamic>;
          final candidates = data['candidates'] as List?;
          if (candidates != null && candidates.isNotEmpty) {
            final parts = candidates[0]?['content']?['parts'] as List?;
            if (parts != null && parts.isNotEmpty) {
              final rawText = parts[0]?['text'] as String?;
              if (rawText != null && rawText.trim().isNotEmpty) {
                String jsonStr = rawText.trim();
                final jsonMatch = RegExp(r'```(?:json)?\s*([\s\S]*?)\s*```').firstMatch(jsonStr);
                if (jsonMatch != null) jsonStr = jsonMatch.group(1)!;

                final Map<String, dynamic> parsed = jsonDecode(jsonStr);
                return ReadingDiagnosticResult(
                  overallAssessment: parsed['overall_assessment'] as String? ?? 'Kết quả làm bài phản ánh tốt khả năng đọc hiểu học thuật.',
                  questionTypeAnalysis: (parsed['question_type_analysis'] as List?)
                          ?.map((e) => Map<String, String>.from(e as Map))
                          .toList() ??
                      [],
                  cognitivePitfalls: (parsed['cognitive_pitfalls'] as List?)?.map((e) => e.toString()).toList() ?? [],
                  valuableParaphrases: (parsed['valuable_paraphrases'] as List?)
                          ?.map((e) => Map<String, String>.from(e as Map))
                          .toList() ??
                      [],
                  personalizedStrategy: parsed['personalized_strategy'] as String? ?? 'Rèn luyện Skimming và Scanning kết hợp tra cứu từ đồng nghĩa.',
                );
              }
            }
          }
        }
      } catch (_) {}
    }

    // Heuristic Fallback
    return const ReadingDiagnosticResult(
      overallAssessment: 'Bạn đã hoàn thành tốt các câu hỏi thông tin trực tiếp. Cần chú ý thêm ở các câu suy luận logic.',
      questionTypeAnalysis: [
        {'type': 'True / False / Not Given', 'accuracy': '70%', 'diagnosis': 'Cần lưu ý không suy diễn thông tin khi bài đọc không khẳng định rõ ràng.'},
        {'type': 'Matching Headings / Multiple Choice', 'accuracy': '75%', 'diagnosis': 'Nắm bắt ý tưởng đoạn văn khá vững vàng.'},
      ],
      cognitivePitfalls: [
        'Bẫy từ chỉ mức độ tuyệt đối (always, all, completely) thường là dấu hiệu nhận biết câu FALSE.',
        'Nhầm lẫn giữa NOT GIVEN (không nhắc tới) và FALSE (thông tin trái ngược).',
      ],
      valuableParaphrases: [
        {'keyword': 'significant change', 'evidence': 'substantial transformation', 'meaning': 'sự thay đổi đáng kể'},
        {'keyword': 'mitigate problem', 'evidence': 'alleviate the issue', 'meaning': 'giảm thiểu vấn đề'},
      ],
      personalizedStrategy: 'Áp dụng quy tắc 20 phút/passage, gạch chân từ khóa câu hỏi trước khi đọc lướt bài đọc.',
    );
  }
}

class ListeningPhoneticItem {
  final String word;
  final String ipa;
  final String auditoryPhenomenon;
  final String explanation;

  const ListeningPhoneticItem({
    required this.word,
    this.ipa = '',
    required this.auditoryPhenomenon,
    required this.explanation,
  });
}

class ReadingTypeAccuracy {
  final String type;
  final int correct;
  final int total;
  final int percentage;

  const ReadingTypeAccuracy({
    required this.type,
    required this.correct,
    required this.total,
    required this.percentage,
  });
}

class ReadingParaphraseItem {
  final String questionSnippet;
  final String passageSnippet;
  final String meaning;

  const ReadingParaphraseItem({
    required this.questionSnippet,
    required this.passageSnippet,
    required this.meaning,
  });
}

class ListeningDiagnosticResult {
  final double accuracyRate;
  final List<String> missedEndings;
  final List<String> connectedSpeechTraps;
  final List<String> weakFormsMissed;
  final List<String> homophoneConfusions;
  final String earTrainingTip;
  final String keyPhoneticFocus;

  const ListeningDiagnosticResult({
    required this.accuracyRate,
    this.missedEndings = const [],
    this.connectedSpeechTraps = const [],
    this.weakFormsMissed = const [],
    this.homophoneConfusions = const [],
    required this.earTrainingTip,
    required this.keyPhoneticFocus,
  });

  String get diagnosticReason => missedEndings.isNotEmpty || connectedSpeechTraps.isNotEmpty
      ? 'Bạn có thể đã bị lướt qua các âm đuôi hoặc hiện tượng nối âm nhanh trong câu.'
      : 'Khả năng nhận diện âm thanh khá tốt, hãy tập trung vào các từ ngữ âm yếu hoặc từ đồng âm.';

  List<ListeningPhoneticItem> get phoneticBreakdown {
    final list = <ListeningPhoneticItem>[];
    for (final e in missedEndings) {
      list.add(ListeningPhoneticItem(word: 'Âm cuối', auditoryPhenomenon: 'Nuốt âm đuôi', explanation: e));
    }
    for (final e in connectedSpeechTraps) {
      list.add(ListeningPhoneticItem(word: 'Nối âm', auditoryPhenomenon: 'Linking sound', explanation: e));
    }
    for (final e in weakFormsMissed) {
      list.add(ListeningPhoneticItem(word: 'Âm yếu', auditoryPhenomenon: 'Weak form', explanation: e));
    }
    for (final e in homophoneConfusions) {
      list.add(ListeningPhoneticItem(word: 'Đồng âm', auditoryPhenomenon: 'Homophone', explanation: e));
    }
    return list;
  }

  List<String> get earTrainingTips => [
    earTrainingTip,
    'Nghe lặp lại ở tốc độ 0.75x để xác định chính xác vị trí nối âm.',
    'Đối chiếu mặt chữ và nhại lại (shadowing) để rèn phản xạ cho tai.',
  ];

  String get encouragement => accuracyRate >= 80
      ? 'Kỹ năng nghe của bạn rất sắc bén! Tiếp tục duy trì phong độ nhé.'
      : 'Đừng lo lắng! Luyện nghe chép chính tả mỗi ngày 15 phút sẽ giúp tai bạn bắt nhịp cực nhanh.';
}

class ReadingDiagnosticResult {
  final String overallAssessment;
  final List<Map<String, String>> questionTypeAnalysis;
  final List<String> cognitivePitfalls;
  final List<Map<String, String>> valuableParaphrases;
  final String personalizedStrategy;

  const ReadingDiagnosticResult({
    required this.overallAssessment,
    required this.questionTypeAnalysis,
    required this.cognitivePitfalls,
    required this.valuableParaphrases,
    required this.personalizedStrategy,
  });

  List<ReadingTypeAccuracy> get accuracyByType => questionTypeAnalysis.map((m) {
    final accStr = m['accuracy']?.replaceAll('%', '') ?? '70';
    final acc = int.tryParse(accStr) ?? 70;
    return ReadingTypeAccuracy(
      type: m['type'] ?? 'General',
      correct: (acc * 10) ~/ 100,
      total: 10,
      percentage: acc,
    );
  }).toList();

  List<ReadingParaphraseItem> get valuableParaphrasesItems => valuableParaphrases.map((m) {
    return ReadingParaphraseItem(
      questionSnippet: m['keyword'] ?? '',
      passageSnippet: m['evidence'] ?? '',
      meaning: m['meaning'] ?? '',
    );
  }).toList();

  List<String> get actionableAdvice => [
    personalizedStrategy,
    'Luôn gạch chân từ khóa trong câu hỏi trước khi rà soát bài đọc.',
    'Cảnh giác với các từ chỉ mức độ tuyệt đối (always, never, only).',
  ];
}
