// Constructor params are public (`repository`, `onCategoryUsed`) but the
// fields they feed are private; `this._x` initializing formals aren't an
// option without making the params private too.
// ignore_for_file: prefer_initializing_formals

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../../core/utils/task_validation.dart';
import '../../data/repositories/task_repository.dart';
import '../../domain/checklist_item.dart';
import '../../domain/enums.dart';
import '../../domain/local_time.dart';
import '../../domain/task.dart';

const _autosaveDelay = Duration(milliseconds: 400);

/// Owns one task-details sheet/panel's editable state: field values,
/// validation, and persistence (autosave in edit mode, explicit "Add" in
/// create mode). Keeps `TaskDetailsSheet` a thin view over this.
class TaskDraftController extends ChangeNotifier {
  TaskDraftController({
    required TaskRepository repository,
    required ValueChanged<String> onCategoryUsed,
    required String defaultCategoryId,
    Task? initial,
    DateTime? createDate,
  }) : _repository = repository,
       _onCategoryUsed = onCategoryUsed,
       _isNew = initial == null,
       id = initial?.id ?? const Uuid().v4(),
       _createdAt = initial?.createdAt,
       _sortOrder = initial?.sortOrder ?? 0,
       title = initial?.title ?? '',
       categoryId = initial?.categoryId ?? defaultCategoryId,
       taskDate = _dateOnly(initial?.taskDate ?? createDate ?? DateTime.now()),
       timeMode = initial?.timeMode ?? TimeMode.none,
       startTime = initial?.startTime,
       endTime = initial?.endTime,
       notes = initial?.notes ?? '',
       checklist = List.of(initial?.checklist ?? const []),
       status = initial?.status ?? TaskStatus.todo;

  final TaskRepository _repository;
  final ValueChanged<String> _onCategoryUsed;
  bool _isNew;
  final String id;
  DateTime? _createdAt;
  final double _sortOrder;
  Timer? _debounce;
  bool _disposed = false;

  String title;
  String categoryId;
  DateTime taskDate;
  TimeMode timeMode;
  LocalTime? startTime;
  LocalTime? endTime;
  String notes;
  List<ChecklistItem> checklist;
  TaskStatus status;

  bool get isNew => _isNew;
  String? get timeError => validateTaskTime(timeMode, startTime, endTime);
  bool get canSave => title.trim().isNotEmpty && timeError == null;

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  void updateTitle(String value) {
    title = value;
    notifyListeners();
    _scheduleAutosave();
  }

  void updateCategory(String newCategoryId) {
    categoryId = newCategoryId;
    _onCategoryUsed(newCategoryId);
    notifyListeners();
    _scheduleAutosave();
  }

  void updateDate(DateTime date) {
    taskDate = _dateOnly(date);
    notifyListeners();
    _scheduleAutosave();
  }

  void updateTimeMode(TimeMode mode) {
    timeMode = mode;
    switch (mode) {
      case TimeMode.none:
        startTime = null;
        endTime = null;
      case TimeMode.at:
        startTime ??= const LocalTime(9, 0);
        endTime = null;
      case TimeMode.window:
        startTime ??= const LocalTime(9, 0);
        endTime ??= const LocalTime(10, 0);
    }
    notifyListeners();
    _scheduleAutosave();
  }

  void updateStartTime(LocalTime time) {
    startTime = time;
    notifyListeners();
    _scheduleAutosave();
  }

  void updateEndTime(LocalTime time) {
    endTime = time;
    notifyListeners();
    _scheduleAutosave();
  }

  void updateNotes(String value) {
    notes = value;
    notifyListeners();
    _scheduleAutosave();
  }

  void addChecklistItem(String text) {
    if (text.trim().isEmpty) return;
    checklist = [
      ...checklist,
      ChecklistItem(id: const Uuid().v4(), text: text.trim()),
    ];
    notifyListeners();
    _scheduleAutosave();
  }

  void toggleChecklistItem(String itemId) {
    checklist = [
      for (final item in checklist)
        if (item.id == itemId) item.copyWith(done: !item.done) else item,
    ];
    notifyListeners();
    _scheduleAutosave();
  }

  void removeChecklistItem(String itemId) {
    checklist = checklist.where((item) => item.id != itemId).toList();
    notifyListeners();
    _scheduleAutosave();
  }

  /// Explicit "Add" button in create mode. Returns whether it saved.
  Future<bool> createNow() async {
    if (!canSave) return false;
    _createdAt ??= DateTime.now().toUtc();
    _isNew = false;
    await _persist();
    _onCategoryUsed(categoryId);
    notifyListeners();
    return true;
  }

  Future<void> setStatus(TaskStatus newStatus) async {
    status = newStatus;
    notifyListeners();
    if (!_isNew) await _persist();
  }

  Future<void> delete() async {
    if (_isNew) return;
    await _repository.softDelete(_buildTask());
  }

  /// A snapshot of the current field values as a [Task], for the caller to
  /// keep around (e.g. for an Undo action after [delete]).
  Task toTask() => _buildTask();

  void _scheduleAutosave() {
    if (_isNew || !canSave) return;
    _debounce?.cancel();
    _debounce = Timer(_autosaveDelay, _persist);
  }

  Future<void> _persist() async {
    if (_disposed) return;
    await _repository.upsert(_buildTask());
  }

  Task _buildTask() {
    final now = DateTime.now().toUtc();
    return Task(
      id: id,
      categoryId: categoryId,
      title: title.trim(),
      notes: notes.trim().isEmpty ? null : notes.trim(),
      checklist: checklist,
      taskDate: taskDate,
      timeMode: timeMode,
      startTime: startTime,
      endTime: endTime,
      status: status,
      completedAt: status == TaskStatus.done ? now : null,
      sortOrder: _sortOrder,
      createdAt: _createdAt ?? now,
      updatedAt: now,
    );
  }

  @override
  void dispose() {
    _disposed = true;
    _debounce?.cancel();
    super.dispose();
  }
}
