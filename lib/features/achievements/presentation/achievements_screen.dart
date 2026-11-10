import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../app/theme.dart';
import '../../../app/providers.dart';

class AchievementMeta {
  final String code;
  final String title;
  final String description;
  final IconData icon;

  const AchievementMeta({
    required this.code,
    required this.title,
    required this.description,
    required this.icon,
  });
}

const List<AchievementMeta> kAllAchievements = [
  AchievementMeta(
    code: 'first_step',
    title: 'First Flight',
    description: 'Complete your first practice session in English Arena.',
    icon: Icons.flight_takeoff_rounded,
  ),
  AchievementMeta(
    code: 'word_forger',
    title: 'Syntactic Blacksmith',
    description: 'Synthesize a multi-clause sentence in Word Forge.',
    icon: Icons.draw_rounded,
  ),
  AchievementMeta(
    code: 'daily_scribe',
    title: 'Philosopher Scribe',
    description: 'Record your first 3-sentence daily reflection journal.',
    icon: Icons.history_edu_rounded,
  ),
  AchievementMeta(
    code: 'orator_sixty',
    title: 'The Unbroken Voice',
    description: 'Speak for 60 seconds without pausing in 60-Second Talker.',
    icon: Icons.record_voice_over_rounded,
  ),
  AchievementMeta(
    code: 'shadow_boxer',
    title: 'Acoustic Shadow',
    description: 'Complete a full speech shadowing session.',
    icon: Icons.sports_mma_rounded,
  ),
  AchievementMeta(
    code: 'boss_slayer',
    title: 'Titan Slayer',
    description: 'Defeat the weekly multi-skill Boss Leviathan.',
    icon: Icons.military_tech_rounded,
  ),
  AchievementMeta(
    code: 'mock_veteran',
    title: 'Benchmark Veteran',
    description: 'Complete a standardized 4-skill CEFR mock exam.',
    icon: Icons.assessment_rounded,
  ),
  AchievementMeta(
    code: 'collocation_master',
    title: 'Lexical Linker',
    description: 'Achieve 80%+ accuracy in Collocation Match.',
    icon: Icons.link_rounded,
  ),
  AchievementMeta(
    code: 'streak_7',
    title: 'Disciplined Habit',
    description: 'Maintain an uninterrupted 7-day practice streak.',
    icon: Icons.local_fire_department_rounded,
  ),
  AchievementMeta(
    code: 'streak_30',
    title: 'Indomitable Will',
    description: 'Forge an unbroken 30-day streak of mastery.',
    icon: Icons.workspace_premium_rounded,
  ),
  AchievementMeta(
    code: 'sniper_elite',
    title: 'Phonemic Sharpshooter',
    description: 'Hit a 5x streak in minimal-pair Sound Sniper.',
    icon: Icons.gps_fixed_rounded,
  ),
  AchievementMeta(
    code: 'mistake_slayer',
    title: 'Error Extinguisher',
    description: 'Rehabilitate 10 mistakes in the Mistake Gym.',
    icon: Icons.fitness_center_rounded,
  ),
];

class AchievementsScreen extends ConsumerStatefulWidget {
  const AchievementsScreen({super.key});

  @override
  ConsumerState<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends ConsumerState<AchievementsScreen> {
  Map<String, int> _unlockedMap = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAchievements();
  }

  Future<void> _loadAchievements() async {
    final list = await ref.read(statsDaoProvider).getUnlockedAchievements();
    if (!mounted) return;
    setState(() {
      _unlockedMap = {for (var a in list) a.code: a.unlockedAt};
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final unlockedCount = _unlockedMap.length;
    final totalCount = kAllAchievements.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements & Badges'),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  // Progress Banner
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    padding: const EdgeInsets.all(18),
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
                              'Mastery Milestone Progress',
                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '$unlockedCount / $totalCount Unlocked',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: totalCount > 0 ? unlockedCount / totalCount : 0.0,
                            backgroundColor: theme.colorScheme.surfaceContainerHighest,
                            valueColor: const AlwaysStoppedAnimation(AppColors.accent),
                            minHeight: 8,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Achievement Grid
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                      itemCount: kAllAchievements.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final meta = kAllAchievements[index];
                        final isUnlocked = _unlockedMap.containsKey(meta.code);
                        final unlockedAt = _unlockedMap[meta.code];

                        return Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isUnlocked ? AppColors.accent.withAlpha(80) : theme.colorScheme.outline,
                              width: isUnlocked ? 1.5 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: isUnlocked ? AppColors.accent.withAlpha(25) : theme.colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  meta.icon,
                                  color: isUnlocked ? AppColors.accent : theme.colorScheme.onSurfaceVariant.withAlpha(80),
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          meta.title,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: isUnlocked ? theme.colorScheme.onSurface : theme.colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                        if (isUnlocked && unlockedAt != null)
                                          Text(
                                            DateFormat('MMM d').format(DateTime.fromMillisecondsSinceEpoch(unlockedAt)),
                                            style: const TextStyle(fontSize: 11, color: AppColors.correct, fontWeight: FontWeight.bold),
                                          )
                                        else
                                          const Text(
                                            'LOCKED',
                                            style: TextStyle(fontSize: 10, letterSpacing: 0.5, fontWeight: FontWeight.bold, color: Colors.grey),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      meta.description,
                                      style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
