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

  Future<void> updateUserMnemonic(int wordId, String? mnemonic) async {
    await (update(words)..where((w) => w.id.equals(wordId))).write(
      WordsCompanion(userMnemonic: Value(mnemonic)),
    );
  }

  Future<void> updateUserSentence(int wordId, String? sentence) async {
    await (update(words)..where((w) => w.id.equals(wordId))).write(
      WordsCompanion(userSentence: Value(sentence)),
    );
  }

  Future<SrsCard?> getSrsCardForWord(int wordId) async {
    return (select(srsCards)..where((c) => c.itemType.equals('word') & c.itemId.equals(wordId))).getSingleOrNull();
  }

  Future<void> markWordAsKnownOrRetired(int wordId) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final yearLater = now + (365 * 24 * 3600 * 1000);
    final existing = await getSrsCardForWord(wordId);
    if (existing != null) {
      await (update(srsCards)..where((c) => c.id.equals(existing.id))).write(
        SrsCardsCompanion(
          ease: const Value(3.0),
          intervalDays: const Value(365),
          repetitions: const Value(10),
          lapses: const Value(0),
          dueAt: Value(yearLater),
          lastReviewedAt: Value(now),
        ),
      );
    } else {
      await into(srsCards).insert(
        SrsCardsCompanion.insert(
          itemType: 'word',
          itemId: wordId,
          skill: 'vocab',
          ease: const Value(3.0),
          intervalDays: const Value(365),
          repetitions: const Value(10),
          lapses: const Value(0),
          dueAt: yearLater,
          lastReviewedAt: Value(now),
        ),
      );
    }
  }
}
