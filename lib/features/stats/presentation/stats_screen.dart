import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../app/theme.dart';
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
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero Level & Rank Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF26A69A), Color(0xFF00796B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(color: AppColors.accent.withAlpha(60), blurRadius: 12, offset: const Offset(0, 4)),
                  ],
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
                              style: TextStyle(color: Colors.white.withAlpha(200), fontSize: 13),
                            ),
                            Text(
                              rank,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(40),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            'Level $level',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _HeroStat(label: 'Total XP', value: '$totalXp', icon: Icons.bolt_rounded),
                        _HeroStat(label: 'Mastered', value: '$masteredWords', icon: Icons.star_rounded),
                        _HeroStat(label: 'Days Active', value: '$totalDays', icon: Icons.calendar_today_rounded),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Streak & Habits Summary
              Text('Streak & Consistency', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _MetricCard(
                      icon: '🔥',
                      title: 'Current Streak',
                      value: '$streak Days',
                      subtitle: 'Keep it going!',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _MetricCard(
                      icon: '🏆',
                      title: 'Best Streak',
                      value: '$bestStreak Days',
                      subtitle: 'All-time personal record',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _MetricCard(
                      icon: '❄️',
                      title: 'Streak Freezes',
                      value: '$freezes / 3',
                      subtitle: 'Emergency shields',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Recent Game Sessions History
              Text('Recent Game Sessions', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),

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
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Center(
                          child: Text(
                            'No sessions completed yet. Play your first round!',
                            style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                          ),
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

                      return Card(
                        margin: EdgeInsets.zero,
                        child: ListTile(
                          dense: true,
                          leading: CircleAvatar(
                            backgroundColor: AppColors.accent.withAlpha(30),
                            child: const Icon(Icons.videogame_asset_rounded, color: AppColors.accent, size: 20),
                          ),
                          title: Text(
                            s.game.replaceAll('_', ' ').toUpperCase(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${(s.durationMs / 1000).round()}s • Accuracy: ${(s.accuracy * 100).round()}%',
                            style: const TextStyle(fontSize: 12),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '+${s.score} pts',
                                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.correct),
                              ),
                              Text(timeStr, style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant)),
                            ],
                          ),
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
  final IconData icon;

  const _HeroStat({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: Colors.white.withAlpha(180), fontSize: 11)),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String icon;
  final String title;
  final String value;
  final String subtitle;

  const _MetricCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(icon, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 6),
            Text(title, style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant)),
            const SizedBox(height: 2),
            Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
