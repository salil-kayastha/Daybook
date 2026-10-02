import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/breakpoints.dart';
import '../../core/theme/theme.dart';
import '../../data/sync/sync_status.dart';
import '../../domain/task.dart';
import '../sync/sync_providers.dart';
import '../task_details/task_details_sheet.dart';
import 'date_picker_sheet.dart';
import 'day_keyboard_shortcuts.dart';
import 'day_page.dart';
import 'day_page_index.dart';
import 'day_providers.dart';
import 'left_rail.dart';
import 'shortcut_help_dialog.dart';
import 'task_actions_sheet.dart';

/// Full-screen single-day view (SPEC §7.2): swipe left/right between days
/// via a `PageView`, "Today" pill, calendar date-picker. Below 700px this
/// is unchanged from M2–M6. At 700px+ it gains a left rail, task details
/// open as a side sheet (700–1099) or a permanently-docked panel (1100+),
/// arrow-button day navigation, and keyboard shortcuts (SPEC §7.4, §7.6).
class DayScreen extends ConsumerStatefulWidget {
  const DayScreen({super.key, this.initialDate, this.focusQuickAdd = false});

  /// Set by a notification tap (SPEC §8, M6) to open a day other than
  /// today — evening notifications open tomorrow.
  final DateTime? initialDate;

  /// SPEC §8: the evening notification opens tomorrow "with quick-add
  /// focused" — autofocuses the web `QuickAddField`, or opens the
  /// create-task sheet (which already autofocuses its title) on phone.
  final bool focusQuickAdd;

  @override
  ConsumerState<DayScreen> createState() => _DayScreenState();
}

class _DayScreenState extends ConsumerState<DayScreen> {
  late final int _todayIndex = controllerIndexForDate(DateTime.now());
  late final int _startIndex = widget.initialDate != null
      ? controllerIndexForDate(widget.initialDate!)
      : _todayIndex;
  late final PageController _controller = PageController(
    initialPage: _startIndex,
  );
  final FocusNode _quickAddFocusNode = FocusNode(debugLabel: 'quickAdd');

  /// Crossing a layout-mode breakpoint (SPEC §7.6, M7) reshapes the widget
  /// tree around the `PageView` (different Stack/Center ancestors per
  /// mode) — without a stable key Flutter treats it as a new element on
  /// that rebuild, disposing the old `Scrollable` and losing its scroll
  /// position back to `_controller`'s `initialPage`. A `GlobalKey` makes
  /// Flutter relocate the existing element instead, so resizing across a
  /// breakpoint doesn't silently jump back to today.
  final _pageViewKey = GlobalKey();

  Task? _editingTask;
  bool _creating = false;
  Task? _selectedTask;

  /// Mirrors `visibleTasksForDateProvider(currentDate)` — refreshed every
  /// build via `ref.watch` in [build]. Keyboard Up/Down (SPEC §7.6) reads
  /// this cached snapshot rather than `ref.read`-ing the provider fresh,
  /// since nothing else watches it and it would otherwise be disposed
  /// between keystrokes, never resolving before the handler runs.
  List<Task> _visibleTasks = const [];

