import 'package:drift/drift.dart';
import '../database.dart';
import '../tables.dart';

part 'game_dao.g.dart';

@DriftAccessor(tables: [
  SentenceStructures,
  Paragraphs,
  ChunkSentences,
  Passages,
  Questions,
  GameSessions,
  PersonalBests,
])
class GameDao extends DatabaseAccessor<AppDatabase> with _$GameDaoMixin {
  GameDao(super.db);

  // Sentences
  Future<List<SentenceStructure>> getSentencesForLevel(int level) =>
      (select(sentenceStructures)..where((s) => s.level.equals(level))).get();

  // Paragraphs
  Future<List<Paragraph>> getParagraphsForLevel(int level) =>
      (select(paragraphs)..where((p) => p.level.equals(level))).get();

  Future<Paragraph?> getParagraphById(int id) =>
      (select(paragraphs)..where((p) => p.id.equals(id))).getSingleOrNull();

  // Chunks
  Future<List<ChunkSentence>> getChunksForLevel(int level) =>
      (select(chunkSentences)..where((c) => c.level.equals(level))).get();

  // Passages
  Future<List<Passage>> getAllPassages() => select(passages).get();

  Future<Passage?> getPassageById(int id) =>
      (select(passages)..where((p) => p.id.equals(id))).getSingleOrNull();

  Future<List<Question>> getQuestionsForPassage(int passageId) =>
      (select(questions)..where((q) => q.passageId.equals(passageId))).get();

  // Game Sessions
  Future<int> recordSession(GameSessionsCompanion session) =>
      into(gameSessions).insert(session);

  Future<List<GameSession>> getRecentSessions({int limit = 20}) =>
      (select(gameSessions)
            ..orderBy([(s) => OrderingTerm(expression: s.startedAt, mode: OrderingMode.desc)])
            ..limit(limit))
          .get();

  // Personal Bests
  Future<PersonalBest?> getPersonalBest(String game, String mode, String metric) =>
      (select(personalBests)
            ..where((p) =>
                p.game.equals(game) &
                p.mode.equals(mode) &
                p.metric.equals(metric)))
          .getSingleOrNull();

  Future<void> savePersonalBest(PersonalBestsCompanion pb) =>
      into(personalBests).insertOnConflictUpdate(pb);
}
