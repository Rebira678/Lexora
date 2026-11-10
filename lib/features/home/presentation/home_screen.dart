import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../app/theme.dart';
import '../../../app/providers.dart';
import '../../games/word_siege/word_siege_screen.dart';
import '../../games/vocab_sprint/vocab_sprint_screen.dart';
import '../../games/anagram_wheel/anagram_wheel_screen.dart';
import '../../games/sentence_unscrambler/sentence_unscrambler_screen.dart';
import '../../games/paragraph_architect/paragraph_architect_screen.dart';
import '../../games/chunk_echo/chunk_echo_screen.dart';
import '../../games/sentence_xray/sentence_xray_screen.dart';
import '../../games/slice_it/slice_it_screen.dart';
import '../../reading/reading_screen.dart';
import '../../mistakes/presentation/mistakes_screen.dart';
import '../../stats/presentation/stats_screen.dart';
import '../../settings/presentation/settings_screen.dart';
import 'widgets/game_art_painters.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _implementationIntention = 'When I finish breakfast, I will practice for 10 minutes.';

  @override
  void initState() {
    super.initState();
    _loadHabitIntention();
  }

  Future<void> _loadHabitIntention() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString('habit_intention');
      if (saved != null && saved.isNotEmpty && mounted) {
        setState(() {
          _implementationIntention = saved;
        });
      }
    } catch (_) {}
  }

  Future<void> _saveHabitIntention(String text) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('habit_intention', text);
    } catch (_) {}
  }

  void _showStreakInfoDialog(BuildContext context, int streak, int freezes) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Streak Protection'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$streak Consecutive Days',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Freeze Tokens Available: $freezes / 3',
              style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            const Text(
              '• Play one 5-minute session daily to maintain your streak.\n'
              '• Missing a day automatically consumes one freeze token to preserve progress.\n'
              '• Earn 1 new freeze token every 7 consecutive days played.\n'
              '• Your all-time total days and best run are permanently saved.',
              style: TextStyle(height: 1.5, fontSize: 13),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  void _showReminderSettingsDialog(BuildContext context) {
    TimeOfDay selectedTime = const TimeOfDay(hour: 8, minute: 30);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Daily Study Reminder'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select a daily offline notification time for your study session.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Theme.of(context).colorScheme.outline),
              ),
              leading: Icon(Icons.schedule_rounded, color: Theme.of(context).colorScheme.primary),
              title: const Text('Reminder Time'),
              subtitle: Text(selectedTime.format(context)),
              onTap: () async {
                final picked = await showTimePicker(
                  context: ctx,
                  initialTime: selectedTime,
                );
                if (picked != null) {
                  selectedTime = picked;
                  await ref.read(notificationServiceProvider).scheduleDailyReminder(
                        hour: picked.hour,
                        minute: picked.minute,
                      );
                  if (ctx.mounted) {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Daily reminder scheduled for ${picked.format(context)}.'),
                        backgroundColor: AppColors.correct,
                      ),
                    );
                  }
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _editImplementationIntention() {
    final controller = TextEditingController(text: _implementationIntention.replaceAll('"', ''));
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Daily Habit Anchor'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Anchor your English practice to an existing daily routine (implementation intention):',
              style: TextStyle(fontSize: 13, height: 1.4),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: 'e.g. When I pour my morning coffee, I will play 10 minutes.',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                setState(() {
                  _implementationIntention = text;
                });
                _saveHabitIntention(text);
              }
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _launchNextMissionStep(WidgetRef ref) {
    final planAsync = ref.read(todayPlanProvider);
    final plan = planAsync.value;
    if (plan == null || plan.steps.isEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const WordSiegeScreen(level: 3)),
      );
      return;
    }

    final nextStep = plan.steps.firstWhere(
      (s) => !s.isCompleted,
      orElse: () => plan.steps.first,
    );

    switch (nextStep.gameRoute) {
      case '/games/word-siege':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const WordSiegeScreen(level: 3)),
        );
        break;
      case '/games/unscrambler':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const SentenceUnscramblerScreen(level: 1)),
        );
        break;
      case '/games/sprint':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const VocabSprintScreen()),
        );
        break;
      case '/games/anagram':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AnagramWheelScreen()),
        );
        break;
      case '/games/paragraph-architect':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ParagraphArchitectScreen(level: 2)),
        );
        break;
      case '/games/chunk-echo':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ChunkEchoScreen(level: 2)),
        );
        break;
      case '/games/sentence-xray':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const SentenceXRayScreen(level: 2)),
        );
        break;
      default:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const WordSiegeScreen(level: 3)),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final streakStateAsync = ref.watch(streakStreamProvider);
    final todayStatsAsync = ref.watch(todayStatsProvider);
    final dueCardsAsync = ref.watch(dueCardCountProvider);
    final masteredWordsAsync = ref.watch(masteredCountProvider);

    final streak = streakStateAsync.value?.current ?? 0;
    final freezes = streakStateAsync.value?.freezes ?? 0;
    final totalXp = todayStatsAsync.value?.xp ?? 0;
    final dueCards = dueCardsAsync.value ?? 0;
    final masteredWords = masteredWordsAsync.value ?? 0;

    final xpService = ref.read(xpServiceProvider);
    final level = xpService.levelFromXp(totalXp);
    final rank = xpService.rankForLevel(level);
    final currentLevelXp = xpService.xpForLevel(level);
    final nextLevelXp = xpService.xpForLevel(level + 1);
    final xpRange = (nextLevelXp - currentLevelXp).clamp(1, 99999);
    final xpProgress = ((totalXp - currentLevelXp) / xpRange).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: Row(
          children: [
            Text(
              'LEXORA',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                letterSpacing: 2.0,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withAlpha(25),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'B2',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.schedule_rounded, size: 20),
            tooltip: 'Daily Reminder',
            onPressed: () => _showReminderSettingsDialog(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Top Metrics Card: Streak & Mastery
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: theme.colorScheme.outline),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () => _showStreakInfoDialog(context, streak, freezes),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$streak',
                                    style: theme.textTheme.displayMedium?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      height: 1.0,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        'DAY STREAK',
                                        style: theme.textTheme.labelSmall,
                                      ),
                                      if (freezes > 0) ...[
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                          decoration: BoxDecoration(
                                            color: theme.colorScheme.primary.withAlpha(20),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            '$freezes Freezes',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: theme.colorScheme.primary,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '$masteredWords',
                                  style: theme.textTheme.displayMedium?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    height: 1.0,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'WORDS MASTERED',
                                  style: theme.textTheme.labelSmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Level progress
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Level $level • $rank',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              '$totalXp / $nextLevelXp XP',
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: xpProgress,
                            minHeight: 5,
                            backgroundColor: theme.colorScheme.surfaceContainerHighest,
                            valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Implementation Intention Anchor (Minimalist Quote Card)
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: _editImplementationIntention,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: theme.colorScheme.outline),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 3,
                            height: 28,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _implementationIntention,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Edit',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Primary Mission Card
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: theme.colorScheme.primary.withAlpha(120),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "TODAY'S MISSION",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            Text(
                              dueCards > 0 ? '$dueCards Reviews Due' : 'Reviews Completed',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Spaced Review & Sentence Expansion',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Complete 5 structured steps to reinforce long-term memory.',
                          style: theme.textTheme.bodySmall,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => _launchNextMissionStep(ref),
                          child: const Text('Start Session'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Game Arena Section Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Game Arena',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                        ),
                      ),
                      Text(
                        'Phase 1 Core',
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 2-Column Game Grid with Custom Vector Illustrations
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.82,
                    children: [
                      _IllustratedGameCard(
                        type: GameArtType.wordSiege,
                        category: 'ACTION',
                        title: 'Word Siege',
                        description: '3-lane gate defense with typing and tap mode',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const WordSiegeScreen(level: 3)),
                        ),
                      ),
                      _IllustratedGameCard(
                        type: GameArtType.vocabSprint,
                        category: 'SPEED',
                        title: 'Vocab Sprint',
                        description: 'Rapid-fire SRS review across 5 game modes',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const VocabSprintScreen()),
                        ),
                      ),
                      _IllustratedGameCard(
                        type: GameArtType.unscrambler,
                        category: 'SYNTAX',
                        title: 'Unscrambler',
                        description: 'Reconstruct clauses with audio pronunciation',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const SentenceUnscramblerScreen(level: 1)),
                        ),
                      ),
                      _IllustratedGameCard(
                        type: GameArtType.anagramWheel,
                        category: 'SPELLING',
                        title: 'Anagram Wheel',
                        description: 'Swipe letter trail to unlock words and roots',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const AnagramWheelScreen()),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Additional Modules Header
                  Text(
                    'Sentence & Text Modules',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 12),

                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.82,
                    children: [
                      _IllustratedGameCard(
                        type: GameArtType.paragraphArchitect,
                        category: 'COHESION',
                        title: 'Paragraph Arch.',
                        description: 'Cohesion map & sentence connectors',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const ParagraphArchitectScreen(level: 2)),
                        ),
                      ),
                      _IllustratedGameCard(
                        type: GameArtType.chunkEcho,
                        category: 'LISTENING',
                        title: 'Chunk Echo',
                        description: 'Acoustic waveform & chunk assembly',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const ChunkEchoScreen(level: 2)),
                        ),
                      ),
                      _IllustratedGameCard(
                        type: GameArtType.sentenceXray,
                        category: 'GRAMMAR',
                        title: 'Sentence X-Ray',
                        description: 'Isolate main subject, verb, and clause',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const SentenceXRayScreen(level: 2)),
                        ),
                      ),
                      _IllustratedGameCard(
                        type: GameArtType.sliceIt,
                        category: 'CHUNKING',
                        title: 'Slice It',
                        description: 'Interactive phrase cuts & boundary recognition',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const SliceItScreen(level: 2)),
                        ),
                      ),
                      _IllustratedGameCard(
                        type: GameArtType.gradedReader,
                        category: 'READING',
                        title: 'Graded Reader',
                        description: 'Tap-to-define passages with wild word save',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const ReadingScreen()),
                        ),
                      ),
                      _IllustratedGameCard(
                        type: GameArtType.vocabSprint,
                        category: 'RECOVERY',
                        title: 'Mistake Gym',
                        description: 'Targeted drill on missed sentences & wild items',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const MistakesScreen()),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        height: 64,
        onDestinationSelected: (index) {
          if (index == 1) {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MistakesScreen()));
          } else if (index == 2) {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const StatsScreen()));
          } else if (index == 3) {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsScreen()));
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.grid_view_rounded, size: 22),
            label: 'Arena',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_outline_rounded, size: 22),
            selectedIcon: Icon(Icons.bookmark_rounded, size: 22),
            label: 'My Words',
          ),
          NavigationDestination(
            icon: Icon(Icons.insights_rounded, size: 22),
            label: 'Stats',
          ),
          NavigationDestination(
            icon: Icon(Icons.tune_rounded, size: 22),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class _IllustratedGameCard extends StatelessWidget {
  final GameArtType type;
  final String category;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _IllustratedGameCard({
    required this.type,
    required this.category,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Rich vector art illustration header
              GameArtWidget(
                type: type,
                primaryColor: theme.colorScheme.primary,
                height: 95,
              ),

              // Content Area
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withAlpha(20),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              category,
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 13,
                            color: theme.colorScheme.onSurfaceVariant.withAlpha(160),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            description,
                            style: TextStyle(
                              fontSize: 11,
                              color: theme.colorScheme.onSurfaceVariant,
                              height: 1.25,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
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
