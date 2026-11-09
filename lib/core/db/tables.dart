import 'package:drift/drift.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Words & Vocabulary Tables
// ─────────────────────────────────────────────────────────────────────────────

class Words extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get lemma => text()();
  TextColumn get pos => text().nullable()();
  TextColumn get ipa => text().nullable()();
  TextColumn get cefr => text().nullable()(); // 'A1'..'C2'
  IntColumn get freqRank => integer().nullable()();
  TextColumn get definitionEn => text().nullable()();
  TextColumn get definitionNative => text().nullable()();
  TextColumn get audioPath => text().nullable()();
  TextColumn get tags => text().nullable()(); // comma-separated: 'work,travel'
  TextColumn get register => text().nullable()(); // formal, neutral, informal
  TextColumn get nuanceNote => text().nullable()();
  TextColumn get source => text().nullable()();
  TextColumn get userMnemonic => text().nullable()();
  TextColumn get userSentence => text().nullable()();
}

class Examples extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get wordId => integer().references(Words, #id)();
  TextColumn get sentence => text()();
  TextColumn get translation => text().nullable()();
  TextColumn get audioPath => text().nullable()();
}

class WordFamilies extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get root => text()();
  IntColumn get memberWordId => integer().nullable().references(Words, #id)();
  TextColumn get formType => text().nullable()(); // noun, verb, adjective, adverb
}

class Collocations extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get wordId => integer().references(Words, #id)();
  TextColumn get phrase => text()();
  TextColumn get register => text().nullable()();
}

// ─────────────────────────────────────────────────────────────────────────────
// Spaced Repetition (SRS) & Review Tables
// ─────────────────────────────────────────────────────────────────────────────

class SrsCards extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get itemType => text()(); // 'word' | 'sentence' | 'phrase' | 'paragraph' | 'chunk_sentence'
  IntColumn get itemId => integer()();
  TextColumn get skill => text()(); // 'reading' | 'writing' | 'listening' | 'speaking' | 'vocab'
  RealColumn get ease => real().withDefault(const Constant(2.5))();
  IntColumn get intervalDays => integer().withDefault(const Constant(0))();
  IntColumn get repetitions => integer().withDefault(const Constant(0))();
  IntColumn get lapses => integer().withDefault(const Constant(0))();
  IntColumn get dueAt => integer()(); // epoch milliseconds
  IntColumn get lastReviewedAt => integer().nullable()();
}

class ReviewLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get cardId => integer().nullable().references(SrsCards, #id)();
  TextColumn get game => text()();
  IntColumn get correct => integer()(); // 0 or 1
  IntColumn get responseMs => integer()();
  IntColumn get quality => integer()(); // 0..5
  IntColumn get reviewedAt => integer()(); // epoch milliseconds
}

// ─────────────────────────────────────────────────────────────────────────────
// Reading & Sentences Tables
// ─────────────────────────────────────────────────────────────────────────────

class SentenceStructures extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get sentence => text()();
  IntColumn get level => integer()(); // 1..6
  IntColumn get wordCount => integer()();
  TextColumn get subjectSpan => text().nullable()();
  TextColumn get verbSpan => text().nullable()();
  TextColumn get chunksJson => text().nullable()();
  TextColumn get layersJson => text().nullable()();
  TextColumn get connectorsJson => text().nullable()();
  TextColumn get simpleMeaning => text().nullable()();
  TextColumn get audioPath => text().nullable()();
}

class Paragraphs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get level => integer()(); // 1..6
  TextColumn get topic => text().nullable()();
  TextColumn get sentencesJson => text()(); // JSON list of sentence objects
  TextColumn get validOrdersJson => text()(); // JSON list of lists [[1,2,3,4]]
  TextColumn get linksJson => text()(); // JSON list of links
}

