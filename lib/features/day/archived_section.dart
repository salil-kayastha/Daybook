import 'package:flutter/material.dart';

import '../../core/theme/theme.dart';
import '../../core/utils/color_utils.dart';
import '../../core/utils/task_sort.dart';
import '../../core/widgets/task_tile.dart';
import '../../domain/category.dart';
import '../../domain/enums.dart';
import '../../domain/task.dart';

/// Tasks whose category has been archived (SPEC M3): they stay visible
/// here instead of vanishing, even though the category itself no longer
/// appears in the filter chips or the category picker.
class ArchivedSection extends StatelessWidget {
  const ArchivedSection({
    super.key,
    required this.tasks,
    required this.categoriesById,
    required this.onToggle,
    required this.onOpenDetails,
    required this.onLongPressTask,
  });

  final List<Task> tasks;
  final Map<String, Category> categoriesById;
  final ValueChanged<Task> onToggle;
  final ValueChanged<Task> onOpenDetails;
  final ValueChanged<Task> onLongPressTask;

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) return const SizedBox.shrink();
    final text = context.daybookText;
    final colors = context.daybookColors;
    final sorted = sortTasksForDaySection(tasks);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ARCHIVED',
          style: text.sectionTitle.copyWith(color: colors.inkMuted),
        ),
        const SizedBox(height: DaybookSpacing.sm),
        for (final task in sorted) ...[
          _tile(context, task),
          const SizedBox(height: DaybookSpacing.sm),
        ],
      ],
    );
  }

  Widget _tile(BuildContext context, Task task) {
    final category = categoriesById[task.categoryId];
    final color = category != null
        ? colorFromHex(category.color)
        : context.daybookColors.inkMuted;

    return TaskTile(
      title: task.title,
      categoryColor: color,
      status: switch (task.status) {
        TaskStatus.todo => TaskTileStatus.todo,
        TaskStatus.done => TaskTileStatus.done,
        TaskStatus.cancelled => TaskTileStatus.cancelled,
      },
      timeMode: switch (task.timeMode) {
        TimeMode.none => TaskTileTimeMode.none,
        TimeMode.at => TaskTileTimeMode.at,
        TimeMode.window => TaskTileTimeMode.window,
      },
      timeLabel: task.startTime?.format24(),
      onToggle: () => onToggle(task),
      onTap: () => onOpenDetails(task),
      onLongPress: () => onLongPressTask(task),
    );
  }
}
