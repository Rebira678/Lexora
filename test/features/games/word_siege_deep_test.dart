import 'package:flutter_test/flutter_test.dart';
import 'package:english_arena/core/scoring/scoring.dart';

// SM-2 quality mapping from app.md 24.1
int siegeSrsQuality({
  required bool correct,
  required int ms,
  required bool tapMode,
  required bool usedHint,
  required bool reachedGate,
}) {
  if (reachedGate) return 1;
  if (!correct) return 2;
  if (usedHint || tapMode || ms > 6000) return 3;
  return ms < 3000 ? 5 : 4;
}

// Pace control from app.md 24.1
double siegeEnemySpeed(double recentAcc, int level) {
  final base = 0.06 + 0.012 * level; // screen heights per second
  if (recentAcc > 0.85) return base * 1.15;
  if (recentAcc < 0.60) return base * 0.80;
  return base;
}

void main() {
  group('⚔️ Word Siege Core Algorithm & Edge Cases (app.md 24.1)', () {
    test('SM-2 quality table matches spec precisely', () {
      // 1. Typed correctly in <3s, no hint -> Quality 5
      expect(
        siegeSrsQuality(
          correct: true,
          ms: 2200,
          tapMode: false,
          usedHint: false,
          reachedGate: false,
        ),
        equals(5),
      );

      // 2. Typed correctly in 3-6s -> Quality 4
      expect(
        siegeSrsQuality(
          correct: true,
          ms: 4500,
          tapMode: false,
          usedHint: false,
          reachedGate: false,
        ),
        equals(4),
      );

      // 3. Correct but slow (>6s) -> Quality 3
      expect(
        siegeSrsQuality(
          correct: true,
          ms: 7000,
          tapMode: false,
          usedHint: false,
          reachedGate: false,
        ),
        equals(3),
      );

      // 4. Correct with Echo hint -> Quality 3
      expect(
        siegeSrsQuality(
          correct: true,
          ms: 1500,
          tapMode: false,
          usedHint: true,
          reachedGate: false,
        ),
        equals(3),
      );

      // 5. Correct in Tap mode -> Quality 3
      expect(
        siegeSrsQuality(
          correct: true,
          ms: 1200,
          tapMode: true,
          usedHint: false,
          reachedGate: false,
        ),
        equals(3),
      );

      // 6. Wrong answer -> Quality 2
      expect(
        siegeSrsQuality(
          correct: false,
          ms: 3000,
          tapMode: false,
          usedHint: false,
          reachedGate: false,
        ),
        equals(2),
      );

      // 7. Enemy reached gate -> Quality 1
      expect(
        siegeSrsQuality(
          correct: false,
          ms: 12000,
          tapMode: false,
          usedHint: false,
          reachedGate: true,
        ),
        equals(1),
      );
    });

    test('Enemy speed adapts dynamically based on accuracy (app.md 24.1)', () {
      final baseLevel1 = 0.06 + 0.012 * 1; // 0.072
      // Normal accuracy (0.60 to 0.85)
      expect(siegeEnemySpeed(0.75, 1), closeTo(baseLevel1, 0.0001));

      // High accuracy (> 0.85) speeds up by 15%
      expect(siegeEnemySpeed(0.90, 1), closeTo(baseLevel1 * 1.15, 0.0001));

      // Low accuracy (< 0.60) slows down by 20%
      expect(siegeEnemySpeed(0.50, 1), closeTo(baseLevel1 * 0.80, 0.0001));
    });

    test('Scoring formula conforms to exact spec with speed multipliers and hint penalty', () {
      // Base score 100, fast (<3s => 1.5x), combo 5 => (1 + 0.1 * 5) = 1.5x => 100 * 1.5 * 1.5 = 225
      final fastScore = wordSiegeScore(
        correct: true,
        responseTimeSeconds: 2.0,
        combo: 5,
        baseScore: 100,
      );
      expect(fastScore, equals(225));

      // With Echo hint penalty (30% of base => -30)
      final echoScore = wordSiegeScore(
        correct: true,
        responseTimeSeconds: 2.0,
        combo: 5,
        baseScore: 100,
        hintPenalty: 30,
      );
      expect(echoScore, equals(195));

      // Boss correct = 3x base (300 base score), moderate speed (4.0s => 1.2x), combo 10 => 2.0x
      // 300 * 1.2 * 2.0 = 720
      final bossScore = wordSiegeScore(
        correct: true,
        responseTimeSeconds: 4.0,
        combo: 10,
        baseScore: 300,
      );
      expect(bossScore, equals(720));

      // Incorrect score always returns 0
      expect(
        wordSiegeScore(
          correct: false,
          responseTimeSeconds: 1.0,
          combo: 5,
        ),
        equals(0),
      );
    });
  });
}
