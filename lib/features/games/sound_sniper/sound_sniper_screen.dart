import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../app/theme.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/db/database.dart';
import '../../../app/providers.dart';
import '../../../core/services/phase2_content_service.dart';
import '../widgets/what_you_learned_screen.dart';

class SniperPair {
  final int id;
  final String target;
  final String ipaTarget;
  final String distractor;
  final String ipaDistractor;
  final String phonemeContrast;
  final String explanation;

  SniperPair({
    required this.id,
    required this.target,
    required this.ipaTarget,
    required this.distractor,
    required this.ipaDistractor,
    required this.phonemeContrast,
    required this.explanation,
  });

  factory SniperPair.fromJson(Map<String, dynamic> json) {
    return SniperPair(
      id: json['id'] as int,
      target: json['target'] as String,
      ipaTarget: json['ipaTarget'] as String,
      distractor: json['distractor'] as String,
      ipaDistractor: json['ipaDistractor'] as String,
      phonemeContrast: json['phonemeContrast'] as String,
      explanation: json['explanation'] as String,
    );
  }
}

class SoundSniperScreen extends ConsumerStatefulWidget {
  const SoundSniperScreen({super.key});

  @override
  ConsumerState<SoundSniperScreen> createState() => _SoundSniperScreenState();
}

class _SoundSniperScreenState extends ConsumerState<SoundSniperScreen> {
  List<SniperPair> _pairs = [];
  int _currentIndex = 0;
  bool _isLoading = true;

  List<String> _shuffledTargets = [];
  String? _selectedWord;
  bool _hasAnswered = false;
  bool _isHit = false;

  int _combo = 0;
  int _score = 0;
  int _xpEarned = 0;
  int _correctCount = 0;
  final List<LearnedItem> _learnedItems = [];
  int _roundStartTime = 0;

  @override
  void initState() {
    super.initState();
    _roundStartTime = DateTime.now().millisecondsSinceEpoch;
    _loadPairs();
  }

  Future<void> _loadPairs() async {
    try {
      final data = await Phase2ContentService.instance.loadContent();
      final list = (data['sound_sniper'] as List)
          .map((s) => SniperPair.fromJson(s as Map<String, dynamic>))
          .toList();

      if (!mounted) return;
      setState(() {
        _pairs = list..shuffle();
        _isLoading = false;
      });

      if (_pairs.isNotEmpty) {
        _setupCurrentPair();
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  void _setupCurrentPair() {
    final current = _pairs[_currentIndex];
    final options = [current.target, current.distractor]..shuffle();

    setState(() {
      _shuffledTargets = options;
      _selectedWord = null;
      _hasAnswered = false;
      _isHit = false;
    });

    ref.read(audioServiceProvider).speakOrPlay(current.target);
  }

  void _snipeWord(String word) {
    if (_hasAnswered) return;
    final current = _pairs[_currentIndex];
    final isHit = word == current.target;

    setState(() {
      _selectedWord = word;
      _hasAnswered = true;
      _isHit = isHit;
      if (isHit) {
        _combo++;
        _correctCount++;
        _score += (100 + (_combo * 15));
        _xpEarned += 25;
      } else {
        _combo = 0;
      }
    });

    if (isHit) {
      ref.read(audioServiceProvider).playSfx(SfxType.correct);
      _learnedItems.add(
        LearnedItem(
          term: '${current.target} vs ${current.distractor}',
          definition: current.phonemeContrast,
          example: current.explanation,
          wasMistake: false,
        ),
      );
    } else {
      ref.read(audioServiceProvider).playSfx(SfxType.wrong);
      _learnedItems.add(
        LearnedItem(
          term: '${current.target} vs ${current.distractor}',
          definition: current.phonemeContrast,
          example: current.explanation,
          wasMistake: true,
        ),
      );
    }
  }

  void _next() {
    if (_currentIndex + 1 < _pairs.length && _currentIndex + 1 < 5) {
      setState(() => _currentIndex++);
      _setupCurrentPair();
    } else {
      _endGame();
    }
  }

  Future<void> _endGame() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final durationMs = now - _roundStartTime;
    final total = _currentIndex + 1;
    final accuracy = total == 0 ? 0.0 : _correctCount / total;

    await ref.read(gameDaoProvider).recordSession(
          GameSessionsCompanion.insert(
            game: 'sound_sniper',
            mode: const drift.Value('minimal_pairs'),
            level: const drift.Value(2),
            startedAt: _roundStartTime,
            durationMs: durationMs,
            accuracy: accuracy,
            score: _score,
            xpEarned: _xpEarned,
          ),
        );

    final today = DateTime.now();
    final todayKey =
        '${today.year.toString().padLeft(4, '0')}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    await ref.read(statsDaoProvider).recordDailyActivity(
          dayKey: todayKey,
          minutes: (durationMs / 60000).ceil(),
          xp: _xpEarned,
          itemsReviewed: total,
          goalMet: true,
        );

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => WhatYouLearnedScreen(
          gameTitle: '🎯 Sound Sniper',
          score: _score,
          xpEarned: _xpEarned,
          accuracy: accuracy,
          items: _learnedItems,
          onPlayAgain: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const SoundSniperScreen()),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_pairs.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Sound Sniper')),
        body: const Center(child: Text('No minimal pair targets found.')),
      );
    }

