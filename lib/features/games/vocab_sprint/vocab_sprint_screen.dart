import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../app/theme.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/db/database.dart';
import '../../../core/srs/sm2.dart';
import '../../../core/streak/streak_logic.dart';
import '../../../app/providers.dart';
import '../widgets/what_you_learned_screen.dart';

class SprintQuestion {
  final Word targetWord;
  final List<String> options;
  final String correctOption;
  final String questionText;

  SprintQuestion({
    required this.targetWord,
    required this.options,
    required this.correctOption,
    required this.questionText,
  });
}

class VocabSprintScreen extends ConsumerStatefulWidget {
  final int durationSeconds;

  const VocabSprintScreen({
    super.key,
    this.durationSeconds = 60,
  });

  @override
  ConsumerState<VocabSprintScreen> createState() => _VocabSprintScreenState();
}

class _VocabSprintScreenState extends ConsumerState<VocabSprintScreen> {
  int _secondsRemaining = 60;
  Timer? _timer;
  int _score = 0;
  int _xpEarned = 0;
  int _combo = 0;
  int _correctCount = 0;
  int _totalCount = 0;

  List<SprintQuestion> _questions = [];
  int _currentIndex = 0;
  bool _isLoading = true;
  DateTime? _questionStartTime;
  final List<LearnedItem> _learnedItems = [];
  int _roundStartTime = 0;

