import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/theme/theme.dart';
import 'day_providers.dart';

/// Month-grid date picker (SPEC §7.2): days with tasks show a dot; tapping
/// a day returns it so the caller can jump the `PageView` there.
class DatePickerSheet extends ConsumerStatefulWidget {
  const DatePickerSheet({super.key, required this.initialDate});

  final DateTime initialDate;

  @override
  ConsumerState<DatePickerSheet> createState() => _DatePickerSheetState();
}

class _DatePickerSheetState extends ConsumerState<DatePickerSheet> {
  late DateTime _visibleMonth = DateTime(
    widget.initialDate.year,
    widget.initialDate.month,
  );

  @override
  Widget build(BuildContext context) {
    final colors = context.daybookColors;
    final text = context.daybookText;
    final datesWithTasksAsync = ref.watch(tasksInMonthProvider(_visibleMonth));
    final datesWithTasks = datesWithTasksAsync.value ?? const {};

    final firstOfMonth = _visibleMonth;
    final daysInMonth = DateTime(
      _visibleMonth.year,
      _visibleMonth.month + 1,
      0,
    ).day;
    // Monday = 0 .. Sunday = 6, matching SPEC's default week_starts_on = 1.
    final leadingBlanks = (firstOfMonth.weekday + 6) % 7;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(DaybookSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () => setState(
                    () => _visibleMonth = DateTime(
                      _visibleMonth.year,
                      _visibleMonth.month - 1,
                    ),
                  ),
                ),
                Text(
                  DateFormat('MMMM yyyy').format(_visibleMonth),
                  style: text.taskTitle,
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () => setState(
                    () => _visibleMonth = DateTime(
                      _visibleMonth.year,
                      _visibleMonth.month + 1,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: DaybookSpacing.sm),
            GridView.count(
              crossAxisCount: 7,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                for (final label in const ['M', 'T', 'W', 'T', 'F', 'S', 'S'])
                  Center(
                    child: Text(
                      label,
                      style: text.taskMeta.copyWith(color: colors.inkMuted),
                    ),
                  ),
                for (var i = 0; i < leadingBlanks; i++) const SizedBox.shrink(),
                for (var day = 1; day <= daysInMonth; day++)
                  _DayCell(
                    date: DateTime(
                      _visibleMonth.year,
                      _visibleMonth.month,
                      day,
                    ),
                    hasTasks: datesWithTasks.any(
                      (d) =>
                          d.year == _visibleMonth.year &&
                          d.month == _visibleMonth.month &&
                          d.day == day,
                    ),
                    isSelected:
                        widget.initialDate.year == _visibleMonth.year &&
                        widget.initialDate.month == _visibleMonth.month &&
                        widget.initialDate.day == day,
                    onTap: (date) => Navigator.of(context).pop(date),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.date,
    required this.hasTasks,
    required this.isSelected,
    required this.onTap,
  });

  final DateTime date;
  final bool hasTasks;
  final bool isSelected;
  final ValueChanged<DateTime> onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.daybookColors;
    final text = context.daybookText;

    return InkWell(
      borderRadius: BorderRadius.circular(DaybookRadii.pill),
      onTap: () => onTap(date),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? colors.primary : null,
            ),
            child: Text(
              '${date.day}',
              style: text.body.copyWith(
                color: isSelected ? colors.onPrimary : colors.ink,
              ),
            ),
          ),
          SizedBox(
            height: 6,
            child: hasTasks
                ? Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colors.primary,
                      shape: BoxShape.circle,
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }
}
