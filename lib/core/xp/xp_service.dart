import 'dart:math';

/// Represents the user's XP and level state.
class XpState {
  /// Total accumulated XP across all time.
  int totalXp;

  /// Current level (1-based).
  int level;

  /// Current rank title based on level.
  String rank;

  /// Creates an [XpState] with the given values.
  XpState({
    this.totalXp = 0,
    this.level = 1,
    this.rank = 'Rookie',
  });

  /// Creates a deep copy of this state.
  XpState copyWith({int? totalXp, int? level, String? rank}) {
    return XpState(
      totalXp: totalXp ?? this.totalXp,
      level: level ?? this.level,
      rank: rank ?? this.rank,
    );
  }

  @override
  String toString() => 'XpState(totalXp: $totalXp, level: $level, rank: $rank)';
}

/// Result of adding XP, including level-up information.
class XpResult {
  /// Updated XP state.
  final XpState state;

  /// Whether a level-up occurred.
  final bool leveledUp;

  /// Previous level before the XP was added (only meaningful if [leveledUp]).
  final int previousLevel;

  /// XP that was added.
  final int xpAdded;

  /// Creates an [XpResult].
  XpResult({
    required this.state,
    this.leveledUp = false,
    this.previousLevel = 1,
    this.xpAdded = 0,
  });
}

/// Service for managing XP, levels, and ranks.
///
/// Level progression uses the formula: XP required for level n = 100 * n^1.5
///
/// Ranks:
/// - Rookie (1–4)
/// - Explorer (5–9)
/// - Word Hunter (10–14)
/// - Phrase Fighter (15–19)
/// - Grammar Knight (20–24)
/// - Fluency Captain (25–29)
/// - Wordsmith (30–34)
/// - English Master (35+)
class XpService {
  /// XP required to reach level [n] (cumulative threshold).
  ///
  /// Formula: `100 * n^1.5`, rounded to the nearest integer.
  /// Level 1 requires 0 XP (everyone starts at level 1).
  int xpForLevel(int n) {
    if (n <= 1) return 0;
    return (100 * pow(n, 1.5)).round();
  }

  /// Determines the current level based on [totalXp].
  ///
  /// Iterates upward from level 1 until the XP required for the next
  /// level exceeds [totalXp].
  int levelFromXp(int totalXp) {
    if (totalXp < 0) return 1;
    int level = 1;
    while (true) {
      final nextLevelXp = xpForLevel(level + 1);
      if (totalXp < nextLevelXp) break;
      level++;
      // Safety cap to prevent infinite loops.
      if (level > 1000) break;
    }
    return level;
  }

  /// Returns the rank name for the given [level].
  ///
  /// Rank thresholds:
  /// - 1–4: Rookie
  /// - 5–9: Explorer
  /// - 10–14: Word Hunter
  /// - 15–19: Phrase Fighter
  /// - 20–24: Grammar Knight
  /// - 25–29: Fluency Captain
  /// - 30–34: Wordsmith
  /// - 35+: English Master
  String rankForLevel(int level) {
    if (level >= 35) return 'English Master';
    if (level >= 30) return 'Wordsmith';
    if (level >= 25) return 'Fluency Captain';
    if (level >= 20) return 'Grammar Knight';
    if (level >= 15) return 'Phrase Fighter';
    if (level >= 10) return 'Word Hunter';
    if (level >= 5) return 'Explorer';
    return 'Rookie';
  }

  /// Adds [amount] XP to [state] and returns the result.
  ///
  /// Detects level-ups and updates the rank accordingly.
  XpResult addXp(XpState state, int amount) {
    final previousLevel = state.level;
    state.totalXp += amount;

    // Protect against negative totals.
    if (state.totalXp < 0) state.totalXp = 0;

    state.level = levelFromXp(state.totalXp);
    state.rank = rankForLevel(state.level);

    return XpResult(
      state: state,
      leveledUp: state.level > previousLevel,
      previousLevel: previousLevel,
      xpAdded: amount,
    );
  }

  /// Calculates XP earned for a game answer.
  ///
  /// Formula:
  /// ```
  /// points = base * speedMultiplier * (1 + 0.1 * min(combo, 10)) - hintPenalty
  /// ```
  ///
  /// The result is floored to an integer and clamped to a minimum of 0.
  int calculateXp({
    required int basePoints,
    required double speedMultiplier,
    required int combo,
    double hintPenalty = 0,
  }) {
    final comboMultiplier = 1.0 + 0.1 * min(combo, 10);
    final raw = basePoints * speedMultiplier * comboMultiplier - hintPenalty;
    return max(0, raw.floor());
  }

  /// Returns the speed multiplier based on response time.
  ///
  /// - < 3 seconds: 1.5×
  /// - 3–6 seconds: 1.2×
  /// - > 6 seconds: 1.0×
  static double speedMultiplierFromTime(double seconds) {
    if (seconds < 3) return 1.5;
    if (seconds <= 6) return 1.2;
    return 1.0;
  }
}
