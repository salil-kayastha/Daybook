import 'dart:convert';

import 'package:drift/drift.dart' show Value;

import '../../core/utils/date_page.dart';
import '../../domain/checklist_item.dart';
import '../../domain/enums.dart';
import '../../domain/local_time.dart';
import '../../domain/task.dart';
import '../local/database.dart' as db;
import '../local/task_dao.dart';

class TaskRepository {
  TaskRepository(this._dao);

  final TaskDao _dao;

  Stream<List<Task>> watchForDate(DateTime date) =>
      _dao.watchForDate(date).map((rows) => rows.map(_toDomain).toList());

  Stream<Set<DateTime>> watchDatesWithTasksInRange(
    DateTime start,
    DateTime endExclusive,
  ) => _dao.watchDatesWithTasksInRange(start, endExclusive);

  Future<void> upsert(Task task) => _dao.upsert(_toCompanion(task));

  Future<void> toggleDone(Task task) {
    final now = DateTime.now().toUtc();
    final becomingDone = task.status != TaskStatus.done;
    return upsert(
      task.copyWith(
        status: becomingDone ? TaskStatus.done : TaskStatus.todo,
        completedAt: becomingDone ? now : null,
        updatedAt: now,
      ),
    );
  }

  /// Explicit "Cancel task" action (SPEC §7.3 status actions).
  Future<void> cancel(Task task) {
    final now = DateTime.now().toUtc();
    return upsert(
      task.copyWith(
        status: TaskStatus.cancelled,
        completedAt: null,
        updatedAt: now,
      ),
    );
  }

  /// "Restore" action: un-does done/cancelled, back to todo.
  Future<void> restore(Task task) {
    final now = DateTime.now().toUtc();
    return upsert(
      task.copyWith(status: TaskStatus.todo, completedAt: null, updatedAt: now),
    );
  }

  Future<void> moveToDate(Task task, DateTime date) {
    final now = DateTime.now().toUtc();
    return upsert(
      task.copyWith(
        taskDate: DateTime(date.year, date.month, date.day),
        updatedAt: now,
      ),
    );
  }

  Future<void> moveToTomorrow(Task task) =>
      moveToDate(task, addDays(task.taskDate, 1));

  /// Soft delete (CLAUDE.md rule 6) — sets `deleted_at`, hidden by every
  /// query. Pass the same [task] to [restore] via an Undo action to bring
  /// it back (as long as the caller kept a reference to it).
  Future<void> softDelete(Task task) {
    final now = DateTime.now().toUtc();
    return upsert(task.copyWith(deletedAt: now, updatedAt: now));
  }

  /// Undo for [softDelete]: clears `deleted_at`, keeping status/fields as
  /// they were.
  Future<void> undoDelete(Task task) {
    final now = DateTime.now().toUtc();
    return upsert(task.copyWith(deletedAt: null, updatedAt: now));
  }

  db.TasksCompanion _toCompanion(Task task) {
    return db.TasksCompanion.insert(
      id: task.id,
      userId: Value(task.userId),
      categoryId: Value(task.categoryId),
      title: task.title,
      notes: Value(task.notes),
      checklist: Value(
        jsonEncode(task.checklist.map((c) => c.toJson()).toList()),
      ),
      taskDate: DateTime(
        task.taskDate.year,
        task.taskDate.month,
        task.taskDate.day,
      ),
      timeMode: Value(task.timeMode),
      startTime: Value(task.startTime?.format24()),
      endTime: Value(task.endTime?.format24()),
      status: Value(task.status),
      completedAt: Value(task.completedAt),
      sortOrder: Value(task.sortOrder),
      recurrenceRule: Value(task.recurrenceRule),
      recurrenceParentId: Value(task.recurrenceParentId),
      createdAt: task.createdAt,
      updatedAt: task.updatedAt,
      deletedAt: Value(task.deletedAt),
    );
  }

  Task _toDomain(db.Task row) {
    return Task(
      id: row.id,
      userId: row.userId,
      categoryId: row.categoryId,
      title: row.title,
      notes: row.notes,
      checklist: (jsonDecode(row.checklist) as List)
          .cast<Map<String, dynamic>>()
          .map(ChecklistItem.fromJson)
          .toList(),
      taskDate: row.taskDate,
      timeMode: row.timeMode,
      startTime: _parseLocalTime(row.startTime),
      endTime: _parseLocalTime(row.endTime),
      status: row.status,
      completedAt: row.completedAt,
      sortOrder: row.sortOrder,
      recurrenceRule: row.recurrenceRule,
      recurrenceParentId: row.recurrenceParentId,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      deletedAt: row.deletedAt,
    );
  }

  LocalTime? _parseLocalTime(String? raw) {
    if (raw == null) return null;
    final parts = raw.split(':');
    return LocalTime(int.parse(parts[0]), int.parse(parts[1]));
  }
}
