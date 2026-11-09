import 'package:flutter_test/flutter_test.dart';
import 'package:english_arena/core/srs/sm2.dart';

void main() {
  group('SM-2 Core Algorithm', () {
    test('initial card defaults are correct', () {
      final card = SrsCard();
      expect(card.ease, 2.5);
      expect(card.interval, 0);
      expect(card.reps, 0);
      expect(card.lapses, 0);
    });

    test('first successful review (quality >= 3) sets interval to 1 day', () {
      final card = SrsCard();
      review(card, 4);
      expect(card.reps, 1);
      expect(card.interval, 1);
      expect(card.lapses, 0);
    });

    test('second successful review sets interval to 6 days', () {
      final card = SrsCard();
      review(card, 4); // rep 1 -> interval 1
      review(card, 4); // rep 2 -> interval 6
      expect(card.reps, 2);
      expect(card.interval, 6);
    });

    test('third successful review multiplies interval by ease factor', () {
      final card = SrsCard(ease: 2.5);
      review(card, 5); // rep 1 -> 1
      review(card, 5); // rep 2 -> 6
      final prevEase = card.ease;
      review(card, 5); // rep 3 -> round(6 * prevEase)
      expect(card.reps, 3);
      expect(card.interval, (6 * prevEase).round());
    });

    test('failed review (quality < 3) resets reps to 0, sets interval to 1, and increments lapses', () {
      final card = SrsCard();
      review(card, 5);
      review(card, 5);
      expect(card.reps, 2);
      expect(card.interval, 6);

      review(card, 2); // fail
      expect(card.reps, 0);
      expect(card.interval, 1);
      expect(card.lapses, 1);
    });

    test('ease factor remains clamped between 1.3 and 3.0', () {
      final card = SrsCard(ease: 1.3);
      // Repeated low quality should not drop ease below 1.3
      for (int i = 0; i < 10; i++) {
        review(card, 0);
      }
      expect(card.ease, 1.3);

      // Repeated perfect quality should not exceed 3.0
      for (int i = 0; i < 30; i++) {
        review(card, 5);
      }
      expect(card.ease, 3.0);
    });
  });

  group('SM-2 Quality Mapping', () {
    test('Word Siege quality mapping logic via enum', () {
      expect(wordSiegeQuality(WordSiegeOutcome.perfectFast), 5);
      expect(wordSiegeQuality(WordSiegeOutcome.correctMedium), 4);
      expect(wordSiegeQuality(WordSiegeOutcome.correctSlow), 3);
      expect(wordSiegeQuality(WordSiegeOutcome.correctWithHint), 3);
      expect(wordSiegeQuality(WordSiegeOutcome.wrongThenCorrected), 2);
      expect(wordSiegeQuality(WordSiegeOutcome.enemyReachedGate), 1);
      expect(wordSiegeQuality(WordSiegeOutcome.bombUsed), 1);
    });

    test('mapGameResultToQuality mapping logic', () {
      // Reached gate -> 1
      expect(
        mapGameResultToQuality(correct: false, enemyReachedGate: true),
        1,
      );

      // Bomb used -> 1
      expect(
        mapGameResultToQuality(correct: false, bombUsed: true),
        1,
      );

      // Wrong then corrected -> 2
      expect(
        mapGameResultToQuality(correct: true, wrongThenCorrected: true),
        2,
      );

      // Used hint -> 3
      expect(
        mapGameResultToQuality(correct: true, responseTimeSeconds: 1.5, hintUsed: true),
        3,
      );

      // Tap mode -> 3
      expect(
        mapGameResultToQuality(correct: true, responseTimeSeconds: 1.2, tapMode: true),
        3,
      );

      // Slow (> 6s) -> 3
      expect(
        mapGameResultToQuality(correct: true, responseTimeSeconds: 6.5),
        3,
      );

      // Typed normal (3-6s) -> 4
      expect(
        mapGameResultToQuality(correct: true, responseTimeSeconds: 4.0),
        4,
      );

      // Typed fast (< 3s), no hint -> 5
      expect(
        mapGameResultToQuality(correct: true, responseTimeSeconds: 2.1),
        5,
      );
    });
  });

  group('isDue card checker', () {
    test('new card with due in the past or now is due', () {
      final past = SrsCard(due: DateTime.now().subtract(const Duration(minutes: 5)));
      expect(isDue(past), isTrue);

      final future = SrsCard(due: DateTime.now().add(const Duration(days: 2)));
      expect(isDue(future), isFalse);
    });
  });
}
