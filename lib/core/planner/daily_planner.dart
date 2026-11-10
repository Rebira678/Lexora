import '../db/daos/srs_dao.dart';
import '../db/daos/stats_dao.dart';
import 'new_word_cap.dart';

/// Type of pedagogical mission step.
enum MissionType {
  srsReview,
  vocabularyAcquisition,
  readingSyntax,
  listeningShadowing,
  writtenProduction,
  speedFluency,
  sentencePractice,
  wordAction,
}

/// A structured step in the 30-minute daily learning plan (Spec 22.1).
class DailyMissionStep {
  final int stepNumber; // 1 to 5
  final MissionType type;
  final String skill; // Vocabulary, Morphology, Reading, Listening, Writing
  final int durationMinutes; // 8, 5, 8, 5, 4
  final String title;
  final String subtitle;
  final String gameRoute;
  final int targetCount;
  final int completedCount;
  final bool isCompleted;
  final bool isMinimumDayRequirement; // Step 1 and Step 3 are minimum day requirements

  DailyMissionStep({
    required this.stepNumber,
    required this.type,
    required this.skill,
    required this.durationMinutes,
    required this.title,
    required this.subtitle,
    required this.gameRoute,
    required this.targetCount,
    this.completedCount = 0,
    this.isCompleted = false,
    this.isMinimumDayRequirement = false,
  });

  DailyMissionStep copyWith({
    int? completedCount,
    bool? isCompleted,
  }) {
    return DailyMissionStep(
      stepNumber: stepNumber,
      type: type,
      skill: skill,
      durationMinutes: durationMinutes,
      title: title,
      subtitle: subtitle,
      gameRoute: gameRoute,
      targetCount: targetCount,
      completedCount: completedCount ?? this.completedCount,
      isCompleted: isCompleted ?? this.isCompleted,
      isMinimumDayRequirement: isMinimumDayRequirement,
    );
  }
}

/// Metadata and curriculum benchmarks for a single Phase (Phases 1 to 5).
class PhaseMilestone {
  final int phaseNumber;
  final String name;
  final String timeHorizon; // e.g. "Weeks 1–6 (Days 1–42)"
  final String cefrGoal; // "B2 Foundation", "C1 Fluency", "C2 Mastery"
  final String coreFocus;
  final List<String> primaryGames;
  final String vocabularyTarget;
  final String sentenceTarget;
  final String weeklyRoutineSummary;

  const PhaseMilestone({
    required this.phaseNumber,
    required this.name,
    required this.timeHorizon,
    required this.cefrGoal,
    required this.coreFocus,
    required this.primaryGames,
    required this.vocabularyTarget,
    required this.sentenceTarget,
    required this.weeklyRoutineSummary,
  });
}

