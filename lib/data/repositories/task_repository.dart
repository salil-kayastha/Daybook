import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:uuid/uuid.dart';

import '../../domain/checklist_item.dart';
import '../../domain/enums.dart';
import '../../domain/local_time.dart';
import '../../domain/task.dart';
import '../local/database.dart' as db;
import '../local/task_dao.dart';

class TaskRepository {
  TaskRepository(this._dao);

  final TaskDao _dao;
  static const _uuid = Uuid();

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

  Future<int> countAll() => _dao.countAll();

  /// Debug-only helper (M1): seed a handful of sample tasks so the Day
  /// screen layout can be eyeballed before task CRUD exists (M2).
  Future<void> seedDebugSamplesForDate(
    String officeId,
    String personalId,
    DateTime date,
  ) async {
    final now = DateTime.now().toUtc();
    final normalized = DateTime(date.year, date.month, date.day);

    Task sample({
      required String title,
      required String categoryId,
      TimeMode timeMode = TimeMode.none,
      LocalTime? startTime,
      LocalTime? endTime,
      TaskStatus status = TaskStatus.todo,
      required double sortOrder,
    }) {
      return Task(
        id: _uuid.v4(),
        categoryId: categoryId,
        title: title,
        taskDate: normalized,
        timeMode: timeMode,
        startTime: startTime,
        endTime: endTime,
        status: status,
        completedAt: status == TaskStatus.done ? now : null,
        sortOrder: sortOrder,
        createdAt: now,
        updatedAt: now,
      );
    }

    final samples = [
      sample(
        title: 'Meeting',
        categoryId: officeId,
        timeMode: TimeMode.at,
        startTime: const LocalTime(9, 0),
        sortOrder: 1,
      ),
      sample(
        title: 'Watch handover videos',
        categoryId: officeId,
        timeMode: TimeMode.window,
        startTime: const LocalTime(9, 0),
        endTime: const LocalTime(18, 0),
        sortOrder: 2,
      ),
      sample(title: 'Write blog', categoryId: personalId, sortOrder: 1),
      sample(
        title: 'Buy bike parts',
        categoryId: personalId,
        status: TaskStatus.done,
        sortOrder: 2,
      ),
      sample(
        title: 'Watch terraform videos',
        categoryId: personalId,
        status: TaskStatus.cancelled,
        sortOrder: 3,
      ),
    ];

    await _dao.insertAllForDebug(samples.map(_toCompanion).toList());
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
