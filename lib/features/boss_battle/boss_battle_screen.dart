import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../app/theme.dart';
import '../../core/audio/audio_service.dart';
import '../../core/db/database.dart';
import '../../app/providers.dart';
import '../../core/services/phase3_content_service.dart';
import '../games/widgets/what_you_learned_screen.dart';

class BossQuestion {
  final int id;
  final String bossName;
  final String type;
  final String prompt;
  final String sentence;
  final List<String> options;
  final String answer;
  final int damage;
  final String explanation;

  const BossQuestion({
    required this.id,
    required this.bossName,
    required this.type,
    required this.prompt,
    required this.sentence,
    required this.options,
    required this.answer,
    required this.damage,
    required this.explanation,
  });

  factory BossQuestion.fromJson(Map<String, dynamic> json) {
    return BossQuestion(
      id: json['id'] as int,
      bossName: json['bossName'] as String,
      type: json['type'] as String,
      prompt: json['prompt'] as String,
      sentence: json['sentence'] as String,
      options: (json['options'] as List).map((o) => o.toString()).toList(),
      answer: json['answer'] as String,
      damage: json['damage'] as int? ?? 100,
      explanation: json['explanation'] as String,
    );
  }
}

class BossBattleScreen extends ConsumerStatefulWidget {
  const BossBattleScreen({super.key});

  @override
  ConsumerState<BossBattleScreen> createState() => _BossBattleScreenState();
}

class _BossBattleScreenState extends ConsumerState<BossBattleScreen> {
  List<BossQuestion> _questions = [];
  int _currentIndex = 0;
  bool _isLoading = true;

  int _bossMaxHp = 500;
  int _bossHp = 500;
  int _playerLives = 3;
  int _combo = 0;

  String? _selectedOption;
  bool _hasChecked = false;
  bool _isHit = false;

  int _score = 0;
  int _xpEarned = 0;
  final List<LearnedItem> _learnedItems = [];
  int _roundStartTime = 0;

  @override
  void initState() {
    super.initState();
    _roundStartTime = DateTime.now().millisecondsSinceEpoch;
    _loadBossData();
  }