    final theme = Theme.of(context);
    final current = _pairs[_currentIndex];
    final total = _pairs.length < 5 ? _pairs.length : 5;

    return Scaffold(
      appBar: AppBar(
        title: Text('Sound Sniper (${_currentIndex + 1}/$total)'),
        actions: [
          if (_combo > 1)
            Center(
              child: Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.correct.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.correct),
                ),
                child: Text(
                  'COMBO x$_combo',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.correct),
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Acoustic Crosshair Radar
              Container(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: theme.colorScheme.outline),
                ),
                child: Column(
                  children: [
                    IconButton.filled(
                      iconSize: 42,
                      icon: const Icon(Icons.graphic_eq_rounded),
                      tooltip: 'Repeat Target Sound',
                      onPressed: () => ref.read(audioServiceProvider).speakOrPlay(current.target),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _hasAnswered
                          ? (_isHit ? '🎯 DIRECT HIT!' : 'MISSED SHOT')
                          : 'Listen to the target pronunciation & snipe the word!',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _hasAnswered
                            ? (_isHit ? AppColors.correct : AppColors.wrong)
                            : theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 2 Sniper Target Cards
              Expanded(
                child: Row(
                  children: _shuffledTargets.map((word) {
                    final isTarget = word == current.target;
                    final isSelected = _selectedWord == word;
                    final ipa = isTarget ? current.ipaTarget : current.ipaDistractor;

                    Color borderColor = theme.colorScheme.outline;
                    Color bgColor = theme.colorScheme.surface;

                    if (_hasAnswered) {
                      if (isTarget) {
                        borderColor = AppColors.correct;
                        bgColor = AppColors.correct.withAlpha(30);
                      } else if (isSelected && !isTarget) {
                        borderColor = AppColors.wrong;
                        bgColor = AppColors.wrong.withAlpha(30);
                      }
                    }

                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: InkWell(
                          onTap: () => _snipeWord(word),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: borderColor, width: isSelected || (_hasAnswered && isTarget) ? 2.5 : 1),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.gps_fixed_rounded,
                                  size: 32,
                                  color: borderColor == theme.colorScheme.outline ? theme.colorScheme.primary : borderColor,
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  word.toUpperCase(),
                                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  ipa,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontStyle: FontStyle.italic,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 16),

              // Phoneme Breakdown
              if (_hasAnswered)
                Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest.withAlpha(120),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: theme.colorScheme.outline),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.hearing_rounded, size: 22, color: AppColors.accent),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(current.phonemeContrast, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            const SizedBox(height: 4),
                            Text(current.explanation, style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              if (_hasAnswered)
                ElevatedButton(
                  onPressed: _next,
                  child: Text(_currentIndex + 1 < total ? 'Next Sniper Target' : 'Complete Shooting Drill'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
