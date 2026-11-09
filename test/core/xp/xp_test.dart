import 'package:flutter_test/flutter_test.dart';
import 'package:english_arena/core/xp/xp_service.dart';

void main() {
  late XpService xpService;

  setUp(() {
    xpService = XpService();
  });

  group('XpService Level & Rank Tests', () {
    test('level 1 requires 0 XP', () {
      expect(xpService.xpForLevel(1), 0);
    });

    test('level calculation from XP progresses monotonically', () {
      expect(xpService.levelFromXp(0), 1);
      final l2Xp = xpService.xpForLevel(2);
      expect(xpService.levelFromXp(l2Xp), 2);
      expect(xpService.levelFromXp(l2Xp - 1), 1);
    });

    test('ranks correctly match level brackets', () {
      expect(xpService.rankForLevel(1), 'Rookie');
      expect(xpService.rankForLevel(4), 'Rookie');
      expect(xpService.rankForLevel(5), 'Explorer');
      expect(xpService.rankForLevel(9), 'Explorer');
      expect(xpService.rankForLevel(10), 'Word Hunter');
      expect(xpService.rankForLevel(15), 'Phrase Fighter');
      expect(xpService.rankForLevel(20), 'Grammar Knight');
      expect(xpService.rankForLevel(25), 'Fluency Captain');
      expect(xpService.rankForLevel(30), 'Wordsmith');
      expect(xpService.rankForLevel(35), 'English Master');
      expect(xpService.rankForLevel(50), 'English Master');
    });

    test('addXp triggers leveledUp when passing threshold', () {
      final state = XpState(totalXp: 0, level: 1, rank: 'Rookie');
      final l2 = xpService.xpForLevel(2);
      final result = xpService.addXp(state, l2 + 10);

      expect(result.leveledUp, isTrue);
      expect(result.state.level, 2);
      expect(result.previousLevel, 1);
      expect(result.xpAdded, l2 + 10);
    });

    test('calculateXp awards bonuses for speed and combo and subtracts hint penalty', () {
      final xp = xpService.calculateXp(
        basePoints: 100,
        speedMultiplier: 1.5,
        combo: 5, // 1 + 0.5 = 1.5
        hintPenalty: 20,
      );
      // 100 * 1.5 * 1.5 - 20 = 225 - 20 = 205
      expect(xp, 205);
    });

    test('calculateXp caps combo bonus at 10 (2.0x)', () {
      final xp1 = xpService.calculateXp(
        basePoints: 100,
        speedMultiplier: 1.0,
        combo: 10,
      );
      final xp2 = xpService.calculateXp(
        basePoints: 100,
        speedMultiplier: 1.0,
        combo: 20, // should still be capped at 10
      );
      expect(xp1, 200);
      expect(xp2, 200);
    });
  });
}
