import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../app/theme.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/db/database.dart';
import '../../../app/providers.dart';
import '../widgets/what_you_learned_screen.dart';

class FamilyItem {
  final String root;
  final String noun;
  final String verb;
  final String adjective;
  final String adverb;

  FamilyItem({
    required this.root,
    required this.noun,
    required this.verb,
    required this.adjective,
    required this.adverb,
  });
}

class WordFamilyTreeScreen extends ConsumerStatefulWidget {
  const WordFamilyTreeScreen({super.key});

  @override
  ConsumerState<WordFamilyTreeScreen> createState() => _WordFamilyTreeScreenState();
}

class _WordFamilyTreeScreenState extends ConsumerState<WordFamilyTreeScreen> {
  final List<FamilyItem> _families = [
    FamilyItem(root: 'DECIDE', noun: 'decision', verb: 'decide', adjective: 'decisive', adverb: 'decisively'),
    FamilyItem(root: 'CREATE', noun: 'creation', verb: 'create', adjective: 'creative', adverb: 'creatively'),
    FamilyItem(root: 'SIGNIFY', noun: 'significance', verb: 'signify', adjective: 'significant', adverb: 'significantly'),
    FamilyItem(root: 'ANALYZE', noun: 'analysis', verb: 'analyze', adjective: 'analytical', adverb: 'analytically'),
    FamilyItem(root: 'SUCCEED', noun: 'success', verb: 'succeed', adjective: 'successful', adverb: 'successfully'),
  ];

