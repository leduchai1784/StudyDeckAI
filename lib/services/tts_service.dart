import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum TtsVoice {
  uk('Giọng Anh (UK)', 'en-GB'),
  us('Giọng Mỹ (US)', 'en-US');

  final String label;
  final String locale;
  const TtsVoice(this.label, this.locale);
}

class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;
  TtsService._internal();

  final FlutterTts _flutterTts = FlutterTts();
  bool _isInitialized = false;

  static const String _prefVoiceKey = 'studydeck_tts_voice_v1';
  static const String _prefAutoPlayKey = 'studydeck_tts_autoplay_v1';
  static const String _prefRateKey = 'studydeck_tts_rate_v1';

  TtsVoice _voice = TtsVoice.us;
  bool _autoPlay = false;
  double _speechRate = 0.48; // Tốc độ chuẩn cho học ngoại ngữ

  final ValueNotifier<bool> isSpeakingNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<int> settingsVersionNotifier = ValueNotifier<int>(0);

  TtsVoice get voice => _voice;
  bool get autoPlay => _autoPlay;
  double get speechRate => _speechRate;
  bool get isSpeaking => isSpeakingNotifier.value;

  Future<void> init() async {
    if (_isInitialized) return;

    final prefs = await SharedPreferences.getInstance();

    // 1. Đọc cấu hình giọng đã lưu (Mặc định: US)
    final savedVoice = prefs.getString(_prefVoiceKey);
    if (savedVoice == 'uk') {
      _voice = TtsVoice.uk;
    } else {
      _voice = TtsVoice.us;
    }

    // 2. Đọc cấu hình tự động đọc (Mặc định: false)
    _autoPlay = prefs.getBool(_prefAutoPlayKey) ?? false;

    // 3. Đọc tốc độ phát âm (Mặc định: 0.48)
    _speechRate = prefs.getDouble(_prefRateKey) ?? 0.48;

    // 4. Cấu hình Flutter TTS
    try {
      await _flutterTts.setLanguage(_voice.locale);
      await _flutterTts.setSpeechRate(_speechRate);
      await _flutterTts.setPitch(1.0);
      await _flutterTts.setVolume(1.0);

      _flutterTts.setStartHandler(() {
        isSpeakingNotifier.value = true;
      });

      _flutterTts.setCompletionHandler(() {
        isSpeakingNotifier.value = false;
      });

      _flutterTts.setCancelHandler(() {
        isSpeakingNotifier.value = false;
      });

      _flutterTts.setErrorHandler((dynamic msg) {
        isSpeakingNotifier.value = false;
      });
    } catch (_) {}

    _isInitialized = true;
  }

  Future<void> setVoice(TtsVoice newVoice) async {
    _voice = newVoice;
    try {
      await _flutterTts.setLanguage(newVoice.locale);
    } catch (_) {}
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefVoiceKey, newVoice == TtsVoice.uk ? 'uk' : 'us');
    settingsVersionNotifier.value++;
  }

  Future<void> setAutoPlay(bool enabled) async {
    _autoPlay = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefAutoPlayKey, enabled);
    settingsVersionNotifier.value++;
  }

  Future<void> setSpeechRate(double rate) async {
    _speechRate = rate;
    try {
      await _flutterTts.setSpeechRate(rate);
    } catch (_) {}
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_prefRateKey, rate);
    settingsVersionNotifier.value++;
  }

  Future<void> speak(String text) async {
    if (text.trim().isEmpty) return;
    try {
      await stop();
      // Đảm bảo cấu hình ngôn ngữ và tốc độ chuẩn trước khi nói
      await _flutterTts.setLanguage(_voice.locale);
      await _flutterTts.setSpeechRate(_speechRate);
      await _flutterTts.speak(text.trim());
    } catch (_) {
      isSpeakingNotifier.value = false;
    }
  }

  Future<void> stop() async {
    try {
      await _flutterTts.stop();
    } catch (_) {}
    isSpeakingNotifier.value = false;
  }

  void dispose() {
    stop();
  }
}
