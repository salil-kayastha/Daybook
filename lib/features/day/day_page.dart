import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/theme/theme.dart';
import '../../core/utils/task_grouping.dart';
import '../../domain/enums.dart';
import '../../domain/task.dart';
import '../sync/sync_providers.dart';
import 'archived_section.dart';
import 'category_filter_chips.dart';
import 'category_section.dart';
import 'day_providers.dart';
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
  });

  final DateTime date;
  final ValueChanged<Task> onOpenDetails;
  final ValueChanged<Task> onLongPressTask;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = context.daybookText;
    final activeCategoriesAsync = ref.watch(activeCategoriesProvider);
    final allCategoriesAsync = ref.watch(allCategoriesProvider);
    final tasksAsync = ref.watch(tasksForDateProvider(date));
    final settingsAsync = ref.watch(localSettingsProvider);
    final isWide = MediaQuery.sizeOf(context).width >= 700;

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
      return const Center(child: CircularProgressIndicator());
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
              QuickAddField(date: date),
            ],
            const SizedBox(height: DaybookSpacing.xl),
            if (isEmpty)
              _EmptyDay(text: text)
            else ...[
              for (final category in sectionsToShow) ...[
                CategorySection(
                  category: category,
                  tasks: groups.byActiveCategoryId[category.id] ?? const [],
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

class _EmptyDay extends StatelessWidget {
  const _EmptyDay({required this.text});

  final DaybookText text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: DaybookSpacing.xxxl),
      child: Center(
        child: Text(
          'Nothing planned. Add your first task.',
          style: text.body,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
