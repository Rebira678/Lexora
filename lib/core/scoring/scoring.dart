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
// Word Siege Scoring & Spelling Normalization
// ─────────────────────────────────────────────────────────────────────────────

/// Normalizes common US/UK spelling variants so both forms match equivalently:
/// -our / -or (colour/color, honour/honor, favour/favor, rumour/rumor)
/// -ise / -ize (realise/realize, organise/organize, criticise/criticize)
/// -re / -er (centre/center, theatre/theater, metre/meter, litre/liter)
/// -ence / -ense (defence/defense, licence/license, offence/offense)
/// -ogue / -og (catalogue/catalog, dialogue/dialog)
String normalizeSpellingVariant(String word) {
  var s = word.trim().toLowerCase();
  s = s.replaceAll(RegExp(r'our\b'), 'or');
  s = s.replaceAll(RegExp(r'ise\b'), 'ize');
  s = s.replaceAll(RegExp(r'ised\b'), 'ized');
  s = s.replaceAll(RegExp(r'ising\b'), 'izing');
  s = s.replaceAll(RegExp(r'isation\b'), 'ization');
  s = s.replaceAll(RegExp(r're\b'), 'er');
  s = s.replaceAll(RegExp(r'ence\b'), 'ense');
  s = s.replaceAll(RegExp(r'ogue\b'), 'og');
  return s;
}

/// Checks if a Word Siege answer is acceptable.
///
/// An answer is "ok" if:
/// - It exactly matches (case-insensitive)
/// - Matches an accepted variant or normalized US/UK spelling
/// - The Levenshtein distance is within [tolerance] (forgiving at lower levels)
///
/// Parameters:
/// - [answer]: the player's typed answer.
/// - [expected]: the correct word/phrase.
/// - [tolerance]: optional explicit tolerance override.
/// - [acceptedVariants]: optional list of accepted alternative forms.
bool isAnswerOk(
  String answer,
  String expected, {
  int? tolerance,
  List<String> acceptedVariants = const [],
}) {
  final a = answer.trim().toLowerCase();
  final e = expected.trim().toLowerCase();

  if (a == e) return true;

  // Check explicit accepted variants
  for (final variant in acceptedVariants) {
    if (a == variant.trim().toLowerCase()) return true;
  }

  // Check US/UK normalized spellings
  final normA = normalizeSpellingVariant(a);
  final normE = normalizeSpellingVariant(e);
  if (normA == normE) return true;

  for (final variant in acceptedVariants) {
    if (normA == normalizeSpellingVariant(variant)) return true;
  }

  final tol = tolerance ?? (e.length > 4 ? 1 : 0);
  if (tol > 0) {
    if (levenshtein(a, e) <= tol) return true;
    if (levenshtein(normA, normE) <= tol) return true;
  }
  return false;
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
// X-Ray & Slice It Scoring
// ─────────────────────────────────────────────────────────────────────────────

/// Scores an X-Ray game answer using Jaccard similarity across spans.
///
/// Implements section 21.4 of spec:
/// 0.35 * J(subject) + 0.35 * J(verb) + 0.30 * J(extras)
double xraySpanScore({
  required Set<int> tappedSubject,
  required Set<int> correctSubject,
  required Set<int> tappedVerb,
  required Set<int> correctVerb,
  required Set<int> tappedExtras,
  required Set<int> correctExtras,
}) {
  double j(Set<int> a, Set<int> b) {
    if (a.isEmpty && b.isEmpty) return 1.0;
    final union = a.union(b).length;
    if (union == 0) return 1.0;
    return a.intersection(b).length / union;
  }

  return 0.35 * j(tappedSubject, correctSubject) +
      0.35 * j(tappedVerb, correctVerb) +
      0.30 * j(tappedExtras, correctExtras);
}

/// Scores a Slice It answer by comparing cut positions between word tokens.
///
/// Jaccard similarity between tapped cuts and expected chunk cuts:
/// |tapped ∩ correct| / |tapped ∪ correct|
double sliceItScore({
  required Set<int> tappedCuts,
  required Set<int> correctCuts,
}) {
  if (tappedCuts.isEmpty && correctCuts.isEmpty) return 1.0;
  final union = tappedCuts.union(correctCuts).length;
  if (union == 0) return 1.0;
  return tappedCuts.intersection(correctCuts).length / union;
}

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
