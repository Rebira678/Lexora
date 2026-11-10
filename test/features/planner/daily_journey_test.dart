import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/native.dart';
import 'package:sqlite3/open.dart';
import 'package:english_arena/app/providers.dart';
import 'package:english_arena/core/db/database.dart';
import 'package:english_arena/core/db/daos/srs_dao.dart';
import 'package:english_arena/core/db/daos/stats_dao.dart';
import 'package:english_arena/core/planner/daily_planner.dart';
import 'package:english_arena/features/planner/daily_journey_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppDatabase db;

  setUpAll(() {
    open.overrideFor(
      OperatingSystem.linux,
      () => DynamicLibrary.open('/lib/x86_64-linux-gnu/libsqlite3.so.0'),
    );
  });

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('PhaseCurriculum (Phases 1 to 5)', () {
    test('defines all 5 phases systematically from spec', () {
      expect(PhaseCurriculum.phases.length, 5);

      final p1 = PhaseCurriculum.getPhase(1);
      expect(p1.name, contains('Action Game'));
      expect(p1.timeHorizon, contains('Weeks 1–6'));
      expect(p1.cefrGoal, contains('B2'));

      final p2 = PhaseCurriculum.getPhase(2);
      expect(p2.name, contains('Weak-Point Eraser'));
      expect(p2.timeHorizon, contains('Weeks 7–12'));
      expect(p2.primaryGames, contains('Sentence X-Ray'));

      final p3 = PhaseCurriculum.getPhase(3);
      expect(p3.name, contains('Four-Skill Fluency'));
      expect(p3.timeHorizon, contains('Months 4–6'));
      expect(p3.primaryGames, contains('Weekly Boss Battle'));

      final p4 = PhaseCurriculum.getPhase(4);
      expect(p4.name, contains('C1 Push'));
      expect(p4.timeHorizon, contains('Months 7–12'));
      expect(p4.cefrGoal, contains('C1'));

      final p5 = PhaseCurriculum.getPhase(5);
      expect(p5.name, contains('C2 Native Mastery'));
      expect(p5.timeHorizon, contains('Year 2+'));
      expect(p5.cefrGoal, contains('C2'));
    });

    test('getPhaseForDay correctly categorizes days into phases', () {
      expect(PhaseCurriculum.getPhaseForDay(1).phaseNumber, 1);
      expect(PhaseCurriculum.getPhaseForDay(42).phaseNumber, 1);
      expect(PhaseCurriculum.getPhaseForDay(43).phaseNumber, 2);
      expect(PhaseCurriculum.getPhaseForDay(84).phaseNumber, 2);
      expect(PhaseCurriculum.getPhaseForDay(85).phaseNumber, 3);
      expect(PhaseCurriculum.getPhaseForDay(180).phaseNumber, 3);
      expect(PhaseCurriculum.getPhaseForDay(181).phaseNumber, 4);
      expect(PhaseCurriculum.getPhaseForDay(365).phaseNumber, 4);
      expect(PhaseCurriculum.getPhaseForDay(366).phaseNumber, 5);
      expect(PhaseCurriculum.getPhaseForDay(500).phaseNumber, 5);
    });
  });

  group('DailyPlanBuilder 30-Minute Architecture', () {
    test('builds 5 steps totaling exactly 30 minutes with streak keys', () async {
      final builder = DailyPlanBuilder(srsDao: SrsDao(db), statsDao: StatsDao(db));
      final plan = await builder.buildPlanForToday();

      expect(plan.steps.length, 5);

      final totalMinutes = plan.steps.fold<int>(0, (sum, s) => sum + s.durationMinutes);
      expect(totalMinutes, 30);

      // Verify Step 1 and Step 3 are designated as minimum day streak requirements
      expect(plan.steps[0].isMinimumDayRequirement, isTrue); // Step 1 (SRS 8m)
      expect(plan.steps[1].isMinimumDayRequirement, isFalse); // Step 2 (Vocab 5m)
      expect(plan.steps[2].isMinimumDayRequirement, isTrue); // Step 3 (Reading+X-Ray 8m)
      expect(plan.steps[3].isMinimumDayRequirement, isFalse); // Step 4 (Listening 5m)
      expect(plan.steps[4].isMinimumDayRequirement, isFalse); // Step 5 (Writing 4m)
    });

    test('generates weekday-specific themes across Monday to Sunday', () async {
      final builder = DailyPlanBuilder(srsDao: SrsDao(db), statsDao: StatsDao(db));

      // Monday: 2026-11-09
      final mon = await builder.buildPlanForToday(now: DateTime(2026, 11, 9));
      expect(mon.dayOfWeek, 'Monday');
      expect(mon.dayOfWeekFocus, contains('New Words & Morphology'));

      // Tuesday: 2026-11-10
      final tue = await builder.buildPlanForToday(now: DateTime(2026, 11, 10));
      expect(tue.dayOfWeek, 'Tuesday');
      expect(tue.dayOfWeekFocus, contains('Long-Sentence Syntax Gym'));

      // Saturday: 2026-11-14
      final sat = await builder.buildPlanForToday(now: DateTime(2026, 11, 14));
      expect(sat.dayOfWeek, 'Saturday');
      expect(sat.dayOfWeekFocus, contains('Weekly Boss Battle'));

      // Sunday: 2026-11-15
      final sun = await builder.buildPlanForToday(now: DateTime(2026, 11, 15));
      expect(sun.dayOfWeek, 'Sunday');
      expect(sun.dayOfWeekFocus, contains('Pleasure Reading'));
    });
  });

  group('DailyJourneyScreen Widget Tests', () {
    testWidgets('renders 30-min plan steps, toggle minimum mode, and phase roadmap tab', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [databaseProvider.overrideWithValue(db)],
          child: const MaterialApp(home: DailyJourneyScreen()),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('30-Min Daily Plan & Journey'), findsOneWidget);
      expect(find.text("TODAY'S 30-MIN PLAN"), findsOneWidget);
      expect(find.text('PHASE 1–5 ROADMAP'), findsOneWidget);

      // Verify 5 steps are displayed
      expect(find.textContaining('8 MIN'), findsWidgets);
      expect(find.textContaining('5 MIN'), findsWidgets);
      expect(find.textContaining('4 MIN'), findsWidgets);

      // Toggle 5-Minute Minimum Day Mode switch
      final switchFinder = find.byType(Switch);
      expect(switchFinder, findsOneWidget);
      await tester.tap(switchFinder);
      await tester.pump();

      expect(find.text('MINIMUM DAY STEPS (2 of 5)'), findsOneWidget);

      // Switch back to normal
      await tester.tap(switchFinder);
      await tester.pump();

      // Switch to Roadmap Tab
      await tester.tap(find.text('PHASE 1–5 ROADMAP'));
      await tester.pumpAndSettle();

      expect(find.text('PHASE 1 TO PHASE 5 CURRICULUM ROADMAP'), findsOneWidget);
      expect(find.text('P1'), findsOneWidget);
      expect(find.text('P2'), findsOneWidget);
      expect(find.text('P3'), findsOneWidget);
      expect(find.text('P4'), findsOneWidget);
      expect(find.text('P5'), findsOneWidget);

      // Tap P3 button
      await tester.tap(find.text('P3'), warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(find.textContaining('Phase 3'), findsWidgets);
      expect(find.textContaining('Four-Skill Fluency'), findsOneWidget);

      // Tap P5 button
      await tester.tap(find.text('P5'), warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(find.textContaining('Phase 5'), findsWidgets);
      expect(find.textContaining('C2 Native Mastery'), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
    });
  });
}
