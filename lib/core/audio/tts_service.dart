import 'package:flutter_tts/flutter_tts.dart';

/// Offline Text-to-Speech service using [FlutterTts].
///
/// Provides pronunciation for words, sentences, and paragraphs
/// without requiring network access.
class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;
  TtsService._internal();

  final FlutterTts _flutterTts = FlutterTts();
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;
    try {
      await _flutterTts.setLanguage('en-US');
      await _flutterTts.setSpeechRate(0.5); // Natural conversational rate
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);
      _isInitialized = true;
    } catch (e) {
      // Non-fatal if platform TTS initialization has issues on some desktop/test harnesses
    }
  }

  /// Speaks the given [text] aloud.
  ///
  /// Can optionally specify [rate] (e.g. 0.4 for slower beginner audio).
  Future<void> speak(String text, {double rate = 0.5}) async {
    if (!_isInitialized) await init();
    try {
      await _flutterTts.setSpeechRate(rate);
      await _flutterTts.speak(text);
    } catch (_) {}
  }

  /// Stops any currently playing speech.
  Future<void> stop() async {
    try {
      await _flutterTts.stop();
    } catch (_) {}
  }
}
