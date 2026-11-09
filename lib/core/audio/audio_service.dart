import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'tts_service.dart';

/// Sound effect types for games.
enum SfxType {
  correct,
  wrong,
  combo,
  levelUp,
  gateBreach,
  freeze,
  bomb,
}

/// Unified offline audio service that manages sound effects,
/// audio file playback, and TTS speech fallback.
class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _sfxPlayer = AudioPlayer();
  final TtsService _ttsService = TtsService();

  Future<void> init() async {
    await _ttsService.init();
  }

  /// Plays a short haptic & sound feedback for a game event.
  Future<void> playSfx(SfxType type) async {
    try {
      switch (type) {
        case SfxType.correct:
          HapticFeedback.lightImpact();
          break;
        case SfxType.wrong:
          HapticFeedback.mediumImpact();
          break;
        case SfxType.combo:
        case SfxType.levelUp:
          HapticFeedback.heavyImpact();
          break;
        case SfxType.gateBreach:
        case SfxType.freeze:
        case SfxType.bomb:
          HapticFeedback.vibrate();
          break;
      }
    } catch (_) {}
  }

  /// Plays pronunciation for a word or sentence.
  ///
  /// If [assetPath] is provided and exists, it will play the asset audio.
  /// Otherwise, it falls back to TTS.
  Future<void> speakOrPlay(String text, {String? assetPath, double rate = 0.5}) async {
    if (assetPath != null && assetPath.isNotEmpty) {
      try {
        await _sfxPlayer.setAsset(assetPath);
        await _sfxPlayer.play();
        return;
      } catch (_) {
        // Fallback to TTS if audio asset is missing
      }
    }
    await _ttsService.speak(text, rate: rate);
  }

  /// Stops all active audio.
  Future<void> stop() async {
    await _sfxPlayer.stop();
    await _ttsService.stop();
  }

  void dispose() {
    _sfxPlayer.dispose();
  }
}
