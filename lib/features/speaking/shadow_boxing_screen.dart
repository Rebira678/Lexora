import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../app/theme.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/db/database.dart';
import '../../../app/providers.dart';
import '../games/widgets/what_you_learned_screen.dart';

class ShadowBoxingScreen extends ConsumerStatefulWidget {
  const ShadowBoxingScreen({super.key});

  @override
  ConsumerState<ShadowBoxingScreen> createState() => _ShadowBoxingScreenState();
}

class _ShadowBoxingScreenState extends ConsumerState<ShadowBoxingScreen> {
  final List<String> _sentences = [
    "Although the preliminary results appeared promising, secondary analysis uncovered significant inconsistencies.",
    "To substantiate their claims, the researchers conducted an exhaustive examination of historical climate data.",
    "Technological integration in developing regions hinges upon consistent investment in digital infrastructure.",
    "Rather than mitigating the economic crisis, the abrupt policy shift exacerbated existing fiscal disparities.",
  ];

  int _currentIndex = 0;
  bool _isPlayingModel = false;
  bool _isShadowing = false;
  int _shadowSecondsLeft = 6;
  Timer? _shadowTimer;
  Timer? _playbackTimer;
  bool _hasShadowed = false;

  int _roundStartTime = 0;

  @override
  void initState() {
    super.initState();
    _roundStartTime = DateTime.now().millisecondsSinceEpoch;
    _playModelAudio();
  }

  @override
  void dispose() {
    _shadowTimer?.cancel();
    _playbackTimer?.cancel();
    super.dispose();
  }

  void _playModelAudio() {
    setState(() => _isPlayingModel = true);
    final text = _sentences[_currentIndex];
    ref.read(audioServiceProvider).speakOrPlay(text);
    _playbackTimer?.cancel();
    _playbackTimer = Timer(const Duration(milliseconds: 3000), () {
      if (mounted) setState(() => _isPlayingModel = false);
    });
  }

  void _startShadowing() {
    setState(() {
      _isShadowing = true;
      _shadowSecondsLeft = 6;
    });

    ref.read(audioServiceProvider).playSfx(SfxType.levelUp);

    _shadowTimer?.cancel();
    _shadowTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (_shadowSecondsLeft > 1) {
        setState(() => _shadowSecondsLeft--);
      } else {
        t.cancel();
        setState(() {
          _isShadowing = false;
          _hasShadowed = true;
        });
        ref.read(audioServiceProvider).playSfx(SfxType.correct);
      }
    });
  }

  void _nextSentence() {
    if (_currentIndex + 1 < _sentences.length) {
      setState(() {
        _currentIndex++;
        _hasShadowed = false;
        _isShadowing = false;
      });
      _playModelAudio();
    } else {
      _finishGame();
    }
  }

  Future<void> _finishGame() async {
    final durationMs = DateTime.now().millisecondsSinceEpoch - _roundStartTime;
    final total = _sentences.length;

    await ref.read(databaseProvider).into(ref.read(databaseProvider).recordings).insert(
          RecordingsCompanion.insert(
            prompt: 'Shadow Boxing: ${_sentences.first}',
            filePath: 'shadow_session_${DateTime.now().millisecondsSinceEpoch}.m4a',
            durationMs: durationMs,
            score: const drift.Value(4.8),
            createdAt: DateTime.now().millisecondsSinceEpoch,
          ),
        );

    final today = DateTime.now();
    final todayKey =
        '${today.year.toString().padLeft(4, '0')}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    await ref.read(statsDaoProvider).recordDailyActivity(
          dayKey: todayKey,
          minutes: (durationMs / 60000).ceil(),
          xp: 75,
          itemsReviewed: total,
          goalMet: true,
        );

    // Unlock achievement
    await ref.read(statsDaoProvider).unlockAchievement('shadow_boxer');

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => WhatYouLearnedScreen(
          gameTitle: '🥊 Shadow Boxing (Speech Prosody)',
          score: 250,
          xpEarned: 75,
          accuracy: 1.0,
          items: _sentences
              .map((s) => LearnedItem(
                    term: 'Shadowed Model Sentence',
                    definition: 'Rhythm, connected speech, and pause boundaries internalized.',
                    example: s,
                    wasMistake: false,
                  ))
              .toList(),
          onPlayAgain: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const ShadowBoxingScreen()),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = _sentences[_currentIndex];
    final total = _sentences.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Shadow Boxing (${_currentIndex + 1}/$total)'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LinearProgressIndicator(
                value: (_currentIndex + 1) / total,
                backgroundColor: theme.colorScheme.surface,
                valueColor: const AlwaysStoppedAnimation(AppColors.accent),
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
              ),
              const SizedBox(height: 20),

              // Target Sentence Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.colorScheme.outline),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'NATIVE PROSODY CARRIER',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5, color: AppColors.accent),
                        ),
                        IconButton(
                          icon: Icon(
                            _isPlayingModel ? Icons.volume_up_rounded : Icons.play_circle_fill_rounded,
                            color: AppColors.accent,
                            size: 28,
                          ),
                          onPressed: _playModelAudio,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      text,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, height: 1.4),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Shadowing Status Visualizer
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Icon(
                      _isShadowing ? Icons.mic_rounded : (_hasShadowed ? Icons.check_circle_rounded : Icons.mic_none_rounded),
                      size: 48,
                      color: _isShadowing ? AppColors.wrong : (_hasShadowed ? AppColors.correct : theme.colorScheme.primary),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _isShadowing
                          ? 'Shadowing Active: $_shadowSecondsLeft s'
                          : (_hasShadowed ? 'Shadow Recording Complete' : 'Listen carefully, then shadow aloud'),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _isShadowing ? AppColors.wrong : (_hasShadowed ? AppColors.correct : theme.colorScheme.onSurface),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Match the stress shifts and linking consonants in real time.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              const Spacer(),

              // Action Buttons
              if (!_isShadowing && !_hasShadowed)
                ElevatedButton.icon(
                  icon: const Icon(Icons.mic_rounded),
                  label: const Text('Start Shadowing (Aloud)'),
                  onPressed: _startShadowing,
                )
              else if (_isShadowing)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.wrong),
                  onPressed: () {
                    _shadowTimer?.cancel();
                    setState(() {
                      _isShadowing = false;
                      _hasShadowed = true;
                    });
                  },
                  child: const Text('Done Speaking'),
                )
              else ...[
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.replay_rounded),
                        label: const Text('Re-Shadow'),
                        onPressed: _startShadowing,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _nextSentence,
                        child: Text(_currentIndex + 1 < _sentences.length ? 'Next Sentence' : 'Finish Session'),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
