import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../app/theme.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/db/database.dart';
import '../../../app/providers.dart';
import '../../../core/planner/difficulty_tuner.dart';
import '../../../core/services/section20_content_service.dart';
import '../widgets/what_you_learned_screen.dart';

enum RacePhase { listening, countdown, answered }

class SentenceRaceScreen extends ConsumerStatefulWidget {
  final int level;

  const SentenceRaceScreen({
    super.key,
    this.level = 4,
  });

  @override
  ConsumerState<SentenceRaceScreen> createState() => _SentenceRaceScreenState();
}

class _SentenceRaceScreenState extends ConsumerState<SentenceRaceScreen> {
  final Section20ContentService _contentService = Section20ContentService();
  List<SentenceRaceItem> _items = [];
  int _currentIndex = 0;
  bool _isLoading = true;

  RacePhase _phase = RacePhase.listening;
  int _highlightedWordIndex = 0;
  Timer? _wordHighlightTimer;
  Timer? _countdownTimer;
  int _secondsLeft = 10;
  int? _selectedOptionIndex;

  int _score = 0;
  int _xpEarned = 0;
  int _correctCount = 0;
  final List<LearnedItem> _learnedItems = [];
  int _roundStartTime = 0;

  @override
  void initState() {
    super.initState();
    _roundStartTime = DateTime.now().millisecondsSinceEpoch;
    _loadData();
  }

  @override
  void dispose() {
    _wordHighlightTimer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadData() async {
    final list = await _contentService.getSentenceRaceItems(level: widget.level);
    if (!mounted) return;

    setState(() {
      _items = List.of(list)..shuffle();
      _isLoading = false;
    });

    if (_items.isNotEmpty) {
      _startSentencePlayback();
    }
  }

  void _startSentencePlayback() {
    _wordHighlightTimer?.cancel();
    _countdownTimer?.cancel();

    final item = _items[_currentIndex];
    final words = item.sentence.split(' ');

    setState(() {
      _phase = RacePhase.listening;
      _highlightedWordIndex = 0;
      _secondsLeft = 10;
      _selectedOptionIndex = null;
    });

    // Start audio speech
    AudioService().speakOrPlay(item.sentence, rate: 0.55);

    // Pace highlighting ~260ms per word
    int current = 0;
    _wordHighlightTimer = Timer.periodic(const Duration(milliseconds: 260), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      current++;
      if (current >= words.length) {
        timer.cancel();
        _startRaceCountdown();
      } else {
        setState(() {
          _highlightedWordIndex = current;
        });
      }
    });
  }

