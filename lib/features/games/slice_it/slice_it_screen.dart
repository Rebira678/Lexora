import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../app/theme.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/db/database.dart';
import '../../../app/providers.dart';
import '../../../core/scoring/scoring.dart';
import '../../../core/planner/difficulty_tuner.dart';
import '../widgets/what_you_learned_screen.dart';

class SliceItScreen extends ConsumerStatefulWidget {
  final int level;

  const SliceItScreen({
    super.key,
    this.level = 2,
  });

  @override
  ConsumerState<SliceItScreen> createState() => _SliceItScreenState();
}

class _SliceItScreenState extends ConsumerState<SliceItScreen> {
  List<SentenceStructure> _sentences = [];
  int _currentIndex = 0;
  bool _isLoading = true;

  final Set<int> _playerCuts = {};
  Set<int> _expectedCuts = {};
  List<String> _words = [];

  bool _hasChecked = false;
  double _lastMatchAcc = 0.0;
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

    if (list.isNotEmpty) {
      setState(() {
        _sentences = List.of(list)..shuffle();
        _isLoading = false;
      });
    } else {
      final all = await ref.read(databaseProvider).select(ref.read(databaseProvider).sentenceStructures).get();
      setState(() {
        _sentences = List.of(all)..shuffle();
        _isLoading = false;
      });
    }

