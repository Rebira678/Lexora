import 'dart:ffi';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/native.dart';
import 'package:sqlite3/open.dart';
import 'package:english_arena/core/db/database.dart';
import 'package:english_arena/app/providers.dart';
import 'package:english_arena/core/services/phase4_content_service.dart';
import 'package:english_arena/features/games/nuance_duel/nuance_duel_screen.dart';
import 'package:english_arena/features/writing/register_shifter_screen.dart';
import 'package:english_arena/features/writing/paraphrase_blitz_screen.dart';
import 'package:english_arena/features/games/collocation_forge/collocation_forge_screen.dart';
import 'package:english_arena/features/listening/lecture_notes_screen.dart';
import 'package:english_arena/features/speaking/debate_mode_screen.dart';
import 'package:english_arena/features/writing/cohesion_fixer_screen.dart';
import 'package:english_arena/features/wild_items/real_english_log_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppDatabase db;

  setUpAll(() async {
    open.overrideFor(
      OperatingSystem.linux,
      () => DynamicLibrary.open('/lib/x86_64-linux-gnu/libsqlite3.so.0'),
    );
    final raw = File('assets/content/phase4_content.json').readAsStringSync();
    Phase4ContentService.instance.prime(json.decode(raw) as Map<String, dynamic>);
  });

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('NuanceDuelScreen renders context, dual choices, and verifies answer', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: NuanceDuelScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.textContaining('Nuance Duel'), findsOneWidget);
    expect(find.text('Confirm Lexical Choice'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('RegisterShifterScreen renders casual prompt and required markers', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: RegisterShifterScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Register Shifter'), findsOneWidget);
    expect(find.text('ORIGINAL CASUAL MESSAGE'), findsOneWidget);
    expect(find.text('Submit Register Shift'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('ParaphraseBlitzScreen renders source proposition and 3 transform slots', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: ParaphraseBlitzScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Paraphrase Blitz'), findsOneWidget);
    expect(find.text('SOURCE PROPOSITION'), findsOneWidget);
    expect(find.text('Submit 3 Paraphrases'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('CollocationForgeScreen renders prompt and timer countdown', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: CollocationForgeScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Collocation Forge'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('LectureNotesScreen renders lecture controls, tabs, and Cornell notes', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: LectureNotesScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.textContaining('Lecture Notes:'), findsOneWidget);
    expect(find.text('AUTHENTIC SPEED AUDIO'), findsOneWidget);
    expect(find.text('Cornell Notes Scratchpad:'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('DebateModeScreen renders motion, stance buttons, and 90s timer', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: DebateModeScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.textContaining('Debate Mode:'), findsOneWidget);
    expect(find.text('PARLIAMENTARY MOTION'), findsOneWidget);
    expect(find.text('PROPOSITION (FOR)'), findsOneWidget);
    expect(find.text('OPPOSITION (AGAINST)'), findsOneWidget);
    expect(find.text('Start 90s Speech'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('CohesionFixerScreen renders choppy text, gap slots, and connector bank', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: CohesionFixerScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.textContaining('Cohesion Fixer:'), findsOneWidget);
    expect(find.text('CHOPPY DISJOINTED PASSAGE'), findsOneWidget);
    expect(find.text('Verify Cohesion Flow'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('RealEnglishLogScreen renders wild capture and C1 content packs', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: RealEnglishLogScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Real English Log & C1 Packs'), findsOneWidget);
    expect(find.text('Capture Wild Word'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
}
