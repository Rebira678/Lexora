import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:sqlite3/open.dart';
import 'package:english_arena/app/providers.dart';
import 'package:english_arena/core/db/database.dart';
import 'package:english_arena/features/word_notebook/word_notebook_screen.dart';
import 'package:english_arena/features/home/presentation/widgets/daily_quest_board_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppDatabase db;

  setUpAll(() {
    open.overrideFor(OperatingSystem.linux, () => DynamicLibrary.open('/lib/x86_64-linux-gnu/libsqlite3.so.0'));
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    db = AppDatabase.forTesting(NativeDatabase.memory());
    // Seed initial test words
    await db.into(db.words).insert(
          WordsCompanion.insert(
            id: const Value(1),
            lemma: 'ephemeral',
            pos: const Value('adjective'),
            ipa: const Value('/ɪˈfem.ər.əl/'),
            cefr: const Value('C1'),
            definitionEn: const Value('Lasting for a very short time; transient.'),
            tags: const Value('academic,time'),
          ),
        );
    await db.into(db.words).insert(
          WordsCompanion.insert(
            id: const Value(2),
            lemma: 'ubiquitous',
            pos: const Value('adjective'),
            ipa: const Value('/juːˈbɪk.wɪ.təs/'),
            cefr: const Value('B2'),
            definitionEn: const Value('Present, appearing, or found everywhere.'),
            tags: const Value('technology,society'),
          ),
        );
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('WordNotebookScreen renders catalog header, search field, and word cards', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: WordNotebookScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Word Notebook'), findsOneWidget);
    expect(find.text('Catalog'), findsOneWidget);
    expect(find.text('ephemeral'), findsOneWidget);
    expect(find.text('ubiquitous'), findsOneWidget);

    // Search query test
    await tester.enterText(find.byType(TextField), 'ephem');
    await tester.pump();

    expect(find.text('ephemeral'), findsOneWidget);
    expect(find.text('ubiquitous'), findsNothing);

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('DailyQuestBoardWidget renders 3 daily quests and progress badges', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(
          home: Scaffold(body: DailyQuestBoardWidget()),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('DAILY QUEST BOARD'), findsOneWidget);
    expect(find.text('Sharpen Vocabulary'), findsOneWidget);
    expect(find.text('Deep Practice Focus'), findsOneWidget);
    expect(find.text('Rhetoric & Synthesis'), findsOneWidget);
    expect(find.textContaining('/ 3 Done'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
  });
}
