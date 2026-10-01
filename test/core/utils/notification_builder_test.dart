import 'package:daybook/core/utils/notification_builder.dart';
import 'package:daybook/domain/enums.dart';
import 'package:daybook/domain/local_time.dart';
import 'package:daybook/domain/task.dart';
import 'package:daybook/domain/user_settings.dart';
import 'package:flutter_test/flutter_test.dart';

UserSettings _settings({
  bool morningEnabled = true,
  String morningTime = '07:30:00',
  bool eveningEnabled = true,
  String eveningTime = '21:00:00',
}) {
  final now = DateTime.utc(2026, 1, 1);
  return UserSettings(
    userId: 'user-1',
    morningEnabled: morningEnabled,
    morningTime: morningTime,
    eveningEnabled: eveningEnabled,
    eveningTime: eveningTime,
    updatedAt: now,
    localChangedAt: now,
  );
}

Task _task(
  String title, {
  DateTime? date,
  TimeMode timeMode = TimeMode.none,
  int? startHour,
  int? startMinute,
  TaskStatus status = TaskStatus.todo,
  DateTime? deletedAt,
  double sortOrder = 0,
  DateTime? createdAt,
}) {
  final now = DateTime.utc(2026, 1, 1);
  return Task(
    id: title,
    title: title,
    taskDate: date ?? DateTime(2026, 1, 10),
    timeMode: timeMode,
    startTime: startHour == null
        ? null
        : LocalTime(startHour, startMinute ?? 0),
    status: status,
    deletedAt: deletedAt,
    sortOrder: sortOrder,
    createdAt: createdAt ?? now,
    updatedAt: now,
  );
}

