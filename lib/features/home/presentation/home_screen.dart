import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streakAsync = ref.watch(streakStreamProvider);
    final dueCountAsync = ref.watch(dueCardCountProvider);
    final masteredCountAsync = ref.watch(masteredCountProvider);
    final theme = Theme.of(context);

    final streak = streakAsync.value?.current ?? 0;
    final freezes = streakAsync.value?.freezes ?? 0;
    final dueCards = dueCountAsync.value ?? 0;
    final masteredWords = masteredCountAsync.value ?? 0;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Bar: Streak & Level
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Streak Pill
                  Container(
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
                          Text(
                            '❄️$freezes',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Mastered Words Pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.xp.withAlpha(30),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.xp.withAlpha(120)),
                    ),
                    child: Row(
                      children: [
                        const Text('⭐', style: TextStyle(fontSize: 18)),
                        const SizedBox(width: 6),
                        Text(
                          '$masteredWords Mastered',
                          style: const TextStyle(
                            color: AppColors.xp,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Implementation Intention Banner
              Container(
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
                        '"When I finish breakfast, I will play 10 minutes."',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Big Action Button: Today's Mission / Due SRS
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
                    onTap: () {
                      // Daily Plan Builder: if backlog > 40, route to Word Siege
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const WordSiegeScreen(level: 3),
                        ),
                      );
                    },
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
                            'Clear vocabulary backlog with ⚔️ Word Siege',
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
                  Text(icon, style: const TextStyle(fontSize: 26)),
                  Icon(Icons.chevron_right_rounded, color: Colors.grey.withAlpha(120), size: 20),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
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