  int _currentIndex = 0;
  String _missingType = 'adjective'; // The branch that is blanked out
  String? _selectedOption;
  List<String> _options = [];
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
    _setupCurrentFamily();
  }

  void _setupCurrentFamily() {
    final current = _families[_currentIndex];
    // Rotate missing quadrant
    const types = ['noun', 'adjective', 'adverb', 'verb'];
    _missingType = types[_currentIndex % types.length];

    String targetWord;
    switch (_missingType) {
      case 'noun':
        targetWord = current.noun;
        break;
      case 'verb':
        targetWord = current.verb;
        break;
      case 'adjective':
        targetWord = current.adjective;
        break;
      case 'adverb':
      default:
        targetWord = current.adverb;
        break;
    }

    // Generate 3 plausible morphological distractors
    final distractors = <String>{};
    if (_missingType == 'noun') {
      distractors.addAll(['${current.verb}ment', '${current.verb}ance', '${current.adjective}ness']);
    } else if (_missingType == 'adjective') {
      distractors.addAll(['${current.verb}able', '${current.noun}ful', '${current.verb}ive']);
    } else if (_missingType == 'adverb') {
      distractors.addAll(['${current.adjective}ly', '${current.verb}ingly', '${current.noun}ly']);
    } else {
      distractors.addAll(['${current.noun}ize', 'en${current.verb}', '${current.verb}ate']);
    }

    final list = [targetWord, ...distractors.take(3)]..shuffle();

    setState(() {
      _options = list;
      _selectedOption = null;
      _hasChecked = false;
      _isCorrect = false;
    });

    ref.read(audioServiceProvider).speakOrPlay(current.root);
  }

  void _checkAnswer() {
    if (_selectedOption == null || _hasChecked) return;
    final current = _families[_currentIndex];
    String targetWord;
    switch (_missingType) {
      case 'noun':
        targetWord = current.noun;
        break;
      case 'verb':
        targetWord = current.verb;
        break;
      case 'adjective':
        targetWord = current.adjective;
        break;
      case 'adverb':
      default:
        targetWord = current.adverb;
        break;
    }

    final isCorrect = _selectedOption == targetWord;
    setState(() {
      _hasChecked = true;
      _isCorrect = isCorrect;
    });

    if (isCorrect) {
      _correctCount++;
      _score += 150;
      _xpEarned += 30;
      ref.read(audioServiceProvider).playSfx(SfxType.correct);
      ref.read(audioServiceProvider).speakOrPlay('$targetWord. A full family: ${current.verb}, ${current.noun}, ${current.adjective}, ${current.adverb}.');

      _learnedItems.add(
        LearnedItem(
          term: '${current.root} Family',
          definition: 'N: ${current.noun} • V: ${current.verb} • Adj: ${current.adjective} • Adv: ${current.adverb}',
          example: 'Target $_missingType: $targetWord',
          wasMistake: false,
        ),
      );
    } else {
      ref.read(audioServiceProvider).playSfx(SfxType.wrong);

      _learnedItems.add(
        LearnedItem(
          term: '${current.root} Family',
          definition: 'N: ${current.noun} • V: ${current.verb} • Adj: ${current.adjective} • Adv: ${current.adverb}',
          example: 'Target $_missingType: $targetWord',
          wasMistake: true,
        ),
      );
    }
  }

  void _next() {
    if (_currentIndex + 1 < _families.length) {
      setState(() {
        _currentIndex++;
      });
      _setupCurrentFamily();
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
            game: 'word_family_tree',
            mode: const drift.Value('quadrant_tree'),
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
          gameTitle: '🌳 Word Family Tree',
          score: _score,
          xpEarned: _xpEarned,
          accuracy: accuracy,
          items: _learnedItems,
          onPlayAgain: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const WordFamilyTreeScreen()),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final current = _families[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Word Family Tree (${_currentIndex + 1}/${_families.length})'),
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up_rounded, color: AppColors.accent),
            tooltip: 'Hear Word Family',
            onPressed: () => ref.read(audioServiceProvider).speakOrPlay('${current.verb}, ${current.noun}, ${current.adjective}, ${current.adverb}'),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Root Header Banner
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ROOT MORPHEME', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: theme.colorScheme.primary)),
                        const SizedBox(height: 2),
                        Text(current.root, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withAlpha(20),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Missing: ${_missingType.toUpperCase()}',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: theme.colorScheme.primary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // 4-Quadrant Tree Grid
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _QuadrantCard(
                          label: 'VERB',
                          word: _missingType == 'verb' ? (_selectedOption ?? '______') : current.verb,
                          isTarget: _missingType == 'verb',
                          hasChecked: _hasChecked,
                          isCorrect: _isCorrect,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _QuadrantCard(
                          label: 'NOUN',
                          word: _missingType == 'noun' ? (_selectedOption ?? '______') : current.noun,
                          isTarget: _missingType == 'noun',
                          hasChecked: _hasChecked,
                          isCorrect: _isCorrect,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _QuadrantCard(
                          label: 'ADJECTIVE',
                          word: _missingType == 'adjective' ? (_selectedOption ?? '______') : current.adjective,
                          isTarget: _missingType == 'adjective',
                          hasChecked: _hasChecked,
                          isCorrect: _isCorrect,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _QuadrantCard(
                          label: 'ADVERB',
                          word: _missingType == 'adverb' ? (_selectedOption ?? '______') : current.adverb,
                          isTarget: _missingType == 'adverb',
                          hasChecked: _hasChecked,
                          isCorrect: _isCorrect,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Candidate options
              Text('Complete the ${_missingType.toUpperCase()} form:', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _options.map((opt) {
                  final isSel = _selectedOption == opt;
                  return ChoiceChip(
                    label: Text(opt, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    selected: isSel,
                    onSelected: _hasChecked ? null : (_) => setState(() => _selectedOption = opt),
                  );
                }).toList(),
              ),

              const Spacer(),

              // Action button
              if (!_hasChecked)
                ElevatedButton(
                  onPressed: _selectedOption != null ? _checkAnswer : null,
                  child: const Text('Complete Family Tree'),
                )
              else
                ElevatedButton(
                  onPressed: _next,
                  child: Text(_currentIndex + 1 < _families.length ? 'Next Family' : 'Finish Tree Exercises'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuadrantCard extends StatelessWidget {
  final String label;
  final String word;
  final bool isTarget;
  final bool hasChecked;
  final bool isCorrect;

  const _QuadrantCard({
    required this.label,
    required this.word,
    required this.isTarget,
    required this.hasChecked,
    required this.isCorrect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color borderColor = isTarget ? theme.colorScheme.primary : theme.colorScheme.outline;
    Color bgColor = theme.colorScheme.surface;

    if (hasChecked && isTarget) {
      borderColor = isCorrect ? AppColors.correct : AppColors.wrong;
      bgColor = isCorrect ? AppColors.correct.withAlpha(20) : AppColors.wrong.withAlpha(20);
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: isTarget ? 2 : 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
          Text(
            word,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isTarget && word == '______' ? theme.colorScheme.onSurfaceVariant : theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
