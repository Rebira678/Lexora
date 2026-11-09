import 'package:drift/drift.dart';
import '../database.dart';
import '../tables.dart';

part 'srs_dao.g.dart';

@DriftAccessor(tables: [SrsCards, ReviewLogs, Words, Examples])
class SrsDao extends DatabaseAccessor<AppDatabase> with _$SrsDaoMixin {
  SrsDao(super.db);

  /// Returns cards that are currently due for review.
  Future<List<SrsCard>> getDueCards({int limit = 40}) {
    final now = DateTime.now().millisecondsSinceEpoch;
    return (select(srsCards)
          ..where((c) => c.dueAt.isSmallerOrEqualValue(now))
          ..orderBy([(c) => OrderingTerm(expression: c.dueAt, mode: OrderingMode.asc)])
          ..limit(limit))
        .get();
  }

  /// Returns total number of due cards.
  Future<int> getDueCount() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final count = srsCards.id.count();
    final row = await (selectOnly(srsCards)
          ..addColumns([count])
          ..where(srsCards.dueAt.isSmallerOrEqualValue(now)))
        .getSingle();
    return row.read(count) ?? 0;
  }

  /// Updates an SRS card with new interval and ease after review.
  Future<void> updateCardAfterReview({
    required int cardId,
    required double newEase,
    required int newIntervalDays,
    required int newReps,
    required int newLapses,
    required int nextDueEpochMs,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await (update(srsCards)..where((c) => c.id.equals(cardId))).write(
      SrsCardsCompanion(
        ease: Value(newEase),
        intervalDays: Value(newIntervalDays),
        repetitions: Value(newReps),
        lapses: Value(newLapses),
        dueAt: Value(nextDueEpochMs),
        lastReviewedAt: Value(now),
      ),
    );
  }

  /// Inserts a review log record.
  Future<int> logReview({
    required int cardId,
    required String game,
    required bool correct,
    required int responseMs,
    required int quality,
  }) {
    final now = DateTime.now().millisecondsSinceEpoch;
    return into(reviewLogs).insert(
      ReviewLogsCompanion.insert(
        cardId: Value(cardId),
        game: game,
        correct: correct ? 1 : 0,
        responseMs: responseMs,
        quality: quality,
        reviewedAt: now,
      ),
    );
  }

  /// Returns count of mastered words (interval >= 21 days).
  Future<int> getMasteredCount() async {
    final count = srsCards.id.count();
    final row = await (selectOnly(srsCards)
          ..addColumns([count])
          ..where(srsCards.intervalDays.isBiggerOrEqualValue(21)))
        .getSingle();
    return row.read(count) ?? 0;
  }
}
