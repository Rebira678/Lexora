import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' as drift;
import '../../../app/theme.dart';
import '../../../app/providers.dart';
import '../../../core/db/database.dart';

class LearnedItem {
  final String term;
  final String? ipa;
  final String definition;
  final String example;
  final bool wasMistake;

  LearnedItem({
    required this.term,
    this.ipa,
    required this.definition,
    required this.example,
    this.wasMistake = false,
  });
}

/// "What You Learned" Screen shown after every game round.
///
/// Displays:
/// - Round score and XP earned
/// - Mastered vs Breached count badges
/// - List of words/sentences encountered with definitions and examples
/// - Tap-to-hear audio for every item
/// - ⭐ "Save to Mistake Notebook" toggle
class WhatYouLearnedScreen extends ConsumerStatefulWidget {
  final String gameTitle;
  final int score;
  final int xpEarned;
  final double accuracy;
  final List<LearnedItem> items;
  final VoidCallback? onPlayAgain;

  const WhatYouLearnedScreen({
    super.key,
    required this.gameTitle,
    required this.score,
    required this.xpEarned,
    required this.accuracy,
    required this.items,
    this.onPlayAgain,
  });

  @override
  ConsumerState<WhatYouLearnedScreen> createState() => _WhatYouLearnedScreenState();
}

class _WhatYouLearnedScreenState extends ConsumerState<WhatYouLearnedScreen> {
  final Set<String> _savedToNotebook = {};

  Future<void> _toggleSaveToNotebook(LearnedItem item) async {
    final term = item.term;
    final db = ref.read(databaseProvider);

    if (_savedToNotebook.contains(term)) {
      setState(() => _savedToNotebook.remove(term));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Removed "$term" from Mistake Notebook.'),
          duration: const Duration(seconds: 1),
        ),
      );
    } else {
      setState(() => _savedToNotebook.add(term));
      await db.into(db.wildItems).insert(
            WildItemsCompanion.insert(
              sentence: item.example.isNotEmpty ? item.example : item.term,
              source: drift.Value('Mistake: ${item.term} — ${item.definition}'),
              savedAt: DateTime.now().millisecondsSinceEpoch,
            ),
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('⭐ Saved "$term" to Mistake Notebook!'),
            backgroundColor: AppColors.correct,
            duration: const Duration(seconds: 1),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final audio = ref.watch(audioServiceProvider);
    final theme = Theme.of(context);

    final defeatedCount = widget.items.where((i) => !i.wasMistake).length;
    final mistakeCount = widget.items.where((i) => i.wasMistake).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('What You Learned'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.go('/'),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Score Banner
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: theme.colorScheme.outline),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StatColumn(label: 'Score', value: '${widget.score}'),
                  _StatColumn(label: 'XP', value: '+${widget.xpEarned}'),
                  _StatColumn(
                    label: 'Accuracy',
                    value: '${(widget.accuracy * 100).round()}%',
                  ),
                ],
              ),
            ),

            // Defeated vs Breached/Mistakes Breakdown Badges
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: theme.colorScheme.outline),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_rounded,
                              size: 16, color: theme.colorScheme.primary),
                          const SizedBox(width: 6),
                          Text(
                            'Mastered: $defeatedCount',
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: theme.colorScheme.outline),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.refresh_rounded,
                              size: 16, color: theme.colorScheme.onSurfaceVariant),
                          const SizedBox(width: 6),
                          Text(
                            'To Review: $mistakeCount',
                            style: TextStyle(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  Text(
                    'Vocabulary & Phrases (${widget.items.length})',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Learned Items List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: widget.items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = widget.items[index];
                  final isSaved = _savedToNotebook.contains(item.term) || item.wasMistake;

                  return Card(
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: item.wasMistake
                            ? AppColors.wrong.withAlpha(100)
                            : AppColors.correct.withAlpha(80),
                        width: 1.5,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Text(
                                      item.term,
                                      style: theme.textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: theme.colorScheme.onSurface,
                                      ),
                                    ),
                                    if (item.ipa != null && item.ipa!.isNotEmpty) ...[
                                      const SizedBox(width: 8),
                                      Text(
                                        item.ipa!,
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          color: theme.colorScheme.onSurfaceVariant,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              // Audio button
                              IconButton(
                                icon: const Icon(Icons.volume_up_rounded, color: AppColors.accent),
                                tooltip: 'Listen',
                                onPressed: () {
                                  audio.speakOrPlay(item.term);
                                },
                              ),
                              // ⭐ Save to Mistake Notebook toggle
                              IconButton(
                                icon: Icon(
                                  isSaved ? Icons.star_rounded : Icons.star_border_rounded,
                                  color: isSaved ? AppColors.combo : Colors.grey,
                                ),
                                tooltip: 'Save to Mistake Notebook',
                                onPressed: () => _toggleSaveToNotebook(item),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item.definition,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          if (item.example.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surfaceContainerHighest.withAlpha(100),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.format_quote_rounded, size: 18, color: AppColors.accent),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      item.example,
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        fontStyle: FontStyle.italic,
                                        color: theme.colorScheme.onSurface,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.volume_up_outlined, size: 18),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: () => audio.speakOrPlay(item.example),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.home_rounded),
                      label: const Text('Home'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () => context.go('/'),
                    ),
                  ),
                  if (widget.onPlayAgain != null) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.replay_rounded),
                        label: const Text('Play Again'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: widget.onPlayAgain,
                      ),
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

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;

  const _StatColumn({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label.toUpperCase(),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
