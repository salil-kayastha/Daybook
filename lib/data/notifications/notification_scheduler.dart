import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../../core/theme/colors.dart';
import '../../core/utils/notification_builder.dart';
import '../../core/utils/timezone_change.dart';
import '../../domain/task.dart';
import '../../domain/user_settings.dart';
import '../local/database.dart' hide Task;
import '../repositories/task_repository.dart' show taskFromRow;
import 'notification_tap.dart';

/// Must be top-level/static with this exact `@pragma` (plugin requirement)
/// so a tap is still delivered when Android runs the callback in a
/// background isolate (app not in the foreground). Just forwards the
/// payload to the same tap notifier the foreground handler uses — app.dart
/// consumes it once the widget tree (and router) exists.
@pragma('vm:entry-point')
void notificationBackgroundTapHandler(NotificationResponse response) {
  pendingNotificationTap.value = response.payload;
}

/// Wraps `flutter_local_notifications` + `timezone`/`flutter_timezone`
/// (SPEC §8, M6). No-ops on web (schedules nothing; the Settings screen
/// shows the "best-effort" note instead) — every other method is still
/// safe to call on web, it just does nothing.
class NotificationScheduler {
  NotificationScheduler({required AppDatabase database}) : _db = database;

  final AppDatabase _db;
  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;
  String? _lastZoneId;

  Future<void> initialize() async {
    if (_initialized || kIsWeb) {
      _initialized = true;
      return;
    }

    tz_data.initializeTimeZones();
    await _applyLocalTimezone();

    // Must be a white-on-transparent drawable (`ic_stat_daybook`), never
    // the full-color launcher mipmap — Android rejects a non-silhouette
    // icon here and silently falls back to the default white Flutter
    // logo, which is exactly the bug this fixes. See README "Notification
    // icon" for where the drawable lives and how to regenerate it.
    const androidInit = AndroidInitializationSettings('ic_stat_daybook');
    const iosInit = DarwinInitializationSettings(
      // Requested later, after the first task is created (SPEC §8) — not
      // at first launch.
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: androidInit,
        iOS: iosInit,
      ),
      onDidReceiveNotificationResponse: (response) {
        pendingNotificationTap.value = response.payload;
      },
      onDidReceiveBackgroundNotificationResponse:
          notificationBackgroundTapHandler,
    );

    if (defaultTargetPlatform == TargetPlatform.android) {
      final android = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      await android?.createNotificationChannel(
        const AndroidNotificationChannel(
          dailySummaryChannelId,
          'Daily summary',
          description: 'Your morning task summary',
        ),
      );
      await android?.createNotificationChannel(
        const AndroidNotificationChannel(
          planningChannelId,
          'Planning',
          description: 'Evening reminder to plan tomorrow',
        ),
      );
    }

