import 'dart:convert';

import 'package:drift/drift.dart' show Value;

import '../../domain/enums.dart';
import '../local/database.dart' as db;

/// Maps between local Drift rows and the JSON shape Supabase expects/sends
/// (SPEC §4). `task_date` is `yyyy-MM-dd` and `start_time`/`end_time` are
/// `HH:mm:ss` floating local values — never converted to UTC (CLAUDE.md
/// rule 5). Only `created_at`/`updated_at`/`deleted_at`/`completed_at` are
/// real UTC timestamps.
String formatLocalDate(DateTime date) {
  final y = date.year.toString().padLeft(4, '0');
  final m = date.month.toString().padLeft(2, '0');
  final d = date.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}

DateTime parseLocalDate(String value) {
  final parts = value.split('-');
  return DateTime(
    int.parse(parts[0]),
    int.parse(parts[1]),
    int.parse(parts[2]),
  );
}

String? _toTimeOfDaySeconds(String? hhmm) {
  if (hhmm == null) return null;
  // Tolerates an existing "HH:mm" or "HH:mm:ss" local value.
  final parts = hhmm.split(':');
  final h = parts[0].padLeft(2, '0');
  final m = parts[1].padLeft(2, '0');
  return '$h:$m:00';
}

Map<String, dynamic> categoryToRemoteJson(
  db.Category row, {
  required String userId,
}) {
  return {
    'id': row.id,
    'user_id': userId,
    'name': row.name,
    'color': row.color,
    'icon': row.icon,
    'sort_order': row.sortOrder,
    'is_archived': row.isArchived,
    'created_at': row.createdAt.toUtc().toIso8601String(),
    'updated_at': row.updatedAt.toUtc().toIso8601String(),
    'deleted_at': row.deletedAt?.toUtc().toIso8601String(),
  };
}

db.CategoriesCompanion categoryFromRemoteJson(Map<String, dynamic> json) {
  return db.CategoriesCompanion.insert(
    id: json['id'] as String,
    userId: Value(json['user_id'] as String?),
    name: json['name'] as String,
    color: json['color'] as String,
    icon: Value(json['icon'] as String?),
    sortOrder: Value((json['sort_order'] as num).toDouble()),
    isArchived: Value(json['is_archived'] as bool),
    createdAt: DateTime.parse(json['created_at'] as String).toUtc(),
    updatedAt: DateTime.parse(json['updated_at'] as String).toUtc(),
    deletedAt: Value(
      (json['deleted_at'] as String?) == null
          ? null
          : DateTime.parse(json['deleted_at'] as String).toUtc(),
    ),
    syncState: const Value(SyncState.synced),
    localChangedAt: Value(DateTime.parse(json['updated_at'] as String).toUtc()),
  );
}

Map<String, dynamic> taskToRemoteJson(db.Task row, {required String userId}) {
  return {
    'id': row.id,
    'user_id': userId,
    'category_id': row.categoryId,
    'title': row.title,
    'notes': row.notes,
    'checklist': jsonDecode(row.checklist),
    'task_date': formatLocalDate(row.taskDate),
    'time_mode': row.timeMode.name,
    'start_time': _toTimeOfDaySeconds(row.startTime),
    'end_time': _toTimeOfDaySeconds(row.endTime),
    'status': row.status.name,
    'completed_at': row.completedAt?.toUtc().toIso8601String(),
    'sort_order': row.sortOrder,
    'recurrence_rule': row.recurrenceRule,
    'recurrence_parent_id': row.recurrenceParentId,
    'created_at': row.createdAt.toUtc().toIso8601String(),
    'updated_at': row.updatedAt.toUtc().toIso8601String(),
    'deleted_at': row.deletedAt?.toUtc().toIso8601String(),
  };
}

db.TasksCompanion taskFromRemoteJson(Map<String, dynamic> json) {
  return db.TasksCompanion.insert(
    id: json['id'] as String,
    userId: Value(json['user_id'] as String?),
    // Tolerates a category that hasn't arrived locally yet (pull order
    // pulls categories first, but a task can still reference one this
    // device hasn't seen if the pull races a concurrent remote write) —
    // the FK is nullable locally, so this never crashes.
    categoryId: Value(json['category_id'] as String?),
    title: json['title'] as String,
    notes: Value(json['notes'] as String?),
    checklist: Value(jsonEncode(json['checklist'] ?? const [])),
    taskDate: parseLocalDate(json['task_date'] as String),
    timeMode: Value(TimeMode.values.byName(json['time_mode'] as String)),
    startTime: Value(json['start_time'] as String?),
    endTime: Value(json['end_time'] as String?),
    status: Value(TaskStatus.values.byName(json['status'] as String)),
    completedAt: Value(
      (json['completed_at'] as String?) == null
          ? null
          : DateTime.parse(json['completed_at'] as String).toUtc(),
    ),
    sortOrder: Value((json['sort_order'] as num).toDouble()),
    recurrenceRule: Value(json['recurrence_rule'] as String?),
    recurrenceParentId: Value(json['recurrence_parent_id'] as String?),
    createdAt: DateTime.parse(json['created_at'] as String).toUtc(),
    updatedAt: DateTime.parse(json['updated_at'] as String).toUtc(),
    deletedAt: Value(
      (json['deleted_at'] as String?) == null
          ? null
          : DateTime.parse(json['deleted_at'] as String).toUtc(),
    ),
    syncState: const Value(SyncState.synced),
    localChangedAt: Value(DateTime.parse(json['updated_at'] as String).toUtc()),
  );
}

Map<String, dynamic> userSettingsToRemoteJson(
  db.UserSettingsRow row, {
  required String userId,
}) {
  return {
    'user_id': userId,
    'morning_enabled': row.morningEnabled,
    'morning_time': _toTimeOfDaySeconds(row.morningTime),
    'evening_enabled': row.eveningEnabled,
    'evening_time': _toTimeOfDaySeconds(row.eveningTime),
    'theme_mode': row.themeMode,
    'week_starts_on': row.weekStartsOn,
    'default_category_id': row.defaultCategoryId,
    'updated_at': row.updatedAt.toUtc().toIso8601String(),
  };
}

db.UserSettingsTableCompanion userSettingsFromRemoteJson(
  Map<String, dynamic> json,
) {
  return db.UserSettingsTableCompanion.insert(
    userId: json['user_id'] as String,
    morningEnabled: Value(json['morning_enabled'] as bool),
    morningTime: Value(json['morning_time'] as String),
    eveningEnabled: Value(json['evening_enabled'] as bool),
    eveningTime: Value(json['evening_time'] as String),
    themeMode: Value(json['theme_mode'] as String),
    weekStartsOn: Value(json['week_starts_on'] as int),
    defaultCategoryId: Value(json['default_category_id'] as String?),
    updatedAt: DateTime.parse(json['updated_at'] as String).toUtc(),
    syncState: const Value(SyncState.synced),
    localChangedAt: Value(DateTime.parse(json['updated_at'] as String).toUtc()),
  );
}
