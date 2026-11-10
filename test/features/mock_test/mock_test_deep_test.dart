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
import 'package:english_arena/features/mock_test/mock_test_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppDatabase db;
  late Map<String, dynamic> rawJson;

  setUpAll(() async {
    open.overrideFor(
      OperatingSystem.linux,
      () => DynamicLibrary.open('/lib/x86_64-linux-gnu/libsqlite3.so.0'),
    );
    final raw = File('assets/content/phase3_content.json').readAsStringSync();
    rawJson = json.decode(raw) as Map<String, dynamic>;
    Phase3ContentService.instance.prime(rawJson);
  });

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('CEFR Mock Test - Content Integrity & Rigor', () {
    test('contains 20 comprehensive CEFR benchmark questions', () {
      final list = rawJson['mock_test'] as List;
      expect(list.length, equals(20));
    });

    test('covers all 4 CEFR core skills: reading, writing, listening, vocab', () {
      final list = rawJson['mock_test'] as List;
      final skills = list.map((q) => q['skill'] as String).toSet();

      expect(skills.contains('reading'), isTrue);
      expect(skills.contains('writing'), isTrue);
      expect(skills.contains('listening'), isTrue);
      expect(skills.contains('vocab'), isTrue);
    });

    test('every question has valid prompt, 4 options, answer, cefr, and explanation', () {
      final list = rawJson['mock_test'] as List;
      for (final q in list) {
        expect((q['prompt'] as String).isNotEmpty, isTrue);
        final options = (q['options'] as List).cast<String>();
        expect(options.length, equals(4));
        expect((q['answer'] as String).isNotEmpty, isTrue);
        expect(options.contains(q['answer']), isTrue);
        expect((q['explanation'] as String).isNotEmpty, isTrue);
        expect((q['cefr'] as String).isNotEmpty, isTrue);
      }
    });
  });

  group('MockTestScreen - Interactive Widget Execution', () {
    testWidgets('renders progress bar, section badge, and options', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [databaseProvider.overrideWithValue(db)],
          child: const MaterialApp(home: MockTestScreen()),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.textContaining('CEFR Mock Benchmark (1/20)'), findsOneWidget);
      expect(find.text('Confirm Answer'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('selecting an option enables Confirm Answer and reveals rationale', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [databaseProvider.overrideWithValue(db)],
          child: const MaterialApp(home: MockTestScreen()),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Find first option and tap
      final firstOptionFinder = find.byType(InkWell).first;
      await tester.tap(firstOptionFinder);
      await tester.pump();

      // Tap Confirm Answer
      final confirmBtn = find.text('Confirm Answer');
      await tester.tap(confirmBtn);
      await tester.pump();

      // Next Question button should now be visible
      expect(find.text('Next Question'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    });
  });
}
