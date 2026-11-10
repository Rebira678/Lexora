import 'package:flutter_test/flutter_test.dart';
import 'package:english_arena/core/scoring/scoring.dart';

void main() {
  group('Phase 2: X-Ray Span Scoring (Spec 21.4)', () {
    test('perfect match on subject, verb, and extras scores 1.0', () {
      final score = xraySpanScore(
        tappedSubject: {0, 1},
        correctSubject: {0, 1},
        tappedVerb: {2},
        correctVerb: {2},
        tappedExtras: {3, 4, 5},
        correctExtras: {3, 4, 5},
      );
      expect(score, closeTo(1.0, 0.001));
    });

    test('partial match calculates weighted Jaccard accurately (0.35 + 0.35 + 0.30)', () {
      // Subject: tapped {0}, correct {0, 1} -> J = 1/2 = 0.5 -> 0.35 * 0.5 = 0.175
      // Verb: tapped {2}, correct {2} -> J = 1.0 -> 0.35 * 1.0 = 0.350
      // Extras: tapped {3, 4}, correct {3, 4, 5} -> J = 2/3 ≈ 0.6667 -> 0.30 * 0.6667 = 0.200
      // Total = 0.175 + 0.350 + 0.200 = 0.725
      final score = xraySpanScore(
        tappedSubject: {0},
        correctSubject: {0, 1},
        tappedVerb: {2},
        correctVerb: {2},
        tappedExtras: {3, 4},
        correctExtras: {3, 4, 5},
      );
      expect(score, closeTo(0.725, 0.01));
    });

    test('completely mismatched spans score 0.0', () {
      final score = xraySpanScore(
        tappedSubject: {5},
        correctSubject: {0, 1},
        tappedVerb: {4},
        correctVerb: {2},
        tappedExtras: {0},
        correctExtras: {3, 4, 5},
      );
      expect(score, closeTo(0.0, 0.001));
    });
  });

  group('Phase 2: Slice It Cut Scoring', () {
    test('exact cuts match returns 1.0', () {
      final score = sliceItScore(
        tappedCuts: {1, 3, 6},
        correctCuts: {1, 3, 6},
      );
      expect(score, closeTo(1.0, 0.001));
    });

    test('partial cuts return Jaccard index', () {
      // intersection {1, 3} (2), union {1, 2, 3, 6} (4) -> 2/4 = 0.5
      final score = sliceItScore(
        tappedCuts: {1, 2, 3},
        correctCuts: {1, 3, 6},
      );
      expect(score, closeTo(0.5, 0.001));
    });

    test('no overlap returns 0.0', () {
      final score = sliceItScore(
        tappedCuts: {4, 5},
        correctCuts: {1, 2},
      );
      expect(score, closeTo(0.0, 0.001));
    });
  });
}
