import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/theme/breakpoints.dart';
import '../../core/theme/theme.dart';
import '../../core/utils/task_grouping.dart';
import '../../domain/enums.dart';
import '../../domain/task.dart';
import '../sync/sync_providers.dart';
import 'archived_section.dart';
import 'category_filter_chips.dart';
import 'category_section.dart';
import 'day_empty_state.dart';
import 'day_providers.dart';
import 'day_skeleton.dart';
import 'quick_add_field.dart';

/// One day's content: date header, filter chips, progress, and a category
/// section per active category (empty categories hidden unless selected by
/// the filter — SPEC §7.2, M3), plus one combined "Archived" section.
class DayPage extends ConsumerWidget {
  const DayPage({
    super.key,
    required this.date,
    required this.onOpenDetails,
    required this.onLongPressTask,
    this.autofocusQuickAdd = false,
    this.quickAddFocusNode,
    this.selectedTaskId,
  });

  final DateTime date;
  final ValueChanged<Task> onOpenDetails;
  final ValueChanged<Task> onLongPressTask;

  /// SPEC §8 (M6): autofocus the web quick-add bar when arriving here via
  /// the evening notification tap.
  final bool autofocusQuickAdd;

  /// Shared with the keyboard-shortcuts handler (SPEC §7.6, M7) — only
  /// given to the currently-visible page.
  final FocusNode? quickAddFocusNode;

  /// Keyboard-selected task (Up/Down, SPEC §7.6, M7) — shown with a focus
  /// ring in [CategorySection]/[ArchivedSection].
  final String? selectedTaskId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = context.daybookText;
    final activeCategoriesAsync = ref.watch(activeCategoriesProvider);
    final allCategoriesAsync = ref.watch(allCategoriesProvider);
    final tasksAsync = ref.watch(tasksForDateProvider(date));
    final settingsAsync = ref.watch(localSettingsProvider);
    final isWide =
        MediaQuery.sizeOf(context).width >= DaybookBreakpoints.phoneMax;

    for (final async in [
      activeCategoriesAsync,
      allCategoriesAsync,
      tasksAsync,
      settingsAsync,
    ]) {
      if (async.hasError) {
        return Center(child: Text('Error: ${async.error}'));
      }
    }
    if (!activeCategoriesAsync.hasValue ||
        !allCategoriesAsync.hasValue ||
        !tasksAsync.hasValue ||
        !settingsAsync.hasValue) {
      return DaySkeleton(isWide: isWide);
    }

    final activeCategories = activeCategoriesAsync.requireValue;
    final allCategories = allCategoriesAsync.requireValue;
    final allTasks = tasksAsync.requireValue;
    final selectedFilterId =
        settingsAsync.requireValue.selectedFilterCategoryId;

    final tasks = selectedFilterId == null
        ? allTasks
        : allTasks.where((t) => t.categoryId == selectedFilterId).toList();

    final groups = groupTasksForDay(tasks, allCategories);
    final categoriesById = {for (final c in allCategories) c.id: c};

    final doneCount = allTasks.where((t) => t.status == TaskStatus.done).length;

    final sectionsToShow = selectedFilterId == null
        ? activeCategories
              .where(
                (c) => groups.byActiveCategoryId[c.id]?.isNotEmpty ?? false,
              )
              .toList()
        : activeCategories.where((c) => c.id == selectedFilterId).toList();

    final showArchived = selectedFilterId == null && groups.archived.isNotEmpty;
    final isEmpty = sectionsToShow.isEmpty && !showArchived;

    return RefreshIndicator(
      onRefresh: () => ref.read(syncEngineProvider).pull(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: isWide
              ? DaybookSpacing.screenPaddingWeb
              : DaybookSpacing.screenPaddingPhone,
          vertical: DaybookSpacing.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(DateFormat('d MMMM').format(date), style: text.displayDate),
            const SizedBox(height: DaybookSpacing.xs),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('EEEE · yyyy').format(date),
                  style: text.subDate,
                ),
                if (allTasks.isNotEmpty)
                  Text(
                    '$doneCount/${allTasks.length} done',
                    style: text.subDate,
                  ),
              ],
            ),
            const SizedBox(height: DaybookSpacing.lg),
            CategoryFilterChips(
              categories: activeCategories,
              selectedCategoryId: selectedFilterId,
            ),
            if (isWide) ...[
              const SizedBox(height: DaybookSpacing.lg),
              QuickAddField(
                date: date,
                autofocus: autofocusQuickAdd,
                focusNode: quickAddFocusNode,
              ),
            ],
            const SizedBox(height: DaybookSpacing.xl),
            if (isEmpty)
              DayEmptyState(
                activeCategories: activeCategories,
                allCategories: allCategories,
                selectedFilterCategoryId: selectedFilterId,
                isWide: isWide,
              )
            else ...[
              for (final category in sectionsToShow) ...[
                CategorySection(
                  category: category,
                  tasks: groups.byActiveCategoryId[category.id] ?? const [],
                  selectedTaskId: selectedTaskId,
                  onToggle: (task) =>
                      ref.read(taskRepositoryProvider).toggleDone(task),
                  onOpenDetails: onOpenDetails,
                  onLongPressTask: onLongPressTask,
                ),
                const SizedBox(height: DaybookSpacing.xl),
              ],
              if (showArchived)
                ArchivedSection(
                  tasks: groups.archived,
                  categoriesById: categoriesById,
                  selectedTaskId: selectedTaskId,
                  onToggle: (task) =>
                      ref.read(taskRepositoryProvider).toggleDone(task),
                  onOpenDetails: onOpenDetails,
                  onLongPressTask: onLongPressTask,
                ),
            ],
          ],
        ),
      ),
    );
  }
}
