import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../app/theme.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/db/database.dart';
import '../../../core/scoring/scoring.dart';
import '../../../core/srs/sm2.dart';
import '../../../core/streak/streak_logic.dart';
import '../../../core/planner/difficulty_tuner.dart';
import '../../../app/providers.dart';
import '../widgets/what_you_learned_screen.dart';

enum SiegeGameMode {
  meaningToWord,
  sentenceGap,
  synonymStrike,
  collocation,
  wordFamily,
}

class WordSiegeEnemy {
  final int wordId;
  final String clue;
  final String answer;
  final String example;
  final String? ipa;
  final String definition;
  final int lane; // 0, 1, 2
  final bool isBoss;
  double y = 0.0; // 0.0 (top) to 1.0 (gate)
  bool isDefeated = false;
  List<String> tapOptions = const [];

  WordSiegeEnemy({
    required this.wordId,
    required this.clue,
    required this.answer,
    required this.example,
    this.ipa,
    required this.definition,
    required this.lane,
    this.isBoss = false,
    this.tapOptions = const [],
  });
}

class WordSiegeScreen extends ConsumerStatefulWidget {
  final int level;
  final bool tapMode;
  final SiegeGameMode mode;

  const WordSiegeScreen({
    super.key,
    this.level = 3,
    this.tapMode = false,
    this.mode = SiegeGameMode.meaningToWord,
  });

  @override
  ConsumerState<WordSiegeScreen> createState() => _WordSiegeScreenState();
}

