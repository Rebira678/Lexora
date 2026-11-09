import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// 100% Offline Daily Reminder Notification Service.
///
/// Encourages daily 5-15 minute study habits without guilt or shame copy.
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    try {
      tz.initializeTimeZones();

      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const initSettings = InitializationSettings(android: androidSettings);

      await _notificationsPlugin.initialize(initSettings);
      _isInitialized = true;
    } catch (_) {
      // Graceful fallback on test/unsupported environments
    }
  }

  /// Schedules a recurring daily study reminder at the given [hour] and [minute].
  Future<void> scheduleDailyReminder({int hour = 8, int minute = 30}) async {
    if (!_isInitialized) await init();

    try {
      const androidDetails = AndroidNotificationDetails(
        'english_arena_daily_channel',
        'Daily English Arena Reminder',
        channelDescription: 'Kind daily reminders to keep your English learning streak alive',
        importance: Importance.high,
        priority: Priority.high,
      );

      const notificationDetails = NotificationDetails(android: androidDetails);

      final now = tz.TZDateTime.now(tz.local);
      var scheduledDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );

      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      await _notificationsPlugin.zonedSchedule(
        1001,
        'English Arena 🔥',
        'Your arena is ready! 5 minutes today keeps your streak growing.',
        scheduledDate,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (_) {
      // Inexact scheduling exception handling
    }
  }

  /// Cancels all scheduled reminders.
  Future<void> cancelDailyReminder() async {
    try {
      await _notificationsPlugin.cancel(1001);
    } catch (_) {}
  }
}
