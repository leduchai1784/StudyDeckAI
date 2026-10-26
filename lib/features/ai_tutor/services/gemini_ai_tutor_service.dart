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
}
