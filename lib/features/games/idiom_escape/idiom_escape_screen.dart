import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../app/theme.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/db/database.dart';
import '../../../app/providers.dart';
import '../../../core/services/phase3_content_service.dart';
import '../widgets/what_you_learned_screen.dart';

class IdiomEscapeItem {
  final int id;
  final String chamberName;
  final String clue;
  final String puzzleSentence;
  final List<String> idiomOptions;
  final String correct;
  final String originNote;

  const IdiomEscapeItem({
    required this.id,
    required this.chamberName,
    required this.clue,
    required this.puzzleSentence,
    required this.idiomOptions,
    required this.correct,
    required this.originNote,
  });

  factory IdiomEscapeItem.fromJson(Map<String, dynamic> json) {
    return IdiomEscapeItem(
      id: json['id'] as int,
      chamberName: json['chamberName'] as String,
      clue: json['clue'] as String,
      puzzleSentence: json['puzzleSentence'] as String,
      idiomOptions: (json['idiomOptions'] as List).map((o) => o.toString()).toList(),
      correct: json['correct'] as String,
      originNote: json['originNote'] as String,
    );
  }
}

class IdiomEscapeScreen extends ConsumerStatefulWidget {
  const IdiomEscapeScreen({super.key});

  @override
  ConsumerState<IdiomEscapeScreen> createState() => _IdiomEscapeScreenState();
}

class _IdiomEscapeScreenState extends ConsumerState<IdiomEscapeScreen> {
  List<IdiomEscapeItem> _items = [];
  int _currentIndex = 0;
  bool _isLoading = true;

  String? _selectedOption;
  bool _hasChecked = false;
  bool _isCorrect = false;

  int _score = 0;
  int _xpEarned = 0;
  int _chambersUnlocked = 0;
  final List<LearnedItem> _learnedItems = [];
  int _roundStartTime = 0;

  @override
  void initState() {
    super.initState();
    _roundStartTime = DateTime.now().millisecondsSinceEpoch;
    _loadChambers();
  }

  Future<void> _loadChambers() async {
    try {
      final data = await Phase3ContentService.instance.loadContent();
      final list = (data['idiom_escape'] as List)
          .map((i) => IdiomEscapeItem.fromJson(i as Map<String, dynamic>))
          .toList();

      if (!mounted) return;
      setState(() {
        _items = list..shuffle();
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

  void _checkAnswer() {
    if (_selectedOption == null || _hasChecked) return;
    final item = _items[_currentIndex];
    final isCorrect = _selectedOption!.trim().toLowerCase() == item.correct.trim().toLowerCase();

    setState(() {
      _hasChecked = true;
      _isCorrect = isCorrect;
    });

    if (isCorrect) {
      _chambersUnlocked++;
      _score += 160;
      _xpEarned += 30;
      ref.read(audioServiceProvider).playSfx(SfxType.correct);
      ref.read(audioServiceProvider).speakOrPlay(item.correct);

      _learnedItems.add(
        LearnedItem(
          term: item.correct,
          definition: item.clue,
          example: item.puzzleSentence.replaceAll('______', item.correct),
          wasMistake: false,
        ),
      );
    } else {
      ref.read(audioServiceProvider).playSfx(SfxType.wrong);
      _learnedItems.add(
        LearnedItem(
          term: item.correct,
          definition: item.clue,
          example: 'Your choice: $_selectedOption (Expected: ${item.correct})',
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
    } else {
      _finishEscape();
    }
  }

  Future<void> _finishEscape() async {
    final durationMs = DateTime.now().millisecondsSinceEpoch - _roundStartTime;
    final total = _items.isNotEmpty ? _items.length : 1;
    final accuracy = _chambersUnlocked / total;

    await ref.read(gameDaoProvider).recordSession(
          GameSessionsCompanion.insert(
            game: 'idiom_escape',
            mode: const drift.Value('escape_room'),
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
          gameTitle: '🗝️ Idiom Escape Room Cleared',
          score: _score,
          xpEarned: _xpEarned,
          accuracy: accuracy,
          items: _learnedItems,
          onPlayAgain: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const IdiomEscapeScreen()),
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
        appBar: AppBar(title: const Text('Idiom Escape Room')),
        body: const Center(child: Text('No escape puzzle chambers found.')),
      );
    }

    final theme = Theme.of(context);
    final item = _items[_currentIndex];
    final total = _items.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(item.chamberName),
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
              const SizedBox(height: 16),

              // Cryptic Clue Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.colorScheme.outline),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.vpn_key_rounded, color: AppColors.accent, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'CHAMBER CIPHER CLUE',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5, color: theme.colorScheme.primary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.clue,
                      style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic, height: 1.3),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      item.puzzleSentence.replaceAll('______', _selectedOption ?? '______'),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, height: 1.4),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Key options
              Text(
                'Select Master Key Idiom:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 10),

              Expanded(
                child: ListView.separated(
                  itemCount: item.idiomOptions.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final opt = item.idiomOptions[index];
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
                    border: Border.all(color: AppColors.accent.withAlpha(60)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.history_edu_rounded, color: AppColors.accent, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item.originNote,
                          style: TextStyle(fontSize: 12, height: 1.3, color: theme.colorScheme.onSurface),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
              ],

              // Unlock Chamber Button
              if (!_hasChecked)
                ElevatedButton(
                  onPressed: _selectedOption != null ? _checkAnswer : null,
                  child: const Text('Unlock Chamber Door'),
                )
              else
                ElevatedButton(
                  onPressed: _next,
                  child: Text(_currentIndex + 1 < _items.length ? 'Next Chamber' : 'Escape Sanctuary'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
