import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    this.categoryLabel,
    this.timeMode = TaskTileTimeMode.none,
    this.timeLabel,
    this.onToggle,
    this.onTap,
    this.onLongPress,
    this.selected = false,
  });

  final String title;
  final Color categoryColor;

  /// Category name, for the combined accessibility label (SPEC §11 M8) —
  /// the color bar alone conveys nothing to a screen reader.
  final String? categoryLabel;
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

  String _combinedLabel() {
    final statusLabel = switch (status) {
      TaskTileStatus.todo => 'not done',
      TaskTileStatus.done => 'done',
      TaskTileStatus.cancelled => 'cancelled',
    };
    final timeDescription = switch (timeMode) {
      TaskTileTimeMode.none => 'no time',
      TaskTileTimeMode.at => timeLabel == null ? 'no time' : 'at $timeLabel',
      TaskTileTimeMode.window =>
        timeLabel == null ? 'no time' : 'anytime, $timeLabel',
    };
    final parts = [
      title,
      if (categoryLabel != null) '$categoryLabel category',
      timeDescription,
      statusLabel,
    ];
    return parts.join(', ');
  }

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
                            child: Semantics(
                              label: _combinedLabel(),
                              excludeSemantics: true,
                              container: true,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                    // Flexible, not a bare child: at large
                                    // system font scales (SPEC §11 M8,
                                    // 1.3x) a window chip's "9:00 AM –
                                    // 6:00 PM" label can outgrow the space
                                    // left after the title column, which
                                    // would overflow the Row instead of
                                    // shrinking.
                                    Flexible(
                                      child: _TimeChip(
                                        mode: timeMode,
                                        label: timeLabel!,
                                        colors: colors,
                                        text: text,
                                      ),
                                    ),
                                ],
                              ),
                            ),
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
      container: true,
      child: GestureDetector(
        // 24dp of visible circle alone misses the 48dp minimum tap target
        // (SPEC §11 M8 / CLAUDE.md rule 9) — the hit area is padded out to
        // 48dp while only the circle itself is painted.
        behavior: HitTestBehavior.opaque,
        onTap: onToggle == null
            ? null
            : () {
                if (!kIsWeb) HapticFeedback.lightImpact();
                onToggle!();
              },
        child: SizedBox(
          width: 48,
          height: 48,
          child: Center(
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
          Flexible(
            child: Text(
              label,
              style: text.taskMeta.copyWith(color: tint),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
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
