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
  final int targetPuzzles;

  const AnagramWheelScreen({
    super.key,
    this.durationSeconds = 90,
    this.targetPuzzles = 5,
  });

  @override
  ConsumerState<AnagramWheelScreen> createState() => _AnagramWheelScreenState();
}

class _AnagramWheelScreenState extends ConsumerState<AnagramWheelScreen>
    with SingleTickerProviderStateMixin {
  int _secondsRemaining = 90;
  Timer? _timer;
  int _score = 0;
  int _xpEarned = 0;
  int _combo = 0;
  int _puzzlesCompleted = 0;

  List<Word> _availableWords = [];
  Word? _currentWord;
  List<String> _letters = [];
  final List<int> _selectedIndices = [];
  Offset? _currentPanOffset;

  String _currentInput = '';
  final Set<String> _foundInRound = {};
  final List<LearnedItem> _learnedItems = [];
  bool _isLoading = true;
  int _roundStartTime = 0;
  bool _showClue = false;
  Timer? _clueTimer;

  // Wheel layout constants
  static const double _wheelRadius = 100.0;
  static const double _nodeRadius = 28.0;

  @override
  void initState() {
    super.initState();
    _secondsRemaining = widget.durationSeconds;
    _roundStartTime = DateTime.now().millisecondsSinceEpoch;
    _loadWords();
  }

  Future<void> _loadWords() async {
    final wordDao = ref.read(wordDaoProvider);
    final allWords = await wordDao.getAllWords();
    if (allWords.isEmpty || !mounted) return;

    // Filter suitable words (length 4 to 8, single word without spaces)
    final suitable = allWords
        .where((w) =>
            w.lemma.length >= 4 &&
            w.lemma.length <= 8 &&
            !w.lemma.contains(' ') &&
            !w.lemma.contains('-'))
        .toList();

    if (suitable.isEmpty) return;

    setState(() {
      _availableWords = List.of(suitable)..shuffle();
      _isLoading = false;
    });

    _nextPuzzle();
    _startTimer();
  }

  void _nextPuzzle() {
    _clueTimer?.cancel();
    if (_availableWords.isEmpty) {
      _endGame();
      return;
    }

    final next = _availableWords.removeLast();
    final letters = next.lemma.toUpperCase().split('')..shuffle();

    setState(() {
      _currentWord = next;
      _letters = letters;
      _selectedIndices.clear();
      _currentPanOffset = null;
      _currentInput = '';
      _showClue = false;
    });

    // Reveal definition clue after 10 seconds per app.md 5.1
    _clueTimer = Timer(const Duration(seconds: 10), () {
      if (mounted) {
        setState(() {
          _showClue = true;
        });
      }
    });
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

  Offset _getLetterCenter(int index, Size wheelSize) {
    final center = Offset(wheelSize.width / 2, wheelSize.height / 2);
    final angle = (2 * pi / _letters.length) * index - pi / 2;
    return Offset(
      center.dx + _wheelRadius * cos(angle),
      center.dy + _wheelRadius * sin(angle),
    );
  }

  int? _hitTestLetter(Offset touchPos, Size wheelSize) {
    for (int i = 0; i < _letters.length; i++) {
      final center = _getLetterCenter(i, wheelSize);
      if ((touchPos - center).distance <= _nodeRadius + 12) {
        return i;
      }
    }
    return null;
  }

  void _onPanStart(DragStartDetails details, Size size) {
    final hit = _hitTestLetter(details.localPosition, size);
    if (hit != null) {
      setState(() {
        _selectedIndices.clear();
        _selectedIndices.add(hit);
        _currentPanOffset = details.localPosition;
        _currentInput = _letters[hit];
      });
      ref.read(audioServiceProvider).playSfx(SfxType.click);
    }
  }

  void _onPanUpdate(DragUpdateDetails details, Size size) {
    final hit = _hitTestLetter(details.localPosition, size);
    setState(() {
      _currentPanOffset = details.localPosition;
      if (hit != null && !_selectedIndices.contains(hit)) {
        _selectedIndices.add(hit);
        _currentInput += _letters[hit];
        ref.read(audioServiceProvider).playSfx(SfxType.click);
      }
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _currentPanOffset = null;
    });
    if (_currentInput.isNotEmpty) {
      _checkWord();
    }
  }

  void _onLetterTap(int index) {
    if (_selectedIndices.contains(index)) return;
    setState(() {
      _selectedIndices.add(index);
      _currentInput += _letters[index];
    });
    ref.read(audioServiceProvider).playSfx(SfxType.click);
  }

  void _onClear() {
    setState(() {
      _selectedIndices.clear();
      _currentInput = '';
    });
  }

  void _checkWord() {
    if (_currentWord == null || _currentInput.isEmpty) return;
    final candidate = _currentInput.toLowerCase();
    final target = _currentWord!.lemma.toLowerCase();

    if (candidate == target) {
      // Correct!
      _combo++;
      final isMegaWord = candidate.length >= 6 || _selectedIndices.length == _letters.length;
      final comboMult = _combo >= 3 ? 2.0 : (1.0 + 0.2 * _combo);
      final pts = (200 * comboMult).round() + (isMegaWord ? 100 : 0);
      final xp = (25 * comboMult).round() + (isMegaWord ? 15 : 0);

      _score += pts;
      _xpEarned += xp;
      _puzzlesCompleted++;
      _foundInRound.add(target);

      ref.read(audioServiceProvider).playSfx(SfxType.correct);
      ref.read(audioServiceProvider).speakOrPlay(_currentWord!.lemma);

      _learnedItems.add(
        LearnedItem(
          term: _currentWord!.lemma,
          ipa: _currentWord!.ipa,
          definition: _currentWord!.definitionEn ?? 'Target word',
          example: '',
          wasMistake: false,
        ),
      );

      final msg = isMegaWord
          ? '🌟 MEGA WORD! ${_currentWord!.lemma}! +$pts pts'
          : '🎉 Found: ${_currentWord!.lemma}! +$pts pts${_combo >= 3 ? " (x2 COMBO!)" : ""}';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: isMegaWord ? Colors.deepPurpleAccent : AppColors.correct,
          duration: const Duration(milliseconds: 1400),
        ),
      );

      if (_puzzlesCompleted >= widget.targetPuzzles) {
        _endGame();
      } else {
        _nextPuzzle();
      }
    } else {
      // Miss
      ref.read(audioServiceProvider).playSfx(SfxType.wrong);
      _combo = 0;
      _onClear();
    }
  }

  Future<void> _endGame() async {
    _timer?.cancel();
    _clueTimer?.cancel();
    final now = DateTime.now().millisecondsSinceEpoch;
    final durationMs = now - _roundStartTime;
    final totalAttempts = _puzzlesCompleted + (_currentWord != null && !_foundInRound.contains(_currentWord!.lemma.toLowerCase()) ? 1 : 0);
    final accuracy = totalAttempts == 0 ? 0.0 : _puzzlesCompleted / totalAttempts;

    if (_currentWord != null && !_foundInRound.contains(_currentWord!.lemma.toLowerCase())) {
      _learnedItems.add(
        LearnedItem(
          term: _currentWord!.lemma,
          ipa: _currentWord!.ipa,
          definition: _currentWord!.definitionEn ?? 'Target word',
          example: '',
          wasMistake: true,
        ),
      );
    }

    // Add any remaining puzzle words that were not solved, with their meanings (app.md 5.1)
    for (final word in _availableWords) {
      if (!_foundInRound.contains(word.lemma.toLowerCase()) &&
          !_learnedItems.any((item) => item.term.toLowerCase() == word.lemma.toLowerCase())) {
        _learnedItems.add(
          LearnedItem(
            term: word.lemma,
            ipa: word.ipa,
            definition: word.definitionEn ?? 'Target word',
            example: '',
            wasMistake: true,
          ),
        );
      }
    }

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
          itemsReviewed: _puzzlesCompleted,
          goalMet: true,
        );

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
    _clueTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final theme = Theme.of(context);
    final wheelSize = const Size(270, 270);

    return Scaffold(
      appBar: AppBar(
        title: Text('Anagram Wheel (${_puzzlesCompleted + 1}/${widget.targetPuzzles})'),
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Score, Combo, Progress
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Score: $_score', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  if (_combo > 1)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.combo,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _combo >= 3 ? '🔥 Combo x$_combo (x2 XP!)' : 'Combo x$_combo',
                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
            ),

            // Definition Clue (appears after 10s or when unlocked)
            AnimatedOpacity(
              opacity: _showClue && _currentWord != null ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withAlpha(140),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.combo.withAlpha(120)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lightbulb_rounded, color: AppColors.combo, size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _currentWord?.definitionEn ?? '',
                        style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Word Input Slot
            Container(
              height: 64,
              margin: const EdgeInsets.symmetric(horizontal: 32),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border.all(color: AppColors.accent, width: 2),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: AppColors.accent.withAlpha(40), blurRadius: 12, spreadRadius: 1),
                ],
              ),
              child: Center(
                child: Text(
                  _currentInput.isEmpty ? '— SWIPE LETTERS —' : _currentInput,
                  style: TextStyle(
                    fontSize: _currentInput.isEmpty ? 15 : 30,
                    fontWeight: FontWeight.bold,
                    letterSpacing: _currentInput.isEmpty ? 1 : 5,
                    color: _currentInput.isEmpty
                        ? theme.colorScheme.onSurfaceVariant.withAlpha(140)
                        : AppColors.accent,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Interactive Wheel with Pan Gesture & Canvas Trail
            GestureDetector(
              onPanStart: (d) => _onPanStart(d, wheelSize),
              onPanUpdate: (d) => _onPanUpdate(d, wheelSize),
              onPanEnd: _onPanEnd,
              child: SizedBox(
                width: wheelSize.width,
                height: wheelSize.height,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Canvas for connecting trail lines
                    CustomPaint(
                      size: wheelSize,
                      painter: _WheelTrailPainter(
                        selectedIndices: _selectedIndices,
                        currentPanOffset: _currentPanOffset,
                        letters: _letters,
                        wheelRadius: _wheelRadius,
                      ),
                    ),

                    // Center Shuffle Button
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _letters.shuffle();
                          _selectedIndices.clear();
                          _currentInput = '';
                        });
                        ref.read(audioServiceProvider).playSfx(SfxType.click);
                      },
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: AppColors.accent.withAlpha(120), blurRadius: 12),
                          ],
                        ),
                        child: const Icon(Icons.shuffle_rounded, color: Colors.white, size: 28),
                      ),
                    ),

                    // Letter Circular Nodes
                    ...List.generate(_letters.length, (index) {
                      final center = _getLetterCenter(index, wheelSize);
                      final isSelected = _selectedIndices.contains(index);

                      return Positioned(
                        left: center.dx - _nodeRadius,
                        top: center.dy - _nodeRadius,
                        child: GestureDetector(
                          onTap: () => _onLetterTap(index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            width: _nodeRadius * 2,
                            height: _nodeRadius * 2,
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.accent : theme.colorScheme.surface,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected ? Colors.white : AppColors.accent,
                                width: isSelected ? 3 : 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: isSelected
                                      ? AppColors.accent.withAlpha(160)
                                      : Colors.black.withAlpha(30),
                                  blurRadius: isSelected ? 12 : 4,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                _letters[index],
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? Colors.white : theme.colorScheme.onSurface,
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
            ),

            const SizedBox(height: 20),

            // Bottom Buttons (Clear & Check)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.backspace_outlined),
                      label: const Text('Clear'),
                      onPressed: _onClear,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.check_rounded),
                      label: const Text('Check'),
                      onPressed: _checkWord,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WheelTrailPainter extends CustomPainter {
  final List<int> selectedIndices;
  final Offset? currentPanOffset;
  final List<String> letters;
  final double wheelRadius;

  _WheelTrailPainter({
    required this.selectedIndices,
    required this.currentPanOffset,
    required this.letters,
    required this.wheelRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (selectedIndices.isEmpty) return;

    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = AppColors.accent.withAlpha(180)
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    for (int i = 0; i < selectedIndices.length; i++) {
      final idx = selectedIndices[i];
      final angle = (2 * pi / letters.length) * idx - pi / 2;
      final pt = Offset(
        center.dx + wheelRadius * cos(angle),
        center.dy + wheelRadius * sin(angle),
      );

      if (i == 0) {
        path.moveTo(pt.dx, pt.dy);
      } else {
        path.lineTo(pt.dx, pt.dy);
      }
    }

    if (currentPanOffset != null) {
      path.lineTo(currentPanOffset!.dx, currentPanOffset!.dy);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WheelTrailPainter oldDelegate) {
    return true;
  }
}
