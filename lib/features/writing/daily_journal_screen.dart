import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../app/theme.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/db/database.dart';
import '../../../app/providers.dart';
import '../../../core/services/phase3_content_service.dart';
import 'writing_portfolio_screen.dart';

class JournalPromptItem {
  final int id;
  final String theme;
  final String sentence1Prompt;
  final String sentence1Starter;
  final String sentence2Prompt;
  final String sentence2Starter;
  final String sentence3Prompt;
  final String sentence3Starter;

  const JournalPromptItem({
    required this.id,
    required this.theme,
    required this.sentence1Prompt,
    required this.sentence1Starter,
    required this.sentence2Prompt,
    required this.sentence2Starter,
    required this.sentence3Prompt,
    required this.sentence3Starter,
  });

  factory JournalPromptItem.fromJson(Map<String, dynamic> json) {
    return JournalPromptItem(
      id: json['id'] as int,
      theme: json['theme'] as String,
      sentence1Prompt: json['sentence1Prompt'] as String,
      sentence1Starter: json['sentence1Starter'] as String,
      sentence2Prompt: json['sentence2Prompt'] as String,
      sentence2Starter: json['sentence2Starter'] as String,
      sentence3Prompt: json['sentence3Prompt'] as String,
      sentence3Starter: json['sentence3Starter'] as String,
    );
  }
}

class DailyJournalScreen extends ConsumerStatefulWidget {
  const DailyJournalScreen({super.key});

  @override
  ConsumerState<DailyJournalScreen> createState() => _DailyJournalScreenState();
}

class _DailyJournalScreenState extends ConsumerState<DailyJournalScreen> {
  JournalPromptItem? _prompt;
  bool _isLoading = true;

  final TextEditingController _s1Controller = TextEditingController();
  final TextEditingController _s2Controller = TextEditingController();
  final TextEditingController _s3Controller = TextEditingController();

  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _loadJournalPrompt();
  }

  @override
  void dispose() {
    _s1Controller.dispose();
    _s2Controller.dispose();
    _s3Controller.dispose();
    super.dispose();
  }

  Future<void> _loadJournalPrompt() async {
    try {
      final data = await Phase3ContentService.instance.loadContent();
      final list = (data['journal_prompts'] as List)
          .map((j) => JournalPromptItem.fromJson(j as Map<String, dynamic>))
          .toList();

      if (!mounted) return;
      if (list.isNotEmpty) {
        final p = list.first;
        setState(() {
          _prompt = p;
          _s1Controller.text = p.sentence1Starter;
          _s2Controller.text = p.sentence2Starter;
          _s3Controller.text = p.sentence3Starter;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveJournal() async {
    final s1 = _s1Controller.text.trim();
    final s2 = _s2Controller.text.trim();
    final s3 = _s3Controller.text.trim();

    if (s1.isEmpty || s2.isEmpty || s3.isEmpty) return;

    final fullText = '$s1\n\n$s2\n\n$s3';
    final db = ref.read(databaseProvider);

    await db.into(db.userTexts).insert(
          UserTextsCompanion.insert(
            prompt: 'Daily 3 Sentences: ${_prompt?.theme ?? "Reflection"}',
            body: fullText,
            createdAt: DateTime.now().millisecondsSinceEpoch,
            selfScore: const drift.Value(5),
          ),
        );

    // Record stats
    final today = DateTime.now();
    final todayKey =
        '${today.year.toString().padLeft(4, '0')}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    await ref.read(statsDaoProvider).recordDailyActivity(
          dayKey: todayKey,
          minutes: 5,
          xp: 60,
          itemsReviewed: 3,
          goalMet: true,
        );

    // Unlock achievement
    await ref.read(statsDaoProvider).unlockAchievement('daily_scribe');

    ref.read(audioServiceProvider).playSfx(SfxType.correct);

    setState(() => _isSaved = true);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final theme = Theme.of(context);
    final p = _prompt;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily 3 Sentences'),
        actions: [
          IconButton(
            icon: const Icon(Icons.collections_bookmark_rounded, color: AppColors.accent),
            tooltip: 'Writing Portfolio',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const WritingPortfolioScreen()),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Card
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          p?.theme ?? 'Daily Observation',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withAlpha(20),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'JOURNAL',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.accent),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '3 targeted sentences to build spontaneous fluency and daily discourse coherence.',
                      style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Sentence 1: Observation
              _SentenceInputCard(
                stepNumber: '1',
                stepTitle: 'OBSERVATION',
                promptText: p?.sentence1Prompt ?? 'State an intellectual insight.',
                controller: _s1Controller,
                readOnly: _isSaved,
              ),
              const SizedBox(height: 16),

              // Sentence 2: Contrast / Complication
              _SentenceInputCard(
                stepNumber: '2',
                stepTitle: 'CONTRAST / NUANCE',
                promptText: p?.sentence2Prompt ?? 'Introduce an unexpected complication or contrast.',
                controller: _s2Controller,
                readOnly: _isSaved,
              ),
              const SizedBox(height: 16),

              // Sentence 3: Conclusion / Pragmatic Intent
              _SentenceInputCard(
                stepNumber: '3',
                stepTitle: 'PRAGMATIC RESOLUTION',
                promptText: p?.sentence3Prompt ?? 'Formulate a future action or takeaway.',
                controller: _s3Controller,
                readOnly: _isSaved,
              ),
              const SizedBox(height: 24),

              if (!_isSaved)
                ElevatedButton(
                  onPressed: _saveJournal,
                  child: const Text('Save to Writing Portfolio (+60 XP)'),
                )
              else ...[
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.correct.withAlpha(20),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.correct.withAlpha(80)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.check_circle_rounded, color: AppColors.correct, size: 20),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Entry recorded! Your thoughts are archived in your Writing Portfolio.',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const WritingPortfolioScreen()),
                  ),
                  child: const Text('View All Entries in Portfolio'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SentenceInputCard extends StatelessWidget {
  final String stepNumber;
  final String stepTitle;
  final String promptText;
  final TextEditingController controller;
  final bool readOnly;

  const _SentenceInputCard({
    required this.stepNumber,
    required this.stepTitle,
    required this.promptText,
    required this.controller,
    required this.readOnly,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 10,
                backgroundColor: theme.colorScheme.primary.withAlpha(30),
                child: Text(
                  stepNumber,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                stepTitle,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: theme.colorScheme.primary, letterSpacing: 0.5),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(promptText, style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant)),
          const SizedBox(height: 10),
          TextField(
            controller: controller,
            maxLines: 2,
            readOnly: readOnly,
            style: const TextStyle(fontSize: 14, height: 1.3),
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: theme.colorScheme.surfaceContainerHighest,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
            ),
          ),
        ],
      ),
    );
  }
}
