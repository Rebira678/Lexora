import 'package:drift/drift.dart';
import '../database.dart';
import '../tables.dart';

part 'stats_dao.g.dart';

@DriftAccessor(tables: [DailyStats, Streaks, Achievements, SkillLevels])
class StatsDao extends DatabaseAccessor<AppDatabase> with _$StatsDaoMixin {
  StatsDao(super.db);

  // Streak
  Future<Streak?> getStreak() =>
      (select(streaks)..where((s) => s.id.equals(1))).getSingleOrNull();

  Future<void> updateStreak(StreaksCompanion sc) =>
      (update(streaks)..where((s) => s.id.equals(1))).write(sc);

  // Daily Stats
  Future<DailyStat?> getStatForDay(String dayKey) =>
      (select(dailyStats)..where((s) => s.day.equals(dayKey))).getSingleOrNull();

  Future<void> recordDailyActivity({
    required String dayKey,
    int minutes = 0,
    int xp = 0,
    int itemsReviewed = 0,
    bool goalMet = false,
  }) async {
    final existing = await getStatForDay(dayKey);
    if (existing == null) {
      await into(dailyStats).insert(
        DailyStatsCompanion.insert(
          day: dayKey,
          minutes: Value(minutes),
          xp: Value(xp),
          itemsReviewed: Value(itemsReviewed),
          goalMet: Value(goalMet ? 1 : 0),
        ),
      );
    } else {
      await (update(dailyStats)..where((s) => s.day.equals(dayKey))).write(
        DailyStatsCompanion(
          minutes: Value(existing.minutes + minutes),
          xp: Value(existing.xp + xp),
          itemsReviewed: Value(existing.itemsReviewed + itemsReviewed),
          goalMet: Value(existing.goalMet == 1 || goalMet ? 1 : 0),
        ),
      );
    }
  }

  Future<List<DailyStat>> getStatsHistory({int days = 30}) =>
      (select(dailyStats)
            ..orderBy([(s) => OrderingTerm(expression: s.day, mode: OrderingMode.desc)])
            ..limit(days))
          .get();

  // Achievements
  Future<List<Achievement>> getUnlockedAchievements() => select(achievements).get();

  Future<void> unlockAchievement(String code) =>
      into(achievements).insertOnConflictUpdate(
        AchievementsCompanion.insert(
          code: code,
          unlockedAt: DateTime.now().millisecondsSinceEpoch,
        ),
      );
}
