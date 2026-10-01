import '../../domain/enums.dart';
import '../../domain/task.dart';
import '../../domain/user_settings.dart';
import 'date_page.dart';
import 'task_sort.dart';

/// Android notification channels (SPEC §8, M6).
const dailySummaryChannelId = 'daily_summary';
const planningChannelId = 'planning';

enum NotificationKind { morning, evening }

/// Deterministic id so rescheduling replaces rather than duplicates
/// (SPEC §8): `yyyyMMdd * 10 + 1` for morning, `+ 2` for evening.
int notificationIdFor(DateTime date, NotificationKind kind) {
  final yyyymmdd = date.year * 10000 + date.month * 100 + date.day;
  return yyyymmdd * 10 + (kind == NotificationKind.morning ? 1 : 2);
}

class ScheduledNotification {
  const ScheduledNotification({
    required this.id,
    required this.scheduledAt,
    required this.title,
    required this.body,
    required this.channelId,
    required this.kind,
  });

  final int id;

  /// Floating local value (CLAUDE.md rule 5) — never UTC-converted.
  final DateTime scheduledAt;
  final String title;
  final String body;
  final String channelId;
  final NotificationKind kind;
}

/// Pure builder (SPEC §8, M6) — no plugin calls, fully unit-testable.
///
/// [tasksByDate] must cover `today .. today + days` inclusive (the evening
/// notification on the last scheduled day still needs *tomorrow*'s tasks,
/// one day past the [days] window) — keyed by floating local date
/// (year/month/day only, as produced by `DateTime(y, m, d)`).
List<ScheduledNotification> buildDailyNotifications({
  required Map<DateTime, List<Task>> tasksByDate,
  required UserSettings settings,
  required DateTime now,
  int days = 7,
}) {
  final today = DateTime(now.year, now.month, now.day);
  final result = <ScheduledNotification>[];

  for (var offset = 0; offset < days; offset++) {
    final date = addDays(today, offset);

    if (settings.morningEnabled) {
      final scheduledAt = _atTimeOfDay(date, settings.morningTime);
      if (!scheduledAt.isBefore(now)) {
        final todoTasks = _todoTasksFor(tasksByDate, date);
        result.add(
          ScheduledNotification(
            id: notificationIdFor(date, NotificationKind.morning),
            scheduledAt: scheduledAt,
            title: 'Good morning: ${todoTasks.length} tasks today',
            body: _morningBody(todoTasks),
            channelId: dailySummaryChannelId,
            kind: NotificationKind.morning,
          ),
        );
      }
    }

    if (settings.eveningEnabled) {
      final scheduledAt = _atTimeOfDay(date, settings.eveningTime);
      if (!scheduledAt.isBefore(now)) {
        final tomorrow = addDays(date, 1);
        final tomorrowTasks = _todoTasksFor(tasksByDate, tomorrow);
        result.add(
          ScheduledNotification(
            id: notificationIdFor(date, NotificationKind.evening),
            scheduledAt: scheduledAt,
            title: 'Plan tomorrow',
            body: tomorrowTasks.isEmpty
                ? 'Nothing planned for tomorrow yet.'
                : 'Tomorrow has ${tomorrowTasks.length} tasks. Add or '
                      'review them.',
            channelId: planningChannelId,
            kind: NotificationKind.evening,
          ),
        );
      }
    }
  }

  return result;
}

List<Task> _todoTasksFor(Map<DateTime, List<Task>> tasksByDate, DateTime date) {
  final tasks = tasksByDate[date] ?? const [];
  return tasks
      .where((t) => t.status == TaskStatus.todo && t.deletedAt == null)
      .toList();
}

String _morningBody(List<Task> todoTasks) {
  if (todoTasks.isEmpty) return 'Nothing planned today. Add something?';
  final sorted = sortTasksForDaySection(todoTasks);
  final firstThree = sorted.take(3).map((t) => t.title).toList();
  final remaining = sorted.length - firstThree.length;
  var body = firstThree.join(', ');
  if (remaining > 0) body += ', +$remaining more';
  body += '\nTap to see the latest';
  return body;
}

DateTime _atTimeOfDay(DateTime date, String hhmmss) {
  final parts = hhmmss.split(':');
  return DateTime(
    date.year,
    date.month,
    date.day,
    int.parse(parts[0]),
    int.parse(parts[1]),
  );
}
