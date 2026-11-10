import 'dart:ffi';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:sqlite3/open.dart';
import 'package:english_arena/core/db/database.dart';
import 'package:english_arena/core/db/importer.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppDatabase db;
  late ContentImporter importer;

  setUpAll(() {
    open.overrideFor(OperatingSystem.linux, () => DynamicLibrary.open('/lib/x86_64-linux-gnu/libsqlite3.so.0'));
  });

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    importer = ContentImporter(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('ContentImporter successfully imports all 5 starter content datasets', () async {
    final imported = await importer.importIfNeeded();
    expect(imported, isTrue);

    // Verify words table
    final words = await db.select(db.words).get();
    expect(words.length, 200);

    // Verify initial SRS cards generated for all words
    final srsCards = await db.select(db.srsCards).get();
    expect(srsCards.length, 200);

    // Verify sentences table (expanded to meet Section 23 >= 100 benchmark)
    final sentences = await db.select(db.sentenceStructures).get();
    expect(sentences.length, greaterThanOrEqualTo(100));

    // Verify paragraphs table
    final paragraphs = await db.select(db.paragraphs).get();
    expect(paragraphs.length, 10);

    // Verify chunks table
    final chunks = await db.select(db.chunkSentences).get();
    expect(chunks.length, 20);

    // Verify passages table
    final passages = await db.select(db.passages).get();
    expect(passages.length, 8);

    // Verify second run does not duplicate (returns false)
    final secondRun = await importer.importIfNeeded();
    expect(secondRun, isFalse);
    final wordsAfter = await db.select(db.words).get();
    expect(wordsAfter.length, 200);
  });
}
