/// SM-2 spaced repetition card representing a single learnable item.
///
/// Tracks the ease factor, interval, repetition count, lapse count,
/// and due date for scheduling reviews using the SM-2 algorithm.
class SrsCard {
  /// Ease factor — determines how quickly intervals grow.
  /// Ranges from 1.3 to 3.0.
  double ease;

  /// Current interval in days until next review.
  int interval;

  /// Number of consecutive successful repetitions.
  int reps;

  /// Number of times the card has lapsed (quality < 3).
  int lapses;

  /// When the card is next due for review.
  DateTime due;

  /// Creates a new [SrsCard] with optional initial values.
  SrsCard({
    this.ease = 2.5,
    this.interval = 0,
    this.reps = 0,
    this.lapses = 0,
    DateTime? due,
  }) : due = due ?? DateTime.now();

  /// Creates a deep copy of this card.
  SrsCard copyWith({
    double? ease,
    int? interval,
    int? reps,
    int? lapses,
    DateTime? due,
  }) {
    return SrsCard(
      ease: ease ?? this.ease,
      interval: interval ?? this.interval,
      reps: reps ?? this.reps,
      lapses: lapses ?? this.lapses,
      due: due ?? this.due,
    );
  }

  @override
  String toString() =>
      'SrsCard(ease: $ease, interval: $interval, reps: $reps, lapses: $lapses, due: $due)';
}

/// Reviews a card with the given [quality] grade (0–5) using the SM-2 algorithm.
///
/// - **quality 0**: Complete blackout — no recall at all.
/// - **quality 1**: Incorrect; the correct answer seemed familiar once shown.
/// - **quality 2**: Incorrect; the correct answer seemed easy to recall once shown.
/// - **quality 3**: Correct answer with serious difficulty.
/// - **quality 4**: Correct answer after some hesitation.
/// - **quality 5**: Perfect, instant recall.
///
/// The [now] parameter allows injecting a specific time for testing.
void review(SrsCard c, int quality, {DateTime? now}) {
  assert(quality >= 0 && quality <= 5, 'Quality must be between 0 and 5');
  final reviewTime = now ?? DateTime.now();

  if (quality < 3) {
    // Lapse — reset repetitions and set interval to 1 day.
    c.reps = 0;
    c.interval = 1;
    c.lapses++;
  } else {
    // Successful recall — advance the schedule.
    if (c.reps == 0) {
      c.interval = 1;
    } else if (c.reps == 1) {
      c.interval = 6;
    } else {
      c.interval = (c.interval * c.ease).round().clamp(1, 365);
    }
    c.reps++;
  }

  // Update ease factor using the SM-2 formula, clamped to [1.3, 3.0].
  c.ease = (c.ease + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02)))
      .clamp(1.3, 3.0);

  // Schedule the next review.
  c.due = reviewTime.add(Duration(days: c.interval));
}

/// Returns `true` if [card] is due for review at the given time.
///
/// A card is due when the current time is at or past [card.due].
bool isDue(SrsCard card, {DateTime? now}) {
  final checkTime = now ?? DateTime.now();
  return !checkTime.isBefore(card.due);
}

/// Quality mapping result for game-specific scoring.
enum WordSiegeOutcome {
  /// Typed correctly in under 3 seconds, no hint used.
  perfectFast,

  /// Typed correctly in 3–6 seconds.
  correctMedium,

  /// Correct but slow (>6s) or answered in tap mode.
  correctSlow,

  /// Correct but used the Echo hint.
  correctWithHint,

  /// Wrong answer then corrected.
  wrongThenCorrected,

  /// Enemy reached the gate (failed to answer in time).
  enemyReachedGate,

  /// Used a bomb on this word.
  bombUsed,
}

/// Maps a [WordSiegeOutcome] to an SM-2 quality score (0–5).
///
/// Quality mapping for Word Siege:
/// - Typed correctly < 3s, no hint → 5
/// - Typed correctly 3–6s → 4
/// - Correct but slow (>6s) or tap mode → 3
/// - Correct with Echo hint → 3
/// - Wrong answer then corrected → 2
/// - Enemy reached the gate → 1
/// - Bomb used on this word → 1
int wordSiegeQuality(WordSiegeOutcome outcome) {
  switch (outcome) {
    case WordSiegeOutcome.perfectFast:
      return 5;
    case WordSiegeOutcome.correctMedium:
      return 4;
    case WordSiegeOutcome.correctSlow:
      return 3;
    case WordSiegeOutcome.correctWithHint:
      return 3;
    case WordSiegeOutcome.wrongThenCorrected:
      return 2;
    case WordSiegeOutcome.enemyReachedGate:
      return 1;
    case WordSiegeOutcome.bombUsed:
      return 1;
  }
}

/// Maps generic game result parameters to an SM-2 quality score (0–5).
///
/// Parameters:
/// - [correct]: whether the answer was ultimately correct.
/// - [responseTimeSeconds]: time taken to respond in seconds.
/// - [hintUsed]: whether a hint was used.
/// - [bombUsed]: whether a bomb power-up was used.
/// - [enemyReachedGate]: whether the enemy reached the gate (Word Siege).
/// - [wrongThenCorrected]: whether the answer was wrong first, then corrected.
/// - [tapMode]: whether tap input mode was used instead of typing.
int mapGameResultToQuality({
  required bool correct,
  double responseTimeSeconds = 0,
  bool hintUsed = false,
  bool bombUsed = false,
  bool enemyReachedGate = false,
  bool wrongThenCorrected = false,
  bool tapMode = false,
}) {
  // Bomb or enemy reached gate → 1
  if (bombUsed) return 1;
  if (enemyReachedGate) return 1;

  // Wrong then corrected → 2
  if (wrongThenCorrected) return 2;

  // Not correct at all → 0
  if (!correct) return 0;

  // Correct with hint → 3
  if (hintUsed) return 3;

  // Correct in tap mode (slow equivalent) → 3
  if (tapMode) return 3;

  // Correct and typed — score by speed.
  if (responseTimeSeconds < 3) return 5;
  if (responseTimeSeconds <= 6) return 4;
  return 3; // >6 seconds
}
