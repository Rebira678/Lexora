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

  testWidgets('StatsScreen displays level, rank tier, streak cards, and recent history', (tester) async {
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
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Learning Analytics & Stats'), findsOneWidget);
    expect(find.text('Rank Tier'), findsOneWidget);
    expect(find.text('8 Days'), findsOneWidget);
    expect(find.text('14 Days'), findsOneWidget);
    expect(find.text('2 / 3'), findsOneWidget);
  });
}
