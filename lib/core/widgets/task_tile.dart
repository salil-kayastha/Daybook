import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'color_dot.dart';

/// Mirrors the domain `TaskStatus` enum (SPEC §4), kept local until the
/// domain layer exists (M1).
enum TaskTileStatus { todo, done, cancelled }

/// Mirrors the domain `TimeMode` enum (SPEC §4).
enum TaskTileTimeMode { none, at, window }

/// Task tile as specified in SPEC §6.4: rounded-12 card, left 4dp
/// category-color bar, 24dp checkbox circle, title, right-aligned time chip.
class TaskTile extends StatelessWidget {
  const TaskTile({
    super.key,
    required this.title,
    required this.categoryColor,
    required this.status,
    this.timeMode = TaskTileTimeMode.none,
    this.timeLabel,
    this.onToggle,
    this.onTap,
    this.onLongPress,
    this.selected = false,
  });

  final String title;
  final Color categoryColor;
  final TaskTileStatus status;
  final TaskTileTimeMode timeMode;
  final String? timeLabel;
  final VoidCallback? onToggle;

  /// Keyboard-selected (Up/Down, SPEC §7.6, M7) — shown with a focus ring.
  final bool selected;

  /// Opens the task details sheet/panel (SPEC §7.2). Never a horizontal
  /// swipe/drag — that would conflict with the day-to-day `PageView` swipe.
  final VoidCallback? onTap;

  /// Opens the Edit/Move/Pick date/Cancel/Delete menu (SPEC §7.2).
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final colors = context.daybookColors;
    final text = context.daybookText;
    final isFinished =
        status == TaskTileStatus.done || status == TaskTileStatus.cancelled;

    return Container(
      decoration: selected
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(DaybookRadii.card + 2),
              border: Border.all(color: colors.primary, width: 2),
            )
          : null,
      padding: selected ? const EdgeInsets.all(2) : EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(DaybookRadii.card),
        child: Material(
          color: colors.surface,
          child: InkWell(
            onTap: onTap,
            onLongPress: onLongPress,
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(width: 4, color: categoryColor),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: DaybookSpacing.md,
                        vertical: DaybookSpacing.md,
                      ),
                      child: Row(
                        children: [
                          _Checkbox(
                            status: status,
                            colors: colors,
                            onToggle: onToggle,
                          ),
                          const SizedBox(width: DaybookSpacing.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: text.taskTitle.copyWith(
                                    color: isFinished
                                        ? colors.inkMuted
                                        : colors.ink,
                                    decoration: isFinished
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                                ),
                                if (status == TaskTileStatus.cancelled)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: DaybookSpacing.xs,
                                    ),
                                    child: Text(
                                      'Cancelled',
                                      style: text.taskMeta,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          if (timeMode != TaskTileTimeMode.none &&
                              timeLabel != null)
                            _TimeChip(
                              mode: timeMode,
                              label: timeLabel!,
                              colors: colors,
                              text: text,
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Checkbox extends StatelessWidget {
  const _Checkbox({
    required this.status,
    required this.colors,
    required this.onToggle,
  });

  final TaskTileStatus status;
  final DaybookColors colors;
  final VoidCallback? onToggle;

  @override
  Widget build(BuildContext context) {
    final done = status == TaskTileStatus.done;
    return Semantics(
      label: done ? 'Mark not done' : 'Mark done',
      button: true,
      child: GestureDetector(
        onTap: onToggle,
        child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: done ? colors.success : Colors.transparent,
            border: Border.all(
              color: done ? colors.success : colors.line,
              width: 1.5,
            ),
          ),
          child: done
              ? Icon(Icons.check, size: 16, color: colors.onPrimary)
              : null,
        ),
      ),
    );
  }
}

class _TimeChip extends StatelessWidget {
  const _TimeChip({
    required this.mode,
    required this.label,
    required this.colors,
    required this.text,
  });

  final TaskTileTimeMode mode;
  final String label;
  final DaybookColors colors;
  final DaybookText text;

  @override
  Widget build(BuildContext context) {
    final isWindow = mode == TaskTileTimeMode.window;
    final tint = isWindow ? colors.warning : colors.inkMuted;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DaybookSpacing.sm,
        vertical: DaybookSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(DaybookRadii.chip),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isWindow ? Icons.hourglass_bottom : Icons.access_time,
            size: 14,
            color: tint,
          ),
          const SizedBox(width: DaybookSpacing.xs),
          Text(label, style: text.taskMeta.copyWith(color: tint)),
        ],
      ),
    );
  }
}

/// Category section header: colored dot + uppercase name + task count.
class CategorySectionHeader extends StatelessWidget {
  const CategorySectionHeader({
    super.key,
    required this.name,
    required this.color,
    required this.count,
  });

  final String name;
  final Color color;
  final int count;

  @override
  Widget build(BuildContext context) {
    final text = context.daybookText;
    final colors = context.daybookColors;
    return Row(
      children: [
        ColorDot(color: color),
        const SizedBox(width: DaybookSpacing.sm),
        Text(name.toUpperCase(), style: text.sectionTitle),
        const SizedBox(width: DaybookSpacing.xs),
        Text('· $count', style: text.taskMeta.copyWith(color: colors.inkMuted)),
      ],
    );
  }
}
