import 'package:flutter/material.dart';

import '../../core/theme/theme.dart';
import 'month_calendar_grid.dart';

/// Phone date-picker sheet (SPEC §7.2) — a thin wrapper around the shared
/// [MonthCalendarGrid] (also used by the web left rail, M7).
class DatePickerSheet extends StatelessWidget {
  const DatePickerSheet({super.key, required this.initialDate});

  final DateTime initialDate;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(DaybookSpacing.lg),
        child: MonthCalendarGrid(
          selectedDate: initialDate,
          onDateSelected: (date) => Navigator.of(context).pop(date),
        ),
      ),
    );
  }
}
