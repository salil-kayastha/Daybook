import 'package:flutter/material.dart';

import '../../core/theme/theme.dart';
import '../../core/utils/color_utils.dart';
import '../../core/utils/task_sort.dart';
import '../../core/widgets/task_tile.dart';
import '../../domain/category.dart';
import '../../domain/enums.dart';
import '../../domain/task.dart';

/// One category's block on the Day screen: header, timed tasks, a "No
/// time" subheading before untimed tasks, then done/cancelled tasks
/// (SPEC §7.2, §4 sort order).
class CategorySection extends StatelessWidget {
  const CategorySection({
    super.key,
    required this.category,
    required this.tasks,
    required this.onToggle,
  });

  final Category category;
  final List<Task> tasks;
  final ValueChanged<Task> onToggle;

  @override
  Widget build(BuildContext context) {
    final text = context.daybookText;
    final color = colorFromHex(category.color);
    final sorted = sortTasksForDaySection(tasks);

    final timed = sorted
        .where(
          (t) => t.status == TaskStatus.todo && t.timeMode != TimeMode.none,
        )
        .toList();
    final noTime = sorted
        .where(
          (t) => t.status == TaskStatus.todo && t.timeMode == TimeMode.none,
        )
        .toList();
    final finished = sorted.where((t) => t.status != TaskStatus.todo).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CategorySectionHeader(
          name: category.name,
          color: color,
          count: sorted.length,
        ),
        const SizedBox(height: DaybookSpacing.sm),
        for (final task in timed) ...[
          _tile(context, task, color),
          const SizedBox(height: DaybookSpacing.sm),
        ],
        if (noTime.isNotEmpty) ...[
          Text('No time', style: text.sectionTitle),
          const SizedBox(height: DaybookSpacing.sm),
          for (final task in noTime) ...[
            _tile(context, task, color),
            const SizedBox(height: DaybookSpacing.sm),
          ],
        ],
        for (final task in finished) ...[
          _tile(context, task, color),
          const SizedBox(height: DaybookSpacing.sm),
        ],
      ],
    );
  }

  Widget _tile(BuildContext context, Task task, Color color) {
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
      timeLabel: _timeLabel(task),
      onToggle: () => onToggle(task),
    );
  }

  String? _timeLabel(Task task) {
    final start = task.startTime;
    if (start == null) return null;
    final end = task.endTime;
    final startLabel = _formatHour(start.hour, start.minute);
    if (task.timeMode == TimeMode.window && end != null) {
      return '$startLabel – ${_formatHour(end.hour, end.minute)} · anytime';
    }
    return startLabel;
  }

  String _formatHour(int hour, int minute) {
    final period = hour >= 12 ? 'PM' : 'AM';
    final h12 = hour % 12 == 0 ? 12 : hour % 12;
    final m = minute.toString().padLeft(2, '0');
    return '$h12:$m $period';
  }
}
