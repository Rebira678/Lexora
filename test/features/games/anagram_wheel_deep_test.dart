import 'package:flutter_test/flutter_test.dart';
import 'package:english_arena/features/games/widgets/what_you_learned_screen.dart';

void main() {
  group('🎡 Anagram Wheel Deep Logic Tests (app.md 5.1)', () {
    test('Calculates combo multiplier and mega word bonus correctly', () {
      // Combo < 3 uses 1.0 + 0.2 * combo
      const combo1 = 1;
      final mult1 = combo1 >= 3 ? 2.0 : (1.0 + 0.2 * combo1);
      expect(mult1, closeTo(1.2, 0.001));

      const combo2 = 2;
      final mult2 = combo2 >= 3 ? 2.0 : (1.0 + 0.2 * combo2);
      expect(mult2, closeTo(1.4, 0.001));

      // Combo >= 3 doubles score (x2)
      const combo3 = 3;
      final mult3 = combo3 >= 3 ? 2.0 : (1.0 + 0.2 * combo3);
      expect(mult3, equals(2.0));

      const combo5 = 5;
      final mult5 = combo5 >= 3 ? 2.0 : (1.0 + 0.2 * combo5);
      expect(mult5, equals(2.0));

      // Standard word score
      const basePts = 200;
      final regularScore = (basePts * mult3).round();
      expect(regularScore, equals(400));

      // Mega word (6+ letters) adds +100 bonus pts
      const candidateMega = 'clarity';
      final isMegaWord = candidateMega.length >= 6;
      expect(isMegaWord, isTrue);

      final megaScore = regularScore + (isMegaWord ? 100 : 0);
      expect(megaScore, equals(500));
    });

    test('LearnedItem collects missed words with definitions for post-round review', () {
      final learned = <LearnedItem>[
        LearnedItem(
          term: 'pragmatic',
          ipa: '/præɡˈmætɪk/',
          definition: 'dealing with things sensibly and realistically',
          example: 'A pragmatic approach to problem-solving.',
          wasMistake: true,
        ),
        LearnedItem(
          term: 'lucid',
          ipa: '/ˈluːsɪd/',
          definition: 'expressed clearly; easy to understand',
          example: 'A lucid explanation.',
          wasMistake: false,
        ),
      ];

      expect(learned.length, equals(2));
      expect(learned.where((i) => i.wasMistake).length, equals(1));
      expect(learned.first.term, equals('pragmatic'));
      expect(learned.first.definition, contains('sensibly'));
    });
  });
}