class ChunkSentences extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get level => integer()(); // 1..6
  TextColumn get textContent => text().named('text')();
  TextColumn get chunksJson => text()(); // JSON list of strings
  TextColumn get audioPath => text().nullable()();
  TextColumn get audioSlowPath => text().nullable()();
  TextColumn get chunkTimingsJson => text().nullable()();
}

class Passages extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get body => text()();
  TextColumn get cefr => text().nullable()();
  IntColumn get wordCount => integer()();
  TextColumn get audioPath => text().nullable()();
}

class Questions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get passageId => integer().references(Passages, #id)();
  TextColumn get type => text()(); // multiple_choice, true_false
  TextColumn get prompt => text()();
  TextColumn get options => text().nullable()(); // JSON list of strings
  TextColumn get answer => text()();
  TextColumn get explanation => text().nullable()();
}

// ─────────────────────────────────────────────────────────────────────────────
// Writing & Speaking Tracking
// ─────────────────────────────────────────────────────────────────────────────

class UserTexts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get prompt => text()();
  TextColumn get body => text()();
  IntColumn get createdAt => integer()();
  IntColumn get selfScore => integer().nullable()();
}

class Recordings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get prompt => text()();
  TextColumn get filePath => text()();
  IntColumn get durationMs => integer()();
  TextColumn get sttText => text().nullable()();
  RealColumn get score => real().nullable()();
  IntColumn get createdAt => integer()();
}

// ─────────────────────────────────────────────────────────────────────────────
// Stats, Streaks & Progress Tables
// ─────────────────────────────────────────────────────────────────────────────

class DailyStats extends Table {
  TextColumn get day => text()(); // 'YYYY-MM-DD'
  IntColumn get minutes => integer().withDefault(const Constant(0))();
  IntColumn get xp => integer().withDefault(const Constant(0))();
  IntColumn get itemsReviewed => integer().withDefault(const Constant(0))();
  IntColumn get goalMet => integer().withDefault(const Constant(0))(); // 0 or 1

  @override
  Set<Column> get primaryKey => {day};
}

class Streaks extends Table {
  IntColumn get id => integer()();
  IntColumn get current => integer().withDefault(const Constant(0))();
  IntColumn get best => integer().withDefault(const Constant(0))();
  IntColumn get freezes => integer().withDefault(const Constant(0))();
  TextColumn get lastDay => text().withDefault(const Constant(''))();
  IntColumn get totalDays => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

class Achievements extends Table {
  TextColumn get code => text()();
  IntColumn get unlockedAt => integer()();

  @override
  Set<Column> get primaryKey => {code};
}

class GameSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get game => text()(); // 'word_siege', 'anagram_wheel', etc.
  TextColumn get mode => text().nullable()();
  IntColumn get level => integer().nullable()();
  IntColumn get startedAt => integer()();
  IntColumn get durationMs => integer()();
  RealColumn get accuracy => real()();
  IntColumn get score => integer()();
  IntColumn get xpEarned => integer()();
  IntColumn get hintsUsed => integer().withDefault(const Constant(0))();
  TextColumn get extraJson => text().nullable()();
}

class PersonalBests extends Table {
  TextColumn get game => text()();
  TextColumn get mode => text()();
  TextColumn get metric => text()();
  RealColumn get value => real()();
  IntColumn get setAt => integer()();

  @override
  Set<Column> get primaryKey => {game, mode, metric};
}

class WildItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get wordId => integer().nullable().references(Words, #id)();
  TextColumn get sentence => text()();
  TextColumn get source => text().nullable()();
  IntColumn get savedAt => integer()();
}

class SkillLevels extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get skill => text()(); // 'reading' | 'writing' | 'listening' | 'speaking' | 'vocab'
  TextColumn get cefrEstimate => text()(); // 'B2', 'C1', etc.
  RealColumn get score => real()();
  IntColumn get measuredAt => integer()();
  TextColumn get source => text().nullable()(); // 'monthly_mock' | 'placement' | 'self_report'
}
