import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:sqlite3/open.dart';
import 'package:english_arena/core/db/database.dart';
import 'package:english_arena/app/providers.dart';
import 'package:english_arena/core/services/phase2_content_service.dart';
import 'package:english_arena/features/games/connector_match/connector_match_screen.dart';
import 'package:english_arena/features/games/layer_builder/layer_builder_screen.dart';
import 'package:english_arena/features/games/context_detective/context_detective_screen.dart';
import 'package:english_arena/features/games/prefix_suffix_lab/prefix_suffix_lab_screen.dart';
import 'package:english_arena/features/games/word_family_tree/word_family_tree_screen.dart';
import 'package:english_arena/features/games/dictation_dash/dictation_dash_screen.dart';
import 'package:english_arena/features/games/sound_sniper/sound_sniper_screen.dart';
import 'package:english_arena/features/games/error_hunter/error_hunter_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppDatabase db;

  setUpAll(() async {
    open.overrideFor(OperatingSystem.linux, () => DynamicLibrary.open('/lib/x86_64-linux-gnu/libsqlite3.so.0'));
    await Phase2ContentService.instance.loadContent();
  });

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());

    // Seed SentenceStructure
    await db.into(db.sentenceStructures).insert(
          SentenceStructuresCompanion.insert(
            sentence: 'The manager approved the new budget yesterday.',
            wordCount: 7,
            level: 2,
            subjectSpan: const drift.Value('0-1'),
            verbSpan: const drift.Value('2'),
            chunksJson: const drift.Value('["The manager", "approved", "the new budget", "yesterday."]'),
            simpleMeaning: const drift.Value('The manager said yes to the new budget.'),
          ),
        );
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('ConnectorMatchScreen renders options and checks answer', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: ConnectorMatchScreen(level: 2)),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.textContaining('Connector Match'), findsOneWidget);
    expect(find.text('Verify Connector'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('LayerBuilderScreen renders layers and insertion choices', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: LayerBuilderScreen(level: 2)),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.textContaining('Layer Builder'), findsOneWidget);
    expect(find.textContaining('Select Where to Insert this Layer'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('ContextDetectiveScreen renders clues and deduction options', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: ContextDetectiveScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.textContaining('Context Detective'), findsOneWidget);
    expect(find.text('Confirm Deduction'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('PrefixSuffixLabScreen renders root and affix chips', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: PrefixSuffixLabScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.textContaining('Prefix & Suffix Lab'), findsOneWidget);
    expect(find.text('MORPHOLOGICAL FORGE'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('WordFamilyTreeScreen renders 4 quadrants', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: WordFamilyTreeScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.textContaining('Word Family Tree'), findsOneWidget);
    expect(find.text('VERB'), findsOneWidget);
    expect(find.text('NOUN'), findsOneWidget);
    expect(find.text('ADJECTIVE'), findsOneWidget);
    expect(find.text('ADVERB'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('DictationDashScreen renders player and input', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: DictationDashScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.textContaining('Dictation Dash'), findsOneWidget);
    expect(find.text('Submit Transcription'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('SoundSniperScreen renders acoustic crosshair and targets', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: SoundSniperScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.textContaining('Sound Sniper'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('ErrorHunterScreen renders tokens and capture action', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: ErrorHunterScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.textContaining('Error Hunter'), findsOneWidget);
    expect(find.text('Capture Faulty Word'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
}
