import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../app/theme.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/db/database.dart';
import '../../../app/providers.dart';
import '../widgets/what_you_learned_screen.dart';

class SentenceUnscramblerScreen extends ConsumerStatefulWidget {
  final int level;

  const SentenceUnscramblerScreen({
    super.key,
    this.level = 1,
  });

  @override
  ConsumerState<SentenceUnscramblerScreen> createState() => _SentenceUnscramblerScreenState();
}

class _SentenceUnscramblerScreenState extends ConsumerState<SentenceUnscramblerScreen> {
  List<SentenceStructure> _sentences = [];
  int _currentIndex = 0;
  bool _isLoading = true;

  List<String> _bankWords = [];
  List<String> _assembledWords = [];
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
    _loadSentences();
  }

  Future<void> _loadSentences() async {
    final gameDao = ref.read(gameDaoProvider);
    final list = await gameDao.getSentencesForLevel(widget.level);
    if (!mounted) return;

    if (list.isEmpty) {
      final all = await ref.read(databaseProvider).select(ref.read(databaseProvider).sentenceStructures).get();
      setState(() {
        _sentences = List.of(all)..shuffle();
        _isLoading = false;
      });
    } else {
      setState(() {
        _sentences = List.of(list)..shuffle();
        _isLoading = false;
      });
    }

    if (_sentences.isNotEmpty) {
      _setupCurrentSentence();
    }
  }

  void _setupCurrentSentence() {
    final s = _sentences[_currentIndex];
    // Split into words without losing punctuation attached or basic tokens
    final tokens = s.sentence.split(' ');
    final shuffled = List<String>.from(tokens)..shuffle();

    setState(() {
      _bankWords = shuffled;
      _assembledWords = [];
      _hasChecked = false;
      _isCorrect = false;
    });
  }

  void _moveWordToAssembled(int index) {
    if (_hasChecked) return;
    final word = _bankWords.removeAt(index);
    ref.read(audioServiceProvider).speakOrPlay(word);
    setState(() {
      _assembledWords.add(word);
    });
  }

  void _moveWordToBank(int index) {
    if (_hasChecked) return;
    final word = _assembledWords.removeAt(index);
    setState(() {
      _bankWords.add(word);
    });
  }

  void _resetAssembledWords() {
    if (_hasChecked || _assembledWords.isEmpty) return;
    setState(() {
      _bankWords.addAll(_assembledWords);
      _assembledWords.clear();
    });
  }

  void _checkSentence() {
    if (_assembledWords.isEmpty) return;
    final current = _sentences[_currentIndex];
    final assembled = _assembledWords.join(' ');
    final expected = current.sentence.trim();

    final ok = (assembled.toLowerCase() == expected.toLowerCase());

    setState(() {
      _hasChecked = true;
      _isCorrect = ok;
    });

    if (ok) {
      _correctCount++;
      _score += 150;
      _xpEarned += 25;
      ref.read(audioServiceProvider).playSfx(SfxType.correct);
      ref.read(audioServiceProvider).speakOrPlay(expected);

      _learnedItems.add(
        LearnedItem(
          term: current.sentence,
          definition: current.simpleMeaning ?? 'Structured English sentence',
          example: current.connectorsJson != null && current.connectorsJson!.isNotEmpty
              ? 'Connectors: ${current.connectorsJson}'
              : '',
          wasMistake: false,
        ),
      );
    } else {
      ref.read(audioServiceProvider).playSfx(SfxType.wrong);

      _learnedItems.add(
        LearnedItem(
          term: current.sentence,
          definition: current.simpleMeaning ?? 'Structured English sentence',
          example: 'Correct: $expected',
          wasMistake: true,
        ),
      );
    }
  }

  void _nextSentence() {
    if (_currentIndex + 1 < _sentences.length && _currentIndex + 1 < 5) {
      setState(() {
        _currentIndex++;
        _setupCurrentSentence();
      });
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
            game: 'sentence_unscrambler',
            mode: const drift.Value('unscramble'),
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
          gameTitle: '🧱 Sentence Unscrambler',
          score: _score,
          xpEarned: _xpEarned,
          accuracy: accuracy,
          items: _learnedItems,
          onPlayAgain: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => SentenceUnscramblerScreen(level: widget.level),
              ),
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

    final theme = Theme.of(context);
    final current = _sentences[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Sentence Unscrambler (${_currentIndex + 1}/5)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up_rounded, color: AppColors.accent),
            onPressed: () => ref.read(audioServiceProvider).speakOrPlay(current.sentence),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Meaning hint or explanation
              if (current.simpleMeaning != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest.withAlpha(100),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline_rounded, color: AppColors.accent, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Meaning: ${current.simpleMeaning}',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),

              // Assembly Area
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _hasChecked
                          ? (_isCorrect ? AppColors.correct : AppColors.wrong)
                          : AppColors.accent.withAlpha(100),
                      width: 2,
                    ),
                  ),
                  child: _assembledWords.isEmpty
                      ? Center(
                          child: Text(
                            'Tap word tiles below in the correct order',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        )
                      : Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: List.generate(_assembledWords.length, (index) {
                            return ActionChip(
                              label: Text(
                                _assembledWords[index],
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              backgroundColor: AppColors.accent.withAlpha(50),
                              onPressed: () => _moveWordToBank(index),
                            );
                          }),
                        ),
                ),
              ),
              const SizedBox(height: 16),

              // Word Bank
              Expanded(
                flex: 4,
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(_bankWords.length, (index) {
                      return ActionChip(
                        label: Text(
                          _bankWords[index],
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        backgroundColor: theme.colorScheme.surfaceContainerHighest,
                        onPressed: () => _moveWordToAssembled(index),
                      );
                    }),
                  ),
                ),
              ),

              // Bottom Actions
              if (!_hasChecked)
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: _assembledWords.isNotEmpty ? _resetAssembledWords : null,
                      child: const Text('Reset'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _assembledWords.isNotEmpty ? _checkSentence : null,
                        child: const Text('Check Sentence'),
                      ),
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    if (!_isCorrect)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          'Correct: ${current.sentence}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: AppColors.wrong, fontWeight: FontWeight.bold),
                        ),
                      ),
                    Row(
                      children: [
                        OutlinedButton.icon(
                          icon: const Icon(Icons.help_outline_rounded, size: 18),
                          label: const Text('Why?'),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Grammar Structure'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Rule: ${current.simpleMeaning ?? "Standard English sentence pattern."}',
                                        style: const TextStyle(fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 10),
                                    Text('• Subject: ${current.subjectSpan ?? "Main Subject"}'),
                                    Text('• Verb: ${current.verbSpan ?? "Main Verb"}'),
                                    if (current.connectorsJson != null && current.connectorsJson!.isNotEmpty)
                                      Text('• Connectors: ${current.connectorsJson}'),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx),
                                    child: const Text('Got It'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _nextSentence,
                            child: Text(_currentIndex + 1 < 5 ? 'Next Sentence' : 'Finish Round'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