  Future<void> _loadBossData() async {
    try {
      final data = await Phase3ContentService.instance.loadContent();
      final list = (data['boss_battle'] as List)
          .map((b) => BossQuestion.fromJson(b as Map<String, dynamic>))
          .toList();

      if (!mounted) return;
      setState(() {
        _questions = list..shuffle();
        _bossMaxHp = _questions.fold(0, (sum, q) => sum + q.damage);
        _bossHp = _bossMaxHp;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  void _selectOption(String opt) {
    if (_hasChecked) return;
    setState(() => _selectedOption = opt);
  }

  void _strikeBoss() {
    if (_selectedOption == null || _hasChecked) return;
    final current = _questions[_currentIndex];
    final isCorrect = _selectedOption!.trim().toLowerCase() == current.answer.trim().toLowerCase();

    setState(() {
      _hasChecked = true;
      _isHit = isCorrect;
      if (isCorrect) {
        _combo++;
        final dealt = (current.damage * (1.0 + (_combo * 0.2))).round();
        _bossHp = (_bossHp - dealt).clamp(0, _bossMaxHp);
        _score += dealt * 2;
        _xpEarned += 40;
      } else {
        _combo = 0;
        _playerLives = (_playerLives - 1).clamp(0, 3);
      }
    });

    if (isCorrect) {
      ref.read(audioServiceProvider).playSfx(SfxType.bomb);
      _learnedItems.add(
        LearnedItem(
          term: '${current.bossName} Challenge',
          definition: current.explanation,
          example: current.sentence,
          wasMistake: false,
        ),
      );
    } else {
      ref.read(audioServiceProvider).playSfx(SfxType.wrong);
      _learnedItems.add(
        LearnedItem(
          term: '${current.bossName} Strike',
          definition: current.explanation,
          example: 'Your answer: $_selectedOption (Expected: ${current.answer})',
          wasMistake: true,
        ),
      );
    }
  }

  void _next() {
    if (_playerLives <= 0) {
      _finishBattle(defeated: false);
      return;
    }

    if (_bossHp <= 0 || _currentIndex + 1 >= _questions.length) {
      _finishBattle(defeated: _bossHp <= 0);
      return;
    }

    setState(() {
      _currentIndex++;
      _selectedOption = null;
      _hasChecked = false;
      _isHit = false;
    });
  }

  Future<void> _finishBattle({required bool defeated}) async {
    final durationMs = DateTime.now().millisecondsSinceEpoch - _roundStartTime;

    await ref.read(gameDaoProvider).recordSession(
          GameSessionsCompanion.insert(
            game: 'weekly_boss',
            mode: const drift.Value('boss_raid'),
            level: const drift.Value(3),
            startedAt: _roundStartTime,
            durationMs: durationMs,
            accuracy: defeated ? 1.0 : 0.5,
            score: _score,
            xpEarned: _xpEarned + (defeated ? 150 : 0),
          ),
        );

    final today = DateTime.now();
    final todayKey =
        '${today.year.toString().padLeft(4, '0')}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    await ref.read(statsDaoProvider).recordDailyActivity(
          dayKey: todayKey,
          minutes: (durationMs / 60000).ceil(),
          xp: _xpEarned + (defeated ? 150 : 0),
          itemsReviewed: _questions.length,
          goalMet: true,
        );

    if (defeated) {
      await ref.read(statsDaoProvider).unlockAchievement('boss_slayer');
    }

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => WhatYouLearnedScreen(
          gameTitle: defeated ? '👑 Weekly Boss Defeated!' : '⚔️ Boss Raid Attempt Finished',
          score: _score,
          xpEarned: _xpEarned + (defeated ? 150 : 0),
          accuracy: defeated ? 1.0 : 0.6,
          items: _learnedItems,
          onPlayAgain: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const BossBattleScreen()),
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
    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Weekly Boss Battle')),
        body: const Center(child: Text('No boss challenges active.')),
      );
    }

    final theme = Theme.of(context);
    final current = _questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly Boss Raid'),
        actions: [
          // Player Hearts
          Row(
            children: List.generate(
              3,
              (i) => Icon(
                i < _playerLives ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                color: AppColors.wrong,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Boss Header Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.wrong.withAlpha(80)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.shield_rounded, color: AppColors.wrong, size: 20),
                            const SizedBox(width: 8),
                            Text(current.bossName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                        if (_combo > 1)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.accent,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text('${_combo}x COMBO', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.white)),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Boss HP Bar
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: _bossMaxHp > 0 ? _bossHp / _bossMaxHp : 0.0,
                              backgroundColor: theme.colorScheme.surfaceContainerHighest,
                              valueColor: const AlwaysStoppedAnimation(AppColors.wrong),
                              minHeight: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text('$_bossHp / $_bossMaxHp HP', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Boss Question Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: theme.colorScheme.outline),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      current.prompt,
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      current.sentence,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 1.4),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Options
              Expanded(
                child: ListView.separated(
                  itemCount: current.options.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final opt = current.options[index];
                    final isSel = _selectedOption == opt;

                    Color cardColor = theme.colorScheme.surface;
                    Color borderColor = isSel ? theme.colorScheme.primary : theme.colorScheme.outline;

                    if (_hasChecked) {
                      if (opt == current.answer) {
                        cardColor = AppColors.correct.withAlpha(25);
                        borderColor = AppColors.correct;
                      } else if (isSel && !_isHit) {
                        cardColor = AppColors.wrong.withAlpha(25);
                        borderColor = AppColors.wrong;
                      }
                    }

                    return Material(
                      color: cardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: borderColor, width: isSel ? 2 : 1),
                      ),
                      child: InkWell(
                        onTap: _hasChecked ? null : () => _selectOption(opt),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          child: Text(
                            opt,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              if (_hasChecked) ...[
                Text(current.explanation, style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant)),
                const SizedBox(height: 12),
              ],

              // Attack Button
              if (!_hasChecked)
                ElevatedButton.icon(
                  icon: const Icon(Icons.bolt_rounded),
                  label: const Text('Strike Boss'),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
                  onPressed: _selectedOption != null ? _strikeBoss : null,
                )
              else
                ElevatedButton(
                  onPressed: _next,
                  child: Text(_playerLives <= 0 || _bossHp <= 0 ? 'Conclude Raid' : 'Next Boss Move'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
