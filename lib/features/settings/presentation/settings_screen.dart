import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../app/theme.dart';
import '../../../app/providers.dart';
import 'backup_restore_screen.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _remindersEnabled = true;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 8, minute: 30);
  double _speechRate = 0.5;
  bool _useFsrs = false;

  @override
  void initState() {
    super.initState();
    _loadSrsPreference();
  }

  Future<void> _loadSrsPreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (mounted) {
        setState(() {
          _useFsrs = prefs.getBool('use_fsrs_engine') ?? false;
        });
      }
    } catch (_) {}
  }

  Future<void> _toggleSrsPreference(bool val) async {
    setState(() => _useFsrs = val);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('use_fsrs_engine', val);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(val ? 'FSRS v4.5 Scheduler Activated (90% target retention)' : 'SM-2 Classic Scheduler Activated'),
            backgroundColor: AppColors.correct,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings & Preferences'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Offline Privacy Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.colorScheme.outline),
              ),
              child: Row(
                children: [
                  Icon(Icons.lock_outline_rounded, color: theme.colorScheme.primary, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('100% Offline & Private', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                        const SizedBox(height: 2),
                        Text(
                          'Zero cloud tracking, zero network permissions. All progress and audio live locally on your device.',
                          style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Daily Notifications Section
            Text('Daily Habits', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Daily Study Reminder'),
                    subtitle: const Text('A kind, offline notification to protect your streak'),
                    value: _remindersEnabled,
                    onChanged: (val) async {
                      setState(() => _remindersEnabled = val);
                      if (val) {
                        await ref.read(notificationServiceProvider).scheduleDailyReminder(
                              hour: _reminderTime.hour,
                              minute: _reminderTime.minute,
                            );
                      } else {
                        await ref.read(notificationServiceProvider).cancelDailyReminder();
                      }
                    },
                  ),
                  if (_remindersEnabled) ...[
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.access_time_rounded, color: AppColors.accent),
                      title: const Text('Reminder Time'),
                      subtitle: Text(_reminderTime.format(context)),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: _reminderTime,
                        );
                        if (picked != null) {
                          setState(() => _reminderTime = picked);
                          await ref.read(notificationServiceProvider).scheduleDailyReminder(
                                hour: picked.hour,
                                minute: picked.minute,
                              );
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Reminder set for ${picked.format(context)} daily!'),
                                backgroundColor: AppColors.correct,
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Audio & Speech Section
            Text('Audio & Pronunciation', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('TTS Speech Speed', style: TextStyle(fontWeight: FontWeight.w600)),
                        Text('${(_speechRate * 2).toStringAsFixed(1)}x', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.accent)),
                      ],
                    ),
                    Slider(
                      value: _speechRate,
                      min: 0.25,
                      max: 1.0,
                      divisions: 6,
                      activeColor: AppColors.accent,
                      onChanged: (val) {
                        setState(() => _speechRate = val);
                        ref.read(ttsServiceProvider).setSpeechRate(val);
                      },
                    ),
                    const SizedBox(height: 4),
                    Center(
                      child: TextButton.icon(
                        icon: const Icon(Icons.volume_up_rounded),
                        label: const Text('Test English Pronunciation'),
                        onPressed: () {
                          ref.read(audioServiceProvider).speakOrPlay('Welcome to English Arena. Build mastery one day at a time.');
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Spaced Repetition Engine (Spec 2.1 & Phase 5)
            Text('Spaced Repetition Algorithm', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Use FSRS v4.5 (Modern DSR Engine)', style: TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text(
                        _useFsrs
                            ? 'FSRS active: Retrievability decay model targeting 90% retention'
                            : 'SM-2 active: Classical SuperMemo fixed-factor progression',
                        style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                      ),
                      value: _useFsrs,
                      activeColor: const Color(0xFF10B981),
                      onChanged: _toggleSrsPreference,
                    ),
                    const Divider(height: 1),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.info_outline, size: 16, color: theme.colorScheme.primary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'FSRS calculates item stability (S) and difficulty (D) to eliminate review bottlenecks on mature cards.',
                            style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Danger Zone
            Text('Data & Progress', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.backup_rounded, color: AppColors.accent),
                title: const Text('Backup & Restore'),
                subtitle: const Text('Export or restore offline JSON progress'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const BackupRestoreScreen()),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.restart_alt_rounded, color: AppColors.wrong),
                title: const Text('Reset Today\'s Daily Plan'),
                subtitle: const Text('Regenerate today\'s 4-step mission queue'),
                onTap: () {
                  ref.invalidate(todayPlanProvider);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Today\'s mission plan refreshed!')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
