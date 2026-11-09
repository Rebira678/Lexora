import 'dart:math';

// ─────────────────────────────────────────────────────────────────────────────
// Levenshtein Distance
// ─────────────────────────────────────────────────────────────────────────────

/// Computes the Levenshtein edit distance between two strings.
///
/// The Levenshtein distance is the minimum number of single-character
/// edits (insertions, deletions, or substitutions) required to change
/// one string into the other.
///
/// Used for typo tolerance in answer checking.
int levenshtein(String a, String b) {
  if (a == b) return 0;
  if (a.isEmpty) return b.length;
  if (b.isEmpty) return a.length;

  // Use two rows of the DP matrix for space efficiency.
  List<int> prev = List.generate(b.length + 1, (i) => i);
  List<int> curr = List.filled(b.length + 1, 0);

  for (int i = 1; i <= a.length; i++) {
    curr[0] = i;
    for (int j = 1; j <= b.length; j++) {
      final cost = a[i - 1] == b[j - 1] ? 0 : 1;
      curr[j] = [
        prev[j] + 1, // deletion
        curr[j - 1] + 1, // insertion
        prev[j - 1] + cost, // substitution
      ].reduce(min);
    }
    // Swap rows.
    final temp = prev;
    prev = curr;
    curr = temp;
  }
  return prev[b.length];
}

// ─────────────────────────────────────────────────────────────────────────────
// Jaccard Similarity
// ─────────────────────────────────────────────────────────────────────────────

/// Computes the Jaccard similarity coefficient between two sets of words.
///
/// Jaccard(A, B) = |A ∩ B| / |A ∪ B|
///
/// Both inputs are lowercased and split by whitespace. Returns a value
/// between 0.0 (no overlap) and 1.0 (identical sets).
///
/// Used for X-Ray game scoring where word order doesn't matter.
double jaccardSimilarity(String a, String b) {
  final setA = _tokenize(a);
  final setB = _tokenize(b);

  if (setA.isEmpty && setB.isEmpty) return 1.0;
  if (setA.isEmpty || setB.isEmpty) return 0.0;

  final intersection = setA.intersection(setB).length;
  final union = setA.union(setB).length;

  return intersection / union;
}

/// Tokenizes a string into a set of lowercase, non-empty words.
Set<String> _tokenize(String s) {
  return s
      .toLowerCase()
      .split(RegExp(r'\s+'))
      .where((w) => w.isNotEmpty)
      .toSet();
}

// ─────────────────────────────────────────────────────────────────────────────
// Word Siege Scoring
// ─────────────────────────────────────────────────────────────────────────────

/// Checks if a Word Siege answer is acceptable.
///
/// An answer is "ok" if:
/// - It exactly matches (case-insensitive), OR
/// - The Levenshtein distance is within [tolerance] (default 1 for words
///   longer than 4 characters, 0 otherwise).
///
/// Parameters:
/// - [answer]: the player's typed answer.
/// - [expected]: the correct word/phrase.
/// - [tolerance]: optional explicit tolerance override.
bool isAnswerOk(String answer, String expected, {int? tolerance}) {
  final a = answer.trim().toLowerCase();
  final e = expected.trim().toLowerCase();

  if (a == e) return true;

  final tol = tolerance ?? (e.length > 4 ? 1 : 0);
  return levenshtein(a, e) <= tol;
}

/// Scores a single Word Siege answer.
///
/// Base score of 100 points, modified by:
/// - Speed multiplier: <3s = 1.5×, 3–6s = 1.2×, >6s = 1.0×
/// - Combo multiplier: 1 + 0.1 * min(combo, 10)
/// - Hint penalty subtracted from the result
///
/// Returns 0 for incorrect answers.
int wordSiegeScore({
  required bool correct,
  required double responseTimeSeconds,
  required int combo,
  int baseScore = 100,
  double hintPenalty = 0,
}) {
  if (!correct) return 0;

  final speedMul = _speedMultiplier(responseTimeSeconds);
  final comboMul = 1.0 + 0.1 * min(combo, 10);
  final raw = baseScore * speedMul * comboMul - hintPenalty;
  return max(0, raw.floor());
}

/// Speed multiplier based on response time.
double _speedMultiplier(double seconds) {
  if (seconds < 3) return 1.5;
  if (seconds <= 6) return 1.2;
  return 1.0;
}

// ─────────────────────────────────────────────────────────────────────────────
// Paragraph Architect Scoring
// ─────────────────────────────────────────────────────────────────────────────

