import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../app/theme.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/db/database.dart';
import '../../../app/providers.dart';
import '../widgets/what_you_learned_screen.dart';

class ChunkEchoScreen extends ConsumerStatefulWidget {
  final int level;

  const ChunkEchoScreen({
    super.key,
    this.level = 1,
  });

  @override
  ConsumerState<ChunkEchoScreen> createState() => _ChunkEchoScreenState();
}

class _ChunkEchoScreenState extends ConsumerState<ChunkEchoScreen> {
  List<ChunkSentence> _sentences = [];
  int _currentIndex = 0;
  bool _isLoading = true;

  int _replaysAllowed = 2;
  int _replaysUsed = 0;
  bool _isPlayingAudio = false;

  List<String> _bankChunks = [];
  List<String> _assembledChunks = [];
  List<String> _correctChunks = [];
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
    _replaysAllowed = widget.level <= 2 ? 3 : (widget.level <= 4 ? 2 : 1);
    _loadChunks();
  }

  Future<void> _loadChunks() async {
    final gameDao = ref.read(gameDaoProvider);
    final list = await gameDao.getChunksForLevel(widget.level);
    if (!mounted) return;

    if (list.isNotEmpty) {
      setState(() {
        _sentences = List.of(list)..shuffle();
        _isLoading = false;
      });
    } else {
      final all = await ref.read(databaseProvider).select(ref.read(databaseProvider).chunkSentences).get();
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
    final List<dynamic> raw = json.decode(current.chunksJson);
    final chunks = raw.map((c) => c as String).toList();
    final shuffled = List<String>.from(chunks)..shuffle();

    setState(() {
      _correctChunks = chunks;
      _bankChunks = shuffled;
      _assembledChunks = [];
      _hasChecked = false;
      _isCorrect = false;
      _replaysUsed = 0;
    });

    _playSentenceAudio();
  }

  Future<void> _playSentenceAudio() async {
    if (_isPlayingAudio) return;
    setState(() => _isPlayingAudio = true);
    final current = _sentences[_currentIndex];
    await ref.read(audioServiceProvider).speakOrPlay(current.textContent);
    if (mounted) setState(() => _isPlayingAudio = false);
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
            game: 'chunk_echo',
            mode: const drift.Value('rebuild'),
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
          gameTitle: '🔊 Chunk Echo',
          score: _score,
          xpEarned: _xpEarned,
          accuracy: accuracy,
          items: _learnedItems,
          onPlayAgain: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => ChunkEchoScreen(level: widget.level)),
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
        title: Text('Chunk Echo (${_currentIndex + 1}/5)'),
        actions: [
          Row(
            children: [
              IconButton(
                icon: Icon(
                  _isPlayingAudio ? Icons.graphic_eq_rounded : Icons.replay_rounded,
                  color: _replaysUsed < _replaysAllowed ? AppColors.accent : Colors.grey,
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
              // Audio Waveform Visualizer Area
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.accent.withAlpha(60)),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _isPlayingAudio ? Icons.multitrack_audio_rounded : Icons.hearing_rounded,
                        color: _isPlayingAudio ? AppColors.accent : AppColors.accentDark,
                        size: 42,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isPlayingAudio ? 'Listening to sentence...' : 'Tap Replay to listen again',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Rebuilt Chunks Container
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
                          : AppColors.accent.withAlpha(80),
                      width: 2,
                    ),
                  ),
                  child: _assembledChunks.isEmpty
                      ? Center(
                          child: Text(
                            'Order the chunk tiles as you heard them',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        )
                      : Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: List.generate(_assembledChunks.length, (index) {
                            return ActionChip(
                              label: Text(
                                _assembledChunks[index],
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              backgroundColor: AppColors.accent.withAlpha(60),
                              onPressed: () => _moveChunkToBank(index),
                            );
                          }),
                        ),
                ),
              ),
              const SizedBox(height: 16),

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
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        backgroundColor: theme.colorScheme.surfaceContainerHighest,
                        onPressed: () => _moveChunkToAssembled(index),
                      );
                    }),
                  ),
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
                          'Correct: ${current.textContent}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: AppColors.wrong, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ElevatedButton(
                      onPressed: _nextSentence,
                      child: Text(_currentIndex + 1 < 5 ? 'Next Sentence' : 'Finish Round'),
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
