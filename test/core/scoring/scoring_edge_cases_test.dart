import 'package:flutter_test/flutter_test.dart';
import 'package:english_arena/core/scoring/scoring.dart';

void main() {
  group('Scoring & Typo Tolerance Edge Cases', () {
    test('words <= 4 chars strictly require exact match (0 distance)', () {
      // 4-letter words
      expect(isAnswerOk('word', 'word'), isTrue);
      expect(isAnswerOk('ward', 'word'), isFalse);
      expect(isAnswerOk('cars', 'cats'), isFalse);
      expect(isAnswerOk('bear', 'beer'), isFalse);

      // 3-letter words
      expect(isAnswerOk('act', 'act'), isTrue);
      expect(isAnswerOk('art', 'act'), isFalse);
    });

    test('words > 4 chars forgive single typo but reject 2 typos', () {
      // 1 typo allowed for > 4 chars
      expect(isAnswerOk('ubiqitous', 'ubiquitous'), isTrue); // deletion
      expect(isAnswerOk('reluctant', 'reluctant'), isTrue);
      expect(isAnswerOk('reluktanto', 'reluctant'), isFalse); // 2 edits
      expect(isAnswerOk('tenasious', 'tenacious'), isTrue); // substitution
      expect(isAnswerOk('tenasiouz', 'tenacious'), isFalse); // 2 edits
    });

    test('case insensitivity and whitespace trimming', () {
      expect(isAnswerOk('   PRAGMATIC  \n', 'pragmatic'), isTrue);
      expect(isAnswerOk('EpHeMeRaL', 'ephemeral'), isTrue);
    });

    test('word siege scoring speed tiers', () {
      // < 3s = 1.5x
      final fast = wordSiegeScore(
        correct: true,
        responseTimeSeconds: 1.5,
        combo: 0,
        baseScore: 100,
      );
      expect(fast, 150);

      // 3-6s = 1.2x
      final mid = wordSiegeScore(
        correct: true,
        responseTimeSeconds: 4.2,
        combo: 0,
        baseScore: 100,
      );
      expect(mid, 120);

      // > 6s = 1.0x
      final slow = wordSiegeScore(
        correct: true,
        responseTimeSeconds: 7.0,
        combo: 0,
        baseScore: 100,
      );
      expect(slow, 100);
    });

    test('combo multiplier caps at 10 (2.0x max)', () {
      final combo10 = wordSiegeScore(
        correct: true,
        responseTimeSeconds: 8.0,
        combo: 10,
        baseScore: 100,
      );
      expect(combo10, 200); // 100 * 1.0 * (1 + 0.1 * 10) = 200

      final combo25 = wordSiegeScore(
        correct: true,
        responseTimeSeconds: 8.0,
        combo: 25,
        baseScore: 100,
      );
      // Still capped at 2.0x
      expect(combo25, 200);
    });

    test('Boss battle awards 3x base score points', () {
      final bossScore = wordSiegeScore(
        correct: true,
        responseTimeSeconds: 2.0, // 1.5x
        combo: 5, // (1 + 0.5) = 1.5x
        baseScore: 300, // 3x base
      );
      // 300 * 1.5 * 1.5 = 675
      expect(bossScore, 675);
    });

    test('Echo hint subtracts hint penalty correctly', () {
      final withHint = wordSiegeScore(
        correct: true,
        responseTimeSeconds: 2.0, // 150 pts
        combo: 0,
        baseScore: 100,
        hintPenalty: 30,
      );
      expect(withHint, 120);
    });
  });
}
