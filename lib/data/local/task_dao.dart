import 'package:drift/drift.dart';

import 'database.dart';
import 'tables.dart';

part 'task_dao.g.dart';

@DriftAccessor(tables: [Tasks])
class TaskDao extends DatabaseAccessor<AppDatabase> with _$TaskDaoMixin {
  TaskDao(super.db);

  Stream<List<Task>> watchForDate(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    return (select(tasks)
          ..where((t) => t.deletedAt.isNull() & t.taskDate.equals(normalized)))
        .watch();
  }

  /// Distinct dates (in `[start, endExclusive)`) that have at least one
  /// non-deleted task, for the date-picker sheet's "has tasks" dot.
  Stream<Set<DateTime>> watchDatesWithTasksInRange(
    DateTime start,
    DateTime endExclusive,
  ) {
    final query = selectOnly(tasks, distinct: true)
      ..addColumns([tasks.taskDate])
      ..where(
        tasks.deletedAt.isNull() &
            tasks.taskDate.isBiggerOrEqualValue(start) &
            tasks.taskDate.isSmallerThanValue(endExclusive),
      );
    return query.watch().map(
      (rows) => rows.map((r) => r.read(tasks.taskDate)!).toSet(),
    );
  }

  Future<void> upsert(TasksCompanion entry) =>
      into(tasks).insertOnConflictUpdate(entry);

  Future<Task?> getById(String id) =>
      (select(tasks)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<Task>> getAll() => select(tasks).get();
}
