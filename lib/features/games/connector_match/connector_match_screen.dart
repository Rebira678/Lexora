import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../app/theme.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/db/database.dart';
import '../../../app/providers.dart';
import '../../../core/planner/difficulty_tuner.dart';
import '../../../core/services/phase2_content_service.dart';
import '../widgets/what_you_learned_screen.dart';

class ConnectorItem {
  final int id;
  final int level;
  final String sentenceBefore;
  final String sentenceAfter;
  final String correct;
  final String category;
  final List<String> options;
  final String explanation;

  ConnectorItem({
    required this.id,
    required this.level,
    required this.sentenceBefore,
    required this.sentenceAfter,
    required this.correct,
    required this.category,
    required this.options,
    required this.explanation,
  });

  factory ConnectorItem.fromJson(Map<String, dynamic> json) {
    return ConnectorItem(
      id: json['id'] as int,
      level: json['level'] as int? ?? 2,
      sentenceBefore: json['sentenceBefore'] as String,
      sentenceAfter: json['sentenceAfter'] as String,
      correct: json['correct'] as String,
      category: json['category'] as String,
      options: (json['options'] as List).map((o) => o.toString()).toList(),
      explanation: json['explanation'] as String,
    );
  }
}

class ConnectorMatchScreen extends ConsumerStatefulWidget {
  final int level;

  const ConnectorMatchScreen({
    super.key,
    this.level = 2,
  });

  @override
  ConsumerState<ConnectorMatchScreen> createState() => _ConnectorMatchScreenState();
}

