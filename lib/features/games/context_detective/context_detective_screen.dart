import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../app/theme.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/db/database.dart';
import '../../../app/providers.dart';
import '../../../core/services/phase2_content_service.dart';
import '../widgets/what_you_learned_screen.dart';

class DetectiveItem {
  final int id;
  final String targetWord;
  final String sentence;
  final List<String> options;
  final String answer;
  final String clueType;
  final String explanation;

  DetectiveItem({
    required this.id,
    required this.targetWord,
    required this.sentence,
    required this.options,
    required this.answer,
    required this.clueType,
    required this.explanation,
  });

  factory DetectiveItem.fromJson(Map<String, dynamic> json) {
    return DetectiveItem(
      id: json['id'] as int,
      targetWord: json['targetWord'] as String,
      sentence: json['sentence'] as String,
      options: (json['options'] as List).map((o) => o.toString()).toList(),
      answer: json['answer'] as String,
      clueType: json['clueType'] as String,
      explanation: json['explanation'] as String,
    );
  }
}

class ContextDetectiveScreen extends ConsumerStatefulWidget {
  const ContextDetectiveScreen({super.key});

  @override
  ConsumerState<ContextDetectiveScreen> createState() => _ContextDetectiveScreenState();
}

class _ContextDetectiveScreenState extends ConsumerState<ContextDetectiveScreen> {
  List<DetectiveItem> _items = [];
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
      final data = await Phase2ContentService.instance.loadContent();
      final list = (data['context_detective'] as List)
          .map((d) => DetectiveItem.fromJson(d as Map<String, dynamic>))
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
      ref.read(audioServiceProvider).speakOrPlay(_items[_currentIndex].sentence);
    }
  }

  void _selectOption(String opt) {
    if (_hasChecked) return;
    setState(() => _selectedOption = opt);
  }

  void _checkAnswer() {
    if (_selectedOption == null || _hasChecked) return;
    final current = _items[_currentIndex];
    final isCorrect = _selectedOption == current.answer;

    setState(() {
      _hasChecked = true;
      _isCorrect = isCorrect;
    });

    if (isCorrect) {
      _correctCount++;
      _score += 150;
      _xpEarned += 30;
      ref.read(audioServiceProvider).playSfx(SfxType.correct);
      ref.read(audioServiceProvider).speakOrPlay(current.targetWord);

      _learnedItems.add(
        LearnedItem(
          term: current.targetWord,
          definition: current.answer,
          example: current.sentence,
          wasMistake: false,
        ),
      );
    } else {
      ref.read(audioServiceProvider).playSfx(SfxType.wrong);

      _learnedItems.add(
        LearnedItem(
          term: current.targetWord,
          definition: current.answer,
          example: current.sentence,
          wasMistake: true,
        ),
      );
    }
  }

  Future<void> _saveToWild() async {
    final current = _items[_currentIndex];
    final db = ref.read(databaseProvider);
    await db.into(db.wildItems).insert(
          WildItemsCompanion.insert(
            sentence: current.sentence,
            source: const drift.Value('Context Detective'),
            savedAt: DateTime.now().millisecondsSinceEpoch,
          ),
        );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Saved "${current.targetWord}" to Wild Words!'),
        backgroundColor: AppColors.correct,
      ),
    );
  }

  void _next() {
    if (_currentIndex + 1 < _items.length && _currentIndex + 1 < 5) {
      setState(() {
        _currentIndex++;
        _selectedOption = null;
        _hasChecked = false;
        _isCorrect = false;
      });
      _speakSentence();
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
            game: 'context_detective',
            mode: const drift.Value('context_clues'),
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
          gameTitle: '🔍 Context Detective',
          score: _score,
          xpEarned: _xpEarned,
          accuracy: accuracy,
          items: _learnedItems,
          onPlayAgain: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const ContextDetectiveScreen()),
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
        appBar: AppBar(title: const Text('Context Detective')),
        body: const Center(child: Text('No detective items found.')),
      );
    }

    final theme = Theme.of(context);
    final current = _items[_currentIndex];
    final total = _items.length < 5 ? _items.length : 5;

    return Scaffold(
      appBar: AppBar(
        title: Text('Context Detective (${_currentIndex + 1}/$total)'),
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
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Row: Clue Type & Target Word
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withAlpha(25),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      current.clueType.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  Text(
                    _hasChecked
                        ? (_isCorrect ? '✓ CORRECT' : '✗ REVIEW')
                        : 'Target: ${current.targetWord.toUpperCase()}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: _hasChecked
                          ? (_isCorrect ? AppColors.correct : AppColors.wrong)
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Academic Context Sentence Box
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
                      fontSize: 16,
                      height: 1.55,
                      color: theme.colorScheme.onSurface,
                    ),
                    children: _buildHighlightedSentence(current.sentence, current.targetWord, theme),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Multiple Choice Options
              Expanded(
                child: ListView.separated(
                  itemCount: current.options.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final opt = current.options[index];
                    final isSelected = _selectedOption == opt;
                    final isTarget = opt == current.answer;

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
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: borderColor,
                            width: isSelected || (_hasChecked && isTarget) ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: borderColor.withAlpha(40),
                              child: Text(
                                String.fromCharCode(65 + index),
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textColor),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                opt,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                  color: textColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Teacher Clue Analysis
              if (_hasChecked)
                Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest.withAlpha(120),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.colorScheme.outline),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.travel_explore_rounded, size: 18, color: AppColors.accent),
                              const SizedBox(width: 8),
                              Text(
                                'Detective Clue Analysis (${current.clueType})',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: _saveToWild,
                            child: Row(
                              children: [
                                const Icon(Icons.bookmark_add_rounded, size: 16, color: AppColors.accent),
                                const SizedBox(width: 4),
                                Text(
                                  'Save to Wild',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        current.explanation,
                        style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurfaceVariant, height: 1.3),
                      ),
                    ],
                  ),
                ),

              // Action button
              if (!_hasChecked)
                ElevatedButton(
                  onPressed: _selectedOption != null ? _checkAnswer : null,
                  child: const Text('Confirm Deduction'),
                )
              else
                ElevatedButton(
                  onPressed: _next,
                  child: Text(_currentIndex + 1 < total ? 'Next Case' : 'Complete Investigation'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  List<TextSpan> _buildHighlightedSentence(String sentence, String targetWord, ThemeData theme) {
    final lowerSent = sentence.toLowerCase();
    final lowerTarget = targetWord.toLowerCase();
    final index = lowerSent.indexOf(lowerTarget);

    if (index == -1) {
      return [TextSpan(text: sentence)];
    }

    final before = sentence.substring(0, index);
    final target = sentence.substring(index, index + targetWord.length);
    final after = sentence.substring(index + targetWord.length);

    return [
      TextSpan(text: before),
      TextSpan(
        text: target,
        style: TextStyle(
          fontWeight: FontWeight.w800,
          color: theme.colorScheme.primary,
          decoration: TextDecoration.underline,
          decorationColor: theme.colorScheme.primary,
          decorationThickness: 2,
        ),
      ),
      TextSpan(text: after),
    ];
  }
}
