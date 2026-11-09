import 'dart:ffi';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:sqlite3/open.dart';
import 'package:english_arena/core/db/database.dart';
import 'package:english_arena/core/db/daos/srs_dao.dart';
import 'package:english_arena/core/db/daos/stats_dao.dart';
import 'package:english_arena/core/planner/daily_planner.dart';
import 'package:english_arena/core/planner/new_word_cap.dart';

void main() {
  late AppDatabase db;
  late SrsDao srsDao;
  late StatsDao statsDao;
  late DailyPlanBuilder planBuilder;

  setUpAll(() {
    open.overrideFor(OperatingSystem.linux, () => DynamicLibrary.open('/lib/x86_64-linux-gnu/libsqlite3.so.0'));
  });

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    srsDao = SrsDao(db);
    statsDao = StatsDao(db);
    planBuilder = DailyPlanBuilder(srsDao: srsDao, statsDao: statsDao);
  });

  tearDown(() async {
    await db.close();
  });

  group('Daily Planner & New Word Cap Edge Cases', () {
    test('backlog > 80 due cards: caps new words strictly at 0', () {
      final allowed = newWordsAllowedToday(95, dailyTarget: 10);
      expect(allowed, 0);
    });

    test('backlog 61-80 due cards: caps new words at exactly 3', () {
      final allowed = newWordsAllowedToday(75, dailyTarget: 10);
      expect(allowed, 3);
    });

    test('backlog 41-60 due cards: cuts new words to half of dailyTarget', () {
      final allowed = newWordsAllowedToday(50, dailyTarget: 10);
      expect(allowed, 5);
    });

    test('backlog <= 40 due cards: awards full daily target of 10 new words', () {
      final allowed = newWordsAllowedToday(20, dailyTarget: 10);
      expect(allowed, 10);
    });

    test('buildPlanForToday creates exactly 4 balanced steps', () async {
      final plan = await planBuilder.buildPlanForToday();
      expect(plan.steps.length, 4);
      expect(plan.steps.any((s) => s.type == MissionType.srsReview), isTrue);
      expect(plan.steps.any((s) => s.type == MissionType.sentencePractice), isTrue);
      expect(plan.steps.any((s) => s.type == MissionType.wordAction), isTrue);
      expect(plan.steps.any((s) => s.type == MissionType.speedFluency), isTrue);
    });
  });
}
