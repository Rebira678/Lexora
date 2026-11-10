import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../app/theme.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/db/database.dart';
import '../../../app/providers.dart';
import '../../../core/services/phase3_content_service.dart';
import '../games/widgets/what_you_learned_screen.dart';

class WordForgeItem {
  final int id;
  final List<String> targetWords;
  final String theme;
  final String modelAnswer;
  final String pedagogyNote;

  const WordForgeItem({
    required this.id,
    required this.targetWords,
    required this.theme,
    required this.modelAnswer,
    required this.pedagogyNote,
  });

  factory WordForgeItem.fromJson(Map<String, dynamic> json) {
    return WordForgeItem(
      id: json['id'] as int,
      targetWords: (json['targetWords'] as List).map((w) => w.toString()).toList(),
      theme: json['theme'] as String,
      modelAnswer: json['modelAnswer'] as String,
      pedagogyNote: json['pedagogyNote'] as String,
    );
  }
}

class WordForgeScreen extends ConsumerStatefulWidget {
  const WordForgeScreen({super.key});

  @override
  ConsumerState<WordForgeScreen> createState() => _WordForgeScreenState();
}

class _WordForgeScreenState extends ConsumerState<WordForgeScreen> {
  List<WordForgeItem> _items = [];
  int _currentIndex = 0;
  bool _isLoading = true;

  final TextEditingController _controller = TextEditingController();
  bool _hasEvaluated = false;
  List<String> _evaluationErrors = [];
  bool _allRulesPassed = false;

  int _score = 0;
  int _xpEarned = 0;
  int _correctCount = 0;
  final List<LearnedItem> _learnedItems = [];
  int _roundStartTime = 0;

  @override
  void initState() {
    super.initState();
    _roundStartTime = DateTime.now().millisecondsSinceEpoch;
    _controller.addListener(() => setState(() {}));
    _loadItems();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadItems() async {
    try {
      final data = await Phase3ContentService.instance.loadContent();
      final list = (data['word_forge'] as List)
          .map((w) => WordForgeItem.fromJson(w as Map<String, dynamic>))
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

  bool _isWordUsed(String word) {
    final text = _controller.text.toLowerCase();
    // Check lemma or standard stem
    final regex = RegExp(r'\b' + RegExp.escape(word.toLowerCase().substring(0, (word.length * 0.75).round())) + r'\w*\b');
    return regex.hasMatch(text);
  }

  void _evaluateSentence() {
    final text = _controller.text.trim();
    final item = _items[_currentIndex];
    final errors = <String>[];

    // Rule 1: All target words used
    for (final word in item.targetWords) {
      if (!_isWordUsed(word)) {
        errors.add("Missing target word: '$word'");
      }
    }

    // Rule 2: Minimum word count (12 words for C1 academic complexity)
    final words = text.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    if (words.length < 12) {
      errors.add("Sentence too short (${words.length}/12 words). Expand with clauses or modifiers.");
    }

    // Rule 3: Capitalization & punctuation
    if (text.isNotEmpty && text[0] != text[0].toUpperCase()) {
      errors.add("Must begin with a capital letter.");
    }
    if (!text.endsWith('.') && !text.endsWith('!') && !text.endsWith('?')) {
      errors.add("Must terminate with valid punctuation (. or ?).");
    }

    // Rule 4: No consecutive repeated words (e.g. 'the the')
    for (int i = 0; i < words.length - 1; i++) {
      if (words[i].toLowerCase() == words[i + 1].toLowerCase()) {
        errors.add("Duplicate consecutive word detected: '${words[i]}'");
      }
    }

    final passed = errors.isEmpty;

    setState(() {
      _hasEvaluated = true;
      _evaluationErrors = errors;
      _allRulesPassed = passed;
    });

    if (passed) {
      _correctCount++;
      _score += 250;
      _xpEarned += 50;
      ref.read(audioServiceProvider).playSfx(SfxType.correct);

      // Save to database
      ref.read(databaseProvider).into(ref.read(databaseProvider).userTexts).insert(
            UserTextsCompanion.insert(
              prompt: 'Word Forge: ${item.targetWords.join(', ')}',
              body: text,
              createdAt: DateTime.now().millisecondsSinceEpoch,
              selfScore: const drift.Value(5),
            ),
          );

      _learnedItems.add(
        LearnedItem(
          term: 'Forge: ${item.targetWords.join(' • ')}',
          definition: item.pedagogyNote,
          example: text,
          wasMistake: false,
        ),
      );
    } else {
      ref.read(audioServiceProvider).playSfx(SfxType.wrong);
    }
  }

  void _next() {
    if (_currentIndex + 1 < _items.length) {
      setState(() {
        _currentIndex++;
        _controller.clear();
        _hasEvaluated = false;
        _evaluationErrors = [];
        _allRulesPassed = false;
      });
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
            game: 'word_forge',
            mode: const drift.Value('synthesis'),
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

    // Unlock achievement
    await ref.read(statsDaoProvider).unlockAchievement('word_forger');

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => WhatYouLearnedScreen(
          gameTitle: '✍️ Word Forge (Syntactic Production)',
          score: _score,
          xpEarned: _xpEarned,
          accuracy: accuracy,
          items: _learnedItems,
          onPlayAgain: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const WordForgeScreen()),
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
        appBar: AppBar(title: const Text('Word Forge')),
        body: const Center(child: Text('No forge prompts found.')),
      );
    }

    final theme = Theme.of(context);
    final item = _items[_currentIndex];
    final total = _items.length;
    final wordsCount = _controller.text.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Word Forge (${_currentIndex + 1}/$total)'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Theme pill & Score
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
                      item.theme.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        color: AppColors.accent,
                      ),
                    ),
                  ),
                  Text('Score: $_score', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 14),

