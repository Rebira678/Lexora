import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../app/theme.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/db/database.dart';
import '../../../app/providers.dart';
import '../../../core/planner/difficulty_tuner.dart';
import '../../../core/services/phase2_content_service.dart';
import '../widgets/what_you_learned_screen.dart';

class LayerStep {
  final String type;
  final String fragment;
  final String targetSentence;
  final String instruction;

  LayerStep({
    required this.type,
    required this.fragment,
    required this.targetSentence,
    required this.instruction,
  });

  factory LayerStep.fromJson(Map<String, dynamic> json) {
    return LayerStep(
      type: json['type'] as String,
      fragment: json['fragment'] as String,
      targetSentence: json['targetSentence'] as String,
      instruction: json['instruction'] as String,
    );
  }
}

class LayerExercise {
  final int id;
  final int level;
  final String kernel;
  final List<LayerStep> layers;

  LayerExercise({
    required this.id,
    required this.level,
    required this.kernel,
    required this.layers,
  });

  factory LayerExercise.fromJson(Map<String, dynamic> json) {
    return LayerExercise(
      id: json['id'] as int,
      level: json['level'] as int? ?? 2,
      kernel: json['kernel'] as String,
      layers: (json['layers'] as List).map((l) => LayerStep.fromJson(l as Map<String, dynamic>)).toList(),
    );
  }
}

class LayerBuilderScreen extends ConsumerStatefulWidget {
  final int level;

  const LayerBuilderScreen({
    super.key,
    this.level = 2,
  });

  @override
  ConsumerState<LayerBuilderScreen> createState() => _LayerBuilderScreenState();
}

class _LayerBuilderScreenState extends ConsumerState<LayerBuilderScreen> {
  List<LayerExercise> _exercises = [];
  int _exerciseIndex = 0;
  int _currentStepIndex = 0;
  String _currentSentence = '';
  bool _isLoading = true;

  int? _selectedPlacement; // 0: Front, 1: Middle/Appositive, 2: End
  bool _hasChecked = false;
  bool _isStepCorrect = false;

  int _score = 0;
  int _xpEarned = 0;
  int _correctCount = 0;
  final List<LearnedItem> _learnedItems = [];
  int _roundStartTime = 0;

