import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:sqlite3/open.dart';
import 'package:english_arena/core/db/database.dart';
import 'package:english_arena/app/providers.dart';
import 'package:english_arena/features/games/word_siege/word_siege_screen.dart';
import 'package:english_arena/features/games/vocab_sprint/vocab_sprint_screen.dart';
import 'package:english_arena/features/games/anagram_wheel/anagram_wheel_screen.dart';
import 'package:english_arena/features/games/sentence_unscrambler/sentence_unscrambler_screen.dart';
import 'package:english_arena/features/home/presentation/home_screen.dart';

void main() {
  late AppDatabase db;

  setUpAll(() {
    open.overrideFor(OperatingSystem.linux, () => DynamicLibrary.open('/lib/x86_64-linux-gnu/libsqlite3.so.0'));
  });

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    // Seed words (including 4-8 char words for Anagram Wheel)
    await db.into(db.words).insert(
          WordsCompanion.insert(
            lemma: 'focus',
            cefr: const drift.Value('B1'),
            definitionEn: const drift.Value('the center of interest or activity'),
          ),
        );
    await db.into(db.words).insert(
          WordsCompanion.insert(
            lemma: 'sharp',
            cefr: const drift.Value('B1'),
            definitionEn: const drift.Value('having an edge or point that is able to cut'),
          ),
        );
    await db.into(db.words).insert(
          WordsCompanion.insert(
            lemma: 'brave',
            cefr: const drift.Value('B1'),
            definitionEn: const drift.Value('ready to face and endure danger or pain'),
          ),
        );
    await db.into(db.words).insert(
          WordsCompanion.insert(
            lemma: 'clarity',
            cefr: const drift.Value('B2'),
            definitionEn: const drift.Value('the quality of being clear and easy to see or hear'),
          ),
        );

    await db.into(db.sentenceStructures).insert(
          SentenceStructuresCompanion.insert(
            sentence: 'The pragmatic scientist verified every single result.',
            wordCount: 7,
            level: 1,
            simpleMeaning: const drift.Value('The scientist carefully checked each finding.'),
          ),
        );
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('Word Siege renders battlefield, gate, and controls', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
        child: const MaterialApp(
          home: WordSiegeScreen(level: 1, tapMode: true),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.textContaining('Word Siege'), findsOneWidget);
    expect(find.textContaining('DEFEND THE GATE'), findsOneWidget);
    expect(find.byIcon(Icons.touch_app_rounded), findsOneWidget);
  });

  testWidgets('Vocab Sprint renders timer, lives, and question card', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
        child: const MaterialApp(
          home: VocabSprintScreen(durationSeconds: 60),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Vocabulary Sprint'), findsOneWidget);
    expect(find.textContaining('Score:'), findsOneWidget);
    expect(find.byType(Card), findsWidgets);
  });

  testWidgets('Anagram Wheel renders rotating wheel and control actions', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
        child: const MaterialApp(
          home: AnagramWheelScreen(durationSeconds: 90),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.textContaining('Anagram Wheel'), findsOneWidget);
    expect(find.text('Clear'), findsOneWidget);
    expect(find.text('Check'), findsOneWidget);
    expect(find.byIcon(Icons.shuffle_rounded), findsOneWidget);
  });

  testWidgets('Sentence Unscrambler renders bank words and Why button', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
        child: const MaterialApp(
          home: SentenceUnscramblerScreen(level: 1),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.textContaining('Sentence Unscrambler'), findsOneWidget);
    expect(find.text('Check Sentence'), findsOneWidget);
    expect(find.text('Reset'), findsOneWidget);
  });

  testWidgets('Home Screen renders streak, XP bar, mission button, and arena grid', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          streakStreamProvider.overrideWith((ref) => Stream.value(null)),
          todayStatsProvider.overrideWith((ref) => Future.value(null)),
          dueCardCountProvider.overrideWith((ref) => Future.value(5)),
          masteredCountProvider.overrideWith((ref) => Future.value(10)),
        ],
        child: const MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.textContaining("TODAY'S MISSION"), findsOneWidget);
    expect(find.text('Game Arena'), findsOneWidget);
    expect(find.text('Word Siege'), findsWidgets);
    expect(find.text('Vocab Sprint'), findsWidgets);
    expect(find.text('Unscrambler'), findsWidgets);
    expect(find.text('Anagram Wheel'), findsWidgets);

    // Pump unmount cleanly
    await tester.pumpWidget(const SizedBox());
  });
}
