import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drift/drift.dart' as drift;
import '../../../../app/providers.dart';
import '../../../../core/audio/audio_service.dart';
import '../../../../core/db/database.dart';

class DailyQuestItem {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final int targetCount;
  final int currentCount;

  DailyQuestItem({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.targetCount,
    required this.currentCount,
  });

  bool get isCompleted => currentCount >= targetCount;
  double get progress => (currentCount / targetCount).clamp(0.0, 1.0);
}

class DailyQuestBoardWidget extends ConsumerStatefulWidget {
  const DailyQuestBoardWidget({super.key});

  @override
  ConsumerState<DailyQuestBoardWidget> createState() => _DailyQuestBoardWidgetState();
}

class _DailyQuestBoardWidgetState extends ConsumerState<DailyQuestBoardWidget> {
  bool _isClaimedToday = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkClaimStatus();
  }

  String _todayDateKey() {
    final now = DateTime.now();
    return 'quest_chest_claimed_${now.year}_${now.month}_${now.day}';
  }

  String _formatDayKey(DateTime d) {
    return '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  Future<void> _checkClaimStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final claimed = prefs.getBool(_todayDateKey()) ?? false;
      if (mounted) {
        setState(() {
          _isClaimedToday = claimed;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _claimReward(int bonusXp) async {
    final audio = ref.read(audioServiceProvider);
    final statsDao = ref.read(statsDaoProvider);
    final dayKey = _formatDayKey(DateTime.now());

    // Award bonus XP into daily activity
    await statsDao.recordDailyActivity(
      dayKey: dayKey,
      xp: bonusXp,
      goalMet: true,
    );

    // Give 1 streak freeze if below maximum (3)
    try {
      final db = ref.read(databaseProvider);
      final streak = await (db.select(db.streaks)..where((s) => s.id.equals(1))).getSingleOrNull();
      if (streak != null && streak.freezes < 3) {
        await (db.update(db.streaks)..where((s) => s.id.equals(1))).write(
          StreaksCompanion(freezes: drift.Value(streak.freezes + 1)),
        );
      }
    } catch (_) {}

    audio.playSfx(SfxType.levelUp);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_todayDateKey(), true);

    if (mounted) {
      setState(() => _isClaimedToday = true);
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: const Color(0xFF131722),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Color(0xFFF59E0B), width: 1.5),
          ),
          title: const Row(
            children: [
              Icon(Icons.inventory_2, color: Color(0xFFF59E0B), size: 28),
              SizedBox(width: 10),
              Text(
                'Quest Chest Unlocked!',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Magnificent achievement! You have fulfilled all 3 daily discipline quests.',
                style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2333),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.stars, color: Color(0xFFF59E0B), size: 24),
                    SizedBox(width: 10),
                    Text(
                      '+100 Bonus XP Awarded',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2333),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.ac_unit, color: Color(0xFF38BDF8), size: 24),
                    SizedBox(width: 10),
                    Text(
                      '+1 Streak Freeze Protection Added',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Claim & Continue'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const SizedBox.shrink();

    final todayStatsAsync = ref.watch(todayStatsProvider);
    final stats = todayStatsAsync.value;

    final cardsReviewed = stats?.itemsReviewed ?? 0;
    final minutesStudied = stats?.minutes ?? 0;
    final totalXp = stats?.xp ?? 0;

    // Spec 7.5: 3 daily quests
    final quests = [
      DailyQuestItem(
        id: 'q1',
        title: 'Sharpen Vocabulary',
        description: 'Review 5 cards or clear 1 vocab duel',
        icon: Icons.auto_awesome,
        targetCount: 5,
        currentCount: cardsReviewed > 0 ? cardsReviewed : (totalXp > 20 ? 5 : 0),
      ),
      DailyQuestItem(
        id: 'q2',
        title: 'Deep Practice Focus',
        description: 'Complete at least 5 minutes of active training',
        icon: Icons.timer_outlined,
        targetCount: 5,
        currentCount: minutesStudied > 0 ? minutesStudied : (totalXp >= 30 ? 5 : 1),
      ),
      DailyQuestItem(
        id: 'q3',
        title: 'Rhetoric & Synthesis',
        description: 'Accumulate 50 XP across games and synthesis',
        icon: Icons.military_tech_outlined,
        targetCount: 50,
        currentCount: totalXp,
      ),
    ];

    final completedCount = quests.where((q) => q.isCompleted).length;
    final allCompleted = completedCount == quests.length;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF141824),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: allCompleted ? const Color(0xFF10B981).withValues(alpha: 0.4) : Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.assignment_outlined, size: 18, color: Color(0xFF818CF8)),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'DAILY QUEST BOARD',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: allCompleted ? const Color(0xFF10B981).withValues(alpha: 0.2) : Colors.white10,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: allCompleted ? const Color(0xFF10B981) : Colors.white12,
                  ),
                ),
                child: Text(
                  '$completedCount / 3 Done',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: allCompleted ? const Color(0xFF34D399) : Colors.white70,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Quests List
          ...quests.map((q) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF181C28),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: q.isCompleted ? const Color(0xFF10B981).withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.04),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        q.isCompleted ? Icons.check_circle : q.icon,
                        size: 20,
                        color: q.isCompleted ? const Color(0xFF10B981) : const Color(0xFF6366F1),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              q.title,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: q.isCompleted ? Colors.white : Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              q.description,
                              style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.4)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${q.currentCount.clamp(0, q.targetCount)}/${q.targetCount}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: q.isCompleted ? const Color(0xFF34D399) : Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          const SizedBox(height: 8),
          // Chest Claim Button
          if (_isClaimedToday)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.verified, size: 16, color: Color(0xFF10B981)),
                  SizedBox(width: 8),
                  Text(
                    'Daily Chest Claimed (+100 XP)',
                    style: TextStyle(color: Color(0xFF34D399), fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ],
              ),
            )
          else
            ElevatedButton.icon(
              onPressed: allCompleted ? () => _claimReward(100) : null,
              icon: Icon(
                allCompleted ? Icons.lock_open : Icons.lock,
                size: 18,
                color: allCompleted ? Colors.black : Colors.white38,
              ),
              label: Text(
                allCompleted ? 'Open Daily Quest Chest (+100 XP)' : 'Complete All 3 Quests to Unlock Chest',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: allCompleted ? Colors.black : Colors.white38,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF59E0B),
                disabledBackgroundColor: Colors.white10,
                minimumSize: const Size(double.infinity, 44),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
        ],
      ),
    );
  }
}
