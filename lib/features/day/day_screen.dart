import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/theme.dart';
import '../../domain/task.dart';
import '../task_details/task_details_sheet.dart';
import 'date_picker_sheet.dart';
import 'day_page.dart';
import 'day_page_index.dart';
import 'day_providers.dart';
import 'task_actions_sheet.dart';

/// Full-screen single-day view (SPEC §7.2): swipe left/right between days
/// via a `PageView`, "Today" pill, calendar date-picker. Task details open
/// as a modal bottom sheet on phone, or an embedded right-hand panel on
/// wide web (SPEC §7.3, §7.6).
class DayScreen extends ConsumerStatefulWidget {
  const DayScreen({super.key});

  @override
  ConsumerState<DayScreen> createState() => _DayScreenState();
}

class _DayScreenState extends ConsumerState<DayScreen> {
  late final int _todayIndex = controllerIndexForDate(DateTime.now());
  late final PageController _controller = PageController(
    initialPage: _todayIndex,
  );

  Task? _editingTask;
  bool _creating = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(currentDayPageIndexProvider.notifier).set(_todayIndex);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goToToday() {
    _controller.animateToPage(
      _todayIndex,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  Future<void> _openDatePicker() async {
    final currentIndex = ref.read(currentDayPageIndexProvider);
    final picked = await showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(DaybookRadii.sheet),
        ),
      ),
      builder: (_) =>
          DatePickerSheet(initialDate: dateForControllerIndex(currentIndex)),
    );
    if (picked != null) {
      _controller.animateToPage(
        controllerIndexForDate(picked),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  bool _isWide(BuildContext context) => MediaQuery.sizeOf(context).width >= 700;

  void _closeDetails() {
    setState(() {
      _editingTask = null;
      _creating = false;
    });
  }

  void _openCreate() {
    final date = dateForControllerIndex(ref.read(currentDayPageIndexProvider));
    if (_isWide(context)) {
      setState(() {
        _creating = true;
        _editingTask = null;
      });
      return;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(DaybookRadii.sheet),
        ),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => TaskDetailsSheet(
          createDate: date,
          onClose: () => Navigator.of(context).pop(),
          onDeleted: _handleDeleted,
        ),
      ),
    );
  }

  void _openEdit(Task task) {
    if (_isWide(context)) {
      setState(() {
        _editingTask = task;
        _creating = false;
      });
      return;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(DaybookRadii.sheet),
        ),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => TaskDetailsSheet(
          initialTask: task,
          onClose: () => Navigator.of(context).pop(),
          onDeleted: _handleDeleted,
        ),
      ),
    );
  }

  void _handleDeleted(Task deleted) {
    _closeDetails();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Deleted "${deleted.title}"'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () => ref.read(taskRepositoryProvider).undoDelete(deleted),
        ),
      ),
    );
  }

  Future<void> _handleLongPress(Task task) async {
    final action = await showTaskActionsSheet(context);
    if (!mounted || action == null) return;
    final repository = ref.read(taskRepositoryProvider);
    switch (action) {
      case TaskAction.edit:
        _openEdit(task);
      case TaskAction.moveToTomorrow:
        await repository.moveToTomorrow(task);
      case TaskAction.pickDate:
        final picked = await showModalBottomSheet<DateTime>(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(DaybookRadii.sheet),
            ),
          ),
          builder: (_) => DatePickerSheet(initialDate: task.taskDate),
        );
        if (picked != null) await repository.moveToDate(task, picked);
      case TaskAction.cancel:
        await repository.cancel(task);
      case TaskAction.delete:
        await repository.softDelete(task);
        if (mounted) _handleDeleted(task);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(currentDayPageIndexProvider);
    final isToday = currentIndex == _todayIndex;
    final isWide = _isWide(context);
    final colors = context.daybookColors;

    final dayContent = PageView.builder(
      controller: _controller,
      itemCount: dayPageCount,
      onPageChanged: (index) =>
          ref.read(currentDayPageIndexProvider.notifier).set(index),
      itemBuilder: (context, index) {
        return DayPage(
          date: dateForControllerIndex(index),
          onOpenDetails: _openEdit,
          onLongPressTask: _handleLongPress,
        );
      },
    );

    final showPanel = isWide && (_editingTask != null || _creating);

    return Scaffold(
      appBar: AppBar(
        actions: [
          if (!isToday)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: DaybookSpacing.xs,
              ),
              child: Center(
                child: TextButton(
                  onPressed: _goToToday,
                  child: const Text('Today'),
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.calendar_today_outlined),
            tooltip: 'Pick a date',
            onPressed: _openDatePicker,
          ),
        ],
      ),
      body: showPanel
          ? Row(
              children: [
                Expanded(child: dayContent),
                VerticalDivider(width: 1, color: colors.line),
                SizedBox(
                  width: 400,
                  child: TaskDetailsSheet(
                    key: ValueKey(_editingTask?.id ?? 'create'),
                    initialTask: _editingTask,
                    createDate: _creating
                        ? dateForControllerIndex(currentIndex)
                        : null,
                    onClose: _closeDetails,
                    onDeleted: _handleDeleted,
                  ),
                ),
              ],
            )
          : dayContent,
      floatingActionButton: isWide
          ? null
          : FloatingActionButton(
              onPressed: _openCreate,
              child: const Icon(Icons.add),
            ),
    );
  }
}
