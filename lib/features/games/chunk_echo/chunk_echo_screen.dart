import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../app/theme.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/db/database.dart';
import '../../../app/providers.dart';
import '../../../core/planner/difficulty_tuner.dart';
import '../widgets/what_you_learned_screen.dart';

enum ChunkEchoMode { rebuild, memoryLadder }

class ChunkEchoScreen extends ConsumerStatefulWidget {
  final int level;
  final ChunkEchoMode initialMode;

  const ChunkEchoScreen({
    super.key,
    this.level = 1,
    this.initialMode = ChunkEchoMode.rebuild,
  });

  @override
  ConsumerState<ChunkEchoScreen> createState() => _ChunkEchoScreenState();
}

class _ChunkEchoScreenState extends ConsumerState<ChunkEchoScreen> {
  late ChunkEchoMode _mode;
  List<ChunkSentence> _sentences = [];
  int _currentIndex = 0;
  bool _isLoading = true;

  int _replaysAllowed = 2;
  int _replaysUsed = 0;
  bool _isPlayingAudio = false;
  int _activeAudioChunkIndex = -1;
  Timer? _chunkHighlightTimer;

  List<String> _bankChunks = [];
  List<String> _assembledChunks = [];
  List<String> _correctChunks = [];
  bool _hasChecked = false;
  bool _isCorrect = false;
  bool _shadowedThisSentence = false;

  int _score = 0;
  int _xpEarned = 0;
  int _correctCount = 0;
  final List<LearnedItem> _learnedItems = [];
  int _roundStartTime = 0;

  @override
  void initState() {
    super.initState();
    _mode = widget.initialMode;
    _roundStartTime = DateTime.now().millisecondsSinceEpoch;
    _replaysAllowed = widget.level <= 2 ? 3 : (widget.level <= 4 ? 2 : 1);
    _loadChunks();
  }