  @override
  void initState() {
    super.initState();
    _secondsRemaining = widget.durationSeconds;
    _roundStartTime = DateTime.now().millisecondsSinceEpoch;
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final wordDao = ref.read(wordDaoProvider);
    final srsDao = ref.read(srsDaoProvider);

    // Prioritize due SRS cards first
    final dueCards = await srsDao.getDueCards(limit: 30);
    final allWords = await wordDao.getAllWords();
    if (allWords.length < 4 || !mounted) return;

    final wordMap = {for (final w in allWords) w.id: w};
    final List<Word> selected = [];

    // Add due words
    for (final card in dueCards) {
      if (card.itemType == 'word' && wordMap.containsKey(card.itemId)) {
        selected.add(wordMap[card.itemId]!);
      }
    }

    // Fill remaining with random words
    final shuffled = List.of(allWords)..shuffle();
    for (final w in shuffled) {
      if (!selected.contains(w)) {
        selected.add(w);
      }
      if (selected.length >= 25) break;
    }

    final questions = <SprintQuestion>[];
    for (final target in selected) {
      final distractors = (List.of(allWords)..remove(target)..shuffle()).take(3).map((w) => w.lemma).toList();
      final options = (distractors..add(target.lemma))..shuffle();

      questions.add(
        SprintQuestion(
          targetWord: target,
          options: options,
          correctOption: target.lemma,
          questionText: target.definitionEn ?? 'Identify the word',
        ),
      );
    }

    setState(() {
      _questions = questions;
      _isLoading = false;
    });

    _startTimer();
    _questionStartTime = DateTime.now();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_secondsRemaining <= 1) {
        timer.cancel();
        _endGame();
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  void _handleAnswer(String option) {
    if (_currentIndex >= _questions.length) return;
    final current = _questions[_currentIndex];
    final elapsedSeconds = _questionStartTime == null
        ? 3.0
        : DateTime.now().difference(_questionStartTime!).inMilliseconds / 1000.0;

    _totalCount++;
    final isCorrect = (option == current.correctOption);

    if (isCorrect) {
      _correctCount++;
      _combo++;
      final pts = (100 * (elapsedSeconds < 3 ? 1.5 : (elapsedSeconds <= 6 ? 1.2 : 1.0)) * (1.0 + 0.1 * _combo.clamp(0, 10))).round();
      final xp = ref.read(xpServiceProvider).calculateXp(
            basePoints: 15,
            speedMultiplier: elapsedSeconds < 3 ? 1.5 : (elapsedSeconds <= 6 ? 1.2 : 1.0),
            combo: _combo,
          );

      _score += pts;
      _xpEarned += xp;

      ref.read(audioServiceProvider).playSfx(SfxType.correct);
      ref.read(audioServiceProvider).speakOrPlay(current.targetWord.lemma);

      final quality = mapGameResultToQuality(
        correct: true,
        responseTimeSeconds: elapsedSeconds,
        tapMode: true,
      );

      ref.read(srsDaoProvider).logReview(
            cardId: current.targetWord.id,
            game: 'vocab_sprint',
            correct: true,
            responseMs: (elapsedSeconds * 1000).round(),
            quality: quality,
          );

      _learnedItems.add(
        LearnedItem(
          term: current.targetWord.lemma,
          ipa: current.targetWord.ipa,
          definition: current.targetWord.definitionEn ?? '',
          example: '',
          wasMistake: false,
        ),
      );
    } else {
      _combo = 0;
      ref.read(audioServiceProvider).playSfx(SfxType.wrong);

      ref.read(srsDaoProvider).logReview(
            cardId: current.targetWord.id,
            game: 'vocab_sprint',
            correct: false,
            responseMs: (elapsedSeconds * 1000).round(),
            quality: 2,
          );

      _learnedItems.add(
        LearnedItem(
          term: current.targetWord.lemma,
          ipa: current.targetWord.ipa,
          definition: current.targetWord.definitionEn ?? '',
          example: '',
          wasMistake: true,
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Answer: ${current.correctOption}'),
          backgroundColor: AppColors.wrong,
          duration: const Duration(seconds: 1),
        ),
      );
    }

    if (_currentIndex + 1 < _questions.length) {
      setState(() {
        _currentIndex++;
        _questionStartTime = DateTime.now();
      });
    } else {
      _timer?.cancel();
      _endGame();
    }
  }

  Future<void> _endGame() async {
    _timer?.cancel();
    final now = DateTime.now().millisecondsSinceEpoch;
    final durationMs = now - _roundStartTime;
    final accuracy = _totalCount == 0 ? 0.0 : _correctCount / _totalCount;

    await ref.read(gameDaoProvider).recordSession(
          GameSessionsCompanion.insert(
            game: 'vocab_sprint',
            mode: const drift.Value('fast_choice'),
            level: const drift.Value(1),
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
          itemsReviewed: _totalCount,
          goalMet: true,
        );

    final streakState = await ref.read(statsDaoProvider).getStreak();
    if (streakState != null) {
      final updatedResult = ref.read(streakServiceProvider).onSessionComplete(
            StreakState(
              current: streakState.current,
              best: streakState.best,
              freezes: streakState.freezes,
              lastDay: streakState.lastDay,
              totalDays: streakState.totalDays,
            ),
          );

      await ref.read(statsDaoProvider).updateStreak(
            StreaksCompanion(
              current: drift.Value(updatedResult.state.current),
              best: drift.Value(updatedResult.state.best),
              freezes: drift.Value(updatedResult.state.freezes),
              lastDay: drift.Value(updatedResult.state.lastDay),
              totalDays: drift.Value(updatedResult.state.totalDays),
            ),
          );
    }

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => WhatYouLearnedScreen(
          gameTitle: '⚡ Vocabulary Sprint',
          score: _score,
          xpEarned: _xpEarned,
          accuracy: accuracy,
          items: _learnedItems,
          onPlayAgain: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => const VocabSprintScreen(),
              ),
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
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final question = _questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vocabulary Sprint'),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: _secondsRemaining <= 10 ? AppColors.wrong : AppColors.accent,
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
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Score & Combo HUD
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Score: $_score', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  if (_combo > 1)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.combo, borderRadius: BorderRadius.circular(12)),
                      child: Text('Combo x$_combo', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    ),
                ],
              ),
              const SizedBox(height: 24),

              // Question Card
              Expanded(
                flex: 4,
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.psychology_rounded, size: 48, color: AppColors.accent),
                          const SizedBox(height: 16),
                          Text(
                            question.questionText,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 4 Multiple Choice Options
              ...question.options.map((opt) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () => _handleAnswer(opt),
                    child: Text(
                      opt,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
