import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/theme/theme.dart';
import 'day_providers.dart';

/// Month-grid calendar (SPEC §7.2/§7.6): days with tasks show a dot.
/// Shared by [DatePickerSheet] (phone, M1) and the web left rail (M7) —
/// reused, not rebuilt. Watches `tasksInMonthProvider` itself (rather than
/// taking the data as a prop) so it can change the visible month
/// internally without the parent needing to know.
class MonthCalendarGrid extends ConsumerStatefulWidget {
  const MonthCalendarGrid({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  @override
  ConsumerState<MonthCalendarGrid> createState() => _MonthCalendarGridState();
}

class _MonthCalendarGridState extends ConsumerState<MonthCalendarGrid> {
  late DateTime _visibleMonth = DateTime(
    widget.selectedDate.year,
    widget.selectedDate.month,
  );

  @override
  void didUpdateWidget(MonthCalendarGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    final target = DateTime(
      widget.selectedDate.year,
      widget.selectedDate.month,
    );
    // Follow the selected date to a different month (e.g. arrow/keyboard
    // navigation), but don't fight the user's own month-nav taps.
    if (target !=
        DateTime(oldWidget.selectedDate.year, oldWidget.selectedDate.month)) {
      _visibleMonth = target;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.daybookColors;
    final text = context.daybookText;
    final datesWithTasks =
        ref.watch(tasksInMonthProvider(_visibleMonth)).value ?? const {};

    final firstOfMonth = _visibleMonth;
    final daysInMonth = DateTime(
      _visibleMonth.year,
      _visibleMonth.month + 1,
      0,
    ).day;
    // Monday = 0 .. Sunday = 6, matching SPEC's default week_starts_on = 1.
    final leadingBlanks = (firstOfMonth.weekday + 6) % 7;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              tooltip: 'Previous month',
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
              tooltip: 'Next month',
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
          // Narrower than square: the 240px web left rail (SPEC §7.6, M7)
          // leaves ~30px per cell, too tight for a 32dp circle + dot row
          // at aspect ratio 1 — taller cells avoid clipping there without
          // affecting the (already comfortably wide) phone sheet.
          childAspectRatio: 0.72,
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
                date: DateTime(_visibleMonth.year, _visibleMonth.month, day),
                hasTasks: datesWithTasks.any(
                  (d) =>
                      d.year == _visibleMonth.year &&
                      d.month == _visibleMonth.month &&
                      d.day == day,
                ),
                isSelected:
                    widget.selectedDate.year == _visibleMonth.year &&
                    widget.selectedDate.month == _visibleMonth.month &&
                    widget.selectedDate.day == day,
                onTap: widget.onDateSelected,
              ),
          ],
        ),
      ],
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

    return Semantics(
      container: true,
      excludeSemantics: true,
      label:
          '${DateFormat('EEEE, d MMMM').format(date)}'
          '${hasTasks ? ', has tasks' : ''}',
      selected: isSelected,
      button: true,
      child: InkWell(
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
      ),
    );
  }
}
