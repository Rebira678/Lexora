import 'package:flutter_test/flutter_test.dart';
import 'package:english_arena/core/streak/streak_logic.dart';

void main() {
  group('Streak & Freeze Edge Cases', () {
    final service = StreakService();

    test('3-freeze cap: earning freezes past 21 days never exceeds 3 freezes', () {
      var state = StreakState(
        current: 6,
        best: 6,
        freezes: 2,
        totalDays: 6,
        lastDay: '2026-03-01',
      );

      // Day 7: earn 1 freeze (now 3)
      var res = service.onSessionComplete(state, now: DateTime(2026, 3, 2));
      expect(res.state.freezes, 3);
      expect(res.state.current, 7);

      // Simulate up to Day 14
      state = StreakState(
        current: 13,
        best: 13,
        freezes: 3,
        totalDays: 13,
        lastDay: '2026-03-08',
      );
      res = service.onSessionComplete(state, now: DateTime(2026, 3, 9));
      expect(res.state.freezes, 3); // Still capped at 3
      expect(res.state.current, 14);
    });

    test('missing 1 day with 1 freeze consumes freeze and keeps streak alive', () {
      final state = StreakState(
        current: 12,
        best: 12,
        freezes: 1,
        totalDays: 12,
        lastDay: '2026-03-01',
      );

      // Played on 2026-03-03 (gap of 2 days = 1 day missed)
      final res = service.onSessionComplete(state, now: DateTime(2026, 3, 3));
      expect(res.freezeUsed, isTrue);
      expect(res.state.freezes, 0);
      expect(res.state.current, 13); // Streak continued!
      expect(res.state.totalDays, 13);
      expect(res.streakBroken, isFalse);
    });

    test('missing 2 days with only 1 freeze breaks streak gently and resets current to 1', () {
      final state = StreakState(
        current: 15,
        best: 15,
        freezes: 1,
        totalDays: 15,
        lastDay: '2026-03-01',
      );

      // Played on 2026-03-04 (gap of 3 days = 2 days missed, only 1 freeze)
      final res = service.onSessionComplete(state, now: DateTime(2026, 3, 4));
      expect(res.streakBroken, isTrue);
      expect(res.state.current, 1);
      expect(res.state.best, 15); // Best remains 15!
      expect(res.state.totalDays, 16); // Total days monotonically increments!
      expect(res.message, isNotNull);
      expect(res.message, contains('15'));
    });

    test('missing 2 days with 2 freezes consumes freeze and keeps streak alive', () {
      final state = StreakState(
        current: 18,
        best: 18,
        freezes: 2,
        totalDays: 18,
        lastDay: '2026-03-01',
      );

      // Played on 2026-03-03 (1 day missed, 1 freeze used)
      final res = service.onSessionComplete(state, now: DateTime(2026, 3, 3));
      expect(res.freezeUsed, isTrue);
      expect(res.state.freezes, 1);
      expect(res.state.current, 19); // Streak saved!
      expect(res.streakBroken, isFalse);
    });

    test('multiple sessions on same calendar day are ignored', () {
      final state = StreakState(
        current: 5,
        best: 5,
        freezes: 1,
        totalDays: 5,
        lastDay: '2026-03-05',
      );

      final res = service.onSessionComplete(state, now: DateTime(2026, 3, 5, 14, 30));
      expect(res.alreadyCounted, isTrue);
      expect(res.state.current, 5);
      expect(res.state.totalDays, 5);
    });

    test('streak comeback message uses growth mindset tone without shaming', () {
      final state = StreakState(
        current: 1,
        best: 18,
        freezes: 0,
        totalDays: 25,
        lastDay: '2026-03-10',
      );
      final message = service.getComebackMessage(state);
      expect(message, isNotEmpty);
      expect(message.toLowerCase(), isNot(contains('shame')));
      expect(message.toLowerCase(), isNot(contains('failed')));
      expect(message.toLowerCase(), isNot(contains('lost')));
      expect(message, contains('18'));
    });
  });
}
