import 'package:drift/drift.dart';
import '../database.dart';
import '../tables.dart';

part 'word_dao.g.dart';

@DriftAccessor(tables: [Words, Examples, Collocations, WordFamilies, SrsCards])
class WordDao extends DatabaseAccessor<AppDatabase> with _$WordDaoMixin {
  WordDao(super.db);

  Future<List<Word>> getAllWords() => select(words).get();

  Future<Word?> getWordById(int id) => (select(words)..where((w) => w.id.equals(id))).getSingleOrNull();

  Future<Word?> getWordByLemma(String lemma) =>
      (select(words)..where((w) => w.lemma.equals(lemma))).getSingleOrNull();

  Future<List<Example>> getExamplesForWord(int wordId) =>
      (select(examples)..where((e) => e.wordId.equals(wordId))).get();

  Future<List<Collocation>> getCollocationsForWord(int wordId) =>
      (select(collocations)..where((c) => c.wordId.equals(wordId))).get();

  Future<List<WordFamily>> getWordFamily(int wordId) =>
      (select(wordFamilies)..where((f) => f.memberWordId.equals(wordId))).get();

  Future<List<Word>> getWordsByCefr(String cefr) =>
      (select(words)..where((w) => w.cefr.equals(cefr))).get();

  Future<int> getWordsCount() async {
    final count = words.id.count();
    final row = await (selectOnly(words)..addColumns([count])).getSingle();
    return row.read(count) ?? 0;
  }
}
