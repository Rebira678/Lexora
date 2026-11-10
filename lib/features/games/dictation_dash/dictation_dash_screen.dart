import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../app/theme.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/db/database.dart';
import '../../../app/providers.dart';
import '../../../core/scoring/scoring.dart';
import '../widgets/what_you_learned_screen.dart';

class DictationDashScreen extends ConsumerStatefulWidget {
  const DictationDashScreen({super.key});

  @override
  ConsumerState<DictationDashScreen> createState() => _DictationDashScreenState();
}

class _DictationDashScreenState extends ConsumerState<DictationDashScreen> {
  List<SentenceStructure> _sentences = [];
  int _currentIndex = 0;
  bool _isLoading = true;

  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  bool _hasChecked = false;
  double _scoreAccuracy = 0.0;
  List<String> _typedTokens = [];
  List<String> _targetTokens = [];

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

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _loadSentences() async {
    final gameDao = ref.read(gameDaoProvider);
    final list = await gameDao.getSentencesForLevel(2);
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
      _playAudio();
    }
  }

  void _playAudio({bool slow = false}) {
    if (_currentIndex < _sentences.length) {
      final sent = _sentences[_currentIndex].sentence;
      ref.read(audioServiceProvider).speakOrPlay(sent);
    }
  }

  void _checkDictation() {
    if (_textController.text.trim().isEmpty || _hasChecked) return;
    final current = _sentences[_currentIndex];
    final typed = _textController.text.trim();
    final target = current.sentence.trim();

    final typedWords = typed.split(RegExp(r'\s+'));
    final targetWords = target.split(RegExp(r'\s+'));

    int matches = 0;
    for (int i = 0; i < targetWords.length; i++) {
      if (i < typedWords.length &&
          isAnswerOk(typedWords[i].replaceAll(RegExp(r'[^\w]'), ''), targetWords[i].replaceAll(RegExp(r'[^\w]'), ''))) {
        matches++;
      }
    }

    final accuracy = matches / targetWords.length;
    final isGood = accuracy >= 0.70;

    setState(() {
      _hasChecked = true;
      _scoreAccuracy = accuracy;
      _typedTokens = typedWords;
      _targetTokens = targetWords;
    });

    if (isGood) {
      _correctCount++;
      final earned = (accuracy * 180).round();
      _score += earned;
      _xpEarned += (earned * 0.25).round();
      ref.read(audioServiceProvider).playSfx(SfxType.correct);

      _learnedItems.add(
        LearnedItem(
          term: current.sentence,
          definition: 'Dictation Accuracy: ${(accuracy * 100).round()}%',
          example: 'Transcribed accurately',
          wasMistake: false,
        ),
      );
    } else {
      ref.read(audioServiceProvider).playSfx(SfxType.wrong);

      _learnedItems.add(
        LearnedItem(
          term: current.sentence,
          definition: 'Dictation Accuracy: ${(accuracy * 100).round()}%',
          example: 'Target: $target',
          wasMistake: true,
        ),
      );
    }
  }

  void _next() {
    if (_currentIndex + 1 < _sentences.length && _currentIndex + 1 < 5) {
      setState(() {
        _currentIndex++;
        _textController.clear();
        _hasChecked = false;
        _scoreAccuracy = 0.0;
        _typedTokens.clear();
        _targetTokens.clear();
      });
      _playAudio();
      _focusNode.requestFocus();
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
            game: 'dictation_dash',
            mode: const drift.Value('audio_transcription'),
            level: const drift.Value(2),
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
          gameTitle: '🎧 Dictation Dash',
          score: _score,
          xpEarned: _xpEarned,
          accuracy: accuracy,
          items: _learnedItems,
          onPlayAgain: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const DictationDashScreen()),
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
    if (_sentences.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Dictation Dash')),
        body: const Center(child: Text('No sentences available for dictation.')),
      );
    }

    final theme = Theme.of(context);
    final current = _sentences[_currentIndex];
    final total = _sentences.length < 5 ? _sentences.length : 5;

    return Scaffold(
      appBar: AppBar(
        title: Text('Dictation Dash (${_currentIndex + 1}/$total)'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Audio Playback Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.colorScheme.outline),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton.filled(
                          icon: const Icon(Icons.volume_up_rounded, size: 24),
                          tooltip: 'Normal Speed',
                          onPressed: () => _playAudio(slow: false),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _hasChecked ? 'Accuracy: ${(_scoreAccuracy * 100).round()}%' : 'Listen and type exactly',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            const SizedBox(height: 2),
                            Text('English Acoustic Dictation', style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant)),
                          ],
                        ),
                      ],
                    ),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.slow_motion_video_rounded, size: 16),
                      label: const Text('0.8x'),
                      onPressed: () => _playAudio(slow: true),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Transcription Input Box
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _hasChecked
                          ? (_scoreAccuracy >= 0.70 ? AppColors.correct : AppColors.wrong)
                          : theme.colorScheme.outline,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          focusNode: _focusNode,
                          readOnly: _hasChecked,
                          maxLines: null,
                          expands: true,
                          autofocus: true,
                          decoration: const InputDecoration(
                            hintText: 'Type the English sentence you hear...',
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(fontSize: 17, height: 1.45),
                        ),
                      ),
                      if (_hasChecked) ...[
                        const Divider(height: 24),
                        const Text('Target Sentence:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.correct)),
                        const SizedBox(height: 4),
                        Text(current.sentence, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Action button
              if (!_hasChecked)
                ElevatedButton(
                  onPressed: _checkDictation,
                  child: const Text('Submit Transcription'),
                )
              else
                ElevatedButton(
                  onPressed: _next,
                  child: Text(_currentIndex + 1 < total ? 'Next Audio Clip' : 'Finish Dictation'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
