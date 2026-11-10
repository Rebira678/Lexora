import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:sqlite3/open.dart';
import 'package:english_arena/core/db/database.dart';
import 'package:english_arena/app/providers.dart';
import 'package:english_arena/features/games/sentence_xray/sentence_xray_screen.dart';
import 'package:english_arena/features/games/slice_it/slice_it_screen.dart';
import 'package:english_arena/features/games/paragraph_architect/paragraph_architect_screen.dart';
import 'package:english_arena/features/games/chunk_echo/chunk_echo_screen.dart';

void main() {
  late AppDatabase db;

  setUpAll(() {
    open.overrideFor(OperatingSystem.linux, () => DynamicLibrary.open('/lib/x86_64-linux-gnu/libsqlite3.so.0'));
  });

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());

    // Seed SentenceStructure
    await db.into(db.sentenceStructures).insert(
          SentenceStructuresCompanion.insert(
            sentence: 'The manager approved the new budget yesterday.',
            wordCount: 7,
            level: 1,
            subjectSpan: const drift.Value('0-1'),
            verbSpan: const drift.Value('2'),
            chunksJson: const drift.Value('["The manager", "approved", "the new budget", "yesterday."]'),
            simpleMeaning: const drift.Value('The manager said yes to the new budget.'),
          ),
        );

    // Seed Paragraph
    await db.into(db.paragraphs).insert(
          ParagraphsCompanion.insert(
            level: 1,
            topic: const drift.Value('technology'),
            sentencesJson: '[{"id": 1, "text": "First, the system initializes."}, {"id": 2, "text": "Then, it processes the request."}]',
            validOrdersJson: '[[1, 2]]',
            linksJson: '[{"from": 1, "to": 2, "cue": "Then", "type": "chronology"}]',
          ),
        );

    // Seed ChunkSentence
    await db.into(db.chunkSentences).insert(
          ChunkSentencesCompanion.insert(
            level: 1,
            textContent: 'Although it was raining, the team decided to finish the match.',
            chunksJson: '["Although it was raining,", "the team decided", "to finish the match."]',
          ),
        );
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('SentenceXRayScreen renders words and analyzes sentence', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
        child: const MaterialApp(
          home: SentenceXRayScreen(level: 1),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Sentence X-Ray'), findsOneWidget);
    expect(find.text('The'), findsOneWidget);
    expect(find.text('manager'), findsOneWidget);
    expect(find.text('approved'), findsOneWidget);

    // Tap words to tag
    await tester.tap(find.text('The'));
    await tester.pump();
    await tester.tap(find.text('manager'));
    await tester.pump();

    // Switch to Verb mode
    await tester.tap(find.text('Main Verb'));
    await tester.pump();
    await tester.tap(find.text('approved'));
    await tester.pump();

    // Check Breakdown
    final analyzeBtn = find.text('Analyze Sentence');
    expect(analyzeBtn, findsOneWidget);
    await tester.tap(analyzeBtn);
    await tester.pumpAndSettle();

    expect(find.textContaining('X-Ray Core Breakdown'), findsOneWidget);
    expect(find.textContaining('The manager said yes'), findsOneWidget);
  });

  testWidgets('SliceItScreen renders tokens and allows slicing', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
        child: const MaterialApp(
          home: SliceItScreen(level: 1),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Slice It'), findsOneWidget);
    expect(find.text('The'), findsOneWidget);
    expect(find.text('manager'), findsOneWidget);

    // Find and tap a slice divider cut slot
    final inkwells = find.byType(InkWell);
    expect(inkwells, findsWidgets);
    await tester.tap(inkwells.first);
    await tester.pump();

    // Check slices button
    final checkBtn = find.text('Check Slices');
    expect(checkBtn, findsOneWidget);
    await tester.tap(checkBtn);
    await tester.pumpAndSettle();

    expect(find.textContaining('Chunk Breakdown'), findsOneWidget);
  });

  testWidgets('ParagraphArchitectScreen renders 3 helper chips and Cohesion Map', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
        child: const MaterialApp(
          home: ParagraphArchitectScreen(level: 1),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Paragraph Architect'), findsOneWidget);
    expect(find.text('Highlight (-10%)'), findsOneWidget);
    expect(find.text('Pin First (-20%)'), findsOneWidget);
    expect(find.text('Show Link (-15%)'), findsOneWidget);

    // Tap Check Order
    await tester.tap(find.text('Check Order'));
    await tester.pumpAndSettle();

    // Cohesion Map should be visible
    expect(find.text('Cohesion Map'), findsOneWidget);
  });

  testWidgets('ChunkEchoScreen supports Memory Ladder mode', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
        child: const MaterialApp(
          home: ChunkEchoScreen(
            level: 1,
            initialMode: ChunkEchoMode.memoryLadder,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Memory Ladder'), findsWidgets);
  });
}
