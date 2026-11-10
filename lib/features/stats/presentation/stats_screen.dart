import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../app/theme.dart';
import '../../../app/providers.dart';
import '../../../core/db/database.dart';
import 'monthly_checkpoint_screen.dart';
import '../../achievements/presentation/achievements_screen.dart';
import '../../mistakes/presentation/mistakes_screen.dart';

/// Executive Linguistic Profile & Senior Performance Dossier.
/// Designed for C1/C2 advanced candidates with zero cartoon/childish aesthetic.
/// Built with obsidian surfaces, metallic hairline borders, precision typography,
/// CEFR 5-skill competency spectrum, and local database security status.
class StatsScreen extends ConsumerStatefulWidget {
  const StatsScreen({super.key});

  @override
  ConsumerState<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends ConsumerState<StatsScreen> {
  String _candidateName = 'Executive Linguist';
  String _targetCefr = 'B2 ➔ C1 Breakthrough';

  @override
  void initState() {
    super.initState();
    _loadProfilePrefs();
  }

  Future<void> _loadProfilePrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedName = prefs.getString('candidate_name');
      final savedCefr = prefs.getString('target_cefr_goal');
      if (mounted) {
        setState(() {
          if (savedName != null && savedName.isNotEmpty) {
            _candidateName = savedName;
          }
          if (savedCefr != null && savedCefr.isNotEmpty) {
            _targetCefr = savedCefr;
          }
        });
      }
    } catch (_) {}
  }

  Future<void> _saveProfile(String name, String cefr) async {
    setState(() {
      _candidateName = name;
      _targetCefr = cefr;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('candidate_name', name);
      await prefs.setString('target_cefr_goal', cefr);
    } catch (_) {}
  }

  void _showEditProfileSheet(BuildContext context) {
    final nameController = TextEditingController(text: _candidateName);
    String selectedCefr = _targetCefr;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.darkSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        side: BorderSide(color: AppColors.darkBorder),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Edit Candidate Profile',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkText,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Configure your identity and CEFR target trajectory.',
                    style: TextStyle(fontSize: 13, color: AppColors.darkTextSecondary),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'CANDIDATE NAME / TITLE',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5, color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: nameController,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'e.g. Senior Candidate, Dr. Alexander',
                      hintStyle: const TextStyle(color: Colors.white38),
                      filled: true,
                      fillColor: AppColors.darkBg,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AppColors.darkBorder),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AppColors.darkBorder),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AppColors.accent),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'CEFR MASTERY GOAL',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5, color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildCefrOptionChip('B2 ➔ C1 Breakthrough', selectedCefr, (val) {
                        setSheetState(() => selectedCefr = val);
                      }),
                      _buildCefrOptionChip('C1 ➔ C2 Native Precision', selectedCefr, (val) {
                        setSheetState(() => selectedCefr = val);
                      }),
                      _buildCefrOptionChip('IELTS 8.0+ Academic', selectedCefr, (val) {
                        setSheetState(() => selectedCefr = val);
                      }),
                      _buildCefrOptionChip('Executive Business English', selectedCefr, (val) {
                        setSheetState(() => selectedCefr = val);
                      }),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      final name = nameController.text.trim();
                      if (name.isNotEmpty) {
                        _saveProfile(name, selectedCefr);
                      }
                      Navigator.pop(ctx);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Save Profile Settings', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCefrOptionChip(String title, String currentSelected, Function(String) onSelect) {
    final isSelected = title == currentSelected;
    return ChoiceChip(
      label: Text(title),
      selected: isSelected,
      onSelected: (_) => onSelect(title),
      selectedColor: AppColors.accent.withAlpha(50),
      backgroundColor: AppColors.darkBg,
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        color: isSelected ? AppColors.accentLight : AppColors.darkTextSecondary,
      ),
      side: BorderSide(
        color: isSelected ? AppColors.accent : AppColors.darkBorder,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return 'LX';
    if (parts.length == 1) {
      return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
    }
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final streakAsync = ref.watch(streakStreamProvider);
    final todayStatsAsync = ref.watch(todayStatsProvider);
    final masteredCountAsync = ref.watch(masteredCountProvider);
    final db = ref.watch(databaseProvider);
    final theme = Theme.of(context);

    final streak = streakAsync.value?.current ?? 0;
    final bestStreak = streakAsync.value?.best ?? 0;
    final freezes = streakAsync.value?.freezes ?? 0;
    final totalDays = streakAsync.value?.totalDays ?? 0;
    final totalXp = todayStatsAsync.value?.xp ?? 0;
    final todayMinutes = todayStatsAsync.value?.minutes ?? 0;
    final masteredWords = masteredCountAsync.value ?? 0;

    final xpService = ref.watch(xpServiceProvider);
    final level = xpService.levelFromXp(totalXp);
    final rank = xpService.rankForLevel(level);

    final currentLevelXp = xpService.xpForLevel(level);
    final nextLevelXp = xpService.xpForLevel(level + 1);
    final xpRange = (nextLevelXp - currentLevelXp).clamp(1, 999999);
    final xpProgress = ((totalXp - currentLevelXp) / xpRange).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: AppColors.darkBg,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Executive Linguistic Dossier',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
                color: Colors.white,
              ),
            ),
            Text(
              'Learning Analytics & Stats',
              style: TextStyle(
                fontSize: 11,
                color: Colors.white.withAlpha(150),
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.military_tech_rounded, size: 22, color: Color(0xFFF59E0B)),
            tooltip: 'Executive Achievements',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AchievementsScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.assignment_outlined, size: 22, color: AppColors.accentLight),
            tooltip: 'Monthly Checkpoint Report',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const MonthlyCheckpointScreen()),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. EXECUTIVE PROFILE HERO HEADER
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF131726), Color(0xFF0F121C)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.darkBorder),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(80),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Monogram Avatar with luxury ring
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 68,
                              height: 68,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const SweepGradient(
                                  colors: [
                                    Color(0xFF6366F1),
                                    Color(0xFF818CF8),
                                    Color(0xFFF59E0B),
                                    Color(0xFF10B981),
                                    Color(0xFF6366F1),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.accent.withAlpha(50),
                                    blurRadius: 12,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 62,
                              height: 62,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF0D0F17),
                              ),
                              child: Center(
                                child: Text(
                                  _getInitials(_candidateName),
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: AppColors.correct,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: const Color(0xFF0D0F17), width: 2.5),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        // Profile Info & Target
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      _candidateName,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: -0.3,
                                        color: Colors.white,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  InkWell(
                                    onTap: () => _showEditProfileSheet(context),
                                    borderRadius: BorderRadius.circular(4),
                                    child: const Padding(
                                      padding: EdgeInsets.all(4),
                                      child: Icon(Icons.edit_outlined, size: 14, color: Colors.white54),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(
                                _targetCefr,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.accentLight,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.white.withAlpha(12),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: Colors.white.withAlpha(18)),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.shield_outlined, size: 11, color: AppColors.correct),
                                    SizedBox(width: 4),
                                    Text(
                                      'DRIFT SQLITE • ENCRYPTED LOCAL',
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.5,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Divider(color: Colors.white.withAlpha(18), height: 1),
                    const SizedBox(height: 16),
                    // Rank & Level Progress
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Rank Tier',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.4,
                                color: Colors.white.withAlpha(160),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              rank,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withAlpha(35),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.accent.withAlpha(80)),
                          ),
                          child: Text(
                            'Level $level',
                            style: const TextStyle(
                              color: AppColors.accentLight,
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: xpProgress,
                        backgroundColor: Colors.white.withAlpha(18),
                        valueColor: const AlwaysStoppedAnimation(AppColors.accent),
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$totalXp XP',
                          style: const TextStyle(fontSize: 11, color: Colors.white60, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '${nextLevelXp - totalXp} XP to Level ${level + 1}',
                          style: const TextStyle(fontSize: 11, color: Colors.white38),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // 2. EXECUTIVE BENTO KPI MATRIX (2x2 Grid)
              Text(
                'Linguistic Velocity & Discipline',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _ExecutiveBentoCard(
                      icon: Icons.local_fire_department_rounded,
                      iconColor: const Color(0xFFF59E0B),
                      label: 'CURRENT',
                      value: '$streak Days',
                      subtext: 'Best: $bestStreak Days',
                      badge: 'Active run',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ExecutiveBentoCard(
                      icon: Icons.shield_rounded,
                      iconColor: const Color(0xFF818CF8),
                      label: 'FREEZES',
                      value: '$freezes / 3',
                      subtext: '$totalDays Total days',
                      badge: 'Tokens ready',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _ExecutiveBentoCard(
                      icon: Icons.auto_stories_rounded,
                      iconColor: const Color(0xFF10B981),
                      label: 'LEXICON',
                      value: '$masteredWords Words',
                      subtext: 'FSRS Spaced Repetition',
                      badge: 'Retention 90%+',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ExecutiveBentoCard(
                      icon: Icons.timer_outlined,
                      iconColor: const Color(0xFF38BDF8),
                      label: 'DAILY VELOCITY',
                      value: '${todayMinutes}m',
                      subtext: 'Daily target: 30m',
                      badge: todayMinutes >= 30 ? 'Goal Met' : 'In Progress',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 3. PHASE 3 & 4 DIAGNOSTIC BENCHMARK PORTAL
              InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const MonthlyCheckpointScreen()),
                ),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1E1B4B), Color(0xFF131724)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColors.accent.withAlpha(100),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withAlpha(40),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.accent.withAlpha(80)),
                        ),
                        child: const Icon(
                          Icons.query_stats_rounded,
                          color: AppColors.accentLight,
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'CEFR Diagnostic Benchmark',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                                SizedBox(width: 6),
                                Icon(Icons.verified_rounded, size: 14, color: AppColors.correct),
                              ],
                            ),
                            SizedBox(height: 3),
                            Text(
                              'Execute full 30-min calibrated assessment with senior teacher analytical rubric.',
                              style: TextStyle(
                                color: Colors.white60,
                                fontSize: 12,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.white54),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 4. CEFR 5-SKILL COMPETENCY SPECTRUM (Senior Teacher Diagnostics)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'CEFR 5-Skill Competency Profile',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(10),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'CEFR C1 Standard',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white70),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              FutureBuilder<List<SkillLevel>>(
                future: (db.select(db.skillLevels)
                      ..orderBy([(t) => drift.OrderingTerm.desc(t.measuredAt)]))
                    .get(),
                builder: (context, snapshot) {
                  final skills = snapshot.data ?? [];
                  double readingScore = 0.78;
                  double writingScore = 0.72;
                  double listeningScore = 0.68;
                  double vocabScore = 0.84;
                  double syntaxScore = 0.76;

                  for (final s in skills) {
                    if (s.skill == 'reading') readingScore = s.score;
                    if (s.skill == 'writing') writingScore = s.score;
                    if (s.skill == 'listening') listeningScore = s.score;
                    if (s.skill == 'vocab') vocabScore = s.score;
                    if (s.skill == 'syntax') syntaxScore = s.score;
                  }

                  return Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.darkSurface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.darkBorder),
                    ),
                    child: Column(
                      children: [
                        _ExecutiveSkillSpectrumBar(
                          skill: 'Lexical Range & Nuance',
                          subtitle: 'Academic collocations, connotation precision, idioms',
                          score: vocabScore,
                          cefrBand: vocabScore >= 0.85 ? 'C2' : (vocabScore >= 0.75 ? 'C1' : 'B2'),
                          accentColor: const Color(0xFF6366F1),
                        ),
                        const SizedBox(height: 14),
                        _ExecutiveSkillSpectrumBar(
                          skill: 'Complex Syntax & Cohesion',
                          subtitle: 'Clefting, inversion, subordination, participial clauses',
                          score: syntaxScore,
                          cefrBand: syntaxScore >= 0.85 ? 'C2' : (syntaxScore >= 0.75 ? 'C1' : 'B2'),
                          accentColor: const Color(0xFF818CF8),
                        ),
                        const SizedBox(height: 14),
                        _ExecutiveSkillSpectrumBar(
                          skill: 'Critical & Analytic Reading',
                          subtitle: 'Tone inference, synthesizing dense scholarly prose',
                          score: readingScore,
                          cefrBand: readingScore >= 0.85 ? 'C2' : (readingScore >= 0.75 ? 'C1' : 'B2'),
                          accentColor: const Color(0xFF10B981),
                        ),
                        const SizedBox(height: 14),
                        _ExecutiveSkillSpectrumBar(
                          skill: 'Written Synthesis & Discourse',
                          subtitle: 'Hedging, logical transitionals, register shifting',
                          score: writingScore,
                          cefrBand: writingScore >= 0.85 ? 'C2' : (writingScore >= 0.75 ? 'C1' : 'B2'),
                          accentColor: const Color(0xFFF59E0B),
                        ),
                        const SizedBox(height: 14),
                        _ExecutiveSkillSpectrumBar(
                          skill: 'Acoustic Shadowing & Prosody',
                          subtitle: 'Speech rhythm, connected speech, fast audio decoding',
                          score: listeningScore,
                          cefrBand: listeningScore >= 0.85 ? 'C2' : (listeningScore >= 0.75 ? 'C1' : 'B2'),
                          accentColor: const Color(0xFF38BDF8),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // 5. QUICK EXECUTIVE VAULT SHORTCUTS
              Text(
                'Linguistic Repositories',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _VaultActionButton(
                      icon: Icons.bookmark_outline_rounded,
                      title: 'Error Bank',
                      subtitle: 'Review weak items',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const MistakesScreen()),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _VaultActionButton(
                      icon: Icons.military_tech_rounded,
                      title: 'Achievements',
                      subtitle: 'Milestones & badges',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const AchievementsScreen()),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 6. RECENT SESSIONS LEDGER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Practice Session Ledger',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'Recent 10',
                    style: TextStyle(fontSize: 12, color: Colors.white38),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              FutureBuilder<List<GameSession>>(
                future: (db.select(db.gameSessions)
                      ..orderBy([(t) => drift.OrderingTerm.desc(t.startedAt)])
                      ..limit(10))
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: Padding(
                      padding: EdgeInsets.all(24),
                      child: CircularProgressIndicator(),
                    ));
                  }

                  final sessions = snapshot.data ?? [];
                  if (sessions.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.darkSurface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.darkBorder),
                      ),
                      child: const Center(
                        child: Text(
                          'No practice sessions recorded yet. Launch a session from Arena.',
                          style: TextStyle(color: Colors.white38, fontSize: 13),
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: sessions.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final s = sessions[index];
                      final date = DateTime.fromMillisecondsSinceEpoch(s.startedAt);
                      final timeStr = '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
                      final accuracyPct = (s.accuracy * 100).round();
                      final isHighAccuracy = accuracyPct >= 80;

                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.darkSurface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.darkBorder),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    s.game.replaceAll('_', ' ').toUpperCase(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                      color: Colors.white,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: isHighAccuracy ? AppColors.correct.withAlpha(25) : AppColors.warning.withAlpha(25),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          '$accuracyPct% ACCURACY',
                                          style: TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w700,
                                            color: isHighAccuracy ? AppColors.correct : AppColors.warning,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '${(s.durationMs / 1000).round()}s',
                                        style: const TextStyle(fontSize: 11, color: Colors.white38),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '+${s.score} XP',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 13,
                                    color: AppColors.accentLight,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  timeStr,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.white38,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

/// Executive Bento Information Card with dark surface styling.
class _ExecutiveBentoCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String subtext;
  final String badge;

  const _ExecutiveBentoCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.subtext,
    required this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: iconColor, size: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(10),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              color: Colors.white38,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtext,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.white60,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// Precision CEFR skill spectrum bar with pedagogical subtitle and CEFR level badge.
class _ExecutiveSkillSpectrumBar extends StatelessWidget {
  final String skill;
  final String subtitle;
  final double score;
  final String cefrBand;
  final Color accentColor;

  const _ExecutiveSkillSpectrumBar({
    required this.skill,
    required this.subtitle,
    required this.score,
    required this.cefrBand,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final pct = (score * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                skill,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: Colors.white,
                ),
              ),
            ),
            Row(
              children: [
                Text(
                  '$pct%',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: accentColor.withAlpha(35),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: accentColor.withAlpha(70)),
                  ),
                  child: Text(
                    cefrBand,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 10,
                      color: accentColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 11, color: Colors.white38),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: score.clamp(0.0, 1.0),
            backgroundColor: Colors.white.withAlpha(15),
            valueColor: AlwaysStoppedAnimation(accentColor),
            minHeight: 5,
          ),
        ),
      ],
    );
  }
}

/// Clean action button linking directly to key vaults.
class _VaultActionButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _VaultActionButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.darkSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.darkBorder),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(10),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 20, color: Colors.white70),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 11, color: Colors.white38),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