void main() {
  // Fixed "now" well before any of the test notification times, so nothing
  // is skipped as past unless a test deliberately sets up that case.
  final now = DateTime(2026, 1, 10, 6);
  final today = DateTime(2026, 1, 10);

  group('buildDailyNotifications', () {
    test('0 tasks: morning/evening use the empty-state bodies', () {
      final result = buildDailyNotifications(
        tasksByDate: const {},
        settings: _settings(),
        now: now,
        days: 1,
      );

      final morning = result.firstWhere(
        (n) => n.kind == NotificationKind.morning,
      );
      expect(morning.title, 'Good morning: 0 tasks today');
      expect(morning.body, 'Nothing planned today. Add something?');

      final evening = result.firstWhere(
        (n) => n.kind == NotificationKind.evening,
      );
      expect(evening.title, 'Plan tomorrow');
      expect(evening.body, 'Nothing planned for tomorrow yet.');
    });

    test('1 task: morning title/body reflect it, no "+K more"', () {
      final result = buildDailyNotifications(
        tasksByDate: {
          today: [_task('Buy milk', date: today)],
        },
        settings: _settings(),
        now: now,
        days: 1,
      );
      final morning = result.firstWhere(
        (n) => n.kind == NotificationKind.morning,
      );
      expect(morning.title, 'Good morning: 1 tasks today');
      expect(morning.body, 'Buy milk\nTap to see the latest');
    });

    test('exactly 3 tasks: all three listed, no "+K more"', () {
      final tasks = [
        _task('A', date: today),
        _task('B', date: today),
        _task('C', date: today),
      ];
      final result = buildDailyNotifications(
        tasksByDate: {today: tasks},
        settings: _settings(),
        now: now,
        days: 1,
      );
      final morning = result.firstWhere(
        (n) => n.kind == NotificationKind.morning,
      );
      expect(morning.title, 'Good morning: 3 tasks today');
      expect(morning.body, 'A, B, C\nTap to see the latest');
    });

    test('10 tasks: first 3 (by sort order) + "+7 more"', () {
      final tasks = [
        for (var i = 0; i < 10; i++)
          _task(
            'Task$i',
            date: today,
            sortOrder: i.toDouble(),
            createdAt: DateTime.utc(2026, 1, 1, 0, i),
          ),
      ];
      final result = buildDailyNotifications(
        tasksByDate: {today: tasks},
        settings: _settings(),
        now: now,
        days: 1,
      );
      final morning = result.firstWhere(
        (n) => n.kind == NotificationKind.morning,
      );
      expect(morning.title, 'Good morning: 10 tasks today');
      expect(
        morning.body,
        'Task0, Task1, Task2, +7 more\nTap to see the latest',
      );
    });

    test('mixed time modes: timed (at) first by start time, then window, '
        'then no-time', () {
      final tasks = [
        _task('NoTime', date: today, timeMode: TimeMode.none, sortOrder: 0),
        _task(
          'Window1000',
          date: today,
          timeMode: TimeMode.window,
          startHour: 10,
        ),
        _task('At0900', date: today, timeMode: TimeMode.at, startHour: 9),
      ];
      final result = buildDailyNotifications(
        tasksByDate: {today: tasks},
        settings: _settings(),
        now: now,
        days: 1,
      );
      final morning = result.firstWhere(
        (n) => n.kind == NotificationKind.morning,
      );
      expect(morning.body, 'At0900, Window1000, NoTime\nTap to see the latest');
    });

    test('done, cancelled and deleted tasks are excluded from the count', () {
      final tasks = [
        _task('Todo', date: today, status: TaskStatus.todo),
        _task('Done', date: today, status: TaskStatus.done),
        _task('Cancelled', date: today, status: TaskStatus.cancelled),
        _task(
          'Deleted',
          date: today,
          status: TaskStatus.todo,
          deletedAt: DateTime.utc(2026, 1, 1),
        ),
      ];
      final result = buildDailyNotifications(
        tasksByDate: {today: tasks},
        settings: _settings(),
        now: now,
        days: 1,
      );
      final morning = result.firstWhere(
        (n) => n.kind == NotificationKind.morning,
      );
      expect(morning.title, 'Good morning: 1 tasks today');
      expect(morning.body, 'Todo\nTap to see the latest');
    });

    test('a notification whose time is already in the past is skipped', () {
      // "now" is 06:00; morning is scheduled for 07:30, still future, but
      // evening at 21:00 the PREVIOUS day (offset -1 isn't reachable, so
      // instead schedule days=1 starting "today" with a morning time
      // already past).
      final pastNow = DateTime(2026, 1, 10, 8); // after 07:30
      final result = buildDailyNotifications(
        tasksByDate: const {},
        settings: _settings(morningTime: '07:30:00'),
        now: pastNow,
        days: 1,
      );
      expect(
        result.any((n) => n.kind == NotificationKind.morning),
        isFalse,
        reason: "07:30 today is before 08:00 'now' — must be skipped",
      );
      // Evening (21:00) is still in the future relative to 08:00.
      expect(result.any((n) => n.kind == NotificationKind.evening), isTrue);
    });

    test(
      '7-day window produces up to 14 notifications (morning+evening × 7)',
      () {
        final result = buildDailyNotifications(
          tasksByDate: const {},
          settings: _settings(),
          now: now,
          days: 7,
        );
        expect(result.length, 14);
      },
    );

    test('morning toggle off: no morning notifications at all', () {
      final result = buildDailyNotifications(
        tasksByDate: const {},
        settings: _settings(morningEnabled: false),
        now: now,
        days: 7,
      );
      expect(result.any((n) => n.kind == NotificationKind.morning), isFalse);
      expect(result.length, 7);
    });

    test('evening toggle off: no evening notifications at all', () {
      final result = buildDailyNotifications(
        tasksByDate: const {},
        settings: _settings(eveningEnabled: false),
        now: now,
        days: 7,
      );
      expect(result.any((n) => n.kind == NotificationKind.evening), isFalse);
      expect(result.length, 7);
    });

    test('evening body counts TOMORROW\'s tasks, not today\'s', () {
      final tomorrow = DateTime(2026, 1, 11);
      final result = buildDailyNotifications(
        tasksByDate: {
          today: [_task('TodayTask', date: today)],
          tomorrow: [
            _task('TomorrowA', date: tomorrow),
            _task('TomorrowB', date: tomorrow),
          ],
        },
        settings: _settings(),
        now: now,
        days: 1,
      );
      final evening = result.firstWhere(
        (n) => n.kind == NotificationKind.evening,
      );
      expect(evening.body, 'Tomorrow has 2 tasks. Add or review them.');
    });
  });

  group('notificationIdFor (id generation)', () {
    test('morning and evening ids for the same date are distinct', () {
      final date = DateTime(2026, 3, 7);
      final morningId = notificationIdFor(date, NotificationKind.morning);
      final eveningId = notificationIdFor(date, NotificationKind.evening);
      expect(morningId, 20260307 * 10 + 1);
      expect(eveningId, 20260307 * 10 + 2);
    });

    test('different dates produce different ids (no collisions)', () {
      final id1 = notificationIdFor(
        DateTime(2026, 3, 7),
        NotificationKind.morning,
      );
      final id2 = notificationIdFor(
        DateTime(2026, 3, 8),
        NotificationKind.morning,
      );
      expect(id1, isNot(id2));
    });

    test('rescheduling the same date+kind reuses the same id (replace, not duplicate)', () {
      final date = DateTime(2026, 3, 7);
      final first = notificationIdFor(date, NotificationKind.evening);
      final second = notificationIdFor(date, NotificationKind.evening);
      expect(first, second);
    });
  });
}
