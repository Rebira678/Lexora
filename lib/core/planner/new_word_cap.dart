/// Calculates how many new words the user is allowed to learn today.
///
/// The cap is based on the number of [dueReviews] — the more reviews
/// pending, the fewer new words are introduced. This prevents the user
/// from being overwhelmed by a growing review backlog.
///
/// Thresholds:
/// - dueReviews > 80 → 0 new words (focus entirely on reviews)
/// - dueReviews > 60 → 3 new words
/// - dueReviews > 40 → half of [dailyTarget]
/// - dueReviews <= 40 → full [dailyTarget]
///
/// The [dailyTarget] defaults to 10 new words per day.
int newWordsAllowedToday(int dueReviews, {int dailyTarget = 10}) {
  if (dueReviews > 80) return 0;
  if (dueReviews > 60) return 3;
  if (dueReviews > 40) return (dailyTarget * 0.5).round();
  return dailyTarget;
}
