import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/native.dart';
import 'package:sqlite3/open.dart';
import 'package:english_arena/app/providers.dart';
import 'package:english_arena/core/db/database.dart';
import 'package:english_arena/core/services/phase5_content_service.dart';
import 'package:english_arena/features/games/style_analyzer/style_analyzer_screen.dart';
import 'package:english_arena/features/reading/c2_long_reader_screen.dart';
import 'package:english_arena/features/writing/linguistic_evaluator_screen.dart';
import 'package:english_arena/features/games/gap_finder/gap_finder_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppDatabase db;

  setUpAll(() async {
    open.overrideFor(OperatingSystem.linux, () => DynamicLibrary.open('/lib/x86_64-linux-gnu/libsqlite3.so.0'));
    await Phase5ContentService.instance.loadContent();
  });

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('StyleAnalyzerScreen renders author, excerpt, and device options', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: StyleAnalyzerScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Style & Rhetoric Analyzer'), findsOneWidget);
    expect(find.text('C2 RHETORIC'), findsOneWidget);
    expect(find.text('Chiasmus'), findsOneWidget);

    // Tap choice and verify check
    await tester.tap(find.text('Chiasmus'));
    await tester.pump();

    expect(find.text('RHETORICAL ANALYSIS'), findsOneWidget);
    expect(find.textContaining('Next Rhetorical Passage'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('C2LongReaderScreen renders essay title, paragraphs, and annotations', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: C2LongReaderScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Great Works & Essays (C2)'), findsOneWidget);
    expect(find.text('Of Studies'), findsOneWidget);
    expect(find.textContaining('Francis Bacon'), findsOneWidget);
    expect(find.text('¶ 1'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('LinguisticEvaluatorScreen evaluates syntax, AWL density, and CEFR tier', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: LinguisticEvaluatorScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Linguistic & Rubric Engine'), findsOneWidget);
    expect(find.text('Sample C2'), findsOneWidget);

    // Tap Sample C2 to run evaluation
    await tester.tap(find.text('Sample C2'));
    await tester.pump();

    expect(find.text('PREDICTED CEFR BAND'), findsOneWidget);
    expect(find.textContaining('C2'), findsWidgets);
    expect(find.text('Mean Sentence Length'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('GapFinderScreen renders diagnostic card and decision buttons', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: GapFinderScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Lexical Gap Finder'), findsOneWidget);
    expect(find.text('I Know This'), findsOneWidget);
    expect(find.text("Don't Know"), findsOneWidget);

    // Tap I Know This
    await tester.tap(find.text('I Know This'));
    await tester.pump();

    await tester.pumpWidget(const SizedBox());
  });
}
