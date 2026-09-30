import 'package:daybook/core/utils/task_sort.dart';
import 'package:daybook/domain/enums.dart';
import 'package:daybook/domain/local_time.dart';
import 'package:daybook/domain/task.dart';
import 'package:flutter_test/flutter_test.dart';

Task _task({
  required String title,
  TaskStatus status = TaskStatus.todo,
  TimeMode timeMode = TimeMode.none,
  LocalTime? startTime,
  LocalTime? endTime,
  double sortOrder = 0,
  DateTime? createdAt,
}) {
  final created = createdAt ?? DateTime(2026, 1, 1);
  return Task(
    id: title,
    title: title,
    taskDate: DateTime(2026, 9, 30),
    status: status,
    timeMode: timeMode,
    startTime: startTime,
    endTime: endTime,
    sortOrder: sortOrder,
    createdAt: created,
    updatedAt: created,
  );
}

void main() {
  group('sortTasksForDaySection', () {
    test('todo before done before cancelled', () {
      final cancelled = _task(title: 'cancelled', status: TaskStatus.cancelled);
      final done = _task(title: 'done', status: TaskStatus.done);
      final todo = _task(title: 'todo');

      final sorted = sortTasksForDaySection([cancelled, done, todo]);

      expect(sorted.map((t) => t.title), ['todo', 'done', 'cancelled']);
    });

    test('within todo: at, then window, then none', () {
      final none = _task(title: 'none');
      final at = _task(
        title: 'at',
        timeMode: TimeMode.at,
        startTime: const LocalTime(9, 0),
      );
      final window = _task(
        title: 'window',
        timeMode: TimeMode.window,
        startTime: const LocalTime(9, 0),
        endTime: const LocalTime(18, 0),
      );

      final sorted = sortTasksForDaySection([none, window, at]);

      expect(sorted.map((t) => t.title), ['at', 'window', 'none']);
    });

    test('at tasks ordered by startTime', () {
      final late = _task(
        title: 'late',
        timeMode: TimeMode.at,
        startTime: const LocalTime(14, 0),
      );
      final early = _task(
        title: 'early',
        timeMode: TimeMode.at,
        startTime: const LocalTime(8, 0),
      );

      final sorted = sortTasksForDaySection([late, early]);

      expect(sorted.map((t) => t.title), ['early', 'late']);
    });

    test('window tasks ordered by startTime, after all at tasks', () {
      final at = _task(
        title: 'at',
        timeMode: TimeMode.at,
        startTime: const LocalTime(23, 0),
      );
      final windowLate = _task(
        title: 'window-late',
        timeMode: TimeMode.window,
        startTime: const LocalTime(14, 0),
        endTime: const LocalTime(15, 0),
      );
      final windowEarly = _task(
        title: 'window-early',
        timeMode: TimeMode.window,
        startTime: const LocalTime(9, 0),
        endTime: const LocalTime(10, 0),
      );

      final sorted = sortTasksForDaySection([windowLate, at, windowEarly]);

      expect(sorted.map((t) => t.title), ['at', 'window-early', 'window-late']);
    });

    test('none tasks ordered by sortOrder, then createdAt', () {
      final b = _task(title: 'b', sortOrder: 2);
      final a = _task(title: 'a', sortOrder: 1);
      final tieOlder = _task(
        title: 'tie-older',
        sortOrder: 3,
        createdAt: DateTime(2026, 1, 1),
      );
      final tieNewer = _task(
        title: 'tie-newer',
        sortOrder: 3,
        createdAt: DateTime(2026, 1, 2),
      );

      final sorted = sortTasksForDaySection([tieNewer, b, tieOlder, a]);

      expect(sorted.map((t) => t.title), ['a', 'b', 'tie-older', 'tie-newer']);
    });

    test('full SPEC §7.2 wireframe ordering within one category', () {
      final meeting = _task(
        title: 'Meeting',
        timeMode: TimeMode.at,
        startTime: const LocalTime(9, 0),
      );
      final handover = _task(
        title: 'Watch handover videos',
        timeMode: TimeMode.window,
        startTime: const LocalTime(9, 0),
        endTime: const LocalTime(18, 0),
      );
      final noTime = _task(title: 'Write blog', sortOrder: 1);

      final sorted = sortTasksForDaySection([noTime, handover, meeting]);

      expect(sorted.map((t) => t.title), [
        'Meeting',
        'Watch handover videos',
        'Write blog',
      ]);
    });

    test('does not mutate the input list', () {
      final tasks = [
        _task(title: 'b', sortOrder: 2),
        _task(title: 'a', sortOrder: 1),
      ];
      final original = [...tasks];

      sortTasksForDaySection(tasks);

      expect(tasks.map((t) => t.title), original.map((t) => t.title));
    });

    test('marking a todo task done sinks it below remaining todos', () {
      final a = _task(title: 'a', sortOrder: 1);
      final b = _task(title: 'b', sortOrder: 2);
      final c = _task(title: 'c', sortOrder: 3);

      expect(sortTasksForDaySection([a, b, c]).map((t) => t.title), [
        'a',
        'b',
        'c',
      ]);

      final bDone = b.copyWith(status: TaskStatus.done);
      expect(sortTasksForDaySection([a, bDone, c]).map((t) => t.title), [
        'a',
        'c',
        'b',
      ], reason: 'done sinks below the remaining todos');
    });

    test('cancelling a done task moves it below the remaining done tasks', () {
      final todo = _task(title: 'todo');
      final done = _task(
        title: 'done',
        status: TaskStatus.done,
        createdAt: DateTime(2026, 1, 1),
      );
      final willBeCancelled = _task(
        title: 'will-be-cancelled',
        status: TaskStatus.done,
        createdAt: DateTime(2026, 1, 2),
      );

      expect(
        sortTasksForDaySection([willBeCancelled, done, todo])
            .map((t) => t.title),
        ['todo', 'done', 'will-be-cancelled'],
        reason: 'both done, tied by earlier createdAt first',
      );

      final nowCancelled = willBeCancelled.copyWith(
        status: TaskStatus.cancelled,
      );
      expect(
        sortTasksForDaySection([nowCancelled, done, todo]).map((t) => t.title),
        ['todo', 'done', 'will-be-cancelled'],
        reason: 'cancelled now ranks uniquely below done, same end result',
      );
    });

    test('restoring a cancelled task to todo re-joins the todo ordering', () {
      final at = _task(
        title: 'at',
        timeMode: TimeMode.at,
        startTime: const LocalTime(9, 0),
      );
      final cancelled = _task(
        title: 'was-cancelled',
        status: TaskStatus.cancelled,
      );

      expect(sortTasksForDaySection([cancelled, at]).map((t) => t.title), [
        'at',
        'was-cancelled',
      ]);

      final restored = cancelled.copyWith(
        status: TaskStatus.todo,
        sortOrder: 0,
      );
      expect(sortTasksForDaySection([restored, at]).map((t) => t.title), [
        'at',
        'was-cancelled',
      ], reason: 'restored todo with no time sorts after the timed todo');
    });
  });
}
