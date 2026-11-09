import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [
  Words,
  Examples,
  WordFamilies,
  Collocations,
  SrsCards,
  ReviewLogs,
  SentenceStructures,
  Paragraphs,
  ChunkSentences,
  Passages,
  Questions,
  UserTexts,
  Recordings,
  DailyStats,
  Streaks,
  Achievements,
  GameSessions,
  PersonalBests,
  WildItems,
  SkillLevels,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.connection);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          // Initialize streak singleton row
          await into(streaks).insert(
            StreaksCompanion.insert(
              id: const Value(1),
              current: const Value(0),
              best: const Value(0),
              freezes: const Value(0),
              lastDay: const Value(''),
              totalDays: const Value(0),
            ),
          );
        },
        beforeOpen: (details) async {
          // Enable WAL mode and foreign keys for performance and integrity
          await customStatement('PRAGMA foreign_keys = ON');
          await customStatement('PRAGMA journal_mode = WAL');
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'english_arena.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
