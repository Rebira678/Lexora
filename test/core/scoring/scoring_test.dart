import 'package:flutter_test/flutter_test.dart';
import 'package:english_arena/core/scoring/scoring.dart';

void main() {
  group('Levenshtein Distance Tests', () {
    test('identical strings have distance 0', () {
      expect(levenshtein('achieve', 'achieve'), 0);
    });

    test('single insertion, deletion, substitution', () {
      expect(levenshtein('kitten', 'sitting'), 3);
      expect(levenshtein('flaw', 'lawn'), 2);
      expect(levenshtein('achieve', 'acheive'), 2); // swap c-h vs h-e
      expect(levenshtein('word', 'words'), 1);
    });
  });

  group('Word Siege Answer Checking & Scoring', () {
    test('isAnswerOk accepts exact match (case insensitive)', () {
      expect(isAnswerOk('AcHieVe', 'achieve'), isTrue);
    });

    test('isAnswerOk allows 1 typo on longer words', () {
      expect(isAnswerOk('achievee', 'achieve'), isTrue);
      expect(isAnswerOk('achiev', 'achieve'), isTrue);
      // But not on short words <= 4 chars
      expect(isAnswerOk('cats', 'cat'), isFalse);
    });

    test('wordSiegeScore awards points based on speed and combo', () {
      final fastScore = wordSiegeScore(
        correct: true,
        responseTimeSeconds: 2.0,
        combo: 0,
      );
      // 100 * 1.5 * 1.0 = 150
      expect(fastScore, 150);

      final normalScore = wordSiegeScore(
        correct: true,
        responseTimeSeconds: 4.0,
        combo: 2,
      );
      // 100 * 1.2 * 1.2 = 144
      expect(normalScore, 144);

      // Wrong answer gives 0
      expect(wordSiegeScore(correct: false, responseTimeSeconds: 1.0, combo: 5), 0);
    });
  });

  group('Paragraph Architect Scoring', () {
    test('perfect order earns pair points plus exact bonus', () {
      final score = paragraphArchitectScore(
        playerOrder: [0, 1, 2, 3],
        correctOrder: [0, 1, 2, 3],
        pairPoints: 20,
        exactBonus: 50,
      );
      // 3 correct pairs * 20 + 50 = 110
      expect(score, 110);
    });

    test('partially ordered earns only pair points', () {
      final score = paragraphArchitectScore(
        playerOrder: [0, 2, 1, 3],
        correctOrder: [0, 1, 2, 3],
        pairPoints: 20,
        exactBonus: 50,
      );
      // Pairs in player order:
      // (0, 2): pos 0 < pos 2 -> OK
      // (2, 1): pos 2 < pos 1 -> False
      // (1, 3): pos 1 < pos 3 -> OK
      // 2 pairs * 20 = 40 (no exact bonus)
      expect(score, 40);
    });
  });

  group('Chunk Echo Scoring', () {
    test('exact phrase match earns full score + perfect bonus', () {
      final score = chunkEchoScore(
        playerAnswer: 'The children played happily in the park',
        correctPhrase: 'the children played happily in the park',
        baseScore: 100,
        perfectBonus: 25,
      );
      expect(score, 125);
    });

    test('partial word match earns proportional score', () {
      final score = chunkEchoScore(
        playerAnswer: 'The children in the park',
        correctPhrase: 'The children played in the park',
        baseScore: 100,
        perfectBonus: 25,
      );
      // Correct has 5 unique words: ['the', 'children', 'played', 'in', 'park']
      // Player matches: 'the', 'children', 'in', 'park' = 4 matches out of 5
      // 100 * 4 / 5 = 80
      expect(score, 80);
    });
  });
}
