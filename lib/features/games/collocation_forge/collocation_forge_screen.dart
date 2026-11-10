import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../core/audio/audio_service.dart';
import '../../../app/providers.dart';
import '../../../core/db/database.dart';
import '../../../core/services/phase4_content_service.dart';
import '../widgets/what_you_learned_screen.dart';

class CollocationForgeItem {
  final int id;
  final String prompt;
  final String headword;
  final List<String> options;
  final String correct;
  final String register;
  final String example;

  const CollocationForgeItem({
    required this.id,
    required this.prompt,
    required this.headword,
    required this.options,
    required this.correct,
    required this.register,
    required this.example,
  });

  factory CollocationForgeItem.fromJson(Map<String, dynamic> json) {
    return CollocationForgeItem(
      id: json['id'] as int? ?? 0,
      prompt: json['prompt'] as String? ?? '',
      headword: json['headword'] as String? ?? '',
      options: (json['options'] as List<dynamic>?)?.cast<String>() ?? [],
      correct: json['correct'] as String? ?? '',
      register: json['register'] as String? ?? 'Academic',
      example: json['example'] as String? ?? '',
    );
  }
}

class CollocationForgeScreen extends ConsumerStatefulWidget {
  const CollocationForgeScreen({super.key});

  @override
  ConsumerState<CollocationForgeScreen> createState() =>
      _CollocationForgeScreenState();
}

class _CollocationForgeScreenState extends ConsumerState<CollocationForgeScreen> {
  List<CollocationForgeItem> _items = [];
  int _currentIndex = 0;
  bool _isLoading = true;

  Timer? _countdownTimer;
  int _secondsRemaining = 12;

  String? _selectedOption;
  bool _hasChecked = false;
  bool _isCorrect = false;

  int _score = 0;
  int _streak = 0;
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
    _countdownTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final data = await Phase4ContentService.instance.loadContent();
      final list = (data['collocation_forge'] as List)
          .map((i) => CollocationForgeItem.fromJson(i as Map<String, dynamic>))
          .toList();

      if (!mounted) return;
      setState(() {
        _items = list..shuffle();
        _isLoading = false;
      });

