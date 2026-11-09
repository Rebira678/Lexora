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
import '../../reading/reading_screen.dart';
import '../../mistakes/presentation/mistakes_screen.dart';
import '../../stats/presentation/stats_screen.dart';
import '../../settings/presentation/settings_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _implementationIntention = '"When I finish breakfast, I will play 10 minutes."';

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
        title: const Row(
          children: [
            Text('🔥 Daily Streak & Freezes'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Run: $streak days in a row',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text('Streak Freezes Available: $freezes / 3 ❄️'),
            const SizedBox(height: 12),
            const Text(
              '• Complete any 5-minute game daily to extend your streak.\n'
              '• If you miss a day, a freeze token protects your streak automatically.\n'
              '• You earn 1 new freeze token every 7 consecutive days played.\n'
              '• Progress is never lost — your total days and best streak are saved permanently!',
              style: TextStyle(height: 1.4, fontSize: 13),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Awesome'),
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
        title: const Text('⏰ Daily Study Reminder'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Choose what time you want your daily offline reminder. No guilt, just a gentle nudge!',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.alarm, color: AppColors.accent),
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
                        content: Text('Reminder set for ${picked.format(context)} daily!'),
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
        title: const Text('🎯 Set Your Habit Cue'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Implementation intentions anchor your study session to an existing daily habit:',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: 'e.g. When I finish breakfast, I will play 10 minutes.',
                border: OutlineInputBorder(),
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
                final formatted = '"$text"';
                setState(() {
                  _implementationIntention = formatted;
                });
                _saveHabitIntention(formatted);
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

    if (nextStep.gameRoute == '/games/word-siege') {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const WordSiegeScreen(level: 3)));
    } else if (nextStep.gameRoute == '/games/unscrambler') {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SentenceUnscramblerScreen(level: 1)));
    } else if (nextStep.gameRoute == '/games/sprint') {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const VocabSprintScreen()));
    } else if (nextStep.gameRoute == '/games/anagram') {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AnagramWheelScreen()));
    } else {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const WordSiegeScreen(level: 3)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final streakAsync = ref.watch(streakStreamProvider);
    final dueCountAsync = ref.watch(dueCardCountProvider);
    final masteredCountAsync = ref.watch(masteredCountProvider);
    final planAsync = ref.watch(todayPlanProvider);
    final todayStatsAsync = ref.watch(todayStatsProvider);
    final theme = Theme.of(context);

    final streak = streakAsync.value?.current ?? 0;
    final freezes = streakAsync.value?.freezes ?? 0;
    final dueCards = dueCountAsync.value ?? 0;
    final masteredWords = masteredCountAsync.value ?? 0;
    final totalXp = todayStatsAsync.value?.xp ?? 0;

    final xpService = ref.watch(xpServiceProvider);
    final level = xpService.levelFromXp(totalXp);
    final rank = xpService.rankForLevel(level);
    final currentLevelXp = xpService.xpForLevel(level);
    final nextLevelXp = xpService.xpForLevel(level + 1);
    final xpRange = (nextLevelXp - currentLevelXp).clamp(1, 99999);
    final xpProgress = ((totalXp - currentLevelXp) / xpRange).clamp(0.0, 1.0);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Bar: Streak, Reminder, Mastered
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Streak Pill (Tap opens freeze info)
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => _showStreakInfoDialog(context, streak, freezes),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.streak.withAlpha(30),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.streak.withAlpha(120)),
                      ),
                      child: Row(
                        children: [
                          const Text('🔥', style: TextStyle(fontSize: 20)),
                          const SizedBox(width: 6),
                          Text(
                            '$streak Days',
                            style: const TextStyle(
                              color: AppColors.streak,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          if (freezes > 0) ...[
                            const SizedBox(width: 8),
                            Text('❄️$freezes', style: const TextStyle(fontSize: 14)),
                          ],
                        ],
                      ),
                    ),
                  ),

                  Row(
                    children: [
                      // Reminder Button
                      IconButton(
                        icon: const Icon(Icons.notifications_active_outlined, color: AppColors.accent),
                        tooltip: 'Daily Reminder',
                        onPressed: () => _showReminderSettingsDialog(context),
                      ),

                      // Mastered Words Pill
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.xp.withAlpha(30),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.xp.withAlpha(120)),
                        ),
                        child: Row(
                          children: [
                            const Text('⭐', style: TextStyle(fontSize: 16)),
                            const SizedBox(width: 6),
                            Text(
                              '$masteredWords Mastered',
                              style: const TextStyle(
                                color: AppColors.xp,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // XP & Rank Level Progress Bar
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.colorScheme.outlineVariant.withAlpha(80)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.xp,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Lv $level',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              rank,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ],
                        ),
                        Text(
                          '$totalXp / $nextLevelXp XP',
                          style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: xpProgress,
                        minHeight: 8,
                        backgroundColor: theme.colorScheme.surfaceContainerHighest,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.xp),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Implementation Intention Banner (Tap to customize)
              InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: _editImplementationIntention,
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest.withAlpha(80),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.alarm_on_rounded, color: AppColors.accent, size: 22),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _implementationIntention,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(Icons.edit_outlined, size: 16, color: theme.colorScheme.onSurfaceVariant.withAlpha(150)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Big Action Button: Today's Mission / Start Next Step
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00BFA5), Color(0xFF00897B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withAlpha(80),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: () => _launchNextMissionStep(ref),
                    child: Padding(
                      padding: const EdgeInsets.all(22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withAlpha(40),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  dueCards > 0 ? '$dueCards Reviews Due' : 'All Reviews Done!',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              const Icon(Icons.play_circle_fill_rounded, color: Colors.white, size: 40),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            "▶ TODAY'S MISSION",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Continue daily spaced mastery • Tap to launch',
                            style: TextStyle(
                              color: Colors.white.withAlpha(220),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Today's Structured Mission Plan (●●●○○)
              planAsync.when(
                data: (plan) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: theme.colorScheme.outlineVariant.withAlpha(80)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Today's Plan",
                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${plan.completedStepsCount}/${plan.steps.length} Completed',
                              style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: plan.steps.map((step) {
                            return Expanded(
                              child: Container(
                                height: 8,
                                margin: const EdgeInsets.symmetric(horizontal: 2),
                                decoration: BoxDecoration(
                                  color: step.isCompleted ? AppColors.accent : theme.colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 14),
                        ...plan.steps.map((step) {
                          return ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(
                              step.isCompleted ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
                              color: step.isCompleted ? AppColors.accent : Colors.grey,
                              size: 22,
                            ),
                            title: Text(step.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                            subtitle: Text(step.subtitle, style: const TextStyle(fontSize: 12)),
                            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                            onTap: () {
                              if (step.gameRoute == '/games/word-siege') {
                                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const WordSiegeScreen(level: 3)));
                              } else if (step.gameRoute == '/games/unscrambler') {
                                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SentenceUnscramblerScreen(level: 1)));
                              } else if (step.gameRoute == '/games/sprint') {
                                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const VocabSprintScreen()));
                              } else if (step.gameRoute == '/games/anagram') {
                                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AnagramWheelScreen()));
                              }
                            },
                          );
                        }),
                      ],
                    ),
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),

              const SizedBox(height: 28),

              // Game Arena Section Header
              Text(
                'Game Arena',
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 14),

              // 2-Column Game Grid
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 1.25,
                children: [
                  _GameGridCard(
                    title: 'Word Siege',
                    icon: '⚔️',
                    subtitle: 'Tower defense vocab',
                    color: Colors.orange.shade700,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const WordSiegeScreen(level: 3)),
                    ),
                  ),
                  _GameGridCard(
                    title: 'Vocab Sprint',
                    icon: '⚡',
                    subtitle: 'Speed recall drills',
                    color: Colors.amber.shade700,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const VocabSprintScreen()),
                    ),
                  ),
                  _GameGridCard(
                    title: 'Unscrambler',
                    icon: '🧱',
                    subtitle: 'Drag & order syntax',
                    color: Colors.green.shade700,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SentenceUnscramblerScreen(level: 1)),
                    ),
                  ),
                  _GameGridCard(
                    title: 'Anagram Wheel',
                    icon: '🎡',
                    subtitle: 'Swipe letter combos',
                    color: Colors.indigo.shade700,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const AnagramWheelScreen()),
                    ),
                  ),
                  _GameGridCard(
                    title: 'Paragraph Arch.',
                    icon: '📑',
                    subtitle: 'Cohesion & linking',
                    color: Colors.blue.shade700,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ParagraphArchitectScreen(level: 2)),
                    ),
                  ),
                  _GameGridCard(
                    title: 'Chunk Echo',
                    icon: '🔊',
                    subtitle: 'Sentence memory',
                    color: Colors.teal.shade700,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ChunkEchoScreen(level: 2)),
                    ),
                  ),
                  _GameGridCard(
                    title: 'Sentence X-Ray',
                    icon: '🔬',
                    subtitle: 'Find core subject & verb',
                    color: Colors.purple.shade700,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SentenceXRayScreen(level: 2)),
                    ),
                  ),
                  _GameGridCard(
                    title: 'Graded Reader',
                    icon: '📖',
                    subtitle: 'Tap-to-define texts',
                    color: Colors.deepOrange.shade700,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ReadingScreen()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
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
          NavigationDestination(icon: Icon(Icons.sports_esports_rounded), label: 'Arena'),
          NavigationDestination(icon: Icon(Icons.bookmark_rounded), label: 'My Words'),
          NavigationDestination(icon: Icon(Icons.bar_chart_rounded), label: 'Stats'),
          NavigationDestination(icon: Icon(Icons.settings_rounded), label: 'Settings'),
        ],
      ),
    );
  }
}

class _GameGridCard extends StatelessWidget {
  final String title;
  final String icon;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _GameGridCard({
    required this.title,
    required this.icon,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(icon, style: const TextStyle(fontSize: 28)),
                  Icon(Icons.arrow_forward_rounded, size: 18, color: Theme.of(context).colorScheme.outline),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
