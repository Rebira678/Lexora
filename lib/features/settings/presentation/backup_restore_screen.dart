import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../app/theme.dart';
import '../../../core/db/database.dart';
import '../../../app/providers.dart';

class BackupRestoreScreen extends ConsumerStatefulWidget {
  const BackupRestoreScreen({super.key});

  @override
  ConsumerState<BackupRestoreScreen> createState() => _BackupRestoreScreenState();
}

class _BackupRestoreScreenState extends ConsumerState<BackupRestoreScreen> {
  final TextEditingController _importController = TextEditingController();
  bool _isProcessing = false;
  String? _statusMessage;
  bool _isSuccess = true;

  @override
  void dispose() {
    _importController.dispose();
    super.dispose();
  }

  Future<void> _exportData() async {
    setState(() {
      _isProcessing = true;
      _statusMessage = null;
    });

    try {
      final db = ref.read(databaseProvider);

      final cards = await db.select(db.srsCards).get();
      final stats = await db.select(db.dailyStats).get();
      final streak = await (db.select(db.streaks)..where((s) => s.id.equals(1))).getSingleOrNull();
      final texts = await db.select(db.userTexts).get();
      final achievements = await db.select(db.achievements).get();

      final exportMap = {
        'version': 1,
        'exportedAt': DateTime.now().toIso8601String(),
        'streak': streak != null
            ? {
                'current': streak.current,
                'best': streak.best,
                'freezes': streak.freezes,
                'lastDay': streak.lastDay,
                'totalDays': streak.totalDays,
              }
            : null,
        'srsCards': cards
            .map((c) => {
                  'id': c.id,
                  'itemType': c.itemType,
                  'itemId': c.itemId,
                  'skill': c.skill,
                  'repetitions': c.repetitions,
                  'intervalDays': c.intervalDays,
                  'ease': c.ease,
                  'dueAt': c.dueAt,
                  'lapses': c.lapses,
                })
            .toList(),
        'dailyStats': stats
            .map((s) => {
                  'day': s.day,
                  'minutes': s.minutes,
                  'xp': s.xp,
                  'itemsReviewed': s.itemsReviewed,
                  'goalMet': s.goalMet,
                })
            .toList(),
        'userTexts': texts
            .map((t) => {
                  'prompt': t.prompt,
                  'body': t.body,
                  'createdAt': t.createdAt,
                  'selfScore': t.selfScore,
                })
            .toList(),
        'achievements': achievements
            .map((a) => {
                  'code': a.code,
                  'unlockedAt': a.unlockedAt,
                })
            .toList(),
      };

      final jsonStr = const JsonEncoder.withIndent('  ').convert(exportMap);
      Clipboard.setData(ClipboardData(text: jsonStr));

      if (!mounted) return;
      setState(() {
        _isProcessing = false;
        _isSuccess = true;
        _statusMessage = 'Backup payload successfully created and copied to your clipboard (${cards.length} cards, ${texts.length} texts)!';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isProcessing = false;
        _isSuccess = false;
        _statusMessage = 'Failed to generate backup: $e';
      });
    }
  }

