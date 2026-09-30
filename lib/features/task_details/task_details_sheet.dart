import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/theme.dart';
import '../../domain/category.dart';
import '../../domain/enums.dart';
import '../../domain/local_time.dart';
import '../../domain/task.dart';
import '../day/date_picker_sheet.dart';
import '../day/day_providers.dart';
import 'task_details_widgets.dart';
import 'task_draft_controller.dart';

/// Task details form (SPEC §7.3): phone shows this in a draggable modal
/// bottom sheet, wide web embeds it as a right-hand panel — same widget
/// either way, the caller decides how to host it.
class TaskDetailsSheet extends ConsumerStatefulWidget {
  const TaskDetailsSheet({
    super.key,
    this.initialTask,
    this.createDate,
    required this.onClose,
    required this.onDeleted,
  });

  /// Non-null when editing an existing task.
  final Task? initialTask;

  /// The day this new task is being created for (create mode only).
  final DateTime? createDate;

  final VoidCallback onClose;

  /// Called after a soft delete with the pre-delete snapshot, so the
  /// caller can show an Undo snackbar.
  final ValueChanged<Task> onDeleted;

  @override
  ConsumerState<TaskDetailsSheet> createState() => _TaskDetailsSheetState();
}

class _TaskDetailsSheetState extends ConsumerState<TaskDetailsSheet> {
  late final TaskDraftController _controller;
  late final TextEditingController _titleController;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    final categories = ref.read(activeCategoriesProvider).value ?? const [];
    final lastUsed = ref.read(lastUsedCategoryIdProvider);
    _controller = TaskDraftController(
      repository: ref.read(taskRepositoryProvider),
      onCategoryUsed: (id) =>
          ref.read(lastUsedCategoryIdProvider.notifier).set(id),
      defaultCategoryId: _resolveDefaultCategoryId(categories, lastUsed),
      initial: widget.initialTask,
      createDate: widget.createDate,
    );
    _titleController = TextEditingController(text: _controller.title);
    _notesController = TextEditingController(text: _controller.notes);
  }

  String _resolveDefaultCategoryId(
    List<Category> categories,
    String? lastUsed,
  ) {
    if (categories.isEmpty) return '';
    if (lastUsed != null && categories.any((c) => c.id == lastUsed)) {
      return lastUsed;
    }
    final office = categories.firstWhere(
      (c) => c.name == 'Office',
      orElse: () => categories.first,
    );
    return office.id;
  }

  @override
  void dispose() {
    _controller.dispose();
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(DaybookRadii.sheet),
        ),
      ),
      builder: (_) => DatePickerSheet(initialDate: _controller.taskDate),
    );
    if (picked != null) _controller.updateDate(picked);
  }

  Future<void> _pickTime({required bool isStart}) async {
    final current = isStart ? _controller.startTime : _controller.endTime;
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: current?.hour ?? 9,
        minute: current?.minute ?? 0,
      ),
    );
    if (picked == null) return;
    final local = LocalTime(picked.hour, picked.minute);
    if (isStart) {
      _controller.updateStartTime(local);
    } else {
      _controller.updateEndTime(local);
    }
  }

  Future<void> _handleAdd() async {
    final ok = await _controller.createNow();
    if (ok && mounted) widget.onClose();
  }

  Future<void> _handleDelete() async {
    final snapshot = _controller.toTask();
    await _controller.delete();
    if (!mounted) return;
    widget.onDeleted(snapshot);
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    final text = context.daybookText;
    final categoriesAsync = ref.watch(activeCategoriesProvider);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Padding(
          padding: EdgeInsets.only(
            left: DaybookSpacing.lg,
            right: DaybookSpacing.lg,
            top: DaybookSpacing.lg,
            bottom: MediaQuery.viewInsetsOf(context).bottom + DaybookSpacing.lg,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _controller.isNew ? 'New task' : 'Edit task',
                      style: text.sectionTitle,
                    ),
                    Semantics(
                      label: 'Close',
                      button: true,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: widget.onClose,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: DaybookSpacing.sm),
                TextField(
                  controller: _titleController,
                  autofocus: _controller.isNew,
                  decoration: const InputDecoration(hintText: 'Title'),
                  onChanged: _controller.updateTitle,
                ),
                const SizedBox(height: DaybookSpacing.md),
                categoriesAsync.when(
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
                  data: (categories) => CategoryDropdown(
                    categories: categories,
                    selectedId: _controller.categoryId,
                    onChanged: _controller.updateCategory,
                  ),
                ),
                const SizedBox(height: DaybookSpacing.md),
                OutlinedButton.icon(
                  onPressed: _pickDate,
                  icon: const Icon(Icons.calendar_today_outlined, size: 18),
                  label: Text(_formatDate(_controller.taskDate)),
                ),
                const SizedBox(height: DaybookSpacing.md),
                TimeModeControl(
                  mode: _controller.timeMode,
                  onChanged: _controller.updateTimeMode,
                ),
                if (_controller.timeMode != TimeMode.none) ...[
                  const SizedBox(height: DaybookSpacing.sm),
                  Wrap(
                    spacing: DaybookSpacing.sm,
                    runSpacing: DaybookSpacing.sm,
                    children: [
                      OutlinedButton(
                        onPressed: () => _pickTime(isStart: true),
                        child: Text(
                          _controller.startTime == null
                              ? 'Start time'
                              : 'From ${_controller.startTime!.format24()}',
                        ),
                      ),
                      if (_controller.timeMode == TimeMode.window)
                        OutlinedButton(
                          onPressed: () => _pickTime(isStart: false),
                          child: Text(
                            _controller.endTime == null
                                ? 'End time'
                                : 'To ${_controller.endTime!.format24()}',
                          ),
                        ),
                    ],
                  ),
                ],
                if (_controller.timeError != null) ...[
                  const SizedBox(height: DaybookSpacing.xs),
                  Text(
                    _controller.timeError!,
                    style: text.taskMeta.copyWith(
                      color: context.daybookColors.danger,
                    ),
                  ),
                ],
                const SizedBox(height: DaybookSpacing.md),
                TextField(
                  controller: _notesController,
                  minLines: 2,
                  maxLines: null,
                  decoration: const InputDecoration(hintText: 'Notes'),
                  onChanged: _controller.updateNotes,
                ),
                const SizedBox(height: DaybookSpacing.lg),
                ChecklistEditor(
                  items: _controller.checklist,
                  onAdd: _controller.addChecklistItem,
                  onToggle: _controller.toggleChecklistItem,
                  onRemove: _controller.removeChecklistItem,
                ),
                const SizedBox(height: DaybookSpacing.xl),
                if (_controller.isNew)
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _controller.canSave ? _handleAdd : null,
                      child: const Text('Add'),
                    ),
                  )
                else ...[
                  StatusActions(
                    status: _controller.status,
                    onDone: () => _controller.setStatus(TaskStatus.done),
                    onCancel: () => _controller.setStatus(TaskStatus.cancelled),
                    onRestore: () => _controller.setStatus(TaskStatus.todo),
                  ),
                  const SizedBox(height: DaybookSpacing.sm),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: _handleDelete,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: context.daybookColors.danger,
                        side: BorderSide(color: context.daybookColors.danger),
                      ),
                      child: const Text('Delete'),
                    ),
                  ),
                ],
                const SizedBox(height: DaybookSpacing.lg),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
