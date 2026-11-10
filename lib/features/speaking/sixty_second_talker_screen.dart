import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../app/theme.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/db/database.dart';
import '../../../app/providers.dart';
import '../../../core/services/phase3_content_service.dart';
import '../games/widgets/what_you_learned_screen.dart';

enum TalkerStage { prep, speaking, reflection, completed }

class TalkerPromptItem {
  final int id;
  final String topic;
  final String category;
  final String prompt;
  final List<String> scaffolds;
  final List<String> targetKeywords;
  final int minWords;

  const TalkerPromptItem({
    required this.id,
    required this.topic,
    required this.category,
    required this.prompt,
    required this.scaffolds,
    required this.targetKeywords,
    required this.minWords,
  });

  factory TalkerPromptItem.fromJson(Map<String, dynamic> json) {
    return TalkerPromptItem(
      id: json['id'] as int,
      topic: json['topic'] as String,
      category: json['category'] as String,
      prompt: json['prompt'] as String,
      scaffolds: (json['scaffolds'] as List).map((s) => s.toString()).toList(),
      targetKeywords: (json['targetKeywords'] as List).map((k) => k.toString()).toList(),
      minWords: json['minWords'] as int? ?? 80,
    );
  }
}

class SixtySecondTalkerScreen extends ConsumerStatefulWidget {
  const SixtySecondTalkerScreen({super.key});

  @override
  ConsumerState<SixtySecondTalkerScreen> createState() => _SixtySecondTalkerScreenState();
}

class _SixtySecondTalkerScreenState extends ConsumerState<SixtySecondTalkerScreen> {
  List<TalkerPromptItem> _prompts = [];
  final int _currentIndex = 0;
  bool _isLoading = true;

  TalkerStage _stage = TalkerStage.prep;
  int _prepSecondsLeft = 15;
  int _speakSecondsLeft = 60;
  Timer? _timer;

  // Self-reflection Rubric (1-5 scale)
  int _fluencyRating = 4;
  int _lexicalRating = 4;
  int _grammarRating = 4;
  int _pronunciationRating = 4;
  final TextEditingController _notesController = TextEditingController();

  int _roundStartTime = 0;

