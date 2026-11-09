import 'package:flutter_test/flutter_test.dart';
import 'package:english_arena/core/planner/new_word_cap.dart';
import 'package:english_arena/core/planner/difficulty_tuner.dart';

void main() {
  group('New Word Cap Tests', () {
    test('due reviews > 80 allows 0 new words', () {
      expect(newWordsAllowedToday(81, dailyTarget: 10), 0);
      expect(newWordsAllowedToday(120, dailyTarget: 10), 0);
    });

    test('due reviews > 60 and <= 80 allows 3 new words', () {
      expect(newWordsAllowedToday(61, dailyTarget: 10), 3);
      expect(newWordsAllowedToday(80, dailyTarget: 10), 3);
    });

    test('due reviews > 40 and <= 60 allows half of dailyTarget', () {
      expect(newWordsAllowedToday(41, dailyTarget: 10), 5);
      expect(newWordsAllowedToday(60, dailyTarget: 12), 6);
    });

    test('due reviews <= 40 allows full dailyTarget', () {
      expect(newWordsAllowedToday(40, dailyTarget: 10), 10);
      expect(newWordsAllowedToday(10, dailyTarget: 12), 12);
      expect(newWordsAllowedToday(0, dailyTarget: 8), 8);
    });
  });

  group('Difficulty Tuner Tests', () {
    test('promotes to next sentence level when acc >= 0.85 and rounds >= 3', () {
      expect(nextSentenceLevel(1, 0.90, 3), 2);
      expect(nextSentenceLevel(3, 0.85, 4), 4);
      // Caps at level 6
      expect(nextSentenceLevel(6, 0.95, 5), 6);
    });

    test('does not promote if rounds < 3', () {
      expect(nextSentenceLevel(1, 0.95, 2), 1);
    });

    test('demotes when acc < 0.60', () {
      expect(nextSentenceLevel(4, 0.50, 1), 3);
      // Floor at level 1
      expect(nextSentenceLevel(1, 0.40, 1), 1);
    });

    test('enemy speed scales with level and adapts to accuracy', () {
      final normalSpeedL1 = enemySpeed(0.75, 1);
      final highAccSpeedL1 = enemySpeed(0.90, 1);
      final lowAccSpeedL1 = enemySpeed(0.50, 1);

      expect(highAccSpeedL1, greaterThan(normalSpeedL1));
      expect(lowAccSpeedL1, lessThan(normalSpeedL1));

      final normalSpeedL5 = enemySpeed(0.75, 5);
      expect(normalSpeedL5, greaterThan(normalSpeedL1));
    });
  });
}
