/// Determines the next sentence difficulty level based on accuracy and rounds.
///
/// The level adjusts up or down based on the user's recent performance:
/// - If accuracy >= 85% and at least 3 rounds at this level, and level < 6 → level up
/// - If accuracy < 60% and level > 1 → level down
/// - Otherwise → stay the same
///
/// Parameters:
/// - [current]: current difficulty level (1–6).
/// - [acc]: recent accuracy as a decimal (0.0–1.0).
/// - [roundsAtLevel]: number of rounds played at the current level.
///
/// Returns the next difficulty level.
int nextSentenceLevel(int current, double acc, int roundsAtLevel) {
  if (acc >= 0.85 && roundsAtLevel >= 3 && current < 6) return current + 1;
  if (acc < 0.60 && current > 1) return current - 1;
  return current;
}

/// Calculates the enemy movement speed for Word Siege.
///
/// The base speed increases with [level], and is adjusted by
/// the player's [recentAcc]:
/// - Accuracy > 85% → enemies move 15% faster (challenge the player)
/// - Accuracy < 60% → enemies move 20% slower (give the player a break)
/// - Otherwise → base speed
///
/// Formula: `base = 0.06 + 0.012 * level`
///
/// Parameters:
/// - [recentAcc]: player's recent accuracy (0.0–1.0).
/// - [level]: current game level.
///
/// Returns the enemy speed in units per frame/tick.
double enemySpeed(double recentAcc, int level) {
  final base = 0.06 + 0.012 * level;
  if (recentAcc > 0.85) return base * 1.15;
  if (recentAcc < 0.60) return base * 0.80;
  return base;
}