  @override
  void initState() {
    super.initState();
    _roundStartTime = DateTime.now().millisecondsSinceEpoch;
    _loadPrompts();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadPrompts() async {
    try {
      final data = await Phase3ContentService.instance.loadContent();
      final list = (data['talker_prompts'] as List)
          .map((p) => TalkerPromptItem.fromJson(p as Map<String, dynamic>))
          .toList();

      if (!mounted) return;
      setState(() {
        _prompts = list..shuffle();
        _isLoading = false;
      });

      _startPrepCountdown();
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  void _startPrepCountdown() {
    _stage = TalkerStage.prep;
    _prepSecondsLeft = 15;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (_prepSecondsLeft > 1) {
        setState(() => _prepSecondsLeft--);
      } else {
        t.cancel();
        _startSpeakingStage();
      }
    });
  }

  void _startSpeakingStage() {
    setState(() {
      _stage = TalkerStage.speaking;
      _speakSecondsLeft = 60;
    });

    ref.read(audioServiceProvider).playSfx(SfxType.levelUp);

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (_speakSecondsLeft > 1) {
        setState(() => _speakSecondsLeft--);
      } else {
        t.cancel();
        _finishSpeaking();
      }
    });
  }

  void _finishSpeaking() {
    _timer?.cancel();
    ref.read(audioServiceProvider).playSfx(SfxType.correct);
    setState(() => _stage = TalkerStage.reflection);
  }

  Future<void> _submitReflection() async {
    final current = _prompts[_currentIndex];
    final db = ref.read(databaseProvider);

    final avgRating = (_fluencyRating + _lexicalRating + _grammarRating + _pronunciationRating) / 4.0;

    await db.into(db.recordings).insert(
          RecordingsCompanion.insert(
            prompt: '60s Talker: ${current.topic}',
            filePath: 'simulated_audio_${DateTime.now().millisecondsSinceEpoch}.m4a',
            durationMs: (DateTime.now().millisecondsSinceEpoch - _roundStartTime).clamp(1000, 120000),
            sttText: drift.Value(_notesController.text.trim()),
            score: drift.Value(avgRating),
            createdAt: DateTime.now().millisecondsSinceEpoch,
          ),
        );

    final today = DateTime.now();
    final todayKey =
        '${today.year.toString().padLeft(4, '0')}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    await ref.read(statsDaoProvider).recordDailyActivity(
          dayKey: todayKey,
          minutes: 3,
          xp: 80,
          itemsReviewed: 1,
          goalMet: true,
        );

    // Unlock achievement
    await ref.read(statsDaoProvider).unlockAchievement('orator_sixty');

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => WhatYouLearnedScreen(
          gameTitle: '🗣️ 60-Second Talker (Fluency Sprint)',
          score: (avgRating * 50).round(),
          xpEarned: 80,
          accuracy: avgRating / 5.0,
          items: [
            LearnedItem(
              term: current.topic,
              definition: 'Target Keywords: ${current.targetKeywords.join(', ')}',
              example: _notesController.text.isNotEmpty ? _notesController.text : 'Spoken monologue delivered continuously for 60s.',
              wasMistake: false,
            ),
          ],
          onPlayAgain: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const SixtySecondTalkerScreen()),
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
    if (_prompts.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('60-Second Talker')),
        body: const Center(child: Text('No speaking prompts found.')),
      );
    }

    final theme = Theme.of(context);
    final current = _prompts[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('60-Second Talker'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Topic Header Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.colorScheme.outline),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withAlpha(20),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        current.category.toUpperCase(),
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.accent),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(current.topic, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text(current.prompt, style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurfaceVariant, height: 1.3)),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // STAGE: Preparation
              if (_stage == TalkerStage.prep) ...[
                Center(
                  child: Column(
                    children: [
                      Text('PREPARATION PHASE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: theme.colorScheme.primary, letterSpacing: 1.0)),
                      const SizedBox(height: 8),
                      Text('$_prepSecondsLeft', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: AppColors.accent)),
                      const SizedBox(height: 4),
                      Text('Review scaffolds below. Speaking starts automatically.', style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Discourse Starters & Keywords:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(height: 8),
                      ...current.scaffolds.map((s) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text('• $s', style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic)),
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _startSpeakingStage,
                  child: const Text('Ready Now (Skip Prep)'),
                ),
              ],

              // STAGE: Speaking Countdown
              if (_stage == TalkerStage.speaking) ...[
                Center(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(color: AppColors.wrong, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 8),
                          const Text('RECORDING & SPEAKING ACTIVE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: AppColors.wrong)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text('$_speakSecondsLeft s', style: const TextStyle(fontSize: 54, fontWeight: FontWeight.w900, color: AppColors.correct)),
                      const SizedBox(height: 4),
                      const Text('Do not pause. Prioritize spontaneous flow and connector use.', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                LinearProgressIndicator(
                  value: _speakSecondsLeft / 60.0,
                  backgroundColor: theme.colorScheme.surface,
                  valueColor: const AlwaysStoppedAnimation(AppColors.correct),
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.wrong),
                  onPressed: _finishSpeaking,
                  child: const Text('Finish Speaking Early'),
                ),
              ],

              // STAGE: Self-Reflection Rubric
              if (_stage == TalkerStage.reflection) ...[
                Text('Senior CEFR Self-Assessment Rubric', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Evaluate your 60-second delivery candidly to identify personal bottlenecks.', style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant)),
                const SizedBox(height: 16),

                _RubricSlider(
                  label: 'Fluency & Coherence',
                  subtitle: 'Did you sustain continuous speech with minimal hesitations?',
                  value: _fluencyRating,
                  onChanged: (v) => setState(() => _fluencyRating = v),
                ),
                _RubricSlider(
                  label: 'Lexical Resource',
                  subtitle: 'Did you weave in precise B2/C1 vocabulary and collocations?',
                  value: _lexicalRating,
                  onChanged: (v) => setState(() => _lexicalRating = v),
                ),
                _RubricSlider(
                  label: 'Grammatical Complexity',
                  subtitle: 'Did you deploy varied clause structures (concessions, relatives)?',
                  value: _grammarRating,
                  onChanged: (v) => setState(() => _grammarRating = v),
                ),
                _RubricSlider(
                  label: 'Phonology & Prosody',
                  subtitle: 'Was your intonation clear and chunk boundaries audible?',
                  value: _pronunciationRating,
                  onChanged: (v) => setState(() => _pronunciationRating = v),
                ),
                const SizedBox(height: 12),

                TextField(
                  controller: _notesController,
                  maxLines: 2,
                  style: const TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Optional reflection: What phrase would you improve next time?',
                    filled: true,
                    fillColor: theme.colorScheme.surface,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: theme.colorScheme.outline)),
                  ),
                ),
                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: _submitReflection,
                  child: const Text('Record Assessment & Claim XP'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _RubricSlider extends StatelessWidget {
  final String label;
  final String subtitle;
  final int value;
  final ValueChanged<int> onChanged;

  const _RubricSlider({
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.colorScheme.outline),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Text('$value / 5', style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
              ],
            ),
            const SizedBox(height: 2),
            Text(subtitle, style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant)),
            Slider(
              value: value.toDouble(),
              min: 1,
              max: 5,
              divisions: 4,
              activeColor: AppColors.accent,
              onChanged: (v) => onChanged(v.round()),
            ),
          ],
        ),
      ),
    );
  }
}