/// All 5 Phases systematically documented from Spec Section 23.
class PhaseCurriculum {
  static const List<PhaseMilestone> phases = [
    PhaseMilestone(
      phaseNumber: 1,
      name: 'Action Game & Habit Foundation',
      timeHorizon: 'Weeks 1–6 (Days 1–42)',
      cefrGoal: 'Solid B2 Benchmark',
      coreFocus: 'Replace action game gaming addiction with linguistic gameplay. Establish daily 30-min habit.',
      primaryGames: ['Word Siege', 'Vocabulary Sprint', 'Sentence Unscrambler', 'Anagram Wheel'],
      vocabularyTarget: '+300 core NGSL words',
      sentenceTarget: 'Levels 1–2 simple & compound sentences',
      weeklyRoutineSummary: 'Daily SRS reviews + fast-paced lexical sprint & unblock reflexes.',
    ),
    PhaseMilestone(
      phaseNumber: 2,
      name: 'Weak-Point Eraser & Syntax',
      timeHorizon: 'Weeks 7–12 (Days 43–84)',
      cefrGoal: 'B2 ➔ B2+ Upper Intermediate',
      coreFocus: 'Target the two primary bottlenecks: unknown words in context & clause tracking in long sentences.',
      primaryGames: [
        'Sentence X-Ray',
        'Slice It',
        'Connector Match',
        'Layer Builder',
        'Reference Hunter',
        'Summarize in 10 Words',
        'Chunk Echo',
        'Context Detective',
        'Word Family Tree',
      ],
      vocabularyTarget: '+1,000 words with collocations & families',
      sentenceTarget: 'Levels 3–4 relative & concession clauses at 80%+',
      weeklyRoutineSummary: 'Tue syntax focus, Mon morphology labs, Sat mistake notebook remediation.',
    ),
    PhaseMilestone(
      phaseNumber: 3,
      name: 'Four-Skill Fluency & Production',
      timeHorizon: 'Months 4–6 (Days 85–180)',
      cefrGoal: 'B2+ ➔ C1 Pre-Advanced',
      coreFocus: 'Active speech output, written synthesis, and endurance under timed examination conditions.',
      primaryGames: [
        '60-Second Talker',
        'Shadow Boxing',
        'Word Forge',
        'Daily Journal',
        'Mini-Email Boss',
        'Weekly Boss Battle',
        'Monthly Mock Test',
      ],
      vocabularyTarget: '+2,000 words + AWL academic word list',
      sentenceTarget: 'Level 5 multi-layered sentences with participial phrases at 80%+',
      weeklyRoutineSummary: 'Thu audio shadowing, Fri debate & impromptu speech, monthly CEFR radar check.',
    ),
    PhaseMilestone(
      phaseNumber: 4,
      name: 'C1 Push & Register Precision',
      timeHorizon: 'Months 7–12 (Days 181–365)',
      cefrGoal: 'Full C1 Advanced Competence',
      coreFocus: 'Near-synonym nuance, register shifting (formal/neutral/informal), and academic cohesion.',
      primaryGames: [
        'Nuance Duel',
        'Register Shifter',
        'Paraphrase Blitz',
        'Collocation Forge',
        'Lecture Notes',
        'Debate Mode',
        'Cohesion Fixer',
        'Paragraph Architect',
      ],
      vocabularyTarget: '+3,000 words (C1 academic & professional collocations)',
      sentenceTarget: 'Level 6 academic & legal sentences (25–40 words) at 75%+',
      weeklyRoutineSummary: 'Wed written cohesion, Thu lecture dictation, Real English input log.',
    ),
    PhaseMilestone(
      phaseNumber: 5,
      name: 'C2 Native Mastery & Rhetoric',
      timeHorizon: 'Year 2+ (Days 366+)',
      cefrGoal: 'C2 Mastery & Native Fluency',
      coreFocus: 'Rhetorical devices, classical essays, subtle nuances, publishing-grade syntax, and FSRS memory model.',
      primaryGames: [
        'Style & Rhetoric Analyzer',
        'C2 Great Works Reader',
        'Linguistic Evaluator',
        'Lexical Gap Finder',
        'Define It Yourself',
        'Sentence Race',
      ],
      vocabularyTarget: '5,000+ words including rare literary idioms & nuances',
      sentenceTarget: 'C2 literary syntax, nested inversion, chiasmus & antithesis',
      weeklyRoutineSummary: 'FSRS optimization, deep essay annotations, stylistic refinement.',
    ),
  ];

  static PhaseMilestone getPhase(int phaseNumber) {
    return phases.firstWhere(
      (p) => p.phaseNumber == phaseNumber,
      orElse: () => phases.first,
    );
  }

  static PhaseMilestone getPhaseForDay(int dayNumber) {
    if (dayNumber <= 42) return phases[0];
    if (dayNumber <= 84) return phases[1];
    if (dayNumber <= 180) return phases[2];
    if (dayNumber <= 365) return phases[3];
    return phases[4];
  }
}

/// The daily structured 30-minute learning plan (Spec Section 22).
class DailyPlan {
  final String dateKey;
  final int dayNumber;
  final int currentPhaseNumber;
  final PhaseMilestone currentPhase;
  final String dayOfWeek;
  final String dayOfWeekFocus;
  final String dayOfWeekTheme;
  final List<DailyMissionStep> steps;
  final int dueReviewsCount;
  final int newWordsAllowed;
  final int totalMinutesTarget;

  DailyPlan({
    required this.dateKey,
    required this.dayNumber,
    required this.currentPhaseNumber,
    required this.currentPhase,
    required this.dayOfWeek,
    required this.dayOfWeekFocus,
    required this.dayOfWeekTheme,
    required this.steps,
    required this.dueReviewsCount,
    required this.newWordsAllowed,
    this.totalMinutesTarget = 30,
  });

