import 'package:flutter/material.dart';

import '../../core/theme/theme.dart';

/// Long-press menu on a task tile (SPEC §7.2). Deliberately not a
/// horizontal swipe gesture — that would conflict with the day-to-day
/// `PageView` swipe.
enum TaskAction { edit, moveToTomorrow, pickDate, cancel, delete }

Future<TaskAction?> showTaskActionsSheet(BuildContext context) {
  return showModalBottomSheet<TaskAction>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(DaybookRadii.sheet),
      ),
    ),
    builder: (context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Edit'),
              onTap: () => Navigator.of(context).pop(TaskAction.edit),
            ),
            ListTile(
              leading: const Icon(Icons.wb_sunny_outlined),
              title: const Text('Move to tomorrow'),
              onTap: () => Navigator.of(context).pop(TaskAction.moveToTomorrow),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today_outlined),
              title: const Text('Pick date'),
              onTap: () => Navigator.of(context).pop(TaskAction.pickDate),
            ),
            ListTile(
              leading: const Icon(Icons.cancel_outlined),
              title: const Text('Cancel task'),
              onTap: () => Navigator.of(context).pop(TaskAction.cancel),
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('Delete'),
              onTap: () => Navigator.of(context).pop(TaskAction.delete),
            ),
            const SizedBox(height: DaybookSpacing.sm),
          ],
        ),
      );
    },
  );
}