    if (_sentences.isNotEmpty) {
      _setupCurrentSentence();
    }
  }

  void _setupCurrentSentence() {
    final current = _sentences[_currentIndex];
    final words = current.sentence.split(RegExp(r'\s+'));
    final expectedCuts = _calculateExpectedCuts(current.chunksJson, words);

    setState(() {
      _words = words;
      _expectedCuts = expectedCuts;
      _playerCuts.clear();
      _hasChecked = false;
      _lastMatchAcc = 0.0;
    });

    ref.read(audioServiceProvider).speakOrPlay(current.sentence);
  }

  /// Calculates word boundary cut indices based on chunks_json.
  Set<int> _calculateExpectedCuts(String? chunksJson, List<String> words) {
    if (chunksJson == null || chunksJson.trim().isEmpty) return {};
    try {
      final List<dynamic> chunks = json.decode(chunksJson);
      final cuts = <int>{};
      int wordIndexCounter = 0;

      for (int i = 0; i < chunks.length - 1; i++) {
        final chunkText = chunks[i].toString().trim();
        final chunkWords = chunkText.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
        wordIndexCounter += chunkWords.length;
        if (wordIndexCounter - 1 < words.length - 1) {
          cuts.add(wordIndexCounter - 1);
        }
      }
      return cuts;
    } catch (_) {
      return {};
    }
  }

  void _toggleCut(int index) {
    if (_hasChecked) return;
    setState(() {
      if (_playerCuts.contains(index)) {
        _playerCuts.remove(index);
      } else {
        _playerCuts.add(index);
      }
    });
  }

  void _checkSlices() {
    final current = _sentences[_currentIndex];
    final similarity = sliceItScore(
      tappedCuts: _playerCuts,
      correctCuts: _expectedCuts,
    );
    final isGood = similarity >= 0.60;

    setState(() {
      _hasChecked = true;
      _lastMatchAcc = similarity;
    });

    if (isGood) {
      _correctCount++;
      final earned = (similarity * 180).round();
      _score += earned;
      _xpEarned += (earned * 0.25).round();
      ref.read(audioServiceProvider).playSfx(SfxType.correct);
      ref.read(audioServiceProvider).speakOrPlay(current.sentence);

      _learnedItems.add(
        LearnedItem(
          term: current.sentence,
          definition: current.simpleMeaning ?? 'Sentence chunking & phrase boundary analysis',
          example: 'Chunk accuracy: ${(similarity * 100).round()}%',
          wasMistake: false,
        ),
      );
    } else {
      ref.read(audioServiceProvider).playSfx(SfxType.wrong);

      _learnedItems.add(
        LearnedItem(
          term: current.sentence,
          definition: current.simpleMeaning ?? 'Sentence chunking & phrase boundary analysis',
          example: 'Review natural pauses & clause connectors (Accuracy: ${(similarity * 100).round()}%)',
          wasMistake: true,
        ),
      );
    }
  }

  void _nextSentence() {
    final maxSentences = _sentences.length < 8 ? _sentences.length : 8;
    if (_currentIndex + 1 < maxSentences) {
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
    final nextLevel = nextSentenceLevel(widget.level, accuracy, 3);

    await ref.read(gameDaoProvider).recordSession(
          GameSessionsCompanion.insert(
            game: 'slice_it',
            mode: const drift.Value('chunk_slicing'),
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
          gameTitle: '✂️ Slice It (Level ${widget.level} ➔ $nextLevel)',
          score: _score,
          xpEarned: _xpEarned,
          accuracy: accuracy,
          items: _learnedItems,
          onPlayAgain: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => SliceItScreen(level: nextLevel)),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _sentences.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final theme = Theme.of(context);
    final current = _sentences[_currentIndex];
    final maxSentences = _sentences.length < 8 ? _sentences.length : 8;

    return Scaffold(
      appBar: AppBar(
        title: Text('Slice It (${_currentIndex + 1}/$maxSentences)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up_rounded, color: AppColors.accent),
            tooltip: 'Listen to sentence',
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
              // Instruction banner
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.colorScheme.outline),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.content_cut_rounded, size: 18, color: AppColors.accent),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _hasChecked
                            ? 'Chunk Match: ${(_lastMatchAcc * 100).round()}%'
                            : 'Tap between words to slice the sentence into meaning chunks.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: _hasChecked ? FontWeight.w700 : FontWeight.w500,
                          color: _hasChecked
                              ? (_lastMatchAcc >= 0.60 ? AppColors.correct : AppColors.wrong)
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Interactive Sentence Word & Slicer Area
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: theme.colorScheme.outline),
                  ),
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 4,
                      runSpacing: 14,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: List.generate(_words.length * 2 - 1, (flatIndex) {
                        final isWord = flatIndex % 2 == 0;
                        final wordIndex = flatIndex ~/ 2;

                        if (isWord) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest.withAlpha(120),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _words[wordIndex],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          );
                        } else {
                          // Cut slot divider between wordIndex and wordIndex + 1
                          final cutIndex = wordIndex;
                          final isCutByPlayer = _playerCuts.contains(cutIndex);
                          final isExpected = _expectedCuts.contains(cutIndex);

                          Widget cutIcon;

                          if (!_hasChecked) {
                            cutIcon = isCutByPlayer
                                ? Container(
                                    width: 4,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primary,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  )
                                : Container(
                                    width: 14,
                                    height: 28,
                                    alignment: Alignment.center,
                                    child: Container(
                                      width: 2,
                                      height: 12,
                                      color: theme.colorScheme.onSurfaceVariant.withAlpha(40),
                                    ),
                                  );
                          } else {
                            // Checked state
                            if (isCutByPlayer && isExpected) {
                              cutIcon = Container(
                                width: 4,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: AppColors.correct,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              );
                            } else if (isCutByPlayer && !isExpected) {
                              cutIcon = Container(
                                width: 4,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: AppColors.wrong,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              );
                            } else if (!isCutByPlayer && isExpected) {
                              cutIcon = Container(
                                width: 2,
                                height: 28,
                                decoration: BoxDecoration(
                                  border: Border.all(color: theme.colorScheme.primary, width: 1.5),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              );
                            } else {
                              cutIcon = const SizedBox(width: 8);
                            }
                          }

                          return InkWell(
                            onTap: () => _toggleCut(cutIndex),
                            borderRadius: BorderRadius.circular(4),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2),
                              child: cutIcon,
                            ),
                          );
                        }
                      }),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Breakdown Explanation when checked
              if (_hasChecked)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest.withAlpha(100),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: theme.colorScheme.outline),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.hub_rounded, size: 16, color: AppColors.accent),
                          SizedBox(width: 8),
                          Text('Chunk Breakdown', style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Target Chunks: ${json.decode(current.chunksJson ?? "[]").join("  /  ")}',
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.colorScheme.onSurfaceVariant,
                          height: 1.3,
                        ),
                      ),
                      if (current.simpleMeaning != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          'Paraphrase: "${current.simpleMeaning}"',
                          style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 13),
                        ),
                      ],
                    ],
                  ),
                ),

              const SizedBox(height: 16),

              // Action button
              if (!_hasChecked)
                ElevatedButton(
                  onPressed: _playerCuts.isNotEmpty ? _checkSlices : null,
                  child: const Text('Check Slices'),
                )
              else
                ElevatedButton(
                  onPressed: _nextSentence,
                  child: Text(_currentIndex + 1 < maxSentences ? 'Next Sentence' : 'Finish Round'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
