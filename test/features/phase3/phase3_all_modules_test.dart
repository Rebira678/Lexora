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
import 'package:english_arena/core/services/phase3_content_service.dart';
import 'package:english_arena/features/games/collocation_match/collocation_match_screen.dart';
import 'package:english_arena/features/writing/word_forge_screen.dart';
import 'package:english_arena/features/writing/daily_journal_screen.dart';
import 'package:english_arena/features/writing/writing_portfolio_screen.dart';
import 'package:english_arena/features/speaking/sixty_second_talker_screen.dart';
import 'package:english_arena/features/speaking/shadow_boxing_screen.dart';
import 'package:english_arena/features/boss_battle/boss_battle_screen.dart';
import 'package:english_arena/features/mock_test/mock_test_screen.dart';
import 'package:english_arena/features/achievements/presentation/achievements_screen.dart';
import 'package:english_arena/features/settings/presentation/backup_restore_screen.dart';
import 'package:english_arena/features/speaking/role_play_screen.dart';
import 'package:english_arena/features/reading/story_branch_screen.dart';
import 'package:english_arena/features/games/phrasal_verb_dungeon/phrasal_verb_dungeon_screen.dart';
import 'package:english_arena/features/games/idiom_escape/idiom_escape_screen.dart';
import 'package:english_arena/features/writing/mini_email_boss_screen.dart';
import 'package:english_arena/features/custom_decks/custom_deck_screen.dart';
import 'package:english_arena/features/stats/presentation/monthly_checkpoint_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppDatabase db;

  setUpAll(() async {
    open.overrideFor(OperatingSystem.linux, () => DynamicLibrary.open('/lib/x86_64-linux-gnu/libsqlite3.so.0'));
    final raw = File('assets/content/phase3_content.json').readAsStringSync();
    Phase3ContentService.instance.prime(json.decode(raw) as Map<String, dynamic>);
  });

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('CollocationMatchScreen renders options and checks answer', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: CollocationMatchScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.textContaining('Collocation Match'), findsOneWidget);
    expect(find.text('Verify Collocation'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('WordForgeScreen renders target chips and textfield', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: WordForgeScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.textContaining('Word Forge'), findsOneWidget);
    expect(find.text('Synthesize One Academic Sentence'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('DailyJournalScreen renders 3 observation scaffolds', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: DailyJournalScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.textContaining('Daily 3 Sentences'), findsOneWidget);
    expect(find.text('OBSERVATION'), findsOneWidget);
    expect(find.text('CONTRAST / NUANCE'), findsOneWidget);
    expect(find.text('PRAGMATIC RESOLUTION'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('WritingPortfolioScreen renders archive state', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: WritingPortfolioScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Writing Portfolio'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('SixtySecondTalkerScreen renders prep countdown', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: SixtySecondTalkerScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('60-Second Talker'), findsOneWidget);
    expect(find.text('PREPARATION PHASE'), findsOneWidget);
    expect(find.text('Ready Now (Skip Prep)'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('ShadowBoxingScreen renders native carrier sentence and mic control', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: ShadowBoxingScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.textContaining('Shadow Boxing'), findsOneWidget);
    expect(find.text('NATIVE PROSODY CARRIER'), findsOneWidget);
    expect(find.textContaining('Start Shadowing'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('BossBattleScreen renders Boss HP and strike controls', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: BossBattleScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Weekly Boss Raid'), findsOneWidget);
    expect(find.text('Strike Boss'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('MockTestScreen renders diagnostic questions and skills', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: MockTestScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.textContaining('CEFR Mock Benchmark'), findsOneWidget);
    expect(find.text('Confirm Answer'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('AchievementsScreen renders milestone progress and badges', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: AchievementsScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Achievements & Badges'), findsOneWidget);
    expect(find.text('Mastery Milestone Progress'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('BackupRestoreScreen renders export and restore interfaces', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: BackupRestoreScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Backup & Restore'), findsOneWidget);
    expect(find.text('Export Offline Backup'), findsOneWidget);
    expect(find.text('Restore from Backup'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('RolePlayScreen renders pragmatic dialogue turns and choices', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: RolePlayScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.textContaining('Role-Play:'), findsOneWidget);
    expect(find.text('Deliver Spoken Response'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('StoryBranchScreen renders narrative episode and choices', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: StoryBranchScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.textContaining('Cipher of Oakhaven'), findsOneWidget);
    expect(find.text('SCENE'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('PhrasalVerbDungeonScreen renders guardian encounter and particles', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: PhrasalVerbDungeonScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.textContaining('Phrasal Dungeon'), findsOneWidget);
    expect(find.text('Dispel Guardian'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('IdiomEscapeScreen renders chamber clue and idiom options', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: IdiomEscapeScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('CHAMBER CIPHER CLUE'), findsOneWidget);
    expect(find.text('Unlock Chamber Door'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('MiniEmailBossScreen renders required C1 formulas and editor', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: MiniEmailBossScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Mini Email Boss'), findsOneWidget);
    expect(find.text('C1 DIPLOMATIC REGISTER'), findsOneWidget);
    expect(find.text('Submit to Boss Review'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('CustomDeckScreen renders tabs and cards', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: CustomDeckScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Custom Decks & CSV Importer'), findsOneWidget);
    expect(find.text('Add Single'), findsOneWidget);
    expect(find.text('CSV Import'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('MonthlyCheckpointScreen renders diagnostic audit and CEFR indicators', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: MonthlyCheckpointScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Monthly Checkpoint Diagnostic'), findsOneWidget);
    expect(find.text('Executive Competency Audit'), findsOneWidget);
    expect(find.text('Senior Pedagogical Feedback'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
}
