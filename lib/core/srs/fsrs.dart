import 'dart:math' as math;

/// Rating grade for FSRS reviews.
enum FsrsRating {
  again(1),
  hard(2),
  good(3),
  easy(4);

  final int value;
  const FsrsRating(this.value);
}

/// FSRS State representing an item's memory strength and difficulty.
class FsrsCard {
  /// Memory stability in days (time for retrievability to drop to target retention).
  double stability;

  /// Inherent difficulty of the item, clamped to [1.0, 10.0].
  double difficulty;

  /// Current interval in days until the next scheduled review.
  int interval;

  /// Total number of successful reviews.
  int reps;

  /// Total number of lapses (times rated 'again').
  int lapses;

  /// Timestamp of the last review.
  DateTime? lastReviewed;

  /// Scheduled due date for the next review.
  DateTime due;

  FsrsCard({
    this.stability = 0.0,
    this.difficulty = 0.0,
    this.interval = 0,
    this.reps = 0,
    this.lapses = 0,
    this.lastReviewed,
    DateTime? due,
  }) : due = due ?? DateTime.now();

  /// Calculates the current retrievability (probability of recall) given [now].
  double retrievability({DateTime? now}) {
    if (stability <= 0.0 || lastReviewed == null) return 0.0;
    final currentTime = now ?? DateTime.now();
    final elapsedDays = math.max(0.0, currentTime.difference(lastReviewed!).inHours / 24.0);
    const factor = 19.0 / 81.0;
    const decay = -0.5;
    return math.pow(1.0 + factor * (elapsedDays / stability), decay).toDouble().clamp(0.0, 1.0);
  }

  FsrsCard copyWith({
    double? stability,
    double? difficulty,
    int? interval,
    int? reps,
    int? lapses,
    DateTime? lastReviewed,
    DateTime? due,
  }) {
    return FsrsCard(
      stability: stability ?? this.stability,
      difficulty: difficulty ?? this.difficulty,
      interval: interval ?? this.interval,
      reps: reps ?? this.reps,
      lapses: lapses ?? this.lapses,
      lastReviewed: lastReviewed ?? this.lastReviewed,
      due: due ?? this.due,
    );
  }

  @override
  String toString() =>
      'FsrsCard(stability: ${stability.toStringAsFixed(2)}, difficulty: ${difficulty.toStringAsFixed(2)}, interval: $interval, reps: $reps, due: $due)';
}

/// Parameters and core calculation engine for FSRS v4.5.
class FsrsScheduler {
  /// Target retention rate (e.g. 0.90 for 90% recall probability).
  final double desiredRetention;

  /// Default weight vector optimized across large-scale spaced repetition corpora.
  final List<double> weights;

  const FsrsScheduler({
    this.desiredRetention = 0.90,
    this.weights = const [
      0.40255, 1.18385, 3.173, 15.69105, // Initial stabilities for ratings 1..4
      7.1949, 0.5345, 1.4604, 0.0046,     // Initial & next difficulty parameters
      1.5457, 0.1192, 1.0192,             // Recall stability parameters
      1.9395, 0.11, 0.296, 0.2269,        // Lapse stability parameters
      0.2315, 2.9898,                     // Hard & easy modifiers
    ],
  });

  static const double _factor = 19.0 / 81.0;
  static const double _decay = -0.5;

  /// Calculates the next interval in days given [stability] and [desiredRetention].
  int nextInterval(double stability) {
    if (stability <= 0.0) return 1;
    final interval = (stability / _factor) * (math.pow(desiredRetention, 1.0 / _decay) - 1.0);
    return math.max(1, interval.round()).clamp(1, 365);
  }

  /// Reviews an [FsrsCard] with the given [rating] and returns the updated state.
  FsrsCard reviewCard(FsrsCard card, FsrsRating rating, {DateTime? now}) {
    final reviewTime = now ?? DateTime.now();

    if (card.reps == 0 && card.stability == 0.0) {
      // First review (learning state)
      final initStability = weights[rating.value - 1];
      final initDifficulty = (weights[4] - math.exp(weights[5] * (rating.value - 1)) + 1.0).clamp(1.0, 10.0);
      final interval = nextInterval(initStability);

      return card.copyWith(
        stability: initStability,
        difficulty: initDifficulty,
        interval: interval,
        reps: rating == FsrsRating.again ? 0 : 1,
        lapses: rating == FsrsRating.again ? 1 : 0,
        lastReviewed: reviewTime,
        due: reviewTime.add(Duration(days: interval)),
      );
    }

    // Subsequent review
    final currentR = card.retrievability(now: reviewTime);

    // 1. Update Difficulty
    final deltaD = -weights[6] * (rating.value - 3);
    final nextD = (card.difficulty + deltaD).clamp(1.0, 10.0);
    // Mean reversion to default difficulty
    final updatedD = (weights[7] * weights[4] + (1.0 - weights[7]) * nextD).clamp(1.0, 10.0);

    // 2. Update Stability
    double nextS;
    int nextReps = card.reps;
    int nextLapses = card.lapses;

    if (rating == FsrsRating.again) {
      nextReps = 0;
      nextLapses++;
      // Lapse formula
      nextS = weights[11] *
          math.pow(updatedD, -weights[12]) *
          (math.pow(card.stability + 1.0, weights[13]) - 1.0) *
          math.exp(weights[14] * (1.0 - currentR));
      nextS = math.max(0.1, nextS);
    } else {
      nextReps++;
      // Recall formula
      double hardPenalty = 1.0;
      if (rating == FsrsRating.hard) {
        hardPenalty = weights[15];
      } else if (rating == FsrsRating.easy) {
        hardPenalty = weights[16];
      }

      final factorRecall = 1.0 +
          math.exp(weights[8]) *
              (11.0 - updatedD) *
              math.pow(card.stability, -weights[9]) *
              (math.exp(weights[10] * (1.0 - currentR)) - 1.0) *
              hardPenalty;

      nextS = (card.stability * factorRecall).clamp(0.1, 3650.0);
    }

    final interval = nextInterval(nextS);

    return card.copyWith(
      stability: nextS,
      difficulty: updatedD,
      interval: interval,
      reps: nextReps,
      lapses: nextLapses,
      lastReviewed: reviewTime,
      due: reviewTime.add(Duration(days: interval)),
    );
  }
}
