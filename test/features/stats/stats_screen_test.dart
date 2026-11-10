import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/native.dart';
import 'package:sqlite3/open.dart';
import 'package:english_arena/core/db/database.dart';
import 'package:english_arena/app/providers.dart';
import 'package:english_arena/features/stats/presentation/stats_screen.dart';

void main() {
  late AppDatabase db;

  setUpAll(() {
    open.overrideFor(OperatingSystem.linux, () => DynamicLibrary.open('/lib/x86_64-linux-gnu/libsqlite3.so.0'));
  });

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('StatsScreen renders executive dossier header with candidate title and CEFR goal', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          streakStreamProvider.overrideWith((ref) => Stream.value(
                const Streak(
                  id: 1,
                  current: 8,
                  best: 14,
                  freezes: 2,
                  lastDay: '2026-03-01',
                  totalDays: 19,
                ),
              )),
          todayStatsProvider.overrideWith((ref) => Future.value(
                const DailyStat(day: '2026-03-01', minutes: 25, xp: 450, itemsReviewed: 30, goalMet: 1),
              )),
          masteredCountProvider.overrideWith((ref) => Future.value(35)),
        ],
        child: const MaterialApp(
          home: StatsScreen(),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // Verifies the executive dossier AppBar subtitle renders
    expect(find.text('Learning Analytics & Stats'), findsOneWidget);

    // Verifies the page-level title renders
    expect(find.text('Executive Linguistic Dossier'), findsOneWidget);

    // Verifies the CEFR section header renders
    expect(find.text('CEFR 5-Skill Competency Profile'), findsOneWidget);

    // Verifies the default candidate monogram or name renders in the profile header
    expect(find.text('EL'), findsOneWidget); // "Executive Linguist" initials
  });

  testWidgets('StatsScreen bento KPI cards show correct streak and mastery data', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          streakStreamProvider.overrideWith((ref) => Stream.value(
                const Streak(
                  id: 1,
                  current: 8,
                  best: 14,
                  freezes: 2,
                  lastDay: '2026-03-01',
                  totalDays: 19,
                ),
              )),
          todayStatsProvider.overrideWith((ref) => Future.value(
                const DailyStat(day: '2026-03-01', minutes: 25, xp: 450, itemsReviewed: 30, goalMet: 1),
              )),
          masteredCountProvider.overrideWith((ref) => Future.value(35)),
        ],
        child: const MaterialApp(
          home: StatsScreen(),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // Current streak displayed in CURRENT bento card
    expect(find.text('8 Days'), findsOneWidget);

    // Best streak visible in bento card subtext
    expect(find.text('Best: 14 Days'), findsOneWidget);

    // Freeze token count displayed
    expect(find.text('2 / 3'), findsOneWidget);

    // Mastered words displayed (35 mastered)
    expect(find.text('35 Words'), findsOneWidget);

    // Rank Tier label renders in the level/rank section
    expect(find.text('Rank Tier'), findsOneWidget);
  });

  testWidgets('StatsScreen renders all CEFR 5-skill competency spectrum bars', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          streakStreamProvider.overrideWith((ref) => Stream.value(null)),
          todayStatsProvider.overrideWith((ref) => Future.value(null)),
          masteredCountProvider.overrideWith((ref) => Future.value(0)),
        ],
        child: const MaterialApp(
          home: StatsScreen(),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // All 5 CEFR skills are displayed
    expect(find.text('Lexical Range & Nuance'), findsOneWidget);
    expect(find.text('Complex Syntax & Cohesion'), findsOneWidget);
    expect(find.text('Critical & Analytic Reading'), findsOneWidget);
    expect(find.text('Written Synthesis & Discourse'), findsOneWidget);
    expect(find.text('Acoustic Shadowing & Prosody'), findsOneWidget);
  });

  testWidgets('StatsScreen renders repository vault action buttons', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          streakStreamProvider.overrideWith((ref) => Stream.value(null)),
          todayStatsProvider.overrideWith((ref) => Future.value(null)),
          masteredCountProvider.overrideWith((ref) => Future.value(0)),
        ],
        child: const MaterialApp(
          home: StatsScreen(),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // Error Bank and Achievements action buttons rendered
    expect(find.text('Error Bank'), findsOneWidget);
    expect(find.text('Achievements'), findsOneWidget);
    expect(find.text('Linguistic Repositories'), findsOneWidget);
  });
}
