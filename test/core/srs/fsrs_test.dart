import 'package:flutter_test/flutter_test.dart';
import 'package:english_arena/core/srs/fsrs.dart';

void main() {
  group('FSRS Scheduler Tests', () {
    late FsrsScheduler scheduler;

    setUp(() {
      scheduler = const FsrsScheduler(desiredRetention: 0.90);
    });

    test('Initial review creates valid card state for all ratings', () {
      final now = DateTime(2026, 1, 1, 10, 0);

      // Again
      final cardAgain = scheduler.reviewCard(FsrsCard(), FsrsRating.again, now: now);
      expect(cardAgain.reps, 0);
      expect(cardAgain.lapses, 1);
      expect(cardAgain.stability, greaterThan(0));
      expect(cardAgain.difficulty, inInclusiveRange(1.0, 10.0));
      expect(cardAgain.due.isAfter(now), isTrue);

      // Good
      final cardGood = scheduler.reviewCard(FsrsCard(), FsrsRating.good, now: now);
      expect(cardGood.reps, 1);
      expect(cardGood.lapses, 0);
      expect(cardGood.stability, greaterThan(cardAgain.stability));
      expect(cardGood.interval, greaterThanOrEqualTo(1));
      expect(cardGood.due.isAfter(now), isTrue);

      // Easy
      final cardEasy = scheduler.reviewCard(FsrsCard(), FsrsRating.easy, now: now);
      expect(cardEasy.reps, 1);
      expect(cardEasy.stability, greaterThan(cardGood.stability));
      expect(cardEasy.interval, greaterThan(cardGood.interval));
    });

    test('Retrievability decays predictably over time', () {
      final now = DateTime(2026, 1, 1, 12, 0);
      final card = scheduler.reviewCard(FsrsCard(), FsrsRating.good, now: now);

      // Immediately after review, retrievability should be near 1.0
      expect(card.retrievability(now: now), closeTo(1.0, 0.01));

      // At exactly t = stability, retrievability should be close to desired retention (0.90)
      final atStability = now.add(Duration(hours: (card.stability * 24).round()));
      expect(card.retrievability(now: atStability), closeTo(0.90, 0.05));

      // After 30 days, retrievability should be substantially lower
      final after30Days = now.add(const Duration(days: 30));
      expect(card.retrievability(now: after30Days), lessThan(0.90));
    });

    test('Repeated successful reviews increase stability and interval', () {
      var card = FsrsCard();
      var time = DateTime(2026, 1, 1, 10, 0);

      card = scheduler.reviewCard(card, FsrsRating.good, now: time);
      final firstInterval = card.interval;

      time = card.due;
      card = scheduler.reviewCard(card, FsrsRating.good, now: time);
      final secondInterval = card.interval;

      time = card.due;
      card = scheduler.reviewCard(card, FsrsRating.good, now: time);
      final thirdInterval = card.interval;

      expect(secondInterval, greaterThanOrEqualTo(firstInterval));
      expect(thirdInterval, greaterThan(secondInterval));
      expect(card.reps, 3);
      expect(card.lapses, 0);
    });

    test('Lapse resets reps and penalizes stability', () {
      var card = FsrsCard();
      var time = DateTime(2026, 1, 1, 10, 0);

      // Two successful reviews
      card = scheduler.reviewCard(card, FsrsRating.good, now: time);
      time = card.due;
      card = scheduler.reviewCard(card, FsrsRating.good, now: time);
      final highStability = card.stability;

      // Now lapse (again)
      time = card.due;
      card = scheduler.reviewCard(card, FsrsRating.again, now: time);

      expect(card.reps, 0);
      expect(card.lapses, 1);
      expect(card.stability, lessThan(highStability));
    });
  });
}