  Future<void> _restoreData() async {
    final text = _importController.text.trim();
    if (text.isEmpty) {
      setState(() {
        _statusMessage = 'Please paste a valid JSON backup payload to restore.';
        _isSuccess = false;
      });
      return;
    }

    setState(() {
      _isProcessing = true;
      _statusMessage = null;
    });

    try {
      final data = json.decode(text) as Map<String, dynamic>;
      final db = ref.read(databaseProvider);

      await db.transaction(() async {
        // Restore Streak
        if (data['streak'] != null) {
          final s = data['streak'] as Map<String, dynamic>;
          await (db.update(db.streaks)..where((tbl) => tbl.id.equals(1))).write(
            StreaksCompanion(
              current: drift.Value(s['current'] as int? ?? 0),
              best: drift.Value(s['best'] as int? ?? 0),
              freezes: drift.Value(s['freezes'] as int? ?? 0),
              lastDay: drift.Value(s['lastDay'] as String? ?? ''),
              totalDays: drift.Value(s['totalDays'] as int? ?? 0),
            ),
          );
        }

        // Restore SRS Cards
        if (data['srsCards'] is List) {
          for (final c in data['srsCards']) {
            await db.into(db.srsCards).insertOnConflictUpdate(
                  SrsCardsCompanion(
                    id: drift.Value(c['id'] as int),
                    itemType: drift.Value(c['itemType'] as String? ?? 'word'),
                    itemId: drift.Value(c['itemId'] as int? ?? (c['wordId'] as int? ?? 1)),
                    skill: drift.Value(c['skill'] as String? ?? 'vocab'),
                    repetitions: drift.Value(c['repetitions'] as int? ?? (c['reps'] as int? ?? 0)),
                    intervalDays: drift.Value(c['intervalDays'] as int? ?? (c['interval'] as int? ?? 1)),
                    ease: drift.Value((c['ease'] as num?)?.toDouble() ?? ((c['easeFactor'] as num?)?.toDouble() ?? 2.5)),
                    dueAt: drift.Value(c['dueAt'] as int? ?? (c['due'] as int? ?? 0)),
                    lapses: drift.Value(c['lapses'] as int? ?? 0),
                  ),
                );
          }
        }

        // Restore User Texts
        if (data['userTexts'] is List) {
          for (final t in data['userTexts']) {
            await db.into(db.userTexts).insert(
                  UserTextsCompanion.insert(
                    prompt: t['prompt'] as String,
                    body: t['body'] as String,
                    createdAt: t['createdAt'] as int? ?? DateTime.now().millisecondsSinceEpoch,
                    selfScore: drift.Value(t['selfScore'] as int?),
                  ),
                );
          }
        }

        // Restore Achievements
        if (data['achievements'] is List) {
          for (final a in data['achievements']) {
            await db.into(db.achievements).insertOnConflictUpdate(
                  AchievementsCompanion.insert(
                    code: a['code'] as String,
                    unlockedAt: a['unlockedAt'] as int? ?? DateTime.now().millisecondsSinceEpoch,
                  ),
                );
          }
        }
      });

      if (!mounted) return;
      setState(() {
        _isProcessing = false;
        _isSuccess = true;
        _statusMessage = 'Backup payload successfully restored! All cards, stats, and texts loaded.';
        _importController.clear();
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isProcessing = false;
        _isSuccess = false;
        _statusMessage = 'Restore failed. Invalid format or data corrupt: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Backup & Restore'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Export Section
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.colorScheme.outline),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.file_upload_outlined, color: AppColors.accent, size: 22),
                        const SizedBox(width: 8),
                        Text(
                          'Export Offline Backup',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Export your entire learning history, SRS intervals, journal entries, and streak counters into a lightweight JSON string.',
                      style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant, height: 1.3),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.copy_rounded, size: 18),
                      label: const Text('Generate & Copy Backup JSON'),
                      onPressed: _isProcessing ? null : _exportData,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Import Section
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.colorScheme.outline),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.file_download_outlined, color: AppColors.correct, size: 22),
                        const SizedBox(width: 8),
                        Text(
                          'Restore from Backup',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Paste a previously generated backup JSON payload below to restore your progress without data loss.',
                      style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant, height: 1.3),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: _importController,
                      maxLines: 4,
                      style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                      decoration: InputDecoration(
                        hintText: 'Paste backup JSON here...',
                        filled: true,
                        fillColor: theme.colorScheme.surfaceContainerHighest,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 14),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.restore_rounded, size: 18),
                      label: const Text('Restore Progress from JSON'),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.correct),
                      onPressed: _isProcessing ? null : _restoreData,
                    ),
                  ],
                ),
              ),

              // Status Message
              if (_statusMessage != null) ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: (_isSuccess ? AppColors.correct : AppColors.wrong).withAlpha(20),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: (_isSuccess ? AppColors.correct : AppColors.wrong).withAlpha(80)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isSuccess ? Icons.check_circle_outline_rounded : Icons.error_outline_rounded,
                        color: _isSuccess ? AppColors.correct : AppColors.wrong,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _statusMessage!,
                          style: const TextStyle(fontSize: 13, height: 1.3),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
