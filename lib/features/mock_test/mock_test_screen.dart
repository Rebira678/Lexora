import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../app/theme.dart';
import '../../core/audio/audio_service.dart';
import '../../core/db/database.dart';
import '../../app/providers.dart';
import '../../core/services/phase3_content_service.dart';
import '../games/widgets/what_you_learned_screen.dart';

class MockQuestion {
  final String section;
  final String prompt;
  final List<String> options;
  final String answer;
  final String skill;

  const MockQuestion({
    required this.section,
    required this.prompt,
    required this.options,
    required this.answer,
    required this.skill,
  });

  factory MockQuestion.fromJson(Map<String, dynamic> json) {
    return MockQuestion(
      section: json['section'] as String,
      prompt: json['prompt'] as String,
      options: (json['options'] as List).map((o) => o.toString()).toList(),
      answer: json['answer'] as String,
      skill: json['skill'] as String,
    );
  }
}

class MockTestScreen extends ConsumerStatefulWidget {
  const MockTestScreen({super.key});

  @override
  ConsumerState<MockTestScreen> createState() => _MockTestScreenState();
}

class _MockTestScreenState extends ConsumerState<MockTestScreen> {
  List<MockQuestion> _questions = [];
  int _currentIndex = 0;
  bool _isLoading = true;

  final Map<String, int> _skillScores = {'reading': 0, 'writing': 0, 'listening': 0, 'vocab': 0};
  final Map<String, int> _skillTotals = {'reading': 0, 'writing': 0, 'listening': 0, 'vocab': 0};

  String? _selectedOption;
  bool _hasChecked = false;
  bool _isCorrect = false;

  int _totalCorrect = 0;
  final List<LearnedItem> _learnedItems = [];
  int _roundStartTime = 0;

  @override
  void initState() {
    super.initState();
    _roundStartTime = DateTime.now().millisecondsSinceEpoch;
    _loadMockQuestions();
  }

