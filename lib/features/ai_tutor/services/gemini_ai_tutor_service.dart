import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chat_message_model.dart';

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
}