  @override
  void initState() {
    super.initState();
    _roundStartTime = DateTime.now().millisecondsSinceEpoch;
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    try {
      final data = await Phase2ContentService.instance.loadContent();
      final list = (data['layer_builder'] as List)
          .map((e) => LayerExercise.fromJson(e as Map<String, dynamic>))
          .toList();

      if (!mounted) return;
      setState(() {
        _exercises = list..shuffle();
        _isLoading = false;
      });

      if (_exercises.isNotEmpty) {
        _setupExercise(_exercises.first);
      }
    } catch (e, stack) {
      debugPrint('LayerBuilderScreen error loading: $e\n$stack');
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  void _setupExercise(LayerExercise exercise) {
    setState(() {
      _currentStepIndex = 0;
      _currentSentence = exercise.kernel;
      _selectedPlacement = null;
      _hasChecked = false;
      _isStepCorrect = false;
    });
    ref.read(audioServiceProvider).speakOrPlay(_currentSentence);
  }

  int _getCorrectPlacement(LayerStep step) {
    final frag = step.fragment.trim();
    if (step.targetSentence.startsWith(frag)) return 0; // Front
    if (step.targetSentence.endsWith(frag)) return 2; // End
    return 1; // Middle
  }

  void _checkPlacement() {
    if (_selectedPlacement == null || _hasChecked) return;
    final exercise = _exercises[_exerciseIndex];
    final step = exercise.layers[_currentStepIndex];
    final correctPlacement = _getCorrectPlacement(step);
    final isCorrect = _selectedPlacement == correctPlacement;

    setState(() {
      _hasChecked = true;
      _isStepCorrect = isCorrect;
      if (isCorrect) {
        _currentSentence = step.targetSentence;
      }
    });

    if (isCorrect) {
      _correctCount++;
      _score += 120;
      _xpEarned += 25;
      ref.read(audioServiceProvider).playSfx(SfxType.correct);
      ref.read(audioServiceProvider).speakOrPlay(step.targetSentence);

      _learnedItems.add(
        LearnedItem(
          term: '${step.type} Layer',
          definition: step.instruction,
          example: step.targetSentence,
          wasMistake: false,
        ),
      );
    } else {
      ref.read(audioServiceProvider).playSfx(SfxType.wrong);

      _learnedItems.add(
        LearnedItem(
          term: '${step.type} Layer',
          definition: step.instruction,
          example: step.targetSentence,
          wasMistake: true,
        ),
      );
    }
  }

  void _nextStep() {
    final exercise = _exercises[_exerciseIndex];
    if (_currentStepIndex + 1 < exercise.layers.length) {
      setState(() {
        _currentStepIndex++;
        _selectedPlacement = null;
        _hasChecked = false;
        _isStepCorrect = false;
      });
      final step = exercise.layers[_currentStepIndex];
      ref.read(audioServiceProvider).speakOrPlay(step.fragment);
    } else {
      _nextExercise();
    }
  }

  void _nextExercise() {
    if (_exerciseIndex + 1 < _exercises.length && _exerciseIndex + 1 < 3) {
      setState(() {
        _exerciseIndex++;
      });
      _setupExercise(_exercises[_exerciseIndex]);
    } else {
      _endGame();
    }
  }

  Future<void> _endGame() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final durationMs = now - _roundStartTime;
    final total = _exerciseIndex * 3 + _currentStepIndex + 1;
    final accuracy = total == 0 ? 0.0 : _correctCount / total;
    final nextLevel = nextSentenceLevel(widget.level, accuracy, 3);

    await ref.read(gameDaoProvider).recordSession(
          GameSessionsCompanion.insert(
            game: 'layer_builder',
            mode: const drift.Value('syntax_expansion'),
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
          gameTitle: '🏗️ Layer Builder (Level ${widget.level} ➔ $nextLevel)',
          score: _score,
          xpEarned: _xpEarned,
          accuracy: accuracy,
          items: _learnedItems,
          onPlayAgain: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => LayerBuilderScreen(level: nextLevel)),
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
    if (_exercises.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Layer Builder')),
        body: const Center(child: Text('No layer building exercises found.')),
      );
    }

    final theme = Theme.of(context);
    final exercise = _exercises[_exerciseIndex];
    final step = exercise.layers[_currentStepIndex];
    final totalEx = _exercises.length < 3 ? _exercises.length : 3;

    return Scaffold(
      appBar: AppBar(
        title: Text('Layer Builder (${_exerciseIndex + 1}/$totalEx • Step ${_currentStepIndex + 1}/${exercise.layers.length})'),
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up_rounded, color: AppColors.accent),
            tooltip: 'Hear Sentence',
            onPressed: () => ref.read(audioServiceProvider).speakOrPlay(_currentSentence),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Layer Type Pill & Instruction
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.colorScheme.outline),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withAlpha(25),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        step.type.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        step.instruction,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Incoming Fragment Tile
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withAlpha(120),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: theme.colorScheme.primary, width: 1.5),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.add_circle_outline_rounded, color: AppColors.accent, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '"+ ${step.fragment}"',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Current Sentence Canvas
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: theme.colorScheme.outline),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Structure:',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: theme.colorScheme.onSurfaceVariant),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _hasChecked && _isStepCorrect ? step.targetSentence : _currentSentence,
                          style: TextStyle(
                            fontSize: 17,
                            height: 1.45,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Select Where to Insert this Layer:',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),

                        // 3 Placement options
                        _PlacementButton(
                          title: '1. Front (Opening Clause)',
                          subtitle: 'Place before the main subject clause',
                          selected: _selectedPlacement == 0,
                          onTap: () => setState(() => _selectedPlacement = 0),
                        ),
                        const SizedBox(height: 10),
                        _PlacementButton(
                          title: '2. Middle (Subject Modifier / Appositive)',
                          subtitle: 'Insert immediately after the subject noun',
                          selected: _selectedPlacement == 1,
                          onTap: () => setState(() => _selectedPlacement = 1),
                        ),
                        const SizedBox(height: 10),
                        _PlacementButton(
                          title: '3. End (Manner / Consequence)',
                          subtitle: 'Attach at the conclusion of the sentence',
                          selected: _selectedPlacement == 2,
                          onTap: () => setState(() => _selectedPlacement = 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Action button
              if (!_hasChecked)
                ElevatedButton(
                  onPressed: _selectedPlacement != null ? _checkPlacement : null,
                  child: const Text('Insert Layer & Expand'),
                )
              else
                ElevatedButton(
                  onPressed: _nextStep,
                  child: Text(
                    _currentStepIndex + 1 < exercise.layers.length
                        ? 'Next Layer (${_currentStepIndex + 2}/${exercise.layers.length})'
                        : (_exerciseIndex + 1 < totalEx ? 'Next Sentence' : 'Complete Architecture'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlacementButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _PlacementButton({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? theme.colorScheme.primary.withAlpha(25) : theme.colorScheme.surfaceContainerHighest.withAlpha(80),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? theme.colorScheme.primary : theme.colorScheme.outline.withAlpha(80),
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
              color: selected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: theme.colorScheme.onSurface)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
