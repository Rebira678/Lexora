import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/theme.dart';
import '../../app/providers.dart';
import '../../core/planner/daily_planner.dart';

import '../games/word_siege/word_siege_screen.dart';
import '../games/vocab_sprint/vocab_sprint_screen.dart';
import '../games/prefix_suffix_lab/prefix_suffix_lab_screen.dart';
import '../games/word_family_tree/word_family_tree_screen.dart';
import '../games/define_it_yourself/define_it_yourself_screen.dart';
import '../reading/reading_screen.dart';
import '../reading/c2_long_reader_screen.dart';
import '../games/sentence_xray/sentence_xray_screen.dart';
import '../games/chunk_echo/chunk_echo_screen.dart';
import '../listening/lecture_notes_screen.dart';
import '../games/layer_builder/layer_builder_screen.dart';
import '../writing/daily_journal_screen.dart';
import '../writing/word_forge_screen.dart';
import '../speaking/shadow_boxing_screen.dart';

class DailyJourneyScreen extends ConsumerStatefulWidget {
  const DailyJourneyScreen({super.key});

  @override
  ConsumerState<DailyJourneyScreen> createState() => _DailyJourneyScreenState();
}

class _DailyJourneyScreenState extends ConsumerState<DailyJourneyScreen>
    with SingleTickerProviderStateMixin {
  bool _minimumDayOnly = false;
  int _selectedRoadmapPhase = 1;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _navigateToStep(BuildContext context, DailyMissionStep step, int phaseNumber) {
    switch (step.gameRoute) {
      case '/games/word-siege':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const WordSiegeScreen(level: 3)),
        );
        break;
      case '/games/sprint':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const VocabSprintScreen()),
        );
        break;
      case '/games/prefix-suffix':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const PrefixSuffixLabScreen()),
        );
        break;
      case '/games/word-family':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const WordFamilyTreeScreen()),
        );
        break;
      case '/games/define-it-yourself':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const DefineItYourselfScreen(targetCefr: 'C1')),
        );
        break;
      case '/reading/graded-reader':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ReadingScreen()),
        );
        break;
      case '/reading/c2-reader':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const C2LongReaderScreen()),
        );
        break;
      case '/games/sentence-xray':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const SentenceXRayScreen(level: 3)),
        );
        break;
      case '/games/chunk-echo':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ChunkEchoScreen(level: 2)),
        );
        break;
      case '/listening/lecture-notes':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const LectureNotesScreen()),
        );
        break;
      case '/writing/layer-builder':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const LayerBuilderScreen(level: 2)),
        );
        break;
      case '/writing/daily-journal':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const DailyJournalScreen()),
        );
        break;
      case '/writing/word-forge':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const WordForgeScreen()),
        );
        break;
      case '/speaking/shadow-boxing':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ShadowBoxingScreen()),
        );
        break;
      default:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const SentenceXRayScreen(level: 3)),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final planAsync = ref.watch(todayPlanProvider);

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: AppColors.darkSurface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.darkText),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '30-Min Daily Plan & Journey',
              style: TextStyle(color: AppColors.darkText, fontSize: 17, fontWeight: FontWeight.bold),
            ),
            Text(
              'Phase 1 to Phase 5 Curriculum System',
              style: TextStyle(color: AppColors.darkTextSecondary, fontSize: 11),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.accent,
          indicatorWeight: 3,
          labelColor: AppColors.accent,
          unselectedLabelColor: AppColors.darkTextSecondary,
          tabs: const [
            Tab(text: "TODAY'S 30-MIN PLAN"),
            Tab(text: 'PHASE 1–5 ROADMAP'),
          ],
        ),
      ),
      body: planAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accent)),
        error: (err, stack) => Center(
          child: Text('Error loading plan: $err', style: const TextStyle(color: AppColors.wrong)),
        ),
        data: (plan) {
          return TabBarView(
            controller: _tabController,
            children: [
              _buildTodayPlanTab(context, plan),
              _buildRoadmapTab(context, plan),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTodayPlanTab(BuildContext context, DailyPlan plan) {
    final displayedSteps = _minimumDayOnly
        ? plan.steps.where((s) => s.isMinimumDayRequirement).toList()
        : plan.steps;

    final completedCount = plan.steps.where((s) => s.isCompleted).length;
    final totalSteps = plan.steps.length;
    final progress = totalSteps == 0 ? 0.0 : completedCount / totalSteps;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Hero Banner
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.darkSurface,
                  AppColors.accent.withValues(alpha: 0.15),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
                      ),
                      child: Text(
                        'Day ${plan.dayNumber} of 365',
                        style: const TextStyle(
                          color: AppColors.accent,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.warning.withValues(alpha: 0.4)),
                      ),
                      child: Text(
                        plan.dayOfWeek,
                        style: const TextStyle(
                          color: AppColors.warning,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Phase ${plan.currentPhaseNumber}: ${plan.currentPhase.name}',
                  style: const TextStyle(
                    color: AppColors.darkText,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Today\'s Focus: ${plan.dayOfWeekFocus}',
                  style: const TextStyle(
                    color: AppColors.accent,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  plan.dayOfWeekTheme,
                  style: const TextStyle(
                    color: AppColors.darkTextSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 14),

                // Progress Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$completedCount of $totalSteps Steps Done',
                      style: const TextStyle(color: AppColors.darkText, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '${(progress * 100).round()}% Completed',
                      style: const TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppColors.darkBorder,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Minimum Day Mode Toggle Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.darkSurface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.darkBorder),
            ),
            child: Row(
              children: [
                const Icon(Icons.flash_on, color: AppColors.warning, size: 20),
                const SizedBox(width: 8),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '5-Minute Minimum Day Mode',
                        style: TextStyle(color: AppColors.darkText, fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'Step 1 (SRS) + Step 3 (X-Ray) protects your streak',
                        style: TextStyle(color: AppColors.darkTextSecondary, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _minimumDayOnly,
                  activeColor: AppColors.accent,
                  onChanged: (val) => setState(() => _minimumDayOnly = val),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 5-Step List
          Text(
            _minimumDayOnly ? 'MINIMUM DAY STEPS (2 of 5)' : 'TODAY\'S 30-MINUTE ROUTINE (5 STEPS)',
            style: const TextStyle(
              color: AppColors.darkTextSecondary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 10),

          ...displayedSteps.map((step) => _buildStepCard(context, step, plan.currentPhaseNumber)),

          const SizedBox(height: 14),

          // Senior Teacher Pedagogical Note Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.darkSurface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.darkBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.school, color: AppColors.accent, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Senior Teacher Principle (Paul Nation\'s 4 Strands):',
                      style: TextStyle(color: AppColors.darkText, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Language acquisition requires equal balance across four strands: (1) Meaning-focused input (Reading & Listening), (2) Meaning-focused output (Writing & Speaking), (3) Language-focused learning (SRS & Syntax), and (4) Fluency development. Rushing one without the others leads to passive recognition without productive recall.',
                  style: TextStyle(color: AppColors.darkTextSecondary, fontSize: 12, height: 1.45),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildStepCard(BuildContext context, DailyMissionStep step, int phaseNumber) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: step.isCompleted
              ? AppColors.correct.withValues(alpha: 0.4)
              : AppColors.darkBorder,
          width: step.isCompleted ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: step.isCompleted
                      ? AppColors.correct
                      : AppColors.accent.withValues(alpha: 0.2),
                ),
                child: Center(
                  child: step.isCompleted
                      ? const Icon(Icons.check, color: Colors.white, size: 16)
                      : Text(
                          '${step.stepNumber}',
                          style: const TextStyle(
                            color: AppColors.accent,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.darkBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${step.durationMinutes} MIN',
                  style: const TextStyle(
                    color: AppColors.warning,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.darkBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  step.skill.toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.accent,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const Spacer(),
              if (step.isMinimumDayRequirement)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'STREAK KEY',
                    style: TextStyle(color: AppColors.warning, fontSize: 9, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            step.title,
            style: const TextStyle(
              color: AppColors.darkText,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            step.subtitle,
            style: const TextStyle(
              color: AppColors.darkTextSecondary,
              fontSize: 12,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 38,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _navigateToStep(context, step, phaseNumber),
              style: ElevatedButton.styleFrom(
                backgroundColor: step.isCompleted ? AppColors.darkBorder : AppColors.accent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    step.isCompleted ? Icons.replay : Icons.play_arrow,
                    size: 16,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    step.isCompleted ? 'Practice Again' : 'Start Step (${step.durationMinutes}m)',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoadmapTab(BuildContext context, DailyPlan plan) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'PHASE 1 TO PHASE 5 CURRICULUM ROADMAP',
            style: TextStyle(
              color: AppColors.darkTextSecondary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 12),

          // Phase Selection Buttons
          Row(
            children: List.generate(PhaseCurriculum.phases.length, (idx) {
              final phaseNum = idx + 1;
              final isSelected = _selectedRoadmapPhase == phaseNum;
              final isCurrent = plan.currentPhaseNumber == phaseNum;

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: idx < 4 ? 6 : 0),
                  child: InkWell(
                    onTap: () => setState(() => _selectedRoadmapPhase = phaseNum),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.accent
                            : (isCurrent ? AppColors.accent.withValues(alpha: 0.2) : AppColors.darkSurface),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.accent
                              : (isCurrent ? AppColors.accent : AppColors.darkBorder),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'P$phaseNum',
                            style: TextStyle(
                              color: isSelected ? Colors.white : AppColors.darkText,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          if (isCurrent)
                            const Text(
                              'CURRENT',
                              style: TextStyle(
                                color: AppColors.warning,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 16),

          // Phase Detail View
          _buildPhaseDetailCard(PhaseCurriculum.getPhase(_selectedRoadmapPhase)),

          const SizedBox(height: 16),

          // Weekly Schedule Blueprint (Spec 22.3)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.darkSurface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.darkBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.calendar_month, color: AppColors.warning, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Universal Weekly Focus Rotation (Spec 22.3):',
                      style: TextStyle(color: AppColors.darkText, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildDayRow('Mon', 'New Words + Morphology Lab', 'Prefix/Suffix Lab & Word Family Tree'),
                _buildDayRow('Tue', 'Long-Sentence Mastery', 'Sentence X-Ray, Slice It, Reference Hunter'),
                _buildDayRow('Wed', 'Collocations & Writing', 'Collocation Forge, Word Forge, Daily Journal'),
                _buildDayRow('Thu', 'Listening & Working Memory', 'Lecture Notes, Chunk Echo & Dictation Dash'),
                _buildDayRow('Fri', 'Speaking & Discourse', 'Debate Mode, 60s Talker & Shadow Boxing'),
                _buildDayRow('Sat', 'Weekly Boss & Mistake Gym', 'Boss Battle & 30-min mistake notebook review'),
                _buildDayRow('Sun', 'Pleasure Reading & C2 Synthesis', 'Great Works essay & style analysis'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhaseDetailCard(PhaseMilestone phase) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Phase ${phase.phaseNumber} • ${phase.timeHorizon}',
                  style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.correct.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  phase.cefrGoal,
                  style: const TextStyle(color: AppColors.correct, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            phase.name,
            style: const TextStyle(
              color: AppColors.darkText,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            phase.coreFocus,
            style: const TextStyle(color: AppColors.darkTextSecondary, fontSize: 13, height: 1.4),
          ),
          const Divider(color: AppColors.darkBorder, height: 24),

          const Text(
            'Milestone Benchmarks:',
            style: TextStyle(color: AppColors.warning, fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 6),
          Text(
            '• Lexical Goal: ${phase.vocabularyTarget}',
            style: const TextStyle(color: AppColors.darkText, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            '• Syntax Goal: ${phase.sentenceTarget}',
            style: const TextStyle(color: AppColors.darkText, fontSize: 13),
          ),
          const SizedBox(height: 14),

          const Text(
            'Primary Training Modules:',
            style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: phase.primaryGames.map((game) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.darkBg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.darkBorder),
                ),
                child: Text(
                  game,
                  style: const TextStyle(color: AppColors.darkText, fontSize: 12, fontWeight: FontWeight.w500),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDayRow(String day, String title, String games) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            padding: const EdgeInsets.symmetric(vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.darkBg,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(
                day,
                style: const TextStyle(color: AppColors.warning, fontWeight: FontWeight.bold, fontSize: 11),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: AppColors.darkText, fontSize: 13, fontWeight: FontWeight.w600),
                ),
                Text(
                  games,
                  style: const TextStyle(color: AppColors.darkTextSecondary, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
