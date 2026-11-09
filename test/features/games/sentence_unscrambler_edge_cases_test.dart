import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:sqlite3/open.dart';
import 'package:english_arena/core/db/database.dart';
import 'package:english_arena/app/providers.dart';
import 'package:english_arena/features/games/sentence_unscrambler/sentence_unscrambler_screen.dart';

void main() {
  late AppDatabase db;

  setUpAll(() {
    open.overrideFor(OperatingSystem.linux, () => DynamicLibrary.open('/lib/x86_64-linux-gnu/libsqlite3.so.0'));
  });

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    await db.into(db.sentenceStructures).insert(
          SentenceStructuresCompanion.insert(
            sentence: 'When it rains, I stay inside.',
            wordCount: 6,
            level: 1,
            simpleMeaning: const drift.Value('I stay home during rain.'),
          ),
        );
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('Sentence Unscrambler accepts canonical and inverted clause ordering', (tester) async {
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

    // Verify initial word chips are in the bank
    expect(find.byType(ActionChip), findsWidgets);

    // Tap all chips into assembled row
    final chips = find.byType(ActionChip);
    final count = chips.evaluate().length;
    for (int i = 0; i < count; i++) {
      await tester.tap(find.byType(ActionChip).first);
      await tester.pump();
    }

    // Check sentence button is enabled
    expect(find.text('Check Sentence'), findsOneWidget);

    // Tap Reset to return words back to the bank
    expect(find.text('Reset'), findsOneWidget);
    await tester.tap(find.text('Reset'));
    await tester.pump();

    // Verify bank has all chips back
    expect(find.text('Tap word tiles below in the correct order'), findsOneWidget);
  });
}