              // Instruction Card
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
                    Text(
                      'Synthesize One Academic Sentence',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Construct a cohesive, multi-clause sentence incorporating all 3 target words. Aim for 12+ words with proper punctuation.',
                      style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant, height: 1.3),
                    ),
                    const SizedBox(height: 14),

                    // Target Word Chips
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: item.targetWords.map((word) {
                        final isUsed = _isWordUsed(word);
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: isUsed ? AppColors.correct.withAlpha(30) : theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isUsed ? AppColors.correct : theme.colorScheme.outline,
                              width: isUsed ? 1.5 : 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isUsed ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                                size: 14,
                                color: isUsed ? AppColors.correct : theme.colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                word,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: isUsed ? AppColors.correct : theme.colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Drafting Text Area
              TextField(
                controller: _controller,
                maxLines: 4,
                readOnly: _hasEvaluated && _allRulesPassed,
                style: const TextStyle(fontSize: 15, height: 1.4),
                decoration: InputDecoration(
                  hintText: 'Draft your sentence here...',
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: theme.colorScheme.outline),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.accent, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Live Word Count
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$wordsCount words (12+ recommended)',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: wordsCount >= 12 ? AppColors.correct : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (_hasEvaluated && _allRulesPassed)
                    const Text(
                      '✓ Saved to Writing Portfolio',
                      style: TextStyle(fontSize: 11, color: AppColors.correct, fontWeight: FontWeight.bold),
                    ),
                ],
              ),
              const SizedBox(height: 16),

              // Evaluation Feedback or Errors
              if (_hasEvaluated) ...[
                if (!_allRulesPassed)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.wrong.withAlpha(20),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.wrong.withAlpha(80)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.error_outline_rounded, color: AppColors.wrong, size: 16),
                            SizedBox(width: 6),
                            Text('Revisions Required:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.wrong)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ..._evaluationErrors.map((err) => Padding(
                              padding: const EdgeInsets.only(bottom: 2),
                              child: Text('• $err', style: const TextStyle(fontSize: 12, height: 1.2)),
                            )),
                      ],
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.correct.withAlpha(20),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.correct.withAlpha(80)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.stars_rounded, color: AppColors.correct, size: 18),
                            SizedBox(width: 8),
                            Text('Exceptional Academic Synthesis!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.correct)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(item.pedagogyNote, style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface, height: 1.3)),
                        const Divider(height: 16),
                        Text('Senior Model Sentence:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: theme.colorScheme.primary)),
                        const SizedBox(height: 4),
                        Text('"${item.modelAnswer}"', style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 13, height: 1.3)),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),
              ],

              // Action Button
              if (!_hasEvaluated || !_allRulesPassed)
                ElevatedButton(
                  onPressed: _controller.text.trim().isNotEmpty ? _evaluateSentence : null,
                  child: const Text('Evaluate Sentence'),
                )
              else
                ElevatedButton(
                  onPressed: _next,
                  child: Text(_currentIndex + 1 < _items.length ? 'Next Word Forge' : 'Finish Challenge'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
