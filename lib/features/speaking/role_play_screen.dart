import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../app/theme.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/db/database.dart';
import '../../../app/providers.dart';
import '../../../core/services/phase3_content_service.dart';
import '../games/widgets/what_you_learned_screen.dart';

class RolePlayTurn {
  final String speakerA;
  final String textA;
  final String promptB;
  final List<String> optionsB;
  final int correctIndex;
  final String teacherFeedback;

  const RolePlayTurn({
    required this.speakerA,
    required this.textA,
    required this.promptB,
    required this.optionsB,
    required this.correctIndex,
    required this.teacherFeedback,
  });

  factory RolePlayTurn.fromJson(Map<String, dynamic> json) {
    return RolePlayTurn(
      speakerA: json['speakerA'] as String,
      textA: json['textA'] as String,
      promptB: json['promptB'] as String,
      optionsB: (json['optionsB'] as List).map((o) => o.toString()).toList(),
      correctIndex: json['correctIndex'] as int? ?? 0,
      teacherFeedback: json['teacherFeedback'] as String,
    );
  }
}

class RolePlayScenario {
  final int id;
  final String title;
  final String category;
  final String context;
  final List<RolePlayTurn> turns;

  const RolePlayScenario({
    required this.id,
    required this.title,
    required this.category,
    required this.context,
    required this.turns,
  });

  factory RolePlayScenario.fromJson(Map<String, dynamic> json) {
    return RolePlayScenario(
      id: json['id'] as int,
      title: json['title'] as String,
      category: json['category'] as String,
      context: json['context'] as String,
      turns: (json['turns'] as List).map((t) => RolePlayTurn.fromJson(t as Map<String, dynamic>)).toList(),
    );
  }
}

class RolePlayScreen extends ConsumerStatefulWidget {
  const RolePlayScreen({super.key});

  @override
  ConsumerState<RolePlayScreen> createState() => _RolePlayScreenState();
}

class _RolePlayScreenState extends ConsumerState<RolePlayScreen> {
  List<RolePlayScenario> _scenarios = [];
  int _scenarioIndex = 0;
  int _turnIndex = 0;
  bool _isLoading = true;

