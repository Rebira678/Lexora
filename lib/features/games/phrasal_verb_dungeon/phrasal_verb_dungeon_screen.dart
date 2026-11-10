import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../app/theme.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/db/database.dart';
import '../../../app/providers.dart';
import '../../../core/services/phase3_content_service.dart';
import '../widgets/what_you_learned_screen.dart';

class PhrasalDungeonItem {
  final int id;
  final String verb;
  final String meaning;
  final String carrier;
  final List<String> options;
  final String correct;
  final String bossDefeated;
  final String teacherTip;

  const PhrasalDungeonItem({
    required this.id,
    required this.verb,
    required this.meaning,
    required this.carrier,
    required this.options,
    required this.correct,
    required this.bossDefeated,
    required this.teacherTip,
  });

  factory PhrasalDungeonItem.fromJson(Map<String, dynamic> json) {
    return PhrasalDungeonItem(
      id: json['id'] as int,
      verb: json['verb'] as String,
      meaning: json['meaning'] as String,
      carrier: json['carrier'] as String,
      options: (json['options'] as List).map((o) => o.toString()).toList(),
      correct: json['correct'] as String,
      bossDefeated: json['bossDefeated'] as String,
      teacherTip: json['teacherTip'] as String,
    );
  }
}

class PhrasalVerbDungeonScreen extends ConsumerStatefulWidget {
  const PhrasalVerbDungeonScreen({super.key});

  @override
  ConsumerState<PhrasalVerbDungeonScreen> createState() => _PhrasalVerbDungeonScreenState();
}

class _PhrasalVerbDungeonScreenState extends ConsumerState<PhrasalVerbDungeonScreen> {
  List<PhrasalDungeonItem> _items = [];
  int _currentIndex = 0;
  bool _isLoading = true;

  String? _selectedOption;
  bool _hasChecked = false;
  bool _isCorrect = false;

  int _dungeonFloor = 1;
  int _score = 0;
  int _xpEarned = 0;
  int _correctCount = 0;
  final List<LearnedItem> _learnedItems = [];
  int _roundStartTime = 0;

  @override
  void initState() {
    super.initState();
    _roundStartTime = DateTime.now().millisecondsSinceEpoch;
    _loadItems();
  }

  Future<void> _loadItems() async {
    try {
      final data = await Phase3ContentService.instance.loadContent();
      final list = (data['phrasal_dungeon'] as List)
          .map((p) => PhrasalDungeonItem.fromJson(p as Map<String, dynamic>))
          .toList();

      if (!mounted) return;
      setState(() {
        _items = list..shuffle();
        _isLoading = false;
      });

      if (_items.isNotEmpty) {
        _speakSentence();
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  void _speakSentence() {
    if (_currentIndex < _items.length) {
      ref.read(audioServiceProvider).speakOrPlay(_items[_currentIndex].carrier.replaceAll('______', _items[_currentIndex].correct));
    }
  }

  void _selectOption(String opt) {
    if (_hasChecked) return;
    setState(() => _selectedOption = opt);
  }

  void _checkAnswer() {
    if (_selectedOption == null || _hasChecked) return;
    final item = _items[_currentIndex];
    final isCorrect = _selectedOption!.trim().toLowerCase() == item.correct.trim().toLowerCase();

    setState(() {
      _hasChecked = true;
      _isCorrect = isCorrect;
    });

    if (isCorrect) {
      _correctCount++;
      _score += 180;
      _xpEarned += 35;
      _dungeonFloor++;
      ref.read(audioServiceProvider).playSfx(SfxType.correct);
      ref.read(audioServiceProvider).speakOrPlay(item.correct);

      _learnedItems.add(
        LearnedItem(
          term: item.verb,
          definition: item.meaning,
          example: item.carrier.replaceAll('______', item.correct),
          wasMistake: false,
        ),
      );
    } else {
      ref.read(audioServiceProvider).playSfx(SfxType.wrong);
      _learnedItems.add(
        LearnedItem(
          term: item.verb,
          definition: item.meaning,
          example: 'Your answer: $_selectedOption (Expected: ${item.correct})',
          wasMistake: true,
        ),
      );
    }
  }

  void _next() {
    if (_currentIndex + 1 < _items.length) {
      setState(() {
        _currentIndex++;
        _selectedOption = null;
        _hasChecked = false;
        _isCorrect = false;
      });
      _speakSentence();
    } else {
      _finishDungeon();
    }
  }

  Future<void> _finishDungeon() async {
    final durationMs = DateTime.now().millisecondsSinceEpoch - _roundStartTime;
    final total = _items.isNotEmpty ? _items.length : 1;
    final accuracy = _correctCount / total;

    await ref.read(gameDaoProvider).recordSession(
          GameSessionsCompanion.insert(
            game: 'phrasal_dungeon',
            mode: const drift.Value('dungeon_raid'),
            level: const drift.Value(3),
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
          gameTitle: '🏰 Phrasal Verb Dungeon Cleared',
          score: _score,
          xpEarned: _xpEarned,
          accuracy: accuracy,
          items: _learnedItems,
          onPlayAgain: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const PhrasalVerbDungeonScreen()),
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
    if (_items.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Phrasal Verb Dungeon')),
        body: const Center(child: Text('No dungeon chambers found.')),
      );
    }

    final theme = Theme.of(context);
    final item = _items[_currentIndex];
    final total = _items.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Phrasal Dungeon (Floor $_dungeonFloor)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up_rounded, color: AppColors.accent),
            onPressed: _speakSentence,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Chamber Guardian Header
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: theme.colorScheme.outline),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.castle_rounded, color: AppColors.accent, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'GUARDIAN: ${item.bossDefeated.toUpperCase()}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 0.5),
                        ),
                      ],
                    ),
                    Text('Chamber ${_currentIndex + 1}/$total', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Meaning Clue
              Text(
                'TARGET SEMANTICS:',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: theme.colorScheme.primary, letterSpacing: 0.5),
              ),
              const SizedBox(height: 4),
              Text(
                item.meaning,
                style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 16),

              // Carrier Sentence Box
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.colorScheme.outline),
                ),
                child: Text(
                  item.carrier.replaceAll('______', _selectedOption ?? '______'),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 1.4),
                ),
              ),
              const SizedBox(height: 20),

              // Options
              Expanded(
                child: ListView.separated(
                  itemCount: item.options.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final opt = item.options[index];
                    final isSel = _selectedOption == opt;

                    Color cardColor = theme.colorScheme.surface;
                    Color borderColor = isSel ? theme.colorScheme.primary : theme.colorScheme.outline;

                    if (_hasChecked) {
                      if (opt == item.correct) {
                        cardColor = AppColors.correct.withAlpha(25);
                        borderColor = AppColors.correct;
                      } else if (isSel && !_isCorrect) {
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
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withAlpha(15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.accent.withAlpha(50)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.school_rounded, color: AppColors.accent, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item.teacherTip,
                          style: TextStyle(fontSize: 12, height: 1.3, color: theme.colorScheme.onSurface),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
              ],

              // Button
              if (!_hasChecked)
                ElevatedButton(
                  onPressed: _selectedOption != null ? _checkAnswer : null,
                  child: const Text('Dispel Guardian'),
                )
              else
                ElevatedButton(
                  onPressed: _next,
                  child: Text(_currentIndex + 1 < _items.length ? 'Next Dungeon Floor' : 'Escape Dungeon'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
