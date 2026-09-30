import '../../domain/enums.dart';
import '../../domain/local_time.dart';
import '../../domain/task.dart';

/// Sort order inside a category on the Day screen (SPEC §4):
/// 1. `todo` first, then `done`, then `cancelled`.
/// 2. Within `todo`: `at` by `startTime`, then `window` by `startTime`,
///    then `none` by `sortOrder`, then `createdAt`.
List<Task> sortTasksForDaySection(List<Task> tasks) {
  final copy = [...tasks]..sort(compareTasksForDaySection);
  return copy;
}

int compareTasksForDaySection(Task a, Task b) {
  final statusCompare = _statusRank(a.status).compareTo(_statusRank(b.status));
  if (statusCompare != 0) return statusCompare;

  if (a.status == TaskStatus.todo) {
    final modeCompare = _timeModeRank(a.timeMode)
        .compareTo(_timeModeRank(b.timeMode));
    if (modeCompare != 0) return modeCompare;

    if (a.timeMode == TimeMode.at || a.timeMode == TimeMode.window) {
      final startCompare = (a.startTime ?? const LocalTime(0, 0)).compareTo(
        b.startTime ?? const LocalTime(0, 0),
      );
      if (startCompare != 0) return startCompare;
    } else {
      final sortOrderCompare = a.sortOrder.compareTo(b.sortOrder);
      if (sortOrderCompare != 0) return sortOrderCompare;
    }
  }

  return a.createdAt.compareTo(b.createdAt);
}

int _statusRank(TaskStatus status) => switch (status) {
  TaskStatus.todo => 0,
  TaskStatus.done => 1,
  TaskStatus.cancelled => 2,
};

int _timeModeRank(TimeMode mode) => switch (mode) {
  TimeMode.at => 0,
  TimeMode.window => 1,
  TimeMode.none => 2,
};