  /// True while a dialog/modal sheet is open — blocks every keyboard
  /// shortcut except Esc (SPEC §7.6).
  bool _blocked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(currentDayPageIndexProvider.notifier).set(_startIndex);
      if (widget.focusQuickAdd) {
        if (_isWide(context)) {
          _quickAddFocusNode.requestFocus();
        } else {
          _openCreate();
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _quickAddFocusNode.dispose();
    super.dispose();
  }

  Future<T?> _withBlocked<T>(Future<T?> Function() action) async {
    setState(() => _blocked = true);
    try {
      return await action();
    } finally {
      if (mounted) setState(() => _blocked = false);
    }
  }

  void _goToToday() {
    _controller.animateToPage(
      _todayIndex,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  void _goToPreviousDay() {
    final current = ref.read(currentDayPageIndexProvider);
    _controller.animateToPage(
      current - 1,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  void _goToNextDay() {
    final current = ref.read(currentDayPageIndexProvider);
    _controller.animateToPage(
      current + 1,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  Future<void> _openDatePicker() async {
    final currentIndex = ref.read(currentDayPageIndexProvider);
    final picked = await _withBlocked(
      () => showModalBottomSheet<DateTime>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(DaybookRadii.sheet),
          ),
        ),
        builder: (_) =>
            DatePickerSheet(initialDate: dateForControllerIndex(currentIndex)),
      ),
    );
    if (picked != null) {
      _controller.animateToPage(
        controllerIndexForDate(picked),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  bool _isWide(BuildContext context) =>
      layoutModeForWidth(MediaQuery.sizeOf(context).width) !=
      DayLayoutMode.phone;

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
    _withBlocked(
      () => showModalBottomSheet(
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
      ),
    );
  }

  void _openEdit(Task task) {
    if (_isWide(context)) {
      setState(() {
        _editingTask = task;
        _creating = false;
        _selectedTask = task;
      });
      return;
    }
    _withBlocked(
      () => showModalBottomSheet(
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
      ),
    );
  }

  void _handleDeleted(Task deleted) {
    _closeDetails();
    if (_selectedTask?.id == deleted.id) {
      setState(() => _selectedTask = null);
    }
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
    final action = await _withBlocked(() => showTaskActionsSheet(context));
    if (!mounted || action == null) return;
    final repository = ref.read(taskRepositoryProvider);
    switch (action) {
      case TaskAction.edit:
        _openEdit(task);
      case TaskAction.moveToTomorrow:
        await repository.moveToTomorrow(task);
      case TaskAction.pickDate:
        final picked = await _withBlocked(
          () => showModalBottomSheet<DateTime>(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(DaybookRadii.sheet),
              ),
            ),
            builder: (_) => DatePickerSheet(initialDate: task.taskDate),
          ),
        );
        if (picked != null) await repository.moveToDate(task, picked);
      case TaskAction.cancel:
        await repository.cancel(task);
      case TaskAction.delete:
        await repository.softDelete(task);
        if (mounted) _handleDeleted(task);
    }
  }

  void _handleEscape() {
    if (_editingTask != null || _creating) {
      _closeDetails();
    } else if (_selectedTask != null) {
      setState(() => _selectedTask = null);
    }
  }

  void _handleMoveSelection(int delta) {
    final tasks = _visibleTasks;
    if (tasks.isEmpty) return;
    final currentIndex = _selectedTask == null
        ? -1
        : tasks.indexWhere((t) => t.id == _selectedTask!.id);
    int nextIndex;
    if (currentIndex == -1) {
      nextIndex = delta > 0 ? 0 : tasks.length - 1;
    } else {
      nextIndex = (currentIndex + delta).clamp(0, tasks.length - 1);
    }
    setState(() => _selectedTask = tasks[nextIndex]);
  }

  void _handleToggleSelectedDone() {
    final task = _selectedTask;
    if (task == null) return;
    ref.read(taskRepositoryProvider).toggleDone(task);
  }

  Future<void> _handleDeleteSelected() async {
    final task = _selectedTask;
    if (task == null) return;
    await ref.read(taskRepositoryProvider).softDelete(task);
    if (mounted) _handleDeleted(task);
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(currentDayPageIndexProvider);
    final isToday = currentIndex == _todayIndex;
    final currentDate = dateForControllerIndex(currentIndex);
    final mode = layoutModeForWidth(MediaQuery.sizeOf(context).width);
    final isWide = mode != DayLayoutMode.phone;
    final colors = context.daybookColors;
    final syncEngine = ref.watch(syncEngineProvider);
    _visibleTasks =
        ref.watch(visibleTasksForDateProvider(currentDate)).value ?? const [];

    final dayContent = PageView.builder(
      key: _pageViewKey,
      controller: _controller,
      itemCount: dayPageCount,
      onPageChanged: (index) {
        ref.read(currentDayPageIndexProvider.notifier).set(index);
        setState(() => _selectedTask = null);
      },
      itemBuilder: (context, index) {
        return DayPage(
          date: dateForControllerIndex(index),
          onOpenDetails: _openEdit,
          onLongPressTask: _handleLongPress,
          autofocusQuickAdd: widget.focusQuickAdd && index == _startIndex,
          quickAddFocusNode: index == currentIndex ? _quickAddFocusNode : null,
          selectedTaskId: index == currentIndex ? _selectedTask?.id : null,
        );
      },
    );

    final showPanel = isWide && (_editingTask != null || _creating);

    Widget body;
    switch (mode) {
      case DayLayoutMode.phone:
        body = dayContent;
      case DayLayoutMode.twoPane:
        body = Row(
          children: [
            LeftRail(
              selectedDate: currentDate,
              onDateSelected: (date) => _controller.animateToPage(
                controllerIndexForDate(date),
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
              ),
              onToday: _goToToday,
            ),
            Expanded(
              child: Stack(
                children: [
                  dayContent,
                  if (showPanel) ...[
                    Positioned.fill(
                      child: GestureDetector(
                        onTap: _closeDetails,
                        child: ColoredBox(
                          color: Colors.black.withValues(alpha: 0.2),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Material(
                        elevation: 8,
                        color: colors.surface,
                        child: SizedBox(
                          width: DaybookBreakpoints.detailsWidth,
                          height: double.infinity,
                          child: TaskDetailsSheet(
                            key: ValueKey(_editingTask?.id ?? 'create'),
                            initialTask: _editingTask,
                            createDate: _creating ? currentDate : null,
                            onClose: _closeDetails,
                            onDeleted: _handleDeleted,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      case DayLayoutMode.threePane:
        body = Row(
          children: [
            LeftRail(
              selectedDate: currentDate,
              onDateSelected: (date) => _controller.animateToPage(
                controllerIndexForDate(date),
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
              ),
              onToday: _goToToday,
            ),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: DaybookBreakpoints.dayViewMaxWidth,
                  ),
                  child: dayContent,
                ),
              ),
            ),
            VerticalDivider(width: 1, color: colors.line),
            SizedBox(
              width: DaybookBreakpoints.detailsWidth,
              child: (_editingTask != null || _creating)
                  ? TaskDetailsSheet(
                      key: ValueKey(_editingTask?.id ?? 'create'),
                      initialTask: _editingTask,
                      createDate: _creating ? currentDate : null,
                      onClose: _closeDetails,
                      onDeleted: _handleDeleted,
                    )
                  : Center(
                      child: Padding(
                        padding: const EdgeInsets.all(DaybookSpacing.lg),
                        child: Text(
                          'Select a task, or press N to add one.',
                          style: context.daybookText.body,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
            ),
          ],
        );
    }

    final scaffold = Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: DaybookSpacing.xs),
            child: Center(
              child: ValueListenableBuilder<SyncStatus>(
                valueListenable: syncEngine.status,
                builder: (context, status, _) {
                  if (!status.isOnline) {
                    return Icon(
                      Icons.cloud_off_outlined,
                      size: 18,
                      color: colors.inkMuted,
                      semanticLabel: 'Offline',
                    );
                  }
                  if (status.isSyncing || status.pendingCount > 0) {
                    return Icon(
                      Icons.sync,
                      size: 18,
                      color: colors.inkMuted,
                      semanticLabel: 'Syncing',
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          if (isWide) ...[
            IconButton(
              icon: const Icon(Icons.chevron_left),
              tooltip: 'Previous day',
              onPressed: _goToPreviousDay,
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              tooltip: 'Next day',
              onPressed: _goToNextDay,
            ),
          ],
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
          if (!isWide) ...[
            IconButton(
              icon: const Icon(Icons.category_outlined),
              tooltip: 'Manage categories',
              onPressed: () => context.push('/categories'),
            ),
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              tooltip: 'Settings',
              onPressed: () => context.push('/settings'),
            ),
          ],
          if (isWide)
            IconButton(
              icon: const Icon(Icons.keyboard_outlined),
              tooltip: 'Keyboard shortcuts (?)',
              onPressed: () =>
                  _withBlocked(() => showShortcutHelpDialog(context)),
            ),
        ],
      ),
      body: Stack(
        children: [
          body,
          ValueListenableBuilder<SyncStatus>(
            valueListenable: syncEngine.status,
            builder: (context, status, _) {
              if (!status.isInitialSyncing) return const SizedBox.shrink();
              return ColoredBox(
                color: colors.bg.withValues(alpha: 0.92),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: colors.primary),
                      const SizedBox(height: DaybookSpacing.lg),
                      Text(
                        'Setting up your data…',
                        style: context.daybookText.body,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: isWide
          ? null
          : FloatingActionButton(
              onPressed: _openCreate,
              child: const Icon(Icons.add),
            ),
    );

    if (!isWide) return scaffold;

    return DayKeyboardShortcuts(
      isBlocked: _blocked,
      onNewTask: () {
        if (_quickAddFocusNode.canRequestFocus) {
          _quickAddFocusNode.requestFocus();
        }
      },
      onPreviousDay: _goToPreviousDay,
      onNextDay: _goToNextDay,
      onToday: _goToToday,
      onMoveSelection: _handleMoveSelection,
      onEditSelected: () {
        if (_selectedTask != null) _openEdit(_selectedTask!);
      },
      onToggleSelectedDone: _handleToggleSelectedDone,
      onDeleteSelected: _handleDeleteSelected,
      onEscape: _handleEscape,
      onShowHelp: () => _withBlocked(() => showShortcutHelpDialog(context)),
      child: scaffold,
    );
  }
}
