import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart' as drift;
import 'package:sqlite3/open.dart';
import 'package:english_arena/app/providers.dart';
import 'package:english_arena/core/db/database.dart';
import 'package:english_arena/features/games/reference_hunter/reference_hunter_screen.dart';
import 'package:english_arena/features/games/summarize_ten_words/summarize_ten_words_screen.dart';
import 'package:english_arena/features/games/sentence_race/sentence_race_screen.dart';
import 'package:english_arena/features/games/define_it_yourself/define_it_yourself_screen.dart';

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

  test('Checklist Section 23: sentences.json contains at least 100 annotated sentences', () {
    final file = File('assets/content/sentences.json');
    expect(file.existsSync(), isTrue);
    final content = file.readAsStringSync();
    final List<dynamic> list = json.decode(content);
    expect(list.length, greaterThanOrEqualTo(100));

    // Verify fields for a sample of sentences
    for (final item in list.take(15)) {
      expect(item['sentence'], isNotNull);
      expect(item['level'], inInclusiveRange(1, 6));
      expect(item['word_count'], greaterThan(0));
      expect(item['simple_meaning'], isNotNull);
    }
  });

  testWidgets('ReferenceHunterScreen renders pronoun question and handles antecedent choice', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: ReferenceHunterScreen(level: 4)),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Reference Hunter'), findsOneWidget);
    expect(find.text('Select the Antecedent:'), findsOneWidget);

    // Tap option A
    final optionAFinder = find.text('A');
    expect(optionAFinder, findsOneWidget);
    await tester.tap(optionAFinder);
    await tester.pump();

    // Confirm button becomes active
    final confirmFinder = find.text('Confirm Antecedent');
    expect(confirmFinder, findsOneWidget);
    await tester.tap(confirmFinder);
    await tester.pump();

    // Explanation should appear
    expect(find.text('Senior Teacher Analysis:'), findsOneWidget);
    expect(find.textContaining('Next Sentence'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('SummarizeTenWordsScreen monitors word count and evaluates summary', (tester) async {
    // Insert test sentence into db
    await db.into(db.sentenceStructures).insert(
          SentenceStructuresCompanion.insert(
            sentence: 'The international committee voted unanimously to sanction illegal deforestation across the Amazon basin.',
            level: 4,
            wordCount: 14,
            subjectSpan: const drift.Value('0-2'),
            verbSpan: const drift.Value('3'),
            simpleMeaning: const drift.Value('The committee agreed to penalize illegal deforestation in the Amazon.'),
          ),
        );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: SummarizeTenWordsScreen(level: 4)),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Summarize in 10 Words'), findsOneWidget);
    expect(find.text('0 / 10 words'), findsOneWidget);

    // Enter a concise 7-word summary
    final inputFinder = find.byType(TextField);
    expect(inputFinder, findsOneWidget);
    await tester.enterText(inputFinder, 'The committee penalized illegal Amazon deforestation.');
    await tester.pump();

    expect(find.text('6 / 10 words'), findsOneWidget);

    // Submit summary
    final submitFinder = find.text('Submit Summary');
    expect(submitFinder, findsOneWidget);
    await tester.tap(submitFinder);
    await tester.pump();

    expect(find.textContaining('Teacher Feedback'), findsOneWidget);
    expect(find.text('Senior Teacher Benchmark:'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('SentenceRaceScreen renders sentence and transitions to countdown quiz', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: SentenceRaceScreen(level: 4)),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Sentence Race'), findsOneWidget);
    expect(find.text('Skip to Quiz ➔'), findsOneWidget);

    // Skip listening phase immediately to trigger countdown quiz
    await tester.tap(find.text('Skip to Quiz ➔'));
    await tester.pump();

    expect(find.textContaining('Time Left:'), findsOneWidget);

    // Pick option A
    final optionAFinder = find.text('A');
    expect(optionAFinder, findsOneWidget);
    await tester.tap(optionAFinder);
    await tester.pump();

    expect(find.textContaining('Round Complete'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('DefineItYourselfScreen displays word, reveals definition and rates recall', (tester) async {
    // Insert test word into db
    final wordId = await db.into(db.words).insert(
          WordsCompanion.insert(
            lemma: 'ubiquitous',
            cefr: const drift.Value('C1'),
            pos: const drift.Value('adjective'),
            ipa: const drift.Value('/juːˈbɪk.wɪ.təs/'),
            definitionEn: const drift.Value('Present, appearing, or found everywhere.'),
          ),
        );

    await db.into(db.srsCards).insert(
          SrsCardsCompanion.insert(
            itemType: 'word',
            itemId: wordId,
            skill: 'vocab',
            dueAt: DateTime.now().millisecondsSinceEpoch,
          ),
        );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: DefineItYourselfScreen(targetCefr: 'C1')),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Define It Yourself'), findsOneWidget);
    expect(find.text('ubiquitous'), findsOneWidget);

    // Enter user definition
    final inputFinder = find.byType(TextField);
    await tester.enterText(inputFinder, 'Existing in all places at the same time.');
    await tester.pump();

    // Tap reveal
    final revealFinder = find.text('Reveal Dictionary Definition');
    expect(revealFinder, findsOneWidget);
    await tester.tap(revealFinder);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600)); // Finish flip animation

    expect(find.text('Oxford / Cambridge Definition:'), findsOneWidget);
    expect(find.text('Rate your recall precision:'), findsOneWidget);
    expect(find.text('Easy'), findsOneWidget);

    // Rate card as Easy (quality 4)
    await tester.tap(find.text('Easy'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    await tester.pumpWidget(const SizedBox());
  });
}
