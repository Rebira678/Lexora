import 'package:flutter_test/flutter_test.dart';
import 'package:english_arena/core/streak/streak_logic.dart';

void main() {
  late StreakService streakService;

  setUp(() {
    streakService = StreakService();
  });

  group('StreakService Tests', () {
    test('first session initializes current to 1 and totalDays to 1', () {
      final state = StreakState();
      final now = DateTime(2026, 11, 1);
      final result = streakService.onSessionComplete(state, now: now);

      expect(result.state.current, 1);
      expect(result.state.best, 1);
      expect(result.state.totalDays, 1);
      expect(result.state.lastDay, '2026-11-01');
      expect(result.alreadyCounted, isFalse);
    });

    test('second session on same day is ignored (alreadyCounted)', () {
      final state = StreakState(current: 5, best: 5, totalDays: 10, lastDay: '2026-11-01');
      final now = DateTime(2026, 11, 1, 15, 30);
      final result = streakService.onSessionComplete(state, now: now);

      expect(result.alreadyCounted, isTrue);
      expect(result.state.current, 5);
      expect(result.state.totalDays, 10);
    });

    test('consecutive day increments current and updates best', () {
      final state = StreakState(current: 3, best: 3, totalDays: 3, lastDay: '2026-11-01');
      final now = DateTime(2026, 11, 2);
      final result = streakService.onSessionComplete(state, now: now);

      expect(result.state.current, 4);
      expect(result.state.best, 4);
      expect(result.state.totalDays, 4);
      expect(result.state.lastDay, '2026-11-02');
    });

    test('gap of 2 days with freeze uses freeze and keeps streak alive', () {
      final state = StreakState(current: 10, best: 10, freezes: 2, totalDays: 10, lastDay: '2026-11-01');
      final now = DateTime(2026, 11, 3); // missed 2026-11-02
      final result = streakService.onSessionComplete(state, now: now);

      expect(result.freezeUsed, isTrue);
      expect(result.streakBroken, isFalse);
      expect(result.state.freezes, 1);
      expect(result.state.current, 11);
      expect(result.state.best, 11);
      expect(result.state.totalDays, 11);
    });

    test('gap of 2 days without freeze resets current to 1 gently without resetting totalDays or best', () {
      final state = StreakState(current: 12, best: 12, freezes: 0, totalDays: 20, lastDay: '2026-11-01');
      final now = DateTime(2026, 11, 3);
      final result = streakService.onSessionComplete(state, now: now);

      expect(result.streakBroken, isTrue);
      expect(result.freezeUsed, isFalse);
      expect(result.state.current, 1);
      expect(result.state.best, 12);
      expect(result.state.totalDays, 21);
    });

    test('earns a freeze every 7 days up to cap of 3', () {
      final state = StreakState(current: 6, best: 6, freezes: 0, totalDays: 6, lastDay: '2026-11-06');
      final now = DateTime(2026, 11, 7);
      final result = streakService.onSessionComplete(state, now: now);

      expect(result.state.current, 7);
      expect(result.state.freezes, 1);

      // Max freeze capped at 3
      final stateCapped = StreakState(current: 13, best: 13, freezes: 3, totalDays: 13, lastDay: '2026-11-13');
      final resultCapped = streakService.onSessionComplete(stateCapped, now: DateTime(2026, 11, 14));
      expect(resultCapped.state.current, 14);
      expect(resultCapped.state.freezes, 3); // still 3
    });
  });
}
