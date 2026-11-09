import '../db/daos/srs_dao.dart';
import '../db/daos/stats_dao.dart';
import 'new_word_cap.dart';

/// A single mission step in the user's daily learning plan.
enum MissionType {
  srsReview,
  sentencePractice,
  wordAction,
  speedFluency,
}

class DailyMissionStep {
  final MissionType type;
  final String title;
  final String subtitle;
  final String gameRoute;
  final int targetCount;
  final int completedCount;
  final bool isCompleted;

  DailyMissionStep({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.gameRoute,
    required this.targetCount,
    this.completedCount = 0,
    this.isCompleted = false,
  });

  DailyMissionStep copyWith({
    int? completedCount,
    bool? isCompleted,
  }) {
    return DailyMissionStep(
      type: type,
      title: title,
      subtitle: subtitle,
      gameRoute: gameRoute,
      targetCount: targetCount,
      completedCount: completedCount ?? this.completedCount,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

/// The daily structured learning plan.
///
/// Balanced across Nation's four strands:
/// 1. Language-focused review (SRS Words via Word Siege or Vocab Sprint)
/// 2. Syntax & Grammar (Sentence Unscrambler)
/// 3. Speed & Fluency (Anagram Wheel)
/// 4. Meaning Input (Graded Reader / Chunk Echo)
class DailyPlan {
  final String dateKey;
  final List<DailyMissionStep> steps;
  final int dueReviewsCount;
  final int newWordsAllowed;
  final int totalMinutesTarget;

  DailyPlan({
    required this.dateKey,
    required this.steps,
    required this.dueReviewsCount,
    required this.newWordsAllowed,
    this.totalMinutesTarget = 15,
  });

  int get completedStepsCount => steps.where((s) => s.isCompleted).length;
  double get progress => steps.isEmpty ? 0.0 : completedStepsCount / steps.length;
  bool get isAllCompleted => steps.isNotEmpty && steps.every((s) => s.isCompleted);
}

/// Builds and manages today's learning plan based on SRS backlog and daily stats.
class DailyPlanBuilder {
  final SrsDao srsDao;
  final StatsDao statsDao;

  DailyPlanBuilder({required this.srsDao, required this.statsDao});

  Future<DailyPlan> buildPlanForToday({DateTime? now}) async {
    final today = now ?? DateTime.now();
    final todayKey =
        '${today.year.toString().padLeft(4, '0')}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    final dueCount = await srsDao.getDueCount();
    final allowedNewWords = newWordsAllowedToday(dueCount, dailyTarget: 10);
    final todayStat = await statsDao.getStatForDay(todayKey);

    final itemsReviewedToday = todayStat?.itemsReviewed ?? 0;

    // Build the 4 balanced steps
    final steps = <DailyMissionStep>[
      // Step 1: SRS Backlog / Vocabulary Mastery
      DailyMissionStep(
        type: MissionType.srsReview,
        title: dueCount > 20 ? 'Clear Backlog (Word Siege)' : 'Vocabulary Sprint',
        subtitle: dueCount > 0 ? '$dueCount cards due for spaced review' : 'Quick SRS reinforcement',
        gameRoute: dueCount > 20 ? '/games/word-siege' : '/games/sprint',
        targetCount: dueCount > 0 ? dueCount.clamp(5, 30) : 10,
        completedCount: (itemsReviewedToday ~/ 2).clamp(0, 30),
        isCompleted: itemsReviewedToday >= (dueCount > 0 ? 10 : 5),
      ),

      // Step 2: Sentence Syntax
      DailyMissionStep(
        type: MissionType.sentencePractice,
        title: 'Sentence Unscrambler',
        subtitle: 'Build 5 natural sentence structures',
        gameRoute: '/games/unscrambler',
        targetCount: 5,
        completedCount: itemsReviewedToday > 10 ? 5 : 0,
        isCompleted: itemsReviewedToday > 10,
      ),

      // Step 3: Flagship Action (Word Siege)
      DailyMissionStep(
        type: MissionType.wordAction,
        title: 'Word Siege Arena',
        subtitle: 'Defend gate against 3 waves of vocab',
        gameRoute: '/games/word-siege',
        targetCount: 3,
        completedCount: itemsReviewedToday > 20 ? 3 : 0,
        isCompleted: itemsReviewedToday > 20,
      ),

      // Step 4: Fluency & Dessert
      DailyMissionStep(
        type: MissionType.speedFluency,
        title: 'Anagram Wheel',
        subtitle: 'Form words under speed pressure',
        gameRoute: '/games/anagram',
        targetCount: 1,
        completedCount: itemsReviewedToday > 25 ? 1 : 0,
        isCompleted: itemsReviewedToday > 25,
      ),
    ];

    return DailyPlan(
      dateKey: todayKey,
      steps: steps,
      dueReviewsCount: dueCount,
      newWordsAllowed: allowedNewWords,
    );
  }
}
