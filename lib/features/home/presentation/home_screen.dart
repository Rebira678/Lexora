import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../app/theme.dart';
import '../../../app/providers.dart';
import '../../games/word_siege/word_siege_screen.dart';
import '../../games/vocab_sprint/vocab_sprint_screen.dart';
import '../../games/anagram_wheel/anagram_wheel_screen.dart';
import '../../games/sentence_unscrambler/sentence_unscrambler_screen.dart';
import '../../games/paragraph_architect/paragraph_architect_screen.dart';
import '../../games/chunk_echo/chunk_echo_screen.dart';
import '../../games/sentence_xray/sentence_xray_screen.dart';
import '../../games/slice_it/slice_it_screen.dart';
import '../../games/connector_match/connector_match_screen.dart';
import '../../games/layer_builder/layer_builder_screen.dart';
import '../../games/context_detective/context_detective_screen.dart';
import '../../games/prefix_suffix_lab/prefix_suffix_lab_screen.dart';
import '../../games/word_family_tree/word_family_tree_screen.dart';
import '../../games/dictation_dash/dictation_dash_screen.dart';
import '../../games/sound_sniper/sound_sniper_screen.dart';
import '../../games/error_hunter/error_hunter_screen.dart';
import '../../reading/reading_screen.dart';
import '../../mistakes/presentation/mistakes_screen.dart';
import '../../stats/presentation/stats_screen.dart';
import '../../settings/presentation/settings_screen.dart';
import '../../games/collocation_match/collocation_match_screen.dart';
import '../../writing/word_forge_screen.dart';
import '../../writing/daily_journal_screen.dart';
import '../../speaking/sixty_second_talker_screen.dart';
import '../../speaking/shadow_boxing_screen.dart';
import '../../boss_battle/boss_battle_screen.dart';
import '../../mock_test/mock_test_screen.dart';
import '../../achievements/presentation/achievements_screen.dart';
import '../../speaking/role_play_screen.dart';
import '../../reading/story_branch_screen.dart';
import '../../games/phrasal_verb_dungeon/phrasal_verb_dungeon_screen.dart';
import '../../games/idiom_escape/idiom_escape_screen.dart';
import '../../writing/mini_email_boss_screen.dart';
import '../../custom_decks/custom_deck_screen.dart';
import '../../games/nuance_duel/nuance_duel_screen.dart';
import '../../writing/register_shifter_screen.dart';
import '../../writing/paraphrase_blitz_screen.dart';
import '../../games/collocation_forge/collocation_forge_screen.dart';
import '../../listening/lecture_notes_screen.dart';
import '../../speaking/debate_mode_screen.dart';
import '../../writing/cohesion_fixer_screen.dart';
import '../../wild_items/real_english_log_screen.dart';
import '../../word_notebook/word_notebook_screen.dart';
import 'widgets/daily_quest_board_widget.dart';
import 'widgets/game_art_painters.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _implementationIntention = 'When I finish breakfast, I will practice for 10 minutes.';

  @override
  void initState() {
    super.initState();
    _loadHabitIntention();
  }

  Future<void> _loadHabitIntention() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString('habit_intention');
      if (saved != null && saved.isNotEmpty && mounted) {
        setState(() {
          _implementationIntention = saved;
        });
      }
    } catch (_) {}
  }

  Future<void> _saveHabitIntention(String text) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('habit_intention', text);
    } catch (_) {}
  }

  void _showStreakInfoDialog(BuildContext context, int streak, int freezes) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Streak Protection'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$streak Consecutive Days',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Freeze Tokens Available: $freezes / 3',
              style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            const Text(
              '• Play one 5-minute session daily to maintain your streak.\n'
              '• Missing a day automatically consumes one freeze token to preserve progress.\n'
              '• Earn 1 new freeze token every 7 consecutive days played.\n'
              '• Your all-time total days and best run are permanently saved.',
              style: TextStyle(height: 1.5, fontSize: 13),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  void _showReminderSettingsDialog(BuildContext context) {
    TimeOfDay selectedTime = const TimeOfDay(hour: 8, minute: 30);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Daily Study Reminder'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select a daily offline notification time for your study session.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Theme.of(context).colorScheme.outline),
              ),
              leading: Icon(Icons.schedule_rounded, color: Theme.of(context).colorScheme.primary),
              title: const Text('Reminder Time'),
              subtitle: Text(selectedTime.format(context)),
              onTap: () async {
                final picked = await showTimePicker(
                  context: ctx,
                  initialTime: selectedTime,
                );
                if (picked != null) {
                  selectedTime = picked;
                  await ref.read(notificationServiceProvider).scheduleDailyReminder(
                        hour: picked.hour,
                        minute: picked.minute,
                      );
                  if (ctx.mounted) {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Daily reminder scheduled for ${picked.format(context)}.'),
                        backgroundColor: AppColors.correct,
                      ),
                    );
                  }
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _editImplementationIntention() {
    final controller = TextEditingController(text: _implementationIntention.replaceAll('"', ''));
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Daily Habit Anchor'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Anchor your English practice to an existing daily routine (implementation intention):',
              style: TextStyle(fontSize: 13, height: 1.4),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: 'e.g. When I pour my morning coffee, I will play 10 minutes.',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                setState(() {
                  _implementationIntention = text;
                });
                _saveHabitIntention(text);
              }
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _launchNextMissionStep(WidgetRef ref) {
    final planAsync = ref.read(todayPlanProvider);
    final plan = planAsync.value;
    if (plan == null || plan.steps.isEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const WordSiegeScreen(level: 3)),
      );
      return;
    }

    final nextStep = plan.steps.firstWhere(
      (s) => !s.isCompleted,
      orElse: () => plan.steps.first,
    );

    switch (nextStep.gameRoute) {
      case '/games/word-siege':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const WordSiegeScreen(level: 3)),
        );
        break;
      case '/games/unscrambler':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const SentenceUnscramblerScreen(level: 1)),
        );
        break;
      case '/games/sprint':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const VocabSprintScreen()),
        );
        break;
      case '/games/anagram':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AnagramWheelScreen()),
        );
        break;
      case '/games/paragraph-architect':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ParagraphArchitectScreen(level: 2)),
        );
        break;
      case '/games/chunk-echo':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ChunkEchoScreen(level: 2)),
        );
        break;
      case '/games/sentence-xray':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const SentenceXRayScreen(level: 2)),
        );
        break;
      default:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const WordSiegeScreen(level: 3)),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final streakStateAsync = ref.watch(streakStreamProvider);
    final todayStatsAsync = ref.watch(todayStatsProvider);
    final dueCardsAsync = ref.watch(dueCardCountProvider);
    final masteredWordsAsync = ref.watch(masteredCountProvider);

    final streak = streakStateAsync.value?.current ?? 0;
    final freezes = streakStateAsync.value?.freezes ?? 0;
    final totalXp = todayStatsAsync.value?.xp ?? 0;
    final dueCards = dueCardsAsync.value ?? 0;
    final masteredWords = masteredWordsAsync.value ?? 0;

    final xpService = ref.read(xpServiceProvider);
    final level = xpService.levelFromXp(totalXp);
    final rank = xpService.rankForLevel(level);
    final currentLevelXp = xpService.xpForLevel(level);
    final nextLevelXp = xpService.xpForLevel(level + 1);
    final xpRange = (nextLevelXp - currentLevelXp).clamp(1, 99999);
    final xpProgress = ((totalXp - currentLevelXp) / xpRange).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: Row(
          children: [
            Text(
              'LEXORA',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                letterSpacing: 2.0,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withAlpha(25),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'B2',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu_book_rounded, size: 20),
            tooltip: 'Word Notebook (Pokédex)',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const WordNotebookScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.schedule_rounded, size: 20),
            tooltip: 'Daily Reminder',
            onPressed: () => _showReminderSettingsDialog(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Top Metrics Card: Streak & Mastery
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: theme.colorScheme.outline),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () => _showStreakInfoDialog(context, streak, freezes),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$streak',
                                    style: theme.textTheme.displayMedium?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      height: 1.0,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        'DAY STREAK',
                                        style: theme.textTheme.labelSmall,
                                      ),
                                      if (freezes > 0) ...[
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                          decoration: BoxDecoration(
                                            color: theme.colorScheme.primary.withAlpha(20),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            '$freezes Freezes',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: theme.colorScheme.primary,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '$masteredWords',
                                  style: theme.textTheme.displayMedium?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    height: 1.0,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'WORDS MASTERED',
                                  style: theme.textTheme.labelSmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Level progress
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Level $level • $rank',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              '$totalXp / $nextLevelXp XP',
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: xpProgress,
                            minHeight: 5,
                            backgroundColor: theme.colorScheme.surfaceContainerHighest,
                            valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Daily Quest Board (Spec 7.5)
                  const DailyQuestBoardWidget(),
                  const SizedBox(height: 8),

                  // Implementation Intention Anchor (Minimalist Quote Card)
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: _editImplementationIntention,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: theme.colorScheme.outline),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 3,
                            height: 28,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _implementationIntention,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Edit',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Primary Mission Card
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: theme.colorScheme.primary.withAlpha(120),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "TODAY'S MISSION",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            Text(
                              dueCards > 0 ? '$dueCards Reviews Due' : 'Reviews Completed',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Spaced Review & Sentence Expansion',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Complete 5 structured steps to reinforce long-term memory.',
                          style: theme.textTheme.bodySmall,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => _launchNextMissionStep(ref),
                          child: const Text('Start Session'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Game Arena Section Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Game Arena',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                        ),
                      ),
                      Text(
                        'Phase 1 Core',
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 2-Column Game Grid with Custom Vector Illustrations
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.82,
                    children: [
                      _IllustratedGameCard(
                        type: GameArtType.wordSiege,
                        category: 'ACTION',
                        title: 'Word Siege',
                        description: '3-lane gate defense with typing and tap mode',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const WordSiegeScreen(level: 3)),
                        ),
                      ),
                      _IllustratedGameCard(
                        type: GameArtType.vocabSprint,
                        category: 'SPEED',
                        title: 'Vocab Sprint',
                        description: 'Rapid-fire SRS review across 5 game modes',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const VocabSprintScreen()),
                        ),
                      ),
                      _IllustratedGameCard(
                        type: GameArtType.unscrambler,
                        category: 'SYNTAX',
                        title: 'Unscrambler',
                        description: 'Reconstruct clauses with audio pronunciation',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const SentenceUnscramblerScreen(level: 1)),
                        ),
                      ),
                      _IllustratedGameCard(
                        type: GameArtType.anagramWheel,
                        category: 'SPELLING',
                        title: 'Anagram Wheel',
                        description: 'Swipe letter trail to unlock words and roots',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const AnagramWheelScreen()),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Phase 2: Long Sentences & Cohesion
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Phase 2: Syntax & Cohesion',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Fix Weak Points',
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.82,
                    children: [
                      _IllustratedGameCard(
                        type: GameArtType.sentenceXray,
                        category: 'GRAMMAR',
                        title: 'Sentence X-Ray',
                        description: 'Isolate main subject, verb, and clause',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const SentenceXRayScreen(level: 2)),
                        ),
                      ),
                      _IllustratedGameCard(
                        type: GameArtType.sliceIt,
                        category: 'CHUNKING',
                        title: 'Slice It',
                        description: 'Interactive phrase cuts & boundary recognition',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const SliceItScreen(level: 2)),
                        ),
                      ),
                      _IllustratedGameCard(
                        type: GameArtType.connectorMatch,
                        category: 'DISCOURSE',
                        title: 'Connector Match',
                        description: 'Master transitions & cohesive flow',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const ConnectorMatchScreen(level: 2)),
                        ),
                      ),
                      _IllustratedGameCard(
                        type: GameArtType.layerBuilder,
                        category: 'SYNTAX ARCH',
                        title: 'Layer Builder',
                        description: 'Expand kernel clauses into C1 sentences',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const LayerBuilderScreen(level: 2)),
                        ),
                      ),
                      _IllustratedGameCard(
                        type: GameArtType.paragraphArchitect,
                        category: 'COHESION',
                        title: 'Paragraph Arch.',
                        description: 'Cohesion map & sentence connectors',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const ParagraphArchitectScreen(level: 2)),
                        ),
                      ),
                      _IllustratedGameCard(
                        type: GameArtType.gradedReader,
                        category: 'READING',
                        title: 'Graded Reader',
                        description: 'Tap-to-define passages with wild word save',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const ReadingScreen()),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Phase 2: Vocabulary & Morphology Mastery
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Phase 2: Vocabulary & Morphology',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Multiplier Tools',
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.82,
                    children: [
                      _IllustratedGameCard(
                        type: GameArtType.contextDetective,
                        category: 'INFERENCE',
                        title: 'Context Detective',
                        description: 'Deduce C1 words from 4 context clue types',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const ContextDetectiveScreen()),
                        ),
                      ),
                      _IllustratedGameCard(
                        type: GameArtType.prefixSuffix,
                        category: 'MORPHOLOGY',
                        title: 'Prefix/Suffix Lab',
                        description: 'Derivational morpheme affix forge',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const PrefixSuffixLabScreen()),
                        ),
                      ),
                      _IllustratedGameCard(
                        type: GameArtType.wordFamilyTree,
                        category: 'DERIVATION',
                        title: 'Word Family Tree',
                        description: 'Noun, verb, adjective, adverb quadrants',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const WordFamilyTreeScreen()),
                        ),
                      ),
                      _IllustratedGameCard(
                        type: GameArtType.vocabSprint,
                        category: 'RECOVERY',
                        title: 'Mistake Gym',
                        description: 'Targeted drill on missed sentences & wild items',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const MistakesScreen()),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Phase 2: Listening & Precision Skills
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Phase 2: Listening & Precision',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Four Skills Expansion',
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.82,
                    children: [
                      _IllustratedGameCard(
                        type: GameArtType.chunkEcho,
                        category: 'ACOUSTIC',
                        title: 'Chunk Echo',
                        description: 'Acoustic waveform & memory ladder climb',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const ChunkEchoScreen(level: 2)),
                        ),
                      ),
                      _IllustratedGameCard(
                        type: GameArtType.dictationDash,
                        category: 'TRANSCRIPTION',
                        title: 'Dictation Dash',
                        description: 'Listen and type with letter-level diff',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const DictationDashScreen()),
                        ),
                      ),
                      _IllustratedGameCard(
                        type: GameArtType.soundSniper,
                        category: 'MINIMAL PAIRS',
                        title: 'Sound Sniper',
                        description: 'Rapid phoneme contrast shooter reaction',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const SoundSniperScreen()),
                        ),
                      ),
                      _IllustratedGameCard(
                        type: GameArtType.errorHunter,
                        category: 'PROOFREADING',
                        title: 'Error Hunter',
                        description: 'Spot and fix subtle grammar and syntax errors',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const ErrorHunterScreen()),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Phase 3: Speaking & Productive Fluency
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Phase 3: Speaking & Fluency',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Active Production',
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.82,
                    children: [
                      _IllustratedGameCard(
                        type: GameArtType.sixtySecondTalker,
                        category: 'FLUENCY SPRINT',
                        title: '60s Talker',
                        description: 'Unbroken monologue with CEFR self-assessment',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const SixtySecondTalkerScreen()),
                        ),
                      ),
                      _IllustratedGameCard(
                        type: GameArtType.shadowBoxing,
                        category: 'PROSODY',
                        title: 'Shadow Boxing',
                        description: 'Speech shadowing for natural native rhythm',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const ShadowBoxingScreen()),
                        ),
                      ),
                      _IllustratedGameCard(
                        type: GameArtType.rolePlay,
                        category: 'PRAGMATICS',
                        title: 'Role-Play Dialogues',
                        description: 'Contextual exchanges in real-world scenarios',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const RolePlayScreen()),
                        ),
                      ),
                      _IllustratedGameCard(
                        type: GameArtType.storyBranch,
                        category: 'IMMERSION',
                        title: 'Story Branch',
                        description: 'Branching narrative fiction with choices',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const StoryBranchScreen()),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Phase 3: Writing & Professional Lexis
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Phase 3: Writing & Professional Lexis',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Formal Register',
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.82,
                    children: [
                      _IllustratedGameCard(
                        type: GameArtType.emailBoss,
                        category: 'DIPLOMATIC EMAIL',
                        title: 'Mini Email Boss',
                        description: 'Professional correspondence with required C1 collocations',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const MiniEmailBossScreen()),
                        ),
                      ),
                      _IllustratedGameCard(
                        type: GameArtType.wordForge,
                        category: 'SYNTACTIC FORGE',
                        title: 'Word Forge',
                        description: 'Synthesize 3 target words into one complex sentence',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const WordForgeScreen()),
                        ),
                      ),
                      _IllustratedGameCard(
                        type: GameArtType.dailyJournal,
                        category: 'DISCOURSE JOURNAL',
                        title: 'Daily 3 Sentences',
                        description: 'Observation, contrast, and resolution portfolio',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const DailyJournalScreen()),
                        ),
                      ),
                      _IllustratedGameCard(
                        type: GameArtType.customDecks,
                        category: 'CUSTOM SRS',
                        title: 'Custom Decks & CSV',
                        description: 'Create and import your own vocabulary lists',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const CustomDeckScreen()),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Phase 3: Lexis, Boss Battles & Benchmarks
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Phase 3: Lexis & Capstone',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Raids & Benchmarks',
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.82,
                    children: [
                      _IllustratedGameCard(
                        type: GameArtType.phrasalDungeon,
                        category: 'PHRASAL VERBS',
                        title: 'Phrasal Dungeon',
                        description: 'Dungeon guardian battles with C1 particles',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const PhrasalVerbDungeonScreen()),
                        ),
                      ),
                      _IllustratedGameCard(
                        type: GameArtType.idiomEscape,
                        category: 'ETYMOLOGY',
                        title: 'Idiom Escape Room',
                        description: 'Solve chambers through idiomatic origin clues',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const IdiomEscapeScreen()),
                        ),
                      ),
                      _IllustratedGameCard(
                        type: GameArtType.collocationMatch,
                        category: 'ACADEMIC LEXIS',
                        title: 'Collocation Match',
                        description: 'Fixed verb-noun pairings & phrasal verbs',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const CollocationMatchScreen()),
                        ),
                      ),
                      _IllustratedGameCard(
                        type: GameArtType.bossBattle,
                        category: 'WEEKLY RAID',
                        title: 'Weekly Boss',
                        description: 'Multi-skill exam gauntlet against the Leviathan',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const BossBattleScreen()),
                        ),
                      ),
                      _IllustratedGameCard(
                        type: GameArtType.mockTest,
                        category: 'DIAGNOSTIC',
                        title: 'CEFR Mock Test',
                        description: '4-skill benchmark test with CEFR breakdown',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const MockTestScreen()),
                        ),
                      ),
                      _IllustratedGameCard(
                        type: GameArtType.achievements,
                        category: 'MILESTONES',
                        title: 'Achievements',
                        description: 'Badges and trophies for mastery milestones',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const AchievementsScreen()),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Phase 4: C1 Precision & Semantic Nuance
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Phase 4: C1 Semantic Precision',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'C1/C2 Nuance',
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.82,
                    children: [
                      _IllustratedGameCard(
                        type: GameArtType.nuanceDuel,
                        category: 'SEMANTIC DUEL',
                        title: 'Nuance Duel',
                        description: 'Choose the exact near-synonym with the right connotation',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const NuanceDuelScreen()),
                        ),
                      ),
                      _IllustratedGameCard(
                        type: GameArtType.collocationForge,
                        category: 'SPEED FORGE',
                        title: 'Collocation Forge',
                        description: 'Rapid-fire AWL collocations under time pressure',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const CollocationForgeScreen()),
                        ),
                      ),
                      _IllustratedGameCard(
                        type: GameArtType.realEnglishLog,
                        category: 'WILD CAPTURE',
                        title: 'Real English Log',
                        description: 'Capture real-world vocabulary & AWL/NAWL content packs',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const RealEnglishLogScreen()),
                        ),
                      ),
                      _IllustratedGameCard(
                        type: GameArtType.registerShifter,
                        category: 'SOCIOLINGUISTICS',
                        title: 'Register Shifter',
                        description: 'Transform casual discourse into executive & academic styles',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const RegisterShifterScreen()),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Phase 4: C1 Rhetoric, Synthesis & Debating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Phase 4: C1 Rhetoric & Synthesis',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Academic Debate',
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.82,
                    children: [
                      _IllustratedGameCard(
                        type: GameArtType.paraphraseBlitz,
                        category: 'SYNTACTIC AGILITY',
                        title: 'Paraphrase Blitz',
                        description: 'Express one thesis in 3 advanced grammatical forms',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const ParaphraseBlitzScreen()),
                        ),
                      ),
                      _IllustratedGameCard(
                        type: GameArtType.cohesionFixer,
                        category: 'DISCOURSE FLOW',
                        title: 'Cohesion Fixer',
                        description: 'Repair choppy academic paragraphs with discourse ties',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const CohesionFixerScreen()),
                        ),
                      ),
                      _IllustratedGameCard(
                        type: GameArtType.lectureNotes,
                        category: 'AUTHENTIC SPEED',
                        title: 'Lecture Notes',
                        description: 'Academic lecture listening, Cornell notes & synthesis',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const LectureNotesScreen()),
                        ),
                      ),
                      _IllustratedGameCard(
                        type: GameArtType.debateMode,
                        category: '90S ARGUMENTATION',
                        title: 'Debate Mode',
                        description: 'Defend or oppose parliamentary motions against the clock',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const DebateModeScreen()),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        height: 64,
        onDestinationSelected: (index) {
          if (index == 1) {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MistakesScreen()));
          } else if (index == 2) {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const StatsScreen()));
          } else if (index == 3) {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsScreen()));
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.grid_view_rounded, size: 22),
            label: 'Arena',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_outline_rounded, size: 22),
            selectedIcon: Icon(Icons.bookmark_rounded, size: 22),
            label: 'My Words',
          ),
          NavigationDestination(
            icon: Icon(Icons.insights_rounded, size: 22),
            label: 'Stats',
          ),
          NavigationDestination(
            icon: Icon(Icons.tune_rounded, size: 22),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class _IllustratedGameCard extends StatelessWidget {
  final GameArtType type;
  final String category;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _IllustratedGameCard({
    required this.type,
    required this.category,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Rich vector art illustration header
              GameArtWidget(
                type: type,
                primaryColor: theme.colorScheme.primary,
                height: 95,
              ),

              // Content Area
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withAlpha(20),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              category,
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 13,
                            color: theme.colorScheme.onSurfaceVariant.withAlpha(160),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            description,
                            style: TextStyle(
                              fontSize: 11,
                              color: theme.colorScheme.onSurfaceVariant,
                              height: 1.25,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
