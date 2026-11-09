import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/db/database.dart';
import '../core/db/daos/word_dao.dart';
import '../core/db/daos/srs_dao.dart';
import '../core/db/daos/game_dao.dart';
import '../core/db/daos/stats_dao.dart';
import '../core/db/importer.dart';
import '../core/streak/streak_logic.dart';
import '../core/xp/xp_service.dart';
import '../core/audio/audio_service.dart';
import '../core/audio/tts_service.dart';
import '../core/notifications/notification_service.dart';
import '../core/planner/daily_planner.dart';

// Database Singleton Provider
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

// DAOs
final wordDaoProvider = Provider<WordDao>((ref) {
  return WordDao(ref.watch(databaseProvider));
});

final srsDaoProvider = Provider<SrsDao>((ref) {
  return SrsDao(ref.watch(databaseProvider));
});

final gameDaoProvider = Provider<GameDao>((ref) {
  return GameDao(ref.watch(databaseProvider));
});

final statsDaoProvider = Provider<StatsDao>((ref) {
  return StatsDao(ref.watch(databaseProvider));
});

// Importer
final contentImporterProvider = Provider<ContentImporter>((ref) {
  return ContentImporter(ref.watch(databaseProvider));
});

// Services
final streakServiceProvider = Provider<StreakService>((ref) {
  return StreakService();
});

final xpServiceProvider = Provider<XpService>((ref) {
  return XpService();
});

final audioServiceProvider = Provider<AudioService>((ref) {
  return AudioService();
});

final ttsServiceProvider = Provider<TtsService>((ref) {
  return TtsService();
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

// Daily Planner Provider
final dailyPlanBuilderProvider = Provider<DailyPlanBuilder>((ref) {
  return DailyPlanBuilder(
    srsDao: ref.watch(srsDaoProvider),
    statsDao: ref.watch(statsDaoProvider),
  );
});

final todayPlanProvider = FutureProvider<DailyPlan>((ref) async {
  final builder = ref.watch(dailyPlanBuilderProvider);
  return builder.buildPlanForToday();
});

// Current Streak State Stream Provider
final streakStreamProvider = StreamProvider<Streak?>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.streaks)..where((s) => s.id.equals(1))).watchSingleOrNull();
});

// Due SRS Cards Count Provider
final dueCardCountProvider = FutureProvider<int>((ref) async {
  final srsDao = ref.watch(srsDaoProvider);
  return srsDao.getDueCount();
});

// Mastered Words Count Provider
final masteredCountProvider = FutureProvider<int>((ref) async {
  final srsDao = ref.watch(srsDaoProvider);
  return srsDao.getMasteredCount();
});

// Total XP and Daily Stats Provider
final todayStatsProvider = FutureProvider<DailyStat?>((ref) async {
  final statsDao = ref.watch(statsDaoProvider);
  final today = DateTime.now();
  final todayKey =
      '${today.year.toString().padLeft(4, '0')}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
  return statsDao.getStatForDay(todayKey);
});