  @override
  void dispose() {
    _chunkHighlightTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadChunks() async {
    final gameDao = ref.read(gameDaoProvider);
    final list = await gameDao.getChunksForLevel(widget.level);
    if (!mounted) return;

    List<ChunkSentence> sentences;
    if (list.isNotEmpty) {
      sentences = List.of(list);
    } else {
      final all = await ref.read(databaseProvider).select(ref.read(databaseProvider).chunkSentences).get();
      sentences = List.of(all);
    }

    if (_mode == ChunkEchoMode.memoryLadder) {
      // Sort progressively by chunk count for Memory Ladder climb
      sentences.sort((a, b) {
        final lenA = (json.decode(a.chunksJson) as List).length;
        final lenB = (json.decode(b.chunksJson) as List).length;
        return lenA.compareTo(lenB);
      });
    } else {
      sentences.shuffle();
    }

    setState(() {
      _sentences = sentences;
      _isLoading = false;
    });

    if (_sentences.isNotEmpty) {
      _setupCurrentSentence();
    }
  }

  void _setupCurrentSentence() {
    final current = _sentences[_currentIndex];
    final List<dynamic> raw = json.decode(current.chunksJson);
    final chunks = raw.map((c) => c as String).toList();
    final shuffled = List<String>.from(chunks)..shuffle();

    setState(() {
      _correctChunks = chunks;
      _bankChunks = shuffled;
      _assembledChunks = [];
      _hasChecked = false;
      _isCorrect = false;
      _shadowedThisSentence = false;
      _replaysUsed = 0;
      _activeAudioChunkIndex = -1;
    });

    _playSentenceAudio();
  }

  Future<void> _playSentenceAudio() async {
    if (_isPlayingAudio) return;
    _chunkHighlightTimer?.cancel();
    setState(() {
      _isPlayingAudio = true;
      _activeAudioChunkIndex = 0;
    });

    final current = _sentences[_currentIndex];

    // Rhythmic chunk highlighting during audio
    if (_correctChunks.isNotEmpty) {
      int step = 0;
      _chunkHighlightTimer = Timer.periodic(const Duration(milliseconds: 1100), (timer) {
        step++;
        if (step < _correctChunks.length) {
          if (mounted) setState(() => _activeAudioChunkIndex = step);
        } else {
          timer.cancel();
          if (mounted) setState(() => _activeAudioChunkIndex = -1);
        }
      });
    }

    await ref.read(audioServiceProvider).speakOrPlay(current.textContent);
    _chunkHighlightTimer?.cancel();
    if (mounted) {
      setState(() {
        _isPlayingAudio = false;
        _activeAudioChunkIndex = -1;
      });
    }
  }

  void _onReplayTap() {
    if (_replaysUsed < _replaysAllowed && !_isPlayingAudio) {
      setState(() => _replaysUsed++);
      _playSentenceAudio();
    }
  }

  void _moveChunkToAssembled(int index) {
    if (_hasChecked) return;
    final chunk = _bankChunks.removeAt(index);
    ref.read(audioServiceProvider).speakOrPlay(chunk);
    setState(() {
      _assembledChunks.add(chunk);
    });
  }

  void _moveChunkToBank(int index) {
    if (_hasChecked) return;
    final chunk = _assembledChunks.removeAt(index);
    setState(() {
      _bankChunks.add(chunk);
    });
  }

  void _checkChunks() {
    if (_assembledChunks.isEmpty) return;
    final current = _sentences[_currentIndex];

    bool correct = true;
    if (_assembledChunks.length != _correctChunks.length) {
      correct = false;
    } else {
      for (int i = 0; i < _correctChunks.length; i++) {
        if (_assembledChunks[i] != _correctChunks[i]) {
          correct = false;
          break;
        }
      }
    }

    setState(() {
      _hasChecked = true;
      _isCorrect = correct;
    });

    if (correct) {
      _correctCount++;
      _score += (120 - (_replaysUsed * 10)).clamp(50, 150);
      _xpEarned += 25;
      ref.read(audioServiceProvider).playSfx(SfxType.correct);
      _playSentenceAudio();

      _learnedItems.add(
        LearnedItem(
          term: current.textContent,
          definition: 'Chunk structure: ${_correctChunks.join(" / ")}',
          example: '',
          wasMistake: false,
        ),
      );
    } else {
      ref.read(audioServiceProvider).playSfx(SfxType.wrong);

      _learnedItems.add(
        LearnedItem(
          term: current.textContent,
          definition: 'Chunk structure: ${_correctChunks.join(" / ")}',
          example: '',
          wasMistake: true,
        ),
      );
    }
  }

  void _nextSentence() {
    final maxSentences = _mode == ChunkEchoMode.memoryLadder
        ? _sentences.length
        : (_sentences.length < 10 ? _sentences.length : 10);

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

    final modeString = _mode == ChunkEchoMode.memoryLadder ? 'memory_ladder' : 'rebuild';

    await ref.read(gameDaoProvider).recordSession(
          GameSessionsCompanion.insert(
            game: 'chunk_echo',
            mode: drift.Value(modeString),
            level: drift.Value(widget.level),
            startedAt: _roundStartTime,
            durationMs: durationMs,
            accuracy: accuracy,
            score: _score,
            xpEarned: _xpEarned,
          ),
        );

    if (_mode == ChunkEchoMode.memoryLadder) {
      await ref.read(gameDaoProvider).savePersonalBest(
            PersonalBestsCompanion.insert(
              game: 'chunk_echo',
              mode: 'memory_ladder',
              metric: 'rung',
              value: _correctCount.toDouble(),
              setAt: now,
            ),
          );
    }

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

    final title = _mode == ChunkEchoMode.memoryLadder
        ? '🪜 Memory Ladder (Rung $_correctCount)'
        : '🔊 Chunk Echo (Level ${widget.level} ➔ $nextLevel)';

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => WhatYouLearnedScreen(
          gameTitle: title,
          score: _score,
          xpEarned: _xpEarned,
          accuracy: accuracy,
          items: _learnedItems,
          onPlayAgain: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => ChunkEchoScreen(
                  level: nextLevel,
                  initialMode: _mode,
                ),
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
    final maxSentences = _mode == ChunkEchoMode.memoryLadder
        ? _sentences.length
        : (_sentences.length < 10 ? _sentences.length : 10);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _mode == ChunkEchoMode.memoryLadder
              ? 'Memory Ladder (Rung ${_correctCount + 1})'
              : 'Chunk Echo (${_currentIndex + 1}/$maxSentences)',
        ),
        actions: [
          Row(
            children: [
              IconButton(
                icon: Icon(
                  _isPlayingAudio ? Icons.graphic_eq_rounded : Icons.replay_rounded,
                  color: _replaysUsed < _replaysAllowed ? theme.colorScheme.primary : Colors.grey,
                ),
                tooltip: 'Replay (${_replaysAllowed - _replaysUsed} left)',
                onPressed: _onReplayTap,
              ),
              Text(
                '${_replaysAllowed - _replaysUsed}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Mode switcher
              SegmentedButton<ChunkEchoMode>(
                segments: const [
                  ButtonSegment(
                    value: ChunkEchoMode.rebuild,
                    label: Text('Chunk Rebuild'),
                  ),
                  ButtonSegment(
                    value: ChunkEchoMode.memoryLadder,
                    label: Text('Memory Ladder 🪜'),
                  ),
                ],
                selected: {_mode},
                onSelectionChanged: (set) {
                  setState(() {
                    _mode = set.first;
                    _currentIndex = 0;
                    _score = 0;
                    _xpEarned = 0;
                    _correctCount = 0;
                    _learnedItems.clear();
                    _isLoading = true;
                  });
                  _loadChunks();
                },
              ),
              const SizedBox(height: 14),

              // Audio Waveform Visualizer Area
              Container(
                height: 90,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _isPlayingAudio ? theme.colorScheme.primary : theme.colorScheme.outline,
                    width: _isPlayingAudio ? 1.5 : 1.0,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(7, (i) {
                          final h = _isPlayingAudio ? (12.0 + ((i % 4) * 6.0)) : 6.0;
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: 4,
                            height: h,
                            decoration: BoxDecoration(
                              color: _isPlayingAudio ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant.withAlpha(60),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isPlayingAudio
                            ? (_activeAudioChunkIndex >= 0 && _activeAudioChunkIndex < _correctChunks.length
                                ? 'Echo: "${_correctChunks[_activeAudioChunkIndex]}"'
                                : 'Listening to acoustic waveform...')
                            : 'Tap Replay to listen again',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Rebuilt Chunks Container
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _hasChecked
                          ? (_isCorrect ? AppColors.correct : AppColors.wrong)
                          : theme.colorScheme.outline,
                      width: 1.5,
                    ),
                  ),
                  child: _assembledChunks.isEmpty
                      ? Center(
                          child: Text(
                            'Assemble the chunk tiles in order',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        )
                      : Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: List.generate(_assembledChunks.length, (index) {
                            final isHighlight = _isPlayingAudio && _activeAudioChunkIndex == index;
                            return ActionChip(
                              label: Text(
                                _assembledChunks[index],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: isHighlight ? theme.colorScheme.primary : theme.colorScheme.onSurface,
                                ),
                              ),
                              backgroundColor: isHighlight
                                  ? theme.colorScheme.primary.withAlpha(50)
                                  : theme.colorScheme.primary.withAlpha(20),
                              side: BorderSide(
                                color: isHighlight ? theme.colorScheme.primary : Colors.transparent,
                                width: 1.5,
                              ),
                              onPressed: () => _moveChunkToBank(index),
                            );
                          }),
                        ),
                ),
              ),
              const SizedBox(height: 14),

              // Chunk Tiles Bank
              Expanded(
                flex: 4,
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(_bankChunks.length, (index) {
                      return ActionChip(
                        label: Text(
                          _bankChunks[index],
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        backgroundColor: theme.colorScheme.surfaceContainerHighest,
                        onPressed: () => _moveChunkToAssembled(index),
                      );
                    }),
                  ),
                ),
              ),

              // Optional Shadowing Action
              if (_hasChecked && _isCorrect && !_shadowedThisSentence)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.mic_rounded, size: 18),
                    label: const Text('Say Aloud Shadowing (+20 XP)'),
                    onPressed: () {
                      setState(() {
                        _shadowedThisSentence = true;
                        _score += 40;
                        _xpEarned += 20;
                      });
                      ref.read(audioServiceProvider).playSfx(SfxType.correct);
                    },
                  ),
                ),

              // Bottom Action Button
              if (!_hasChecked)
                ElevatedButton(
                  onPressed: _assembledChunks.isNotEmpty ? _checkChunks : null,
                  child: const Text('Check Chunks'),
                )
              else
                Column(
                  children: [
                    if (!_isCorrect)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          'Target: ${current.textContent}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: AppColors.wrong, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                    ElevatedButton(
                      onPressed: _nextSentence,
                      child: Text(_currentIndex + 1 < maxSentences ? 'Next Sentence' : 'Finish Round'),
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
