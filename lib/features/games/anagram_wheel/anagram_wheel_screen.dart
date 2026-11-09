import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../app/theme.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/db/database.dart';
import '../../../app/providers.dart';
import '../widgets/what_you_learned_screen.dart';

class AnagramWheelScreen extends ConsumerStatefulWidget {
  final int durationSeconds;

  const AnagramWheelScreen({
    super.key,
    this.durationSeconds = 90,
  });

  @override
  ConsumerState<AnagramWheelScreen> createState() => _AnagramWheelScreenState();
}

class _AnagramWheelScreenState extends ConsumerState<AnagramWheelScreen> {
  int _secondsRemaining = 90;
  Timer? _timer;
  int _score = 0;
  int _xpEarned = 0;
  int _combo = 0;

  Word? _targetWord;
  List<String> _letters = [];
  String _currentInput = '';
  final Set<String> _foundWords = {};
  final List<LearnedItem> _learnedItems = [];
  bool _isLoading = true;
  int _roundStartTime = 0;

  @override
  void initState() {
    super.initState();
    _secondsRemaining = widget.durationSeconds;
    _roundStartTime = DateTime.now().millisecondsSinceEpoch;
    _loadPuzzle();
  }

  Future<void> _loadPuzzle() async {
    final wordDao = ref.read(wordDaoProvider);
    final allWords = await wordDao.getAllWords();
    if (allWords.isEmpty || !mounted) return;

    // Pick a word with 5 to 8 characters
    final suitable = allWords.where((w) => w.lemma.length >= 5 && w.lemma.length <= 8 && !w.lemma.contains(' ')).toList();
    if (suitable.isEmpty) return;

    final target = (List.of(suitable)..shuffle()).first;
    final letters = target.lemma.toUpperCase().split('')..shuffle();

    setState(() {
      _targetWord = target;
      _letters = letters;
      _isLoading = false;
    });

    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_secondsRemaining <= 1) {
        timer.cancel();
        _endGame();
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  void _onLetterTap(String letter) {
    setState(() {
      _currentInput += letter;
    });
  }

  void _onBackspace() {
    if (_currentInput.isNotEmpty) {
      setState(() {
        _currentInput = _currentInput.substring(0, _currentInput.length - 1);
      });
    }
  }

  void _onSubmit() {
    if (_currentInput.isEmpty || _targetWord == null) return;
    final word = _currentInput.toLowerCase();

    if (word == _targetWord!.lemma.toLowerCase() && !_foundWords.contains(word)) {
      _foundWords.add(word);
      _combo++;
      final pts = 200 * (1 + 0.2 * _combo.clamp(0, 5)).round();
      _score += pts;
      _xpEarned += 30;

      ref.read(audioServiceProvider).playSfx(SfxType.correct);
      ref.read(audioServiceProvider).speakOrPlay(_targetWord!.lemma);

      _learnedItems.add(
        LearnedItem(
          term: _targetWord!.lemma,
          ipa: _targetWord!.ipa,
          definition: _targetWord!.definitionEn ?? '',
          example: '',
          wasMistake: false,
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🎉 FOUND: ${_targetWord!.lemma}!'),
          backgroundColor: AppColors.correct,
          duration: const Duration(seconds: 2),
        ),
      );

      _currentInput = '';
      _endGame();
    } else {
      ref.read(audioServiceProvider).playSfx(SfxType.wrong);
      _combo = 0;
      setState(() {
        _currentInput = '';
      });
    }
  }

  Future<void> _endGame() async {
    _timer?.cancel();
    final now = DateTime.now().millisecondsSinceEpoch;
    final durationMs = now - _roundStartTime;
    final accuracy = _foundWords.isNotEmpty ? 1.0 : 0.0;

    await ref.read(gameDaoProvider).recordSession(
          GameSessionsCompanion.insert(
            game: 'anagram_wheel',
            mode: const drift.Value('wheel'),
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
          itemsReviewed: 1,
          goalMet: true,
        );

    if (_targetWord != null && _foundWords.isEmpty) {
      _learnedItems.add(
        LearnedItem(
          term: _targetWord!.lemma,
          ipa: _targetWord!.ipa,
          definition: _targetWord!.definitionEn ?? '',
          example: '',
          wasMistake: true,
        ),
      );
    }

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => WhatYouLearnedScreen(
          gameTitle: '🎡 Anagram Wheel',
          score: _score,
          xpEarned: _xpEarned,
          accuracy: accuracy,
          items: _learnedItems,
          onPlayAgain: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const AnagramWheelScreen()),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Anagram Wheel'),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: _secondsRemaining <= 15 ? AppColors.wrong : AppColors.accent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.timer_outlined, size: 18, color: Colors.white),
                const SizedBox(width: 4),
                Text(
                  '${_secondsRemaining}s',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Score & Clue
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Score: $_score', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      if (_combo > 1)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(color: AppColors.combo, borderRadius: BorderRadius.circular(12)),
                          child: Text('Combo x$_combo', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_secondsRemaining <= 80 && _targetWord != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest.withAlpha(120),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.lightbulb_outline_rounded, color: AppColors.combo, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _targetWord!.definitionEn ?? '',
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            // Current Word Formation Display
            Container(
              height: 60,
              margin: const EdgeInsets.symmetric(horizontal: 32),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.accent, width: 2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  _currentInput,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 4),
                ),
              ),
            ),

            const Spacer(),

            // Anagram Wheel
            SizedBox(
              width: 260,
              height: 260,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Center Shuffle Button
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _letters.shuffle();
                      });
                    },
                    child: Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: AppColors.accent.withAlpha(100), blurRadius: 10),
                        ],
                      ),
                      child: const Icon(Icons.shuffle_rounded, color: Colors.white, size: 30),
                    ),
                  ),

                  // Letter Nodes arranged around circle
                  ...List.generate(_letters.length, (index) {
                    final angle = (2 * pi / _letters.length) * index - pi / 2;
                    const radius = 95.0;
                    final x = radius * cos(angle);
                    final y = radius * sin(angle);

                    return Transform.translate(
                      offset: Offset(x, y),
                      child: GestureDetector(
                        onTap: () => _onLetterTap(_letters[index]),
                        child: Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.accent, width: 2),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withAlpha(30), blurRadius: 4),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              _letters[index],
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),

            const Spacer(),

            // Actions: Backspace and Submit
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.backspace_outlined),
                      label: const Text('Clear'),
                      onPressed: _onBackspace,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.check_rounded),
                      label: const Text('Check'),
                      onPressed: _onSubmit,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