class _WordSiegeScreenState extends ConsumerState<WordSiegeScreen>
    with SingleTickerProviderStateMixin {
  int _hp = 3;
  int _wave = 1;
  int _score = 0;
  int _xpEarned = 0;
  int _combo = 0;
  int _maxCombo = 0;
  int _correctCount = 0;
  int _totalCount = 0;
  int _gateBreaches = 0;
  int _waveBreaches = 0;

  bool _isFrozen = false;
  bool _usedEcho = false;
  late bool _isTapMode;
  bool _isPaused = false;
  Timer? _freezeTimer;
  Timer? _gameLoopTimer;
  DateTime? _targetSpawnTime;

  final List<WordSiegeEnemy> _activeEnemies = [];
  final List<LearnedItem> _learnedItems = [];
  final TextEditingController _inputController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  List<Word> _wordPool = [];
  List<Word> _allWords = [];
  bool _isLoading = true;
  int _roundStartTime = 0;

  @override
  void initState() {
    super.initState();
    _isTapMode = widget.tapMode;
    _roundStartTime = DateTime.now().millisecondsSinceEpoch;
    _loadWordsAndStart();
  }

  Future<void> _loadWordsAndStart() async {
    final wordDao = ref.read(wordDaoProvider);
    final allWords = await wordDao.getAllWords();
    if (!mounted) return;

    setState(() {
      _allWords = allWords;
      _wordPool = List.of(allWords)..shuffle();
      _isLoading = false;
    });

    await _startWave();
    _startGameLoop();
  }

  void _startGameLoop() {
    _gameLoopTimer?.cancel();
    _gameLoopTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!mounted) return;
      if (_hp <= 0) {
        timer.cancel();
        _endGame();
        return;
      }

      if (_isFrozen || _isPaused) return;

      final acc = _totalCount == 0 ? 0.8 : _correctCount / _totalCount;
      final speed = enemySpeed(acc, widget.level) * 0.005; // per 50ms tick

      setState(() {
        for (final enemy in _activeEnemies) {
          if (!enemy.isDefeated) {
            enemy.y += speed;
            if (enemy.y >= 1.0) {
              _handleGateBreach(enemy);
            }
          }
        }
        _activeEnemies.removeWhere((e) => e.isDefeated);
      });

      // Check if wave is cleared
      if (_activeEnemies.isEmpty && _hp > 0) {
        if (_wave < 3) {
          setState(() {
            _wave++;
            _waveBreaches = 0;
          });
          _startWave();
        } else {
          timer.cancel();
          _endGame();
        }
      }
    });
  }

  Future<void> _startWave() async {
    final rand = Random();
    final count = _wave == 3 ? 6 : 4;
    _activeEnemies.clear();
    final wordDao = ref.read(wordDaoProvider);

    for (int i = 0; i < count; i++) {
      if (_wordPool.isEmpty) {
        _wordPool = List.of(_allWords)..shuffle();
      }
      final word = _wordPool.removeLast();
      final isBoss = (_wave == 3 && i == count - 1);

      String clue = word.definitionEn ?? 'Identify the word';
      String answer = word.lemma;
      String example = '';

      if (isBoss) {
        final examples = await wordDao.getExamplesForWord(word.id);
        if (examples.isNotEmpty) {
          final ex = examples.first.sentence;
          final masked = ex.replaceAll(
              RegExp('\\b${RegExp.escape(word.lemma)}\\b', caseSensitive: false), '_____');
          clue = '👑 BOSS GAP: $masked';
          example = ex;
        } else {
          clue = '👑 BOSS: ${word.definitionEn ?? word.lemma}';
        }
      } else {
        switch (widget.mode) {
          case SiegeGameMode.sentenceGap:
            final examples = await wordDao.getExamplesForWord(word.id);
            if (examples.isNotEmpty) {
              final ex = examples.first.sentence;
              clue = ex.replaceAll(
                  RegExp('\\b${RegExp.escape(word.lemma)}\\b', caseSensitive: false), '_____');
              example = ex;
            } else {
              clue = word.definitionEn ?? word.lemma;
            }
            break;
          case SiegeGameMode.collocation:
            final collocations = await wordDao.getCollocationsForWord(word.id);
            if (collocations.isNotEmpty) {
              final col = collocations.first.phrase;
              clue = col.replaceAll(
                  RegExp('\\b${RegExp.escape(word.lemma)}\\b', caseSensitive: false), '_____');
              example = col;
            } else {
              clue = 'Collocation: _____ (${word.definitionEn})';
            }
            break;
          case SiegeGameMode.wordFamily:
            final fam = await wordDao.getWordFamily(word.id);
            if (fam.isNotEmpty) {
              clue = '${fam.first.root} ➔ (${fam.first.formType ?? "form"}) _____';
            } else {
              clue = 'Family: ${word.lemma} (${word.pos ?? "word"})';
            }
            break;
          case SiegeGameMode.synonymStrike:
          case SiegeGameMode.meaningToWord:
            clue = word.definitionEn ?? word.lemma;
            break;
        }
      }

      // Generate distractors for tap mode
      final distractors = (_allWords.where((w) => w.id != word.id).toList()..shuffle())
          .take(3)
          .map((w) => w.lemma)
          .toList();
      final tapOptions = (distractors..add(answer))..shuffle();

      _activeEnemies.add(
        WordSiegeEnemy(
          wordId: word.id,
          clue: clue,
          answer: answer,
          example: example,
          ipa: word.ipa,
          definition: word.definitionEn ?? '',
          lane: rand.nextInt(3),
          isBoss: isBoss,
          tapOptions: tapOptions,
        )..y = -(i * 0.25),
      );
    }
    _targetSpawnTime = DateTime.now();
    if (mounted) setState(() {});
  }

  void _handleGateBreach(WordSiegeEnemy enemy) {
    enemy.isDefeated = true;
    _hp--;
    _combo = 0;
    _totalCount++;
    _gateBreaches++;
    _waveBreaches++;

    ref.read(audioServiceProvider).playSfx(SfxType.gateBreach);

    _learnedItems.add(
      LearnedItem(
        term: enemy.answer,
        ipa: enemy.ipa,
        definition: enemy.definition,
        example: enemy.example,
        wasMistake: true,
      ),
    );

    ref.read(srsDaoProvider).logReview(
          cardId: enemy.wordId,
          game: 'word_siege',
          correct: false,
          responseMs: 8000,
          quality: 1,
        );

    // Anti-frustration rule (app.md 24.1):
    // "at most 2 enemies can reach the gate in one wave before the game pauses with 'Take a breath' and offers Tap mode"
    if (_waveBreaches >= 2 && !_isTapMode && _hp > 0) {
      _triggerTakeABreath();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gate breached! Correct word: ${enemy.answer}'),
          backgroundColor: AppColors.wrong,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _triggerTakeABreath() {
    _isPaused = true;
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.spa_rounded, color: AppColors.accent, size: 48),
            const SizedBox(height: 12),
            const Text(
              'Take a breath 🌿',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'That wave was fast! Would you like to switch to Tap Mode for multiple-choice answers?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, height: 1.4),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      _waveBreaches = 0;
                      setState(() => _isPaused = false);
                    },
                    child: const Text('Keep Typing'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(ctx);
                      _waveBreaches = 0;
                      setState(() {
                        _isTapMode = true;
                        _isPaused = false;
                      });
                    },
                    child: const Text('Use Tap Mode'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  WordSiegeEnemy? _getTargetEnemy() {
    WordSiegeEnemy? front;
    for (final e in _activeEnemies) {
      if (!e.isDefeated && e.y >= 0.0) {
        if (front == null || e.y > front.y) {
          front = e;
        }
      }
    }
    return front;
  }

  void _submitAnswer(String text) {
    if (text.trim().isEmpty) return;
    final target = _getTargetEnemy();
    if (target == null) return;

    final elapsedSeconds = _targetSpawnTime == null
        ? 3.0
        : DateTime.now().difference(_targetSpawnTime!).inMilliseconds / 1000.0;

    final isCorrect = isAnswerOk(
      text,
      target.answer,
      tolerance: widget.level <= 3 ? 1 : 0,
    );
    _totalCount++;

    if (isCorrect) {
      target.isDefeated = true;
      _correctCount++;
      _combo++;
      if (_combo > _maxCombo) _maxCombo = _combo;

      final pts = wordSiegeScore(
        correct: true,
        responseTimeSeconds: elapsedSeconds,
        combo: _combo,
        baseScore: target.isBoss ? 300 : 100,
        hintPenalty: _usedEcho ? 30 : 0,
      );

      final xp = ref.read(xpServiceProvider).calculateXp(
            basePoints: target.isBoss ? 50 : 20,
            speedMultiplier: elapsedSeconds < 3 ? 1.5 : (elapsedSeconds <= 6 ? 1.2 : 1.0),
            combo: _combo,
          );

      _score += pts;
      _xpEarned += xp;

      ref.read(audioServiceProvider).playSfx(SfxType.correct);
      ref.read(audioServiceProvider).speakOrPlay(target.answer);

      if (_combo == 5) {
        _triggerFreeze();
      }

      final quality = mapGameResultToQuality(
        correct: true,
        responseTimeSeconds: elapsedSeconds,
        hintUsed: _usedEcho,
        tapMode: _isTapMode,
      );

      ref.read(srsDaoProvider).logReview(
            cardId: target.wordId,
            game: 'word_siege',
            correct: true,
            responseMs: (elapsedSeconds * 1000).round(),
            quality: quality,
          );

      _learnedItems.add(
        LearnedItem(
          term: target.answer,
          ipa: target.ipa,
          definition: target.definition,
          example: target.example,
          wasMistake: false,
        ),
      );

      _usedEcho = false;
      _inputController.clear();
      _targetSpawnTime = DateTime.now();
      setState(() {});
    } else {
      ref.read(audioServiceProvider).playSfx(SfxType.wrong);
      _combo = 0;
      _inputController.clear();
      setState(() {});
    }
  }

  void _triggerFreeze() {
    setState(() => _isFrozen = true);
    ref.read(audioServiceProvider).playSfx(SfxType.freeze);
    _freezeTimer?.cancel();
    _freezeTimer = Timer(const Duration(seconds: 4), () {
      if (mounted) setState(() => _isFrozen = false);
    });
  }

  void _triggerEcho() {
    final target = _getTargetEnemy();
    if (target != null) {
      _usedEcho = true;
      ref.read(audioServiceProvider).speakOrPlay(target.answer);
    }
  }

  void _triggerBomb() {
    if (_activeEnemies.isNotEmpty) {
      ref.read(audioServiceProvider).playSfx(SfxType.bomb);
      setState(() {
        for (final e in _activeEnemies) {
          e.isDefeated = true;
          ref.read(srsDaoProvider).logReview(
                cardId: e.wordId,
                game: 'word_siege',
                correct: false,
                responseMs: 1000,
                quality: 1,
              );
        }
      });
    }
  }

  Future<void> _endGame() async {
    _gameLoopTimer?.cancel();
    _freezeTimer?.cancel();

    final now = DateTime.now().millisecondsSinceEpoch;
    final durationMs = now - _roundStartTime;
    final accuracy = _totalCount == 0 ? 0.0 : _correctCount / _totalCount;

    await ref.read(gameDaoProvider).recordSession(
          GameSessionsCompanion.insert(
            game: 'word_siege',
            mode: drift.Value(widget.mode.name),
            level: drift.Value(widget.level),
            startedAt: _roundStartTime,
            durationMs: durationMs,
            accuracy: accuracy,
            score: _score,
            xpEarned: _xpEarned,
            extraJson: drift.Value('{"gateBreaches": $_gateBreaches, "maxCombo": $_maxCombo}'),
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
          gameTitle: '⚔️ Word Siege',
          score: _score,
          xpEarned: _xpEarned,
          accuracy: accuracy,
          items: _learnedItems,
          onPlayAgain: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => WordSiegeScreen(
                  level: widget.level,
                  tapMode: _isTapMode,
                  mode: widget.mode,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _gameLoopTimer?.cancel();
    _freezeTimer?.cancel();
    _inputController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final target = _getTargetEnemy();

    return Scaffold(
      appBar: AppBar(
        title: Text('Word Siege — Wave $_wave/3'),
        actions: [
          // Tap / Typing Mode Toggle
          IconButton(
            icon: Icon(_isTapMode ? Icons.touch_app_rounded : Icons.keyboard_rounded),
            tooltip: _isTapMode ? 'Switch to Typing Mode' : 'Switch to Tap Mode',
            onPressed: () => setState(() => _isTapMode = !_isTapMode),
          ),
          // HP Hearts
          Row(
            children: List.generate(
              3,
              (index) => Icon(
                index < _hp ? Icons.favorite : Icons.favorite_border,
                color: AppColors.wrong,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top HUD
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(80),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.stars_rounded, color: AppColors.combo, size: 20),
                      const SizedBox(width: 4),
                      Text('$_score', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  if (_combo > 1)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.combo,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Combo x$_combo',
                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                  Row(
                    children: [
                      if (_combo >= 5)
                        IconButton(
                          icon: const Icon(Icons.ac_unit, color: Colors.cyan),
                          tooltip: 'Freeze',
                          onPressed: _triggerFreeze,
                        ),
                      if (_combo >= 8)
                        IconButton(
                          icon: const Icon(Icons.volume_up, color: AppColors.accent),
                          tooltip: 'Echo Hint',
                          onPressed: _triggerEcho,
                        ),
                      if (_combo >= 12)
                        IconButton(
                          icon: const Icon(Icons.local_fire_department, color: Colors.orange),
                          tooltip: 'Bomb Lane',
                          onPressed: _triggerBomb,
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Freeze Banner
            if (_isFrozen)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 4),
                color: Colors.cyan.withAlpha(160),
                child: const Text(
                  '❄️ FROZEN — 4 SECONDS ❄️',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),

            // 3-Lane Battlefield
            Expanded(
              child: Stack(
                children: [
                  Row(
                    children: [
                      Expanded(child: Container(decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.white.withAlpha(20)))))),
                      Expanded(child: Container(decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.white.withAlpha(20)))))),
                      const Expanded(child: SizedBox()),
                    ],
                  ),

                  // Enemies
                  ..._activeEnemies.where((e) => !e.isDefeated && e.y >= 0.0).map((enemy) {
                    final isTarget = enemy == target;
                    final laneWidth = MediaQuery.of(context).size.width / 3;
                    final leftPos = enemy.lane * laneWidth;

                    return Positioned(
                      left: leftPos + 4,
                      width: laneWidth - 8,
                      top: enemy.y * (MediaQuery.of(context).size.height * 0.40),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 50),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isTarget
                              ? (enemy.isBoss ? Colors.purple.shade900 : AppColors.accentDark)
                              : Colors.grey.shade800,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isTarget ? AppColors.combo : Colors.transparent,
                            width: 2,
                          ),
                          boxShadow: isTarget
                              ? [BoxShadow(color: AppColors.combo.withAlpha(100), blurRadius: 8)]
                              : null,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (enemy.isBoss)
                              const Text('👑 BOSS', style: TextStyle(color: AppColors.combo, fontSize: 10, fontWeight: FontWeight.bold)),
                            Text(
                              enemy.clue,
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                  // Gate
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 18,
                      color: AppColors.wrong.withAlpha(160),
                      child: const Center(
                        child: Text(
                          '⚡ DEFEND THE GATE ⚡',
                          style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Target Input Area (Typing Mode vs Tap Mode)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withAlpha(40), blurRadius: 8, offset: const Offset(0, -2)),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (target != null) ...[
                    Text(
                      target.clue,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                  ],

                  if (_isTapMode && target != null) ...[
                    // Tap Mode: 4 option buttons for rapid response
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: target.tapOptions.map((opt) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                            foregroundColor: Theme.of(context).colorScheme.onSurface,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          onPressed: () => _submitAnswer(opt),
                          child: Text(opt, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        );
                      }).toList(),
                    ),
                  ] else ...[
                    // Typing Mode: Text field
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _inputController,
                            focusNode: _focusNode,
                            autofocus: true,
                            autocorrect: false,
                            textInputAction: TextInputAction.send,
                            decoration: InputDecoration(
                              hintText: 'Type front enemy word...',
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.send_rounded, color: AppColors.accent),
                                onPressed: () => _submitAnswer(_inputController.text),
                              ),
                            ),
                            onSubmitted: _submitAnswer,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