  int get completedStepsCount => steps.where((s) => s.isCompleted).length;
  double get progress => steps.isEmpty ? 0.0 : completedStepsCount / steps.length;
  bool get isFullDayCompleted => steps.isNotEmpty && steps.every((s) => s.isCompleted);
  bool get isAllCompleted => isFullDayCompleted;
  bool get isMinimumDayCompleted =>
      steps.where((s) => s.isMinimumDayRequirement).every((s) => s.isCompleted);
}

/// Builds and manages today's 30-minute learning plan based on SRS backlog,
/// day of week rotation (Spec 22.3), and Phase milestone (Spec 23).
class DailyPlanBuilder {
  final SrsDao srsDao;
  final StatsDao statsDao;

  DailyPlanBuilder({required this.srsDao, required this.statsDao});

  Future<DailyPlan> buildPlanForToday({DateTime? now, int? overrideDayNumber}) async {
    final today = now ?? DateTime.now();
    final todayKey =
        '${today.year.toString().padLeft(4, '0')}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    final dueCount = await srsDao.getDueCount();
    final allowedNewWords = newWordsAllowedToday(dueCount, dailyTarget: 10);
    final todayStat = await statsDao.getStatForDay(todayKey);
    final itemsReviewedToday = todayStat?.itemsReviewed ?? 0;
    final minutesLoggedToday = todayStat?.minutes ?? 0;

    // Calculate Day Number based on total activity days or default to Day 45 (Phase 2)
    final allStats = await statsDao.getStatsHistory(days: 365);
    final totalDaysActive = allStats.where((s) => s.goalMet == 1 || s.itemsReviewed > 0).length;
    final calculatedDay = overrideDayNumber ?? (totalDaysActive > 0 ? totalDaysActive : 45);

    final phase = PhaseCurriculum.getPhaseForDay(calculatedDay);

    // Day of week focus (Spec 22.3)
    final weekdayInt = today.weekday; // 1 = Mon, 7 = Sun
    late final String dayName;
    late final String dayFocus;
    late final String dayTheme;

    switch (weekdayInt) {
      case DateTime.monday:
        dayName = 'Monday';
        dayFocus = 'New Words & Morphology Lab';
        dayTheme = 'Word Family Tree + Prefix/Suffix Forge';
        break;
      case DateTime.tuesday:
        dayName = 'Tuesday';
        dayFocus = 'Long-Sentence Syntax Gym';
        dayTheme = 'Sentence X-Ray, Slice It & Reference Hunter';
        break;
      case DateTime.wednesday:
        dayName = 'Wednesday';
        dayFocus = 'Collocations & Written Production';
        dayTheme = 'Collocation Forge, Word Forge & Daily Journal';
        break;
      case DateTime.thursday:
        dayName = 'Thursday';
        dayFocus = 'Academic Listening & Working Memory';
        dayTheme = 'Lecture Notes, Chunk Echo & Dictation Dash';
        break;
      case DateTime.friday:
        dayName = 'Friday';
        dayFocus = 'Speaking, Discourse & Nuance';
        dayTheme = 'Debate Mode, 60-Second Talker & Nuance Duel';
        break;
      case DateTime.saturday:
        dayName = 'Saturday';
        dayFocus = 'Weekly Boss Battle & Mistake Gym';
        dayTheme = 'Defeat the 500-HP Boss & clear all flagged errors';
        break;
      case DateTime.sunday:
      default:
        dayName = 'Sunday';
        dayFocus = 'Pleasure Reading & C2 Synthesis';
        dayTheme = 'Great Works Essay, Style Analyzer & Real English input';
        break;
    }

    // Build the 5 core steps from Spec 22.1 totaling 30 minutes
    final steps = <DailyMissionStep>[
      // Step 1 (8 min): SRS review (due words first, in context)
      DailyMissionStep(
        stepNumber: 1,
        type: MissionType.srsReview,
        skill: 'Vocabulary',
        durationMinutes: 8,
        title: dueCount > 20 ? 'SRS Defense (Word Siege)' : 'Vocabulary Sprint',
        subtitle: dueCount > 0 ? '$dueCount cards due for spaced review' : 'Clear due reviews in context',
        gameRoute: dueCount > 20 ? '/games/word-siege' : '/games/sprint',
        targetCount: dueCount > 0 ? dueCount.clamp(5, 30) : 10,
        completedCount: (itemsReviewedToday ~/ 2).clamp(0, 30),
        isCompleted: itemsReviewedToday >= (dueCount > 0 ? 10 : 5),
        isMinimumDayRequirement: true, // Step 1 is essential for 5-min minimum day
      ),

      // Step 2 (5 min): Learn 8–10 new words (sentence, audio, word family, collocation)
      DailyMissionStep(
        stepNumber: 2,
        type: MissionType.vocabularyAcquisition,
        skill: 'Morphology',
        durationMinutes: 5,
        title: weekdayInt == DateTime.monday ? 'Prefix/Suffix Lab' : 'Word Family Tree',
        subtitle: 'Acquire $allowedNewWords new words with full collocations & forms',
        gameRoute: weekdayInt == DateTime.monday ? '/games/prefix-suffix' : '/games/word-family',
        targetCount: allowedNewWords,
        completedCount: itemsReviewedToday > 8 ? allowedNewWords : 0,
        isCompleted: itemsReviewedToday > 8 || minutesLoggedToday >= 10,
        isMinimumDayRequirement: false,
      ),

      // Step 3 (8 min): Read one passage + Sentence X-Ray on 2–3 hard sentences
      DailyMissionStep(
        stepNumber: 3,
        type: MissionType.readingSyntax,
        skill: 'Reading',
        durationMinutes: 8,
        title: phase.phaseNumber >= 4 ? 'C2 Great Works Reader' : 'Graded Reader & Sentence X-Ray',
        subtitle: 'Deconstruct complex clause structures & save wild words',
        gameRoute: phase.phaseNumber >= 4 ? '/reading/c2-reader' : '/reading/graded-reader',
        targetCount: 3,
        completedCount: itemsReviewedToday > 15 ? 3 : 0,
        isCompleted: itemsReviewedToday > 15 || minutesLoggedToday >= 18,
        isMinimumDayRequirement: true, // Step 3 is essential for 5-min minimum day
      ),

      // Step 4 (5 min): Listen to the same passage (audio), then shadow 3 sentences
      DailyMissionStep(
        stepNumber: 4,
        type: MissionType.listeningShadowing,
        skill: 'Listening',
        durationMinutes: 5,
        title: weekdayInt == DateTime.thursday ? 'Lecture Notes Dictation' : 'Chunk Echo & Shadowing',
        subtitle: 'Internalize rhythm boundaries at native audio speed',
        gameRoute: weekdayInt == DateTime.thursday ? '/listening/lecture-notes' : '/games/chunk-echo',
        targetCount: 3,
        completedCount: itemsReviewedToday > 20 ? 3 : 0,
        isCompleted: itemsReviewedToday > 20 || minutesLoggedToday >= 24,
        isMinimumDayRequirement: false,
      ),

      // Step 5 (4 min): Write 2 sentences with today\'s words, then expand using Layer Builder
      DailyMissionStep(
        stepNumber: 5,
        type: MissionType.writtenProduction,
        skill: 'Writing',
        durationMinutes: 4,
        title: weekdayInt == DateTime.wednesday ? 'Daily Journal' : 'Layer Builder Architecture',
        subtitle: 'Synthesize newly learned vocabulary into C1 expanded sentences',
        gameRoute: weekdayInt == DateTime.wednesday ? '/writing/daily-journal' : '/writing/layer-builder',
        targetCount: 2,
        completedCount: itemsReviewedToday > 25 ? 2 : 0,
        isCompleted: itemsReviewedToday > 25 || minutesLoggedToday >= 30,
        isMinimumDayRequirement: false,
      ),
    ];

    return DailyPlan(
      dateKey: todayKey,
      dayNumber: calculatedDay,
      currentPhaseNumber: phase.phaseNumber,
      currentPhase: phase,
      dayOfWeek: dayName,
      dayOfWeekFocus: dayFocus,
      dayOfWeekTheme: dayTheme,
      steps: steps,
      dueReviewsCount: dueCount,
      newWordsAllowed: allowedNewWords,
      totalMinutesTarget: 30,
    );
  }
}
