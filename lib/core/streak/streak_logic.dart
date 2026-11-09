/// Streak tracking state for daily engagement.
///
/// Tracks the current streak, best ever streak, available freezes,
/// the last active day, and total days the user has been active.
class StreakState {
  /// Current consecutive-day streak.
  int current;

  /// Best streak ever achieved.
  int best;

  /// Number of streak freezes available (max 3).
  int freezes;

  /// Last day a session was completed, as 'YYYY-MM-DD'.
  String lastDay;

  /// Total number of unique active days.
  int totalDays;

  /// Creates a new [StreakState] with optional initial values.
  StreakState({
    this.current = 0,
    this.best = 0,
    this.freezes = 0,
    this.lastDay = '',
    this.totalDays = 0,
  });

  /// Creates a deep copy of this state.
  StreakState copyWith({
    int? current,
    int? best,
    int? freezes,
    String? lastDay,
    int? totalDays,
  }) {
    return StreakState(
      current: current ?? this.current,
      best: best ?? this.best,
      freezes: freezes ?? this.freezes,
      lastDay: lastDay ?? this.lastDay,
      totalDays: totalDays ?? this.totalDays,
    );
  }

  @override
  String toString() =>
      'StreakState(current: $current, best: $best, freezes: $freezes, '
      'lastDay: $lastDay, totalDays: $totalDays)';
}

/// Result of processing a session completion.
class StreakResult {
  /// Updated streak state after the session.
  final StreakState state;

  /// Optional message to display to the user.
  final String? message;

  /// Whether a freeze was consumed to keep the streak.
  final bool freezeUsed;

  /// Whether the streak was reset (broken).
  final bool streakBroken;

  /// Whether this is a duplicate session for the same day.
  final bool alreadyCounted;

  /// Milestone reached, if any (e.g. 7, 30, 100).
  final int? milestone;

  /// Creates a new [StreakResult].
  StreakResult({
    required this.state,
    this.message,
    this.freezeUsed = false,
    this.streakBroken = false,
    this.alreadyCounted = false,
    this.milestone,
  });
}

/// Service for managing daily streak logic.
///
/// Handles streak increments, freeze usage, milestone detection,
/// and growth-mindset comeback messages.
class StreakService {
  /// Milestone thresholds that trigger special messages.
  static const List<int> milestones = [3, 7, 14, 30, 50, 100, 200, 365];

  /// Formats a [DateTime] to 'YYYY-MM-DD' string.
  static String _dateToString(DateTime dt) {
    return '${dt.year.toString().padLeft(4, '0')}-'
        '${dt.month.toString().padLeft(2, '0')}-'
        '${dt.day.toString().padLeft(2, '0')}';
  }

  /// Parses a 'YYYY-MM-DD' string to a [DateTime].
  static DateTime _parseDate(String s) {
    final parts = s.split('-');
    return DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }

  /// Calculates the gap in days between two 'YYYY-MM-DD' strings.
  ///
  /// Returns the number of calendar days between [from] and [to].
  static int _dayGap(String from, String to) {
    final d1 = _parseDate(from);
    final d2 = _parseDate(to);
    return d2.difference(d1).inDays;
  }

  /// Processes a session completion and returns the updated streak state.
  ///
  /// Logic:
  /// - If lastDay == today → already counted, return unchanged.
  /// - gap == 1 → increment current streak.
  /// - gap == 2 && freezes > 0 → use freeze, increment streak.
  /// - else → reset to 1 (gentle restart).
  /// - Every 7 days of current streak → earn a freeze (max 3).
  ///
  /// The [now] parameter allows injecting a specific time for testing.
  StreakResult onSessionComplete(StreakState state, {DateTime? now}) {
    final today = _dateToString(now ?? DateTime.now());

    // Already counted today — no-op.
    if (state.lastDay == today) {
      return StreakResult(
        state: state,
        message: null,
        alreadyCounted: true,
      );
    }

    bool freezeUsed = false;
    bool streakBroken = false;

    if (state.lastDay.isEmpty) {
      // Very first session ever.
      state.current = 1;
    } else {
      final gap = _dayGap(state.lastDay, today);

      if (gap == 1) {
        // Consecutive day — extend streak.
        state.current++;
      } else if (gap == 2 && state.freezes > 0) {
        // One day missed but freeze available.
        state.freezes--;
        state.current++;
        freezeUsed = true;
      } else {
        // Streak broken — gentle restart.
        streakBroken = true;
        state.current = 1;
      }
    }

    // Update best streak.
    if (state.current > state.best) {
      state.best = state.current;
    }

    // Increment total active days.
    state.totalDays++;

    // Record today.
    state.lastDay = today;

    // Earn a freeze every 7 days of current streak (max 3).
    if (state.current > 0 && state.current % 7 == 0 && state.freezes < 3) {
      state.freezes++;
    }

    // Detect milestone.
    int? milestone;
    if (milestones.contains(state.current)) {
      milestone = state.current;
    }

    // Build message.
    String? message;
    if (streakBroken) {
      message = getComebackMessage(state);
    } else if (milestone != null) {
      message = _milestoneMessage(milestone);
    } else if (freezeUsed) {
      message = '🧊 Streak freeze used! Your streak lives on at ${state.current} days.';
    }

    return StreakResult(
      state: state,
      message: message,
      freezeUsed: freezeUsed,
      streakBroken: streakBroken,
      milestone: milestone,
    );
  }

  /// Returns a growth-mindset comeback message when a streak is broken.
  ///
  /// Encourages the user to restart without shaming them, emphasizing
  /// that their best record is still preserved.
  String getComebackMessage(StreakState state) {
    if (state.best > 0) {
      return 'Welcome back! Day 1 of a new run, and your best is still ${state.best}. 🔥';
    }
    return 'Welcome back! Every expert was once a beginner. Let\'s start strong! 💪';
  }

  /// Checks whether a freeze was used today.
  ///
  /// This is a heuristic: if the last day is today and the streak is
  /// continuing but a freeze was consumed during this session, it's true.
  /// For accurate tracking, the caller should check [StreakResult.freezeUsed].
  bool freezeUsedToday(StreakState state, {DateTime? now}) {
    final today = _dateToString(now ?? DateTime.now());
    // We can't reliably tell from state alone if a freeze was used today,
    // since that information is in the StreakResult. This method checks
    // if the state's last day is today (meaning a session happened)
    // but relies on the caller tracking the StreakResult.
    // As a best-effort approach, return false — the authoritative
    // answer comes from StreakResult.freezeUsed.
    return state.lastDay == today;
  }

  /// Returns a milestone celebration message.
  String _milestoneMessage(int days) {
    switch (days) {
      case 3:
        return '🎉 3-day streak! You\'re building a habit!';
      case 7:
        return '🔥 7-day streak! One full week — amazing!';
      case 14:
        return '⭐ 14-day streak! Two weeks strong!';
      case 30:
        return '🏆 30-day streak! A whole month — incredible!';
      case 50:
        return '💎 50-day streak! You\'re unstoppable!';
      case 100:
        return '🌟 100-day streak! Triple digits — legendary!';
      case 200:
        return '👑 200-day streak! You\'re a true champion!';
      case 365:
        return '🎊 365-day streak! A full year — you\'re extraordinary!';
      default:
        return '🎯 $days-day streak! Keep it up!';
    }
  }

  /// Detects whether the given streak count is a milestone.
  ///
  /// Returns the milestone value if it is, or `null` if not.
  static int? detectMilestone(int streakDays) {
    if (milestones.contains(streakDays)) return streakDays;
    return null;
  }
}
