import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../app/providers.dart';
import '../../../core/db/database.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streakAsync = ref.watch(streakStreamProvider);
    final todayStatsAsync = ref.watch(todayStatsProvider);
    final masteredCountAsync = ref.watch(masteredCountProvider);
    final db = ref.watch(databaseProvider);
    final theme = Theme.of(context);

    final streak = streakAsync.value?.current ?? 0;
    final bestStreak = streakAsync.value?.best ?? 0;
    final freezes = streakAsync.value?.freezes ?? 0;
    final totalDays = streakAsync.value?.totalDays ?? 0;
    final totalXp = todayStatsAsync.value?.xp ?? 0;
    final masteredWords = masteredCountAsync.value ?? 0;

    final xpService = ref.watch(xpServiceProvider);
    final level = xpService.levelFromXp(totalXp);
    final rank = xpService.rankForLevel(level);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning Analytics & Stats'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero Level & Rank Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: theme.colorScheme.outline),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Rank Tier',
                              style: theme.textTheme.labelSmall,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              rank,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withAlpha(20),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Level $level',
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Divider(color: theme.colorScheme.outline, height: 1),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _HeroStat(label: 'Total XP', value: '$totalXp'),
                        _HeroStat(label: 'Mastered', value: '$masteredWords'),
                        _HeroStat(label: 'Active Days', value: '$totalDays'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Streak & Habits Summary
              Text(
                'Consistency Metrics',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _MetricCard(
                      title: 'CURRENT',
                      value: '$streak Days',
                      subtitle: 'Active run',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _MetricCard(
                      title: 'BEST RECORD',
                      value: '$bestStreak Days',
                      subtitle: 'All-time best',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _MetricCard(
                      title: 'FREEZES',
                      value: '$freezes / 3',
                      subtitle: 'Tokens ready',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // CEFR Four-Skill Competence Profile
              Text(
                'CEFR Skill Mastery Profile',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 10),

              FutureBuilder<List<SkillLevel>>(
                future: (db.select(db.skillLevels)
                      ..orderBy([(t) => drift.OrderingTerm.desc(t.measuredAt)]))
                    .get(),
                builder: (context, snapshot) {
                  final skills = snapshot.data ?? [];
                  double readingScore = 0.75;
                  double writingScore = 0.70;
                  double listeningScore = 0.65;
                  double vocabScore = 0.80;

                  for (final s in skills) {
                    if (s.skill == 'reading') readingScore = s.score;
                    if (s.skill == 'writing') writingScore = s.score;
                    if (s.skill == 'listening') listeningScore = s.score;
                    if (s.skill == 'vocab') vocabScore = s.score;
                  }

                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: theme.colorScheme.outline),
                    ),
                    child: Column(
                      children: [
                        _SkillBar(skill: 'Reading & Inference', score: readingScore, cefr: readingScore >= 0.8 ? 'C1' : 'B2'),
                        const SizedBox(height: 10),
                        _SkillBar(skill: 'Writing & Syntax', score: writingScore, cefr: writingScore >= 0.8 ? 'C1' : 'B2'),
                        const SizedBox(height: 10),
                        _SkillBar(skill: 'Listening & Acoustic', score: listeningScore, cefr: listeningScore >= 0.8 ? 'C1' : 'B2'),
                        const SizedBox(height: 10),
                        _SkillBar(skill: 'Lexical Range & Collocation', score: vocabScore, cefr: vocabScore >= 0.8 ? 'C1' : 'B2'),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Recent Game Sessions History
              Text(
                'Recent Sessions',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 10),

              FutureBuilder<List<GameSession>>(
                future: (db.select(db.gameSessions)
                      ..orderBy([(t) => drift.OrderingTerm.desc(t.startedAt)])
                      ..limit(10))
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final sessions = snapshot.data ?? [];
                  if (sessions.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: theme.colorScheme.outline),
                      ),
                      child: Center(
                        child: Text(
                          'No practice sessions recorded yet.',
                          style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: sessions.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final s = sessions[index];
                      final date = DateTime.fromMillisecondsSinceEpoch(s.startedAt);
                      final timeStr = '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';

                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: theme.colorScheme.outline),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  s.game.replaceAll('_', ' ').toUpperCase(),
                                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${(s.durationMs / 1000).round()}s • Accuracy ${(s.accuracy * 100).round()}%',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '+${s.score} pts',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                Text(
                                  timeStr,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  final String label;
  final String value;

  const _HeroStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, letterSpacing: -0.3),
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

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _SkillBar extends StatelessWidget {
  final String skill;
  final double score;
  final String cefr;

  const _SkillBar({
    required this.skill,
    required this.score,
    required this.cefr,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(skill, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withAlpha(25),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(cefr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: theme.colorScheme.primary)),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: score.clamp(0.0, 1.0),
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}