/// Scores a Paragraph Architect answer.
///
/// The player must arrange sentence fragments in order. Scoring:
/// - Each adjacent pair in the correct relative order earns [pairPoints].
/// - If the entire sequence is perfectly ordered, an [exactBonus] is added.
///
/// Parameters:
/// - [playerOrder]: list of fragment indices in the order the player placed them.
/// - [correctOrder]: the correct order of fragment indices.
/// - [pairPoints]: points per correctly ordered adjacent pair (default 20).
/// - [exactBonus]: bonus for a perfect arrangement (default 50).
///
/// Returns the total score.
int paragraphArchitectScore({
  required List<int> playerOrder,
  required List<int> correctOrder,
  int pairPoints = 20,
  int exactBonus = 50,
}) {
  if (playerOrder.length != correctOrder.length) return 0;
  if (playerOrder.isEmpty) return 0;

  // Build a position map for the correct order.
  final Map<int, int> correctPos = {};
  for (int i = 0; i < correctOrder.length; i++) {
    correctPos[correctOrder[i]] = i;
  }

  // Count correctly ordered adjacent pairs.
  int correctPairs = 0;
  for (int i = 0; i < playerOrder.length - 1; i++) {
    final posA = correctPos[playerOrder[i]];
    final posB = correctPos[playerOrder[i + 1]];
    if (posA != null && posB != null && posA < posB) {
      correctPairs++;
    }
  }

  int score = correctPairs * pairPoints;

  // Check for exact match.
  bool isExact = true;
  for (int i = 0; i < playerOrder.length; i++) {
    if (playerOrder[i] != correctOrder[i]) {
      isExact = false;
      break;
    }
  }
  if (isExact) score += exactBonus;

  return score;
}

// ─────────────────────────────────────────────────────────────────────────────
// Chunk Echo Scoring
// ─────────────────────────────────────────────────────────────────────────────

/// Scores a Chunk Echo answer.
///
/// The player must reproduce a heard phrase. Scoring is based on
/// word-level accuracy:
/// - Exact match → full [baseScore] + [perfectBonus]
/// - Partial match → proportional score based on correct word count
///
/// Parameters:
/// - [playerAnswer]: what the player typed/said.
/// - [correctPhrase]: the correct phrase.
/// - [baseScore]: maximum base score for the phrase (default 100).
/// - [perfectBonus]: bonus for exact reproduction (default 25).
///
/// Returns the score.
int chunkEchoScore({
  required String playerAnswer,
  required String correctPhrase,
  int baseScore = 100,
  int perfectBonus = 25,
}) {
  final correctWords = _tokenize(correctPhrase).toList();

  if (correctWords.isEmpty) return 0;

  // Check for exact match (case-insensitive, order-sensitive).
  final pNorm = playerAnswer.trim().toLowerCase();
  final cNorm = correctPhrase.trim().toLowerCase();
  if (pNorm == cNorm) return baseScore + perfectBonus;

  // Count matching words (bag-of-words style).
  final playerBag = <String, int>{};
  for (final w in _tokenize(playerAnswer)) {
    playerBag[w] = (playerBag[w] ?? 0) + 1;
  }
  final correctBag = <String, int>{};
  for (final w in _tokenize(correctPhrase)) {
    correctBag[w] = (correctBag[w] ?? 0) + 1;
  }

  int matchCount = 0;
  int totalCorrect = 0;
  for (final entry in correctBag.entries) {
    totalCorrect += entry.value;
    matchCount += min(entry.value, playerBag[entry.key] ?? 0);
  }

  if (totalCorrect == 0) return 0;
  return (baseScore * matchCount / totalCorrect).round();
}

// ─────────────────────────────────────────────────────────────────────────────
// X-Ray Scoring
// ─────────────────────────────────────────────────────────────────────────────

/// Scores an X-Ray game answer using Jaccard similarity.
///
/// The player must explain/describe a concept. Scoring is based on
/// word overlap with the reference answer.
///
/// Parameters:
/// - [playerAnswer]: the player's explanation.
/// - [referenceAnswer]: the reference/correct explanation.
/// - [maxScore]: maximum possible score (default 100).
/// - [threshold]: minimum Jaccard score to earn any points (default 0.1).
///
/// Returns the score based on Jaccard similarity.
int xrayScore({
  required String playerAnswer,
  required String referenceAnswer,
  int maxScore = 100,
  double threshold = 0.1,
}) {
  final similarity = jaccardSimilarity(playerAnswer, referenceAnswer);
  if (similarity < threshold) return 0;
  return (maxScore * similarity).round();
}
