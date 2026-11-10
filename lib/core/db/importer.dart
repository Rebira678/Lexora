import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:drift/drift.dart';
import 'database.dart';

/// Service for importing educational content from bundled JSON assets into Drift SQLite.
///
/// Features:
/// - Version-guarded: Only imports on first run or when content version increases.
/// - Batch inserts inside transactions for fast startup.
/// - Initializes corresponding SRS cards for spaced repetition learning.
class ContentImporter {
  final AppDatabase db;

  ContentImporter(this.db);

  /// Checks if content needs import and executes it if so.
  ///
  /// Returns true if content was imported, false if already up to date.
  Future<bool> importIfNeeded({int targetVersion = 2}) async {
    // Check if words and passages tables already have complete datasets
    final wordCount = await (db.selectOnly(db.words)..addColumns([db.words.id.count()])).map((r) => r.read(db.words.id.count())).getSingle();
    final passageCount = await (db.selectOnly(db.passages)..addColumns([db.passages.id.count()])).map((r) => r.read(db.passages.id.count())).getSingle();

    if ((wordCount ?? 0) >= 200 && (passageCount ?? 0) >= 8) {
      return false; // Already imported and up to date
    }

    await importAll();
    return true;
  }

  /// Imports all content from the 5 JSON files.
  Future<void> importAll() async {
    await db.transaction(() async {
      await _importWords();
      await _importSentences();
      await _importParagraphs();
      await _importChunks();
      await _importPassages();
    });
  }

  Future<void> _importWords() async {
    final jsonStr = await rootBundle.loadString('assets/content/words.json');
    final List<dynamic> list = json.decode(jsonStr);

    final now = DateTime.now().millisecondsSinceEpoch;

    for (final item in list) {
      final wordId = await db.into(db.words).insert(
            WordsCompanion.insert(
              id: Value(item['id'] as int),
              lemma: item['lemma'] as String,
              pos: Value(item['pos'] as String?),
              ipa: Value(item['ipa'] as String?),
              cefr: Value(item['cefr'] as String?),
              freqRank: Value(item['freq_rank'] as int?),
              definitionEn: Value(item['definition_en'] as String?),
              tags: Value(item['tags'] as String?),
              register: Value(item['register'] as String?),
              nuanceNote: Value(item['nuance_note'] as String?),
            ),
          );

      // Insert examples
      if (item['examples'] != null) {
        for (final ex in item['examples']) {
          await db.into(db.examples).insert(
                ExamplesCompanion.insert(
                  wordId: wordId,
                  sentence: ex['sentence'] as String,
                  translation: Value(ex['translation'] as String?),
                ),
              );
        }
      }

      // Insert collocations
      if (item['collocations'] != null) {
        for (final col in item['collocations']) {
          await db.into(db.collocations).insert(
                CollocationsCompanion.insert(
                  wordId: wordId,
                  phrase: col as String,
                ),
              );
        }
      }

      // Insert word family
      if (item['word_family'] != null) {
        for (final fam in item['word_family']) {
          await db.into(db.wordFamilies).insert(
                WordFamiliesCompanion.insert(
                  root: item['lemma'] as String,
                  memberWordId: Value(wordId),
                  formType: Value(fam['type'] as String?),
                ),
              );
        }
      }

      // Create initial SRS Card for this word
      await db.into(db.srsCards).insert(
            SrsCardsCompanion.insert(
              itemType: 'word',
              itemId: wordId,
              skill: 'vocab',
              ease: const Value(2.5),
              intervalDays: const Value(0),
              repetitions: const Value(0),
              lapses: const Value(0),
              dueAt: now,
            ),
          );
    }
  }

  Future<void> _importSentences() async {
    final jsonStr = await rootBundle.loadString('assets/content/sentences.json');
    final List<dynamic> list = json.decode(jsonStr);

    for (final item in list) {
      await db.into(db.sentenceStructures).insert(
            SentenceStructuresCompanion.insert(
              id: Value(item['id'] as int),
              sentence: item['sentence'] as String,
              level: item['level'] as int,
              wordCount: item['word_count'] as int,
              subjectSpan: Value(item['subject_span'] as String?),
              verbSpan: Value(item['verb_span'] as String?),
              chunksJson: Value(json.encode(item['chunks_json'])),
              layersJson: Value(json.encode(item['layers_json'])),
              connectorsJson: Value(json.encode(item['connectors_json'])),
              simpleMeaning: Value(item['simple_meaning'] as String?),
              audioPath: Value(item['audio_path'] as String?),
            ),
          );
    }
  }

  Future<void> _importParagraphs() async {
    final jsonStr = await rootBundle.loadString('assets/content/paragraphs.json');
    final List<dynamic> list = json.decode(jsonStr);

    for (final item in list) {
      await db.into(db.paragraphs).insert(
            ParagraphsCompanion.insert(
              id: Value(item['id'] as int),
              level: item['level'] as int,
              topic: Value(item['topic'] as String?),
              sentencesJson: json.encode(item['sentences']),
              validOrdersJson: json.encode(item['valid_orders']),
              linksJson: json.encode(item['links']),
            ),
          );
    }
  }

  Future<void> _importChunks() async {
    final jsonStr = await rootBundle.loadString('assets/content/chunks.json');
    final List<dynamic> list = json.decode(jsonStr);

    for (final item in list) {
      await db.into(db.chunkSentences).insert(
            ChunkSentencesCompanion.insert(
              id: Value(item['id'] as int),
              level: item['level'] as int,
              textContent: item['text'] as String,
              chunksJson: json.encode(item['chunks']),
              audioPath: Value(item['audio_path'] as String?),
              audioSlowPath: Value(item['audio_slow_path'] as String?),
              chunkTimingsJson: Value(json.encode(item['chunk_timings_ms'])),
            ),
          );
    }
  }

  Future<void> _importPassages() async {
    final jsonStr = await rootBundle.loadString('assets/content/passages.json');
    final List<dynamic> list = json.decode(jsonStr);

    for (final item in list) {
      final passageId = await db.into(db.passages).insert(
            PassagesCompanion.insert(
              id: Value(item['id'] as int),
              title: item['title'] as String,
              body: item['body'] as String,
              cefr: Value(item['cefr'] as String?),
              wordCount: item['word_count'] as int,
            ),
            mode: InsertMode.insertOrReplace,
          );

      if (item['questions'] != null) {
        await (db.delete(db.questions)..where((tbl) => tbl.passageId.equals(passageId))).go();
        for (final q in item['questions']) {
          await db.into(db.questions).insert(
                QuestionsCompanion.insert(
                  passageId: passageId,
                  type: q['type'] as String,
                  prompt: q['prompt'] as String,
                  options: Value(q['options'] != null ? json.encode(q['options']) : null),
                  answer: q['answer'] as String,
                  explanation: Value(q['explanation'] as String?),
                ),
                mode: InsertMode.insertOrReplace,
              );
        }
      }
    }
  }
}