    _initialized = true;
  }

  Future<void> _applyLocalTimezone() async {
    try {
      final zone = (await FlutterTimezone.getLocalTimezone()).identifier;
      if (!shouldUpdateTimezone(previousZoneId: _lastZoneId, newZoneId: zone)) {
        return;
      }
      tz.setLocalLocation(tz.getLocation(zone));
      _lastZoneId = zone;
    } catch (_) {
      // Falls back to whatever zone was already set (UTC on first run) —
      // better than crashing the reschedule.
    }
  }

  /// Requests the OS notification permission. Per SPEC §8 this is only
  /// called by the caller after the first task is created, not at launch.
  /// Returns whether permission is granted (best-effort on Android < 13,
  /// where no runtime prompt exists and this always reports granted).
  Future<bool> requestPermission() async {
    if (kIsWeb) return false;
    if (defaultTargetPlatform == TargetPlatform.android) {
      final android = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      final granted = await android?.requestNotificationsPermission();
      return granted ?? true;
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final ios = _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();
      final granted = await ios?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }
    return true;
  }

  /// Android 12+ "Alarms & reminders" grant — only requested when the user
  /// turns on the Settings "Exact time" toggle (SPEC §8).
  Future<void> requestExactAlarmPermission() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await android?.requestExactAlarmsPermission();
  }

  Future<bool> areNotificationsEnabled() async {
    if (kIsWeb) return false;
    if (defaultTargetPlatform == TargetPlatform.android) {
      final android = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      return await android?.areNotificationsEnabled() ?? false;
    }
    return true;
  }

  Future<void> openNotificationSettings() async {
    if (kIsWeb) return;
    if (defaultTargetPlatform == TargetPlatform.android) {
      await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.openAppNotificationSettings();
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      await _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.openAppNotificationSettings();
    }
  }

  /// Cancels and reschedules the next 7 days from the current local data
  /// (SPEC §8 "reschedule triggers"). Safe to call often — it's always a
  /// full rebuild of *its own* ids, never an incremental patch, so it
  /// can't drift out of sync with task/settings edits.
  ///
  /// Cancels only the specific morning/evening ids for the window it's
  /// about to (re)write — deliberately NOT `cancelAll()`. This runs on
  /// every ambient trigger (resume, sync pull, any task write), so a
  /// blanket `cancelAll()` here was wiping out anything else pending,
  /// including one-off debug test schedules (`scheduleTestNotification`)
  /// that had nothing to do with the triggering change — confirmed via
  /// `adb shell dumpsys alarm`/`dumpsys notification`: a test alarm would
  /// register, then vanish from the pending list with no notification
  /// ever posted, because an unrelated reschedule cancelled it first.
  Future<void> rescheduleAll({
    required UserSettings? settings,
    int days = 7,
  }) async {
    if (kIsWeb || !_initialized || settings == null) return;

    await _applyLocalTimezone();

    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day);
    for (var offset = 0; offset < days; offset++) {
      final date = start.add(Duration(days: offset));
      await _plugin.cancel(
        id: notificationIdFor(date, NotificationKind.morning),
      );
      await _plugin.cancel(
        id: notificationIdFor(date, NotificationKind.evening),
      );
    }

    // +1 so the last day's evening notification can see tomorrow's tasks.
    final endExclusive = start.add(Duration(days: days + 1));
    final rows = await _db.taskDao.getForDateRange(start, endExclusive);

    final tasksByDate = <DateTime, List<Task>>{};
    for (final row in rows) {
      final task = taskFromRow(row);
      (tasksByDate[task.taskDate] ??= []).add(task);
    }

    final notifications = buildDailyNotifications(
      tasksByDate: tasksByDate,
      settings: settings,
      now: DateTime.now(),
      days: days,
    );

    final useExact = await _db.settingsDao.watch().first.then(
      (s) => s.useExactAlarms,
    );

    for (final notification in notifications) {
      await _plugin.zonedSchedule(
        id: notification.id,
        scheduledDate: tz.TZDateTime(
          tz.local,
          notification.scheduledAt.year,
          notification.scheduledAt.month,
          notification.scheduledAt.day,
          notification.scheduledAt.hour,
          notification.scheduledAt.minute,
        ),
        notificationDetails: _detailsFor(notification),
        androidScheduleMode: useExact
            ? AndroidScheduleMode.exactAllowWhileIdle
            : AndroidScheduleMode.inexactAllowWhileIdle,
        title: notification.title,
        body: notification.body,
        payload: notification.kind == NotificationKind.morning
            ? 'morning'
            : 'evening',
      );
    }
  }

  NotificationDetails _detailsFor(ScheduledNotification notification) {
    final isMorning = notification.kind == NotificationKind.morning;
    return NotificationDetails(
      android: AndroidNotificationDetails(
        notification.channelId,
        isMorning ? 'Daily summary' : 'Planning',
        channelDescription: isMorning
            ? 'Your morning task summary'
            : 'Evening reminder to plan tomorrow',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        icon: 'ic_stat_daybook',
        color: DaybookColors.light.primary,
      ),
      iOS: const DarwinNotificationDetails(),
    );
  }

  Future<void> cancelAll() async {
    if (kIsWeb) return;
    await _plugin.cancelAll();
  }

  /// Debug tool: schedules a real notification [delay] from now via the
  /// exact same `zonedSchedule` code path `rescheduleAll` uses (not a
  /// shortcut through `.show()`) — lets you verify the actual AlarmManager
  /// scheduling mechanism end to end without waiting for a real morning/
  /// evening time to come around.
  Future<void> scheduleTestNotification({
    required Duration delay,
    required bool exact,
  }) async {
    if (kIsWeb || !_initialized) return;
    await _applyLocalTimezone();

    final at = DateTime.now().add(delay);
    final notification = ScheduledNotification(
      id: exact ? 999999998 : 999999997,
      scheduledAt: at,
      title: exact ? 'Test (exact mode)' : 'Test (inexact mode)',
      body:
          'Scheduled ${delay.inSeconds}s ago via the real zonedSchedule path.',
      channelId: dailySummaryChannelId,
      kind: NotificationKind.morning,
    );

    await _plugin.zonedSchedule(
      id: notification.id,
      scheduledDate: tz.TZDateTime(
        tz.local,
        at.year,
        at.month,
        at.day,
        at.hour,
        at.minute,
        at.second,
      ),
      notificationDetails: _detailsFor(notification),
      androidScheduleMode: exact
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexactAllowWhileIdle,
      title: notification.title,
      body: notification.body,
      payload: 'morning',
    );
  }

  /// Debug tool (SPEC §8): fire a notification immediately.
  Future<void> showTestNotificationNow() async {
    if (kIsWeb) return;
    await _plugin.show(
      id: 999999999,
      title: 'Test notification',
      body: 'This is a Daybook test notification.',
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          dailySummaryChannelId,
          'Daily summary',
          channelDescription: 'Your morning task summary',
          icon: 'ic_stat_daybook',
          color: DaybookColors.light.primary,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: 'morning',
    );
  }

  /// Debug tool (SPEC §8): list what's currently scheduled.
  Future<List<PendingNotificationRequest>> pendingNotifications() async {
    if (kIsWeb) return const [];
    return _plugin.pendingNotificationRequests();
  }

  Future<NotificationAppLaunchDetails?> launchDetails() {
    if (kIsWeb) return Future.value(null);
    return _plugin.getNotificationAppLaunchDetails();
  }
}