  Future<void> _loadMockQuestions() async {
    try {
      final data = await Phase3ContentService.instance.loadContent();
      final list = (data['mock_test'] as List)
          .map((m) => MockQuestion.fromJson(m as Map<String, dynamic>))
          .toList();

      if (!mounted) return;
      setState(() {
        _questions = list..shuffle();
        for (final q in _questions) {
          _skillTotals[q.skill] = (_skillTotals[q.skill] ?? 0) + 1;
        }
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  void _selectOption(String opt) {
    if (_hasChecked) return;
    setState(() => _selectedOption = opt);
  }

  void _submitAnswer() {
    if (_selectedOption == null || _hasChecked) return;
    final current = _questions[_currentIndex];
    final isCorrect = _selectedOption!.trim().toLowerCase() == current.answer.trim().toLowerCase();

    setState(() {
      _hasChecked = true;
      _isCorrect = isCorrect;
      if (isCorrect) {
        _totalCorrect++;
        _skillScores[current.skill] = (_skillScores[current.skill] ?? 0) + 1;
      }
    });

    if (isCorrect) {
      ref.read(audioServiceProvider).playSfx(SfxType.correct);
      _learnedItems.add(
        LearnedItem(
          term: '${current.section} Benchmark',
          definition: 'Mastered question.',
          example: current.prompt,
          wasMistake: false,
        ),
      );
    } else {
      ref.read(audioServiceProvider).playSfx(SfxType.wrong);
      _learnedItems.add(
        LearnedItem(
          term: '${current.section} Discrepancy',
          definition: 'Correct: ${current.answer}',
          example: current.prompt,
          wasMistake: true,
        ),
      );
    }
  }

  void _next() {
    if (_currentIndex + 1 < _questions.length) {
      setState(() {
        _currentIndex++;
        _selectedOption = null;
        _hasChecked = false;
        _isCorrect = false;
      });
    } else {
      _finishMockTest();
    }
  }

  Future<void> _finishMockTest() async {
    final durationMs = DateTime.now().millisecondsSinceEpoch - _roundStartTime;
    final total = _questions.isNotEmpty ? _questions.length : 1;
    final overallAccuracy = _totalCorrect / total;

    String estimatedCefr;
    if (overallAccuracy >= 0.85) {
      estimatedCefr = 'C1 (Advanced)';
    } else if (overallAccuracy >= 0.60) {
      estimatedCefr = 'B2 (Upper-Intermediate)';
    } else {
      estimatedCefr = 'B1 (Intermediate)';
    }

    final db = ref.read(databaseProvider);
    final now = DateTime.now().millisecondsSinceEpoch;

    // Save per-skill levels into Drift database
    for (final skill in ['reading', 'writing', 'listening', 'vocab']) {
      final skillTotal = _skillTotals[skill] ?? 1;
      final skillScore = (_skillScores[skill] ?? 0) / (skillTotal == 0 ? 1 : skillTotal);
      await db.into(db.skillLevels).insert(
            SkillLevelsCompanion.insert(
              skill: skill,
              cefrEstimate: estimatedCefr,
              score: skillScore,
              measuredAt: now,
              source: const drift.Value('monthly_mock'),
            ),
          );
    }

    final today = DateTime.now();
    final todayKey =
        '${today.year.toString().padLeft(4, '0')}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    await ref.read(statsDaoProvider).recordDailyActivity(
          dayKey: todayKey,
          minutes: (durationMs / 60000).ceil(),
          xp: 150,
          itemsReviewed: total,
          goalMet: true,
        );

    // Unlock achievement
    await ref.read(statsDaoProvider).unlockAchievement('mock_veteran');

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => WhatYouLearnedScreen(
          gameTitle: '📊 CEFR Benchmark Test ($estimatedCefr)',
          score: (_totalCorrect * 100),
          xpEarned: 150,
          accuracy: overallAccuracy,
          items: _learnedItems,
          onPlayAgain: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const MockTestScreen()),
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
    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('CEFR Mock Test')),
        body: const Center(child: Text('No mock test items found.')),
      );
    }

    final theme = Theme.of(context);
    final current = _questions[_currentIndex];
    final total = _questions.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('CEFR Mock Benchmark (${_currentIndex + 1}/$total)'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LinearProgressIndicator(
                value: (_currentIndex + 1) / total,
                backgroundColor: theme.colorScheme.surface,
                valueColor: const AlwaysStoppedAnimation(AppColors.accent),
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
              ),
              const SizedBox(height: 18),

              // Section Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withAlpha(25),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      current.section.toUpperCase(),
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5, color: AppColors.accent),
                    ),
                  ),
                  Text('Score: $_totalCorrect / ${_currentIndex + (_hasChecked ? 1 : 0)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 14),

              // Question Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.colorScheme.outline),
                ),
                child: Text(
                  current.prompt,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, height: 1.4),
                ),
              ),
              const SizedBox(height: 20),

              // Options
              Expanded(
                child: ListView.separated(
                  itemCount: current.options.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final opt = current.options[index];
                    final isSel = _selectedOption == opt;

                    Color cardColor = theme.colorScheme.surface;
                    Color borderColor = isSel ? theme.colorScheme.primary : theme.colorScheme.outline;

                    if (_hasChecked) {
                      if (opt == current.answer) {
                        cardColor = AppColors.correct.withAlpha(25);
                        borderColor = AppColors.correct;
                      } else if (isSel && !_isCorrect) {
                        cardColor = AppColors.wrong.withAlpha(25);
                        borderColor = AppColors.wrong;
                      }
                    }

                    return Material(
                      color: cardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: borderColor, width: isSel ? 2 : 1),
                      ),
                      child: InkWell(
                        onTap: _hasChecked ? null : () => _selectOption(opt),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          child: Text(
                            opt,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Action Button
              if (!_hasChecked)
                ElevatedButton(
                  onPressed: _selectedOption != null ? _submitAnswer : null,
                  child: const Text('Confirm Answer'),
                )
              else
                ElevatedButton(
                  onPressed: _next,
                  child: Text(_currentIndex + 1 < _questions.length ? 'Next Question' : 'Complete Benchmark'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
