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

// Current Streak State Stream/Future Provider
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
