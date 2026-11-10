import 'dart:ffi';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:sqlite3/open.dart';
import 'package:english_arena/core/db/database.dart';
import 'package:english_arena/core/db/daos/srs_dao.dart';
import 'package:english_arena/core/db/daos/stats_dao.dart';
import 'package:english_arena/core/planner/daily_planner.dart';

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

  test('buildPlanForToday creates 5 balanced 30-minute mission steps', () async {
    final plan = await planBuilder.buildPlanForToday();
    expect(plan.steps.length, 5);
    expect(plan.steps[0].type, MissionType.srsReview);
    expect(plan.steps[1].type, MissionType.vocabularyAcquisition);
    expect(plan.steps[2].type, MissionType.readingSyntax);
    expect(plan.steps[3].type, MissionType.listeningShadowing);
    expect(plan.steps[4].type, MissionType.writtenProduction);
    expect(plan.totalMinutesTarget, 30);
    expect(plan.progress, 0.0);
    expect(plan.isAllCompleted, isFalse);
  });
}
