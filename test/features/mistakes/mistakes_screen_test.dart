import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:sqlite3/open.dart';
import 'package:english_arena/core/db/database.dart';
import 'package:english_arena/app/providers.dart';
import 'package:english_arena/features/mistakes/presentation/mistakes_screen.dart';

void main() {
  late AppDatabase db;

  setUpAll(() {
    open.overrideFor(OperatingSystem.linux, () => DynamicLibrary.open('/lib/x86_64-linux-gnu/libsqlite3.so.0'));
  });

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());

    // Seed a word with lapses
    final wordId = await db.into(db.words).insert(
          WordsCompanion.insert(
            lemma: 'reluctant',
            cefr: const drift.Value('B2'),
            definitionEn: const drift.Value('unwilling and hesitant'),
          ),
        );

    await db.into(db.srsCards).insert(
          SrsCardsCompanion.insert(
            itemType: 'word',
            itemId: wordId,
            skill: 'vocab',
            lapses: const drift.Value(3),
            dueAt: DateTime.now().millisecondsSinceEpoch,
          ),
        );

    // Seed a wild item saved to notebook
    await db.into(db.wildItems).insert(
          WildItemsCompanion.insert(
            sentence: 'She was reluctant to accept the offer.',
            source: const drift.Value('Mistake: reluctant'),
            savedAt: DateTime.now().millisecondsSinceEpoch,
          ),
        );
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('MistakesScreen displays Mistake Gym and Saved Words tabs', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
        child: const MaterialApp(
          home: MistakesScreen(),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('My Words & Mistakes'), findsOneWidget);
    expect(find.text('Mistake Gym'), findsOneWidget);
    expect(find.text('Saved Words'), findsOneWidget);
    expect(find.text('reluctant'), findsOneWidget);
    expect(find.text('3 lapses'), findsOneWidget);

    // Switch to Saved Words tab
    await tester.tap(find.text('Saved Words'));
    await tester.pumpAndSettle();

    expect(find.text('She was reluctant to accept the offer.'), findsOneWidget);
  });
}
