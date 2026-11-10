import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../app/theme.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/db/database.dart';
import '../../../app/providers.dart';
import '../../../core/services/phase3_content_service.dart';
import '../widgets/what_you_learned_screen.dart';

class CollocationItem {
  final int id;
  final String base;
  final String correct;
  final List<String> options;
  final String type;
  final String carrier;
  final String explanation;

  const CollocationItem({
    required this.id,
    required this.base,
    required this.correct,
    required this.options,
    required this.type,
    required this.carrier,
    required this.explanation,
  });

  factory CollocationItem.fromJson(Map<String, dynamic> json) {
    return CollocationItem(
      id: json['id'] as int,
      base: json['base'] as String,
      correct: json['correct'] as String,
      options: (json['options'] as List).map((e) => e.toString()).toList(),
      type: json['type'] as String,
      carrier: json['carrier'] as String,
      explanation: json['explanation'] as String,
    );
  }
}

class CollocationMatchScreen extends ConsumerStatefulWidget {
  const CollocationMatchScreen({super.key});

  @override
  ConsumerState<CollocationMatchScreen> createState() => _CollocationMatchScreenState();
}

class _CollocationMatchScreenState extends ConsumerState<CollocationMatchScreen> {
  List<CollocationItem> _items = [];
  int _currentIndex = 0;
  bool _isLoading = true;

  String? _selectedOption;
  bool _hasChecked = false;
  bool _isCorrect = false;

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
      final list = (data['collocations'] as List)
          .map((c) => CollocationItem.fromJson(c as Map<String, dynamic>))
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
      final item = _items[_currentIndex];
      ref.read(audioServiceProvider).speakOrPlay('${item.base} ${item.correct}. ${item.carrier}');
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
      _score += 150;
      _xpEarned += 30;
      ref.read(audioServiceProvider).playSfx(SfxType.correct);
      ref.read(audioServiceProvider).speakOrPlay('${item.base} ${item.correct}');

      _learnedItems.add(
        LearnedItem(
          term: '${item.base} ${item.correct}',
          definition: item.explanation,
          example: item.carrier.replaceAll('______', item.correct),
          wasMistake: false,
        ),
      );
    } else {
      ref.read(audioServiceProvider).playSfx(SfxType.wrong);
      _learnedItems.add(
        LearnedItem(
          term: '${item.base} ${item.correct}',
          definition: item.explanation,
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
      _finishGame();
    }
  }

  Future<void> _finishGame() async {
    final durationMs = DateTime.now().millisecondsSinceEpoch - _roundStartTime;
    final total = _items.isNotEmpty ? _items.length : 1;
    final accuracy = _correctCount / total;

    await ref.read(gameDaoProvider).recordSession(
          GameSessionsCompanion.insert(
            game: 'collocation_match',
            mode: const drift.Value('academic'),
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

    // Check achievement for collocation mastery
    if (accuracy >= 0.8) {
      await ref.read(statsDaoProvider).unlockAchievement('collocation_master');
    }

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => WhatYouLearnedScreen(
          gameTitle: '🔗 Collocation Match (Academic Lexis)',
          score: _score,
          xpEarned: _xpEarned,
          accuracy: accuracy,
          items: _learnedItems,
          onPlayAgain: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const CollocationMatchScreen()),
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
        appBar: AppBar(title: const Text('Collocation Match')),
        body: const Center(child: Text('No collocation exercises found.')),
      );
    }

    final theme = Theme.of(context);
    final item = _items[_currentIndex];
    final total = _items.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Collocation Match (${_currentIndex + 1}/$total)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up_rounded, color: AppColors.accent),
            tooltip: 'Hear Sentence',
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
              // Progress Bar
              LinearProgressIndicator(
                value: (_currentIndex + 1) / total,
                backgroundColor: theme.colorScheme.surface,
                valueColor: const AlwaysStoppedAnimation(AppColors.accent),
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
              ),
              const SizedBox(height: 18),

              // Category Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withAlpha(25),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.accent.withAlpha(80)),
                    ),
                    child: Text(
                      item.type == 'phrasal_verb' ? 'PHRASAL VERB' : 'VERB + NOUN COLLOCATION',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        color: AppColors.accent,
                      ),
                    ),
                  ),
                  Text(
                    'Score: $_score',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Carrier Sentence Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.colorScheme.outline),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Complete the academic pairing:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      item.carrier.replaceAll('______', _selectedOption ?? '______'),
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Option Grid
              Text(
                'Select Partner Word:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),

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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${item.base} $opt',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              if (_hasChecked && opt == item.correct)
                                const Icon(Icons.check_circle_rounded, color: AppColors.correct, size: 20)
                              else if (_hasChecked && isSel && !_isCorrect)
                                const Icon(Icons.cancel_rounded, color: AppColors.wrong, size: 20),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Pedagogical Explanation Box
              if (_hasChecked) ...[
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: (_isCorrect ? AppColors.correct : AppColors.wrong).withAlpha(15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: (_isCorrect ? AppColors.correct : AppColors.wrong).withAlpha(70),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        _isCorrect ? Icons.check_circle_outline_rounded : Icons.info_outline_rounded,
                        color: _isCorrect ? AppColors.correct : AppColors.wrong,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          item.explanation,
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.3,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
              ],

              // Bottom Action Button
              if (!_hasChecked)
                ElevatedButton(
                  onPressed: _selectedOption != null ? _checkAnswer : null,
                  child: const Text('Verify Collocation'),
                )
              else
                ElevatedButton(
                  onPressed: _next,
                  child: Text(_currentIndex + 1 < _items.length ? 'Next Collocation' : 'Finish Challenge'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