  void _startRaceCountdown() {
    _wordHighlightTimer?.cancel();
    setState(() {
      _phase = RacePhase.countdown;
      _secondsLeft = 10;
    });

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_secondsLeft <= 1) {
        timer.cancel();
        _onTimeExpired();
      } else {
        setState(() {
          _secondsLeft--;
        });
      }
    });
  }

  void _onTimeExpired() {
    if (_phase != RacePhase.countdown) return;
    _countdownTimer?.cancel();

    final item = _items[_currentIndex];
    AudioService().playSfx(SfxType.wrong);

    _learnedItems.add(
      LearnedItem(
        term: item.question,
        definition: item.options[item.correctIndex],
        example: item.sentence,
        wasMistake: true,
      ),
    );

    setState(() {
      _phase = RacePhase.answered;
      _selectedOptionIndex = -1; // timed out
    });
  }

  void _onSelectOption(int index) {
    if (_phase != RacePhase.countdown) return;
    _countdownTimer?.cancel();

    final item = _items[_currentIndex];
    final isCorrect = index == item.correctIndex;
    final speedBonus = _secondsLeft * 10;

    if (isCorrect) {
      _score += 100 + speedBonus;
      _xpEarned += 20 + (_secondsLeft * 2);
      _correctCount++;
      AudioService().playSfx(SfxType.correct);
    } else {
      AudioService().playSfx(SfxType.wrong);
    }

    _learnedItems.add(
      LearnedItem(
        term: item.question,
        definition: item.options[item.correctIndex],
        example: item.sentence,
        wasMistake: !isCorrect,
      ),
    );

    setState(() {
      _selectedOptionIndex = index;
      _phase = RacePhase.answered;
    });
  }

  void _nextSentence() {
    if (_currentIndex < _items.length - 1) {
      setState(() {
        _currentIndex++;
      });
      _startSentencePlayback();
    } else {
      _finishGame();
    }
  }

  Future<void> _finishGame() async {
    final total = _items.isEmpty ? 1 : _items.length;
    final accuracy = _correctCount / total;
    final durationMs = DateTime.now().millisecondsSinceEpoch - _roundStartTime;

    final nextLevel = nextSentenceLevel(widget.level, accuracy, 1);

    await ref.read(gameDaoProvider).recordSession(
          GameSessionsCompanion.insert(
            game: 'sentence_race',
            mode: const drift.Value('rapid_comprehension'),
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
          gameTitle: '⚡ Sentence Race (Level ${widget.level})',
          score: _score,
          xpEarned: _xpEarned,
          accuracy: accuracy,
          items: _learnedItems,
          onPlayAgain: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => SentenceRaceScreen(level: nextLevel)),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.darkBg,
        body: Center(child: CircularProgressIndicator(color: AppColors.accent)),
      );
    }

    if (_items.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.darkBg,
        appBar: AppBar(title: const Text('Sentence Race')),
        body: const Center(
          child: Text('No sentence race items available for this level.',
              style: TextStyle(color: AppColors.darkTextSecondary)),
        ),
      );
    }

    final item = _items[_currentIndex];
    final progress = (_currentIndex + 1) / _items.length;

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: AppColors.darkSurface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.darkText),
          onPressed: () {
            AudioService().stop();
            Navigator.of(context).pop();
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sentence Race',
              style: TextStyle(color: AppColors.darkText, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Round ${_currentIndex + 1}/${_items.length} • Level ${item.level}',
              style: const TextStyle(color: AppColors.darkTextSecondary, fontSize: 12),
            ),
          ],
        ),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                const Icon(Icons.bolt, color: AppColors.warning, size: 16),
                const SizedBox(width: 4),
                Text('$_score XP',
                    style: const TextStyle(color: AppColors.darkText, fontWeight: FontWeight.bold, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.darkSurface,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
              minHeight: 4,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Timer & phase indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              _phase == RacePhase.listening ? Icons.headphones : Icons.timer,
                              size: 18,
                              color: _phase == RacePhase.countdown
                                  ? (_secondsLeft <= 3 ? AppColors.wrong : AppColors.warning)
                                  : AppColors.accent,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _phase == RacePhase.listening
                                  ? 'Listening & Reading...'
                                  : (_phase == RacePhase.countdown
                                      ? 'Time Left: ${_secondsLeft}s'
                                      : 'Round Complete'),
                              style: TextStyle(
                                color: _phase == RacePhase.countdown && _secondsLeft <= 3
                                    ? AppColors.wrong
                                    : AppColors.darkText,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        if (_phase == RacePhase.listening)
                          TextButton(
                            onPressed: _startRaceCountdown,
                            child: const Text('Skip to Quiz ➔',
                                style: TextStyle(color: AppColors.warning, fontSize: 12)),
                          )
                        else
                          IconButton(
                            icon: const Icon(Icons.volume_up, color: AppColors.darkTextSecondary, size: 20),
                            onPressed: () => AudioService().speakOrPlay(item.sentence),
                            tooltip: 'Replay audio',
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Karaoke sentence box
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.darkSurface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _phase == RacePhase.countdown
                              ? AppColors.warning.withValues(alpha: 0.5)
                              : AppColors.darkBorder,
                        ),
                      ),
                      child: _buildKaraokeSentence(item),
                    ),
                    const SizedBox(height: 20),

                    // Countdown progress bar
                    if (_phase == RacePhase.countdown)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: _secondsLeft / 10.0,
                          backgroundColor: AppColors.darkSurface,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _secondsLeft <= 3 ? AppColors.wrong : AppColors.warning,
                          ),
                          minHeight: 6,
                        ),
                      ),
                    const SizedBox(height: 20),

                    // Question prompt
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.darkSurface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.help_outline, color: AppColors.accent, size: 22),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              item.question,
                              style: const TextStyle(
                                color: AppColors.darkText,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Options list
                    ...List.generate(item.options.length, (idx) {
                      final option = item.options[idx];
                      final isSelected = _selectedOptionIndex == idx;
                      final isCorrect = idx == item.correctIndex;

                      Color borderColor = AppColors.darkBorder;
                      Color bgColor = AppColors.darkSurface;
                      Color textColor = AppColors.darkText;

                      if (_phase == RacePhase.answered) {
                        if (isCorrect) {
                          borderColor = AppColors.correct;
                          bgColor = AppColors.correct.withValues(alpha: 0.15);
                          textColor = AppColors.correct;
                        } else if (isSelected && !isCorrect) {
                          borderColor = AppColors.wrong;
                          bgColor = AppColors.wrong.withValues(alpha: 0.15);
                          textColor = AppColors.wrong;
                        }
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          onTap: _phase == RacePhase.countdown ? () => _onSelectOption(idx) : null,
                          borderRadius: BorderRadius.circular(12),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: borderColor),
                                    color: isSelected ? borderColor : Colors.transparent,
                                  ),
                                  child: Center(
                                    child: Text(
                                      String.fromCharCode(65 + idx),
                                      style: TextStyle(
                                        color: isSelected ? Colors.white : AppColors.darkTextSecondary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Text(
                                    option,
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 15,
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                    ),
                                  ),
                                ),
                                if (_phase == RacePhase.answered && isCorrect)
                                  const Icon(Icons.check_circle, color: AppColors.correct, size: 22)
                                else if (_phase == RacePhase.answered && isSelected && !isCorrect)
                                  const Icon(Icons.cancel, color: AppColors.wrong, size: 22),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),

                    // Senior Teacher breakdown
                    if (_phase == RacePhase.answered) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: (_selectedOptionIndex == item.correctIndex)
                              ? AppColors.correct.withValues(alpha: 0.1)
                              : AppColors.warning.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: (_selectedOptionIndex == item.correctIndex)
                                ? AppColors.correct.withValues(alpha: 0.3)
                                : AppColors.warning.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  _selectedOptionIndex == item.correctIndex
                                      ? Icons.offline_bolt
                                      : Icons.lightbulb_outline,
                                  color: _selectedOptionIndex == item.correctIndex
                                      ? AppColors.correct
                                      : AppColors.warning,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _selectedOptionIndex == item.correctIndex
                                      ? 'Speed Win! (+${_secondsLeft * 10} Speed Bonus)'
                                      : 'Teacher Explanation:',
                                  style: const TextStyle(
                                    color: AppColors.darkText,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item.explanation,
                              style: const TextStyle(
                                color: AppColors.darkTextSecondary,
                                fontSize: 13,
                                height: 1.45,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Bottom action bar
            if (_phase == RacePhase.answered)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppColors.darkSurface,
                  border: Border(top: BorderSide(color: AppColors.darkBorder)),
                ),
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _nextSentence,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      _currentIndex < _items.length - 1 ? 'Next Sprint ➔' : 'View Results ➔',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildKaraokeSentence(SentenceRaceItem item) {
    final words = item.sentence.split(' ');
    final spans = <TextSpan>[];

    for (int i = 0; i < words.length; i++) {
      final isCurrent = (_phase == RacePhase.listening && i == _highlightedWordIndex);
      final hasPassed = (_phase == RacePhase.listening && i < _highlightedWordIndex) ||
          (_phase != RacePhase.listening);

      spans.add(
        TextSpan(
          text: '${words[i]} ',
          style: TextStyle(
            color: isCurrent
                ? AppColors.warning
                : (hasPassed ? AppColors.darkText : AppColors.darkTextSecondary),
            fontWeight: isCurrent ? FontWeight.w900 : (hasPassed ? FontWeight.w500 : FontWeight.normal),
            backgroundColor: isCurrent ? const Color(0x33F59E0B) : Colors.transparent,
            fontSize: 16,
            height: 1.5,
          ),
        ),
      );
    }

    return RichText(text: TextSpan(children: spans));
  }
}