class _ConnectorMatchScreenState extends ConsumerState<ConnectorMatchScreen> {
  List<ConnectorItem> _items = [];
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
    _loadConnectors();
  }

  Future<void> _loadConnectors() async {
    try {
      final data = await Phase2ContentService.instance.loadContent();
      final list = (data['connectors'] as List)
          .map((c) => ConnectorItem.fromJson(c as Map<String, dynamic>))
          .toList();

      if (!mounted) return;
      setState(() {
        _items = list..shuffle();
        _isLoading = false;
      });

      if (_items.isNotEmpty) {
        _speakPrompt();
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  void _speakPrompt() {
    if (_currentIndex < _items.length) {
      final current = _items[_currentIndex];
      ref.read(audioServiceProvider).speakOrPlay('${current.sentenceBefore} ... ${current.sentenceAfter}');
    }
  }

  void _selectOption(String opt) {
    if (_hasChecked) return;
    setState(() => _selectedOption = opt);
  }

  void _checkAnswer() {
    if (_selectedOption == null || _hasChecked) return;
    final current = _items[_currentIndex];
    final isCorrect = _selectedOption!.trim().toLowerCase() == current.correct.trim().toLowerCase();

    setState(() {
      _hasChecked = true;
      _isCorrect = isCorrect;
    });

    final fullSentence = '${current.sentenceBefore} ${current.correct}, ${current.sentenceAfter}';

    if (isCorrect) {
      _correctCount++;
      _score += 150;
      _xpEarned += 30;
      ref.read(audioServiceProvider).playSfx(SfxType.correct);
      ref.read(audioServiceProvider).speakOrPlay(fullSentence);

      _learnedItems.add(
        LearnedItem(
          term: current.correct,
          definition: '${current.category}: ${current.explanation}',
          example: fullSentence,
          wasMistake: false,
        ),
      );
    } else {
      ref.read(audioServiceProvider).playSfx(SfxType.wrong);

      _learnedItems.add(
        LearnedItem(
          term: current.correct,
          definition: '${current.category}: ${current.explanation}',
          example: fullSentence,
          wasMistake: true,
        ),
      );
    }
  }

  void _next() {
    if (_currentIndex + 1 < _items.length && _currentIndex + 1 < 6) {
      setState(() {
        _currentIndex++;
        _selectedOption = null;
        _hasChecked = false;
        _isCorrect = false;
      });
      _speakPrompt();
    } else {
      _endGame();
    }
  }

  Future<void> _endGame() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final durationMs = now - _roundStartTime;
    final total = _currentIndex + 1;
    final accuracy = total == 0 ? 0.0 : _correctCount / total;
    final nextLevel = nextSentenceLevel(widget.level, accuracy, 3);

    await ref.read(gameDaoProvider).recordSession(
          GameSessionsCompanion.insert(
            game: 'connector_match',
            mode: const drift.Value('logical_flow'),
            level: drift.Value(widget.level),
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
          gameTitle: '🔗 Connector Match (Level ${widget.level} ➔ $nextLevel)',
          score: _score,
          xpEarned: _xpEarned,
          accuracy: accuracy,
          items: _learnedItems,
          onPlayAgain: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => ConnectorMatchScreen(level: nextLevel)),
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
        appBar: AppBar(title: const Text('Connector Match')),
        body: const Center(child: Text('No connector exercises found.')),
      );
    }

    final theme = Theme.of(context);
    final current = _items[_currentIndex];
    final total = _items.length < 6 ? _items.length : 6;

    return Scaffold(
      appBar: AppBar(
        title: Text('Connector Match (${_currentIndex + 1}/$total)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up_rounded, color: AppColors.accent),
            tooltip: 'Hear Sentence',
            onPressed: _speakPrompt,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Category pill
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withAlpha(25),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      current.category.toUpperCase(),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Complex Sentence Box
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.colorScheme.outline),
                ),
                child: RichText(
                  text: TextSpan(
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 17,
                      height: 1.5,
                      color: theme.colorScheme.onSurface,
                    ),
                    children: [
                      TextSpan(text: '${current.sentenceBefore} '),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: _hasChecked
                                ? (_isCorrect ? AppColors.correct.withAlpha(30) : AppColors.wrong.withAlpha(30))
                                : theme.colorScheme.primary.withAlpha(20),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: _hasChecked
                                  ? (_isCorrect ? AppColors.correct : AppColors.wrong)
                                  : theme.colorScheme.primary,
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            _selectedOption != null ? _selectedOption! : '______',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: _hasChecked
                                  ? (_isCorrect ? AppColors.correct : AppColors.wrong)
                                  : theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                      TextSpan(text: ' ${current.sentenceAfter}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Options 2x2 Grid
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 2.2,
                  children: current.options.map((opt) {
                    final isSelected = _selectedOption == opt;
                    final isTarget = opt == current.correct;

                    Color borderColor = theme.colorScheme.outline;
                    Color bgColor = theme.colorScheme.surface;
                    Color textColor = theme.colorScheme.onSurface;

                    if (!_hasChecked) {
                      if (isSelected) {
                        borderColor = theme.colorScheme.primary;
                        bgColor = theme.colorScheme.primary.withAlpha(25);
                        textColor = theme.colorScheme.primary;
                      }
                    } else {
                      if (isTarget) {
                        borderColor = AppColors.correct;
                        bgColor = AppColors.correct.withAlpha(30);
                        textColor = AppColors.correct;
                      } else if (isSelected && !isTarget) {
                        borderColor = AppColors.wrong;
                        bgColor = AppColors.wrong.withAlpha(30);
                        textColor = AppColors.wrong;
                      }
                    }

                    return InkWell(
                      onTap: () => _selectOption(opt),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor, width: isSelected || (_hasChecked && isTarget) ? 2 : 1),
                        ),
                        child: Text(
                          opt,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              // Teacher Explanation
              if (_hasChecked)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest.withAlpha(120),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.colorScheme.outline),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.school_rounded, size: 20, color: AppColors.accent),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Teacher Note (${current.category})',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              current.explanation,
                              style: TextStyle(
                                fontSize: 13,
                                color: theme.colorScheme.onSurfaceVariant,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              // Action button
              if (!_hasChecked)
                ElevatedButton(
                  onPressed: _selectedOption != null ? _checkAnswer : null,
                  child: const Text('Verify Connector'),
                )
              else
                ElevatedButton(
                  onPressed: _next,
                  child: Text(_currentIndex + 1 < total ? 'Next Sentence' : 'Finish Exercise'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