      _startTimer();
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  void _startTimer() {
    _countdownTimer?.cancel();
    setState(() => _secondsRemaining = 12);
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_secondsRemaining > 1) {
        setState(() => _secondsRemaining--);
      } else {
        timer.cancel();
        _onTimeOut();
      }
    });
  }

  void _onTimeOut() {
    if (_hasChecked) return;
    _checkAnswer(isTimeOut: true);
  }

  void _selectOption(String opt) {
    if (_hasChecked) return;
    setState(() => _selectedOption = opt);
    _checkAnswer(isTimeOut: false);
  }

  void _checkAnswer({bool isTimeOut = false}) {
    _countdownTimer?.cancel();
    final item = _items[_currentIndex];
    final isCorrect = !isTimeOut &&
        _selectedOption != null &&
        _selectedOption!.trim().toLowerCase() == item.correct.trim().toLowerCase();

    setState(() {
      _hasChecked = true;
      _isCorrect = isCorrect;
    });

    if (isCorrect) {
      _streak++;
      final multiplier = 1.0 + (_streak * 0.2).clamp(0.0, 2.0);
      final points = (100 * multiplier).toInt();
      _score += points;
      _xpEarned += 15;
      _correctCount++;
      ref.read(audioServiceProvider).playSfx(SfxType.correct);
    } else {
      _streak = 0;
      ref.read(audioServiceProvider).playSfx(SfxType.wrong);
    }

    _learnedItems.add(
      LearnedItem(
        term: '${item.correct} + ${item.headword}',
        definition: item.register,
        example: item.example,
        wasMistake: !isCorrect,
      ),
    );
  }

  void _next() {
    if (_currentIndex + 1 < _items.length) {
      setState(() {
        _currentIndex++;
        _selectedOption = null;
        _hasChecked = false;
        _isCorrect = false;
      });
      _startTimer();
    } else {
      _finishGame();
    }
  }

  Future<void> _finishGame() async {
    final durationMs = DateTime.now().millisecondsSinceEpoch - _roundStartTime;
    final total = _items.isNotEmpty ? _items.length : 1;
    final accuracy = _correctCount / total;

    await ref.read(gameDaoProvider).recordSession(
          GameSessionsCompanion.insert(
            game: 'collocation_forge',
            mode: const drift.Value('rapid_forge'),
            level: const drift.Value(4),
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
          gameTitle: '⚡ Collocation Forge (AWL Phrasing)',
          score: _score,
          xpEarned: _xpEarned,
          accuracy: accuracy,
          items: _learnedItems,
          onPlayAgain: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const CollocationForgeScreen()),
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
        backgroundColor: Color(0xFF0A0C10),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF6366F1)),
        ),
      );
    }

    if (_items.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFF0A0C10),
        appBar: AppBar(title: const Text('Collocation Forge')),
        body: const Center(
          child: Text('No collocations loaded.',
              style: TextStyle(color: Colors.white70)),
        ),
      );
    }

    final item = _items[_currentIndex];
    final total = _items.length;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0C10),
      appBar: AppBar(
        backgroundColor: const Color(0xFF12161F),
        elevation: 0,
        title: Row(
          children: [
            const Text(
              'Collocation Forge',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            if (_streak > 1) ...[
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.amber.withAlpha(30),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${_streak}x STREAK',
                  style: const TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            Text(
              'Score: $_score',
              style: const TextStyle(
                color: Color(0xFF10B981),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Timer and Progress Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Round ${_currentIndex + 1} of $total',
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.timer_outlined,
                          size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        '${_secondsRemaining}s',
                        style: TextStyle(
                          color: _secondsRemaining <= 3
                              ? Colors.redAccent
                              : Colors.amber,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: _secondsRemaining / 12,
                backgroundColor: Colors.white10,
                valueColor: AlwaysStoppedAnimation(
                  _secondsRemaining <= 3 ? Colors.redAccent : const Color(0xFF6366F1),
                ),
                minHeight: 4,
                borderRadius: BorderRadius.circular(2),
              ),
              const SizedBox(height: 24),

              // Prompt Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF12161F),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6366F1).withAlpha(30),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            item.register.toUpperCase(),
                            style: const TextStyle(
                              color: Color(0xFF818CF8),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Headword: ${item.headword}',
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      item.prompt,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              if (_hasChecked) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: _isCorrect
                        ? const Color(0xFF10B981).withAlpha(20)
                        : const Color(0xFFEF4444).withAlpha(20),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _isCorrect ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isCorrect ? Icons.check_circle : Icons.error_outline,
                        color: _isCorrect ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _isCorrect
                              ? 'Natural Collocation! (+${100 + (_streak * 20)} pts)'
                              : 'Collocation Target: ${item.correct} ${item.headword}',
                          style: TextStyle(
                            color: _isCorrect ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 24),

              // 4 Fast Choice Options
              ...item.options.map((opt) {
                final isSelected = _selectedOption == opt;
                final isTarget = opt == item.correct;

                Color borderColor = Colors.white24;
                Color bgColor = const Color(0xFF161B26);

                if (_hasChecked) {
                  if (isTarget) {
                    borderColor = const Color(0xFF10B981);
                    bgColor = const Color(0xFF10B981).withAlpha(30);
                  } else if (isSelected) {
                    borderColor = const Color(0xFFEF4444);
                    bgColor = const Color(0xFFEF4444).withAlpha(30);
                  }
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: () => _selectOption(opt),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor, width: 1.5),
                      ),
                      child: Row(
                        children: [
                          Text(
                            opt,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : Colors.white70,
                            ),
                          ),
                          const Spacer(),
                          if (_hasChecked && isTarget)
                            const Icon(Icons.check_circle_rounded,
                                color: Color(0xFF10B981), size: 18)
                          else if (_hasChecked && isSelected)
                            const Icon(Icons.cancel_rounded,
                                color: Color(0xFFEF4444), size: 18),
                        ],
                      ),
                    ),
                  ),
                );
              }),

              const Spacer(),

              // Next Round / Complete
              if (_hasChecked)
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _next,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      _currentIndex + 1 < total
                          ? 'Next Collocation'
                          : 'Complete Forge',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