  int? _selectedOption;
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
    _loadScenarios();
  }

  Future<void> _loadScenarios() async {
    try {
      final data = await Phase3ContentService.instance.loadContent();
      final list = (data['role_play'] as List)
          .map((s) => RolePlayScenario.fromJson(s as Map<String, dynamic>))
          .toList();

      if (!mounted) return;
      setState(() {
        _scenarios = list;
        _isLoading = false;
      });

      if (_scenarios.isNotEmpty && _scenarios.first.turns.isNotEmpty) {
        _speakSpeakerA();
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  void _speakSpeakerA() {
    if (_scenarioIndex < _scenarios.length) {
      final scenario = _scenarios[_scenarioIndex];
      if (_turnIndex < scenario.turns.length) {
        final turn = scenario.turns[_turnIndex];
        ref.read(audioServiceProvider).speakOrPlay(turn.textA);
      }
    }
  }

  void _selectOption(int idx) {
    if (_hasChecked) return;
    setState(() => _selectedOption = idx);
  }

  void _checkAnswer() {
    if (_selectedOption == null || _hasChecked) return;
    final scenario = _scenarios[_scenarioIndex];
    final turn = scenario.turns[_turnIndex];
    final isCorrect = _selectedOption == turn.correctIndex;

    setState(() {
      _hasChecked = true;
      _isCorrect = isCorrect;
    });

    if (isCorrect) {
      _correctCount++;
      _score += 150;
      _xpEarned += 30;
      ref.read(audioServiceProvider).playSfx(SfxType.correct);
      ref.read(audioServiceProvider).speakOrPlay(turn.optionsB[turn.correctIndex]);

      _learnedItems.add(
        LearnedItem(
          term: '${scenario.title} (Turn ${_turnIndex + 1})',
          definition: turn.teacherFeedback,
          example: turn.optionsB[turn.correctIndex],
          wasMistake: false,
        ),
      );
    } else {
      ref.read(audioServiceProvider).playSfx(SfxType.wrong);
      _learnedItems.add(
        LearnedItem(
          term: '${scenario.title} Pragmatic Register',
          definition: turn.teacherFeedback,
          example: 'Selected: ${turn.optionsB[_selectedOption!]}',
          wasMistake: true,
        ),
      );
    }
  }

  void _next() {
    final scenario = _scenarios[_scenarioIndex];
    if (_turnIndex + 1 < scenario.turns.length) {
      setState(() {
        _turnIndex++;
        _selectedOption = null;
        _hasChecked = false;
        _isCorrect = false;
      });
      _speakSpeakerA();
    } else {
      _finishGame();
    }
  }

  Future<void> _finishGame() async {
    final durationMs = DateTime.now().millisecondsSinceEpoch - _roundStartTime;
    final total = _scenarios.isNotEmpty ? _scenarios[_scenarioIndex].turns.length : 1;
    final accuracy = _correctCount / total;

    await ref.read(gameDaoProvider).recordSession(
          GameSessionsCompanion.insert(
            game: 'role_play',
            mode: const drift.Value('dialogue'),
            level: const drift.Value(3),
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

    // Save dialogue record
    await ref.read(databaseProvider).into(ref.read(databaseProvider).recordings).insert(
          RecordingsCompanion.insert(
            prompt: 'Role-Play Dialogue: ${_scenarios[_scenarioIndex].title}',
            filePath: 'roleplay_${DateTime.now().millisecondsSinceEpoch}.m4a',
            durationMs: durationMs,
            score: drift.Value(accuracy * 5.0),
            createdAt: DateTime.now().millisecondsSinceEpoch,
          ),
        );

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => WhatYouLearnedScreen(
          gameTitle: '🎭 Role-Play Dialogue (Pragmatic Fluency)',
          score: _score,
          xpEarned: _xpEarned,
          accuracy: accuracy,
          items: _learnedItems,
          onPlayAgain: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const RolePlayScreen()),
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
    if (_scenarios.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Role-Play Dialogues')),
        body: const Center(child: Text('No role-play scenarios found.')),
      );
    }

    final theme = Theme.of(context);
    final scenario = _scenarios[_scenarioIndex];
    final turn = scenario.turns[_turnIndex];
    final totalTurns = scenario.turns.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Role-Play: ${scenario.title}'),
        actions: [
          PopupMenuButton<int>(
            icon: const Icon(Icons.swap_horiz_rounded),
            tooltip: 'Switch Scenario',
            onSelected: (index) {
              setState(() {
                _scenarioIndex = index;
                _turnIndex = 0;
                _selectedOption = null;
                _hasChecked = false;
                _isCorrect = false;
              });
              _speakSpeakerA();
            },
            itemBuilder: (ctx) => List.generate(
              _scenarios.length,
              (i) => PopupMenuItem(
                value: i,
                child: Text(_scenarios[i].title),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.volume_up_rounded, color: AppColors.accent),
            tooltip: 'Replay Speaker A',
            onPressed: _speakSpeakerA,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Progress Bar
              LinearProgressIndicator(
                value: (_turnIndex + 1) / totalTurns,
                backgroundColor: theme.colorScheme.surface,
                valueColor: const AlwaysStoppedAnimation(AppColors.accent),
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
              ),
              const SizedBox(height: 14),

              // Scenario Context Pill
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.accent),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        scenario.context,
                        style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant, height: 1.3),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Speaker A Speech Bubble
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                    bottomLeft: Radius.circular(4),
                  ),
                  border: Border.all(color: theme.colorScheme.outline),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          turn.speakerA.toUpperCase(),
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
                        ),
                        IconButton(
                          icon: const Icon(Icons.volume_up_rounded, size: 18, color: AppColors.accent),
                          onPressed: () => ref.read(audioServiceProvider).speakOrPlay(turn.textA),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      turn.textA,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, height: 1.4),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Student's Turn Prompt
              Text(
                'YOUR RESPONSE TASK:',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5, color: theme.colorScheme.primary),
              ),
              const SizedBox(height: 4),
              Text(
                turn.promptB,
                style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurfaceVariant, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 14),

              // Response Options
              ...List.generate(turn.optionsB.length, (idx) {
                final opt = turn.optionsB[idx];
                final isSel = _selectedOption == idx;

                Color cardColor = theme.colorScheme.surface;
                Color borderColor = isSel ? theme.colorScheme.primary : theme.colorScheme.outline;

                if (_hasChecked) {
                  if (idx == turn.correctIndex) {
                    cardColor = AppColors.correct.withAlpha(25);
                    borderColor = AppColors.correct;
                  } else if (isSel && !_isCorrect) {
                    cardColor = AppColors.wrong.withAlpha(25);
                    borderColor = AppColors.wrong;
                  }
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Material(
                    color: cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: borderColor, width: isSel ? 2 : 1),
                    ),
                    child: InkWell(
                      onTap: _hasChecked ? null : () => _selectOption(idx),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Text(
                          opt,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 10),

              // Senior Teacher Feedback Card
              if (_hasChecked) ...[
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: (_isCorrect ? AppColors.correct : AppColors.wrong).withAlpha(15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: (_isCorrect ? AppColors.correct : AppColors.wrong).withAlpha(70)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(_isCorrect ? Icons.check_circle_rounded : Icons.info_outline_rounded,
                              color: _isCorrect ? AppColors.correct : AppColors.wrong, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            _isCorrect ? 'Pragmatic Register Mastered' : 'Register Analysis',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: _isCorrect ? AppColors.correct : AppColors.wrong),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        turn.teacherFeedback,
                        style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface, height: 1.3),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
              ],

              // Action Buttons
              if (!_hasChecked)
                ElevatedButton(
                  onPressed: _selectedOption != null ? _checkAnswer : null,
                  child: const Text('Deliver Spoken Response'),
                )
              else
                ElevatedButton(
                  onPressed: _next,
                  child: Text(_turnIndex + 1 < totalTurns ? 'Continue Conversation' : 'Conclude Scenario'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
