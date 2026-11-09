/// App-wide constants for English Arena.
class AppConstants {
  AppConstants._();

  // App info
  static const String appName = 'English Arena';
  static const String appVersion = '1.0.0';

  // Content versioning — bump when JSON content is updated
  static const int contentVersion = 1;

  // Session caps
  static const int maxSessionMinutes = 25;
  static const int softCapMinutes = 20;

  // SRS defaults
  static const double defaultEase = 2.5;
  static const double minEase = 1.3;
  static const double maxEase = 3.0;
  static const int maxNewWordsPerDay = 12;
  static const int maxReviewsPerSession = 40;

  // Game defaults
  static const int roundDurationSeconds = 120;
  static const int targetAccuracyMin = 75;
  static const int targetAccuracyMax = 85;

  // Streak
  static const int maxFreezes = 3;
  static const int freezeEarnInterval = 7; // days
  static const List<int> streakMilestones = [3, 7, 14, 30, 50, 100, 200, 365];

  // XP
  static const double xpLevelExponent = 1.5;
  static const int xpLevelBase = 100;

  // Ranks
  static const Map<int, String> ranks = {
    1: 'Rookie',
    5: 'Explorer',
    10: 'Word Hunter',
    15: 'Phrase Fighter',
    20: 'Grammar Knight',
    25: 'Fluency Captain',
    30: 'Wordsmith',
    35: 'English Master',
  };

  // Timing thresholds (milliseconds) for speed scoring
  static const int fastThresholdMs = 3000;
  static const int normalThresholdMs = 6000;

  // Speed multipliers
  static const double speedFast = 1.5;
  static const double speedNormal = 1.2;
  static const double speedSlow = 1.0;

  // Growth mindset messages for mistakes
  static const List<String> mistakeMessages = [
    "Almost! You'll get it next time.",
    "That one's tough, so it's good you tried.",
    "Your brain is building the memory. Try once more!",
    "Great effort! This word will stick soon.",
    "Mistakes are how the brain learns. Keep going!",
    "You're getting closer every time.",
    "This is exactly how learning works. Well done for trying!",
  ];

  // Comeback messages (streak broken)
  static const List<String> comebackMessages = [
    "Welcome back! Day 1 of a new run.",
    "Great to see you again! Let's pick up where we left off.",
    "Every champion takes a break. Ready for a fresh start?",
    "Your skills are still here. Let's build on them!",
  ];

  // Celebration messages
  static const List<String> celebrationMessages = [
    "Incredible! You're on fire! 🔥",
    "Amazing progress! Keep it up! ⭐",
    "You're getting stronger every day! 💪",
    "What a great session! 🎯",
    "Your English is leveling up! 🚀",
  ];

  // Sentence difficulty levels
  static const Map<int, String> sentenceLevelNames = {
    1: 'Simple',
    2: 'Compound',
    3: 'One clause',
    4: 'Concession',
    5: 'Multi-layer',
    6: 'Academic',
  };

  // CEFR levels
  static const List<String> cefrLevels = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];

  // Database
  static const String dbFileName = 'english_arena.sqlite';
  static const int dbVersion = 1;
}
