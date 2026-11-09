import 'package:flutter_test/flutter_test.dart';
import 'package:english_arena/core/srs/sm2.dart';

void main() {
  group('SM-2 Edge Cases & Stress Tests', () {
    test('instant response (0ms) produces high quality and valid interval', () {
      final card = SrsCard(
        ease: 2.5,
        interval: 0,
        reps: 0,
        lapses: 0,
      );

      final quality = mapGameResultToQuality(
        correct: true,
        responseTimeSeconds: 0.0,
      );
      expect(quality, 5);

      review(card, quality);
      expect(card.reps, 1);
      expect(card.interval, 1);
      expect(card.ease, greaterThanOrEqualTo(2.5));
    });

    test('extremely slow response (> 60s) maps to slow quality (3) if correct', () {
      final quality = mapGameResultToQuality(
        correct: true,
        responseTimeSeconds: 75.0,
      );
      expect(quality, 3);
    });

    test('ease factor strictly clamped at minimum 1.3 after 20 consecutive failures', () {
      final card = SrsCard(
        ease: 1.5,
        interval: 25,
        reps: 5,
        lapses: 0,
      );

      for (int i = 0; i < 20; i++) {
        review(card, 0);
        expect(card.ease, greaterThanOrEqualTo(1.3));
        expect(card.reps, 0);
        expect(card.interval, 1);
      }
      expect(card.ease, 1.3);
      expect(card.lapses, 20);
    });

    test('ease factor strictly clamped at maximum 3.0 after 30 consecutive perfect scores', () {
      final card = SrsCard(
        ease: 2.8,
        interval: 0,
        reps: 0,
        lapses: 0,
      );

      for (int i = 0; i < 30; i++) {
        review(card, 5);
        expect(card.ease, lessThanOrEqualTo(3.0));
      }
      expect(card.ease, 3.0);
    });

    test('quality below 3 resets reps and sets interval to 1 day', () {
      final card = SrsCard(
        ease: 2.6,
        interval: 45,
        reps: 7,
        lapses: 0,
      );

      review(card, 2);
      expect(card.reps, 0);
      expect(card.interval, 1);
      expect(card.lapses, 1);
    });

    test('tap mode caps quality to at most 3 even if instant', () {
      final quality = mapGameResultToQuality(
        correct: true,
        responseTimeSeconds: 0.5,
        tapMode: true,
      );
      expect(quality, 3);
    });

    test('using Echo hint caps quality to at most 3', () {
      final quality = mapGameResultToQuality(
        correct: true,
        responseTimeSeconds: 1.2,
        hintUsed: true,
      );
      expect(quality, 3);
    });
  });
}
