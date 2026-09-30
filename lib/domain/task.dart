import 'package:freezed_annotation/freezed_annotation.dart';

import 'checklist_item.dart';
import 'enums.dart';
import 'local_time.dart';

part 'task.freezed.dart';

/// Mirrors `public.tasks` (SPEC §4). `taskDate`/`startTime`/`endTime` are
/// floating local values — never convert them to UTC (CLAUDE.md rule 5).
/// `userId` is null until the device has signed in (M4).
@freezed
abstract class Task with _$Task {
  const factory Task({
    required String id,
    String? userId,
    String? categoryId,
    required String title,
    String? notes,
    @Default([]) List<ChecklistItem> checklist,

    /// Date-only (year/month/day); time-of-day is ignored.
    required DateTime taskDate,
    @Default(TimeMode.none) TimeMode timeMode,
    LocalTime? startTime,
    LocalTime? endTime,
    @Default(TaskStatus.todo) TaskStatus status,
    DateTime? completedAt,
    required double sortOrder,
    String? recurrenceRule,
    String? recurrenceParentId,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
  }) = _Task;
}
