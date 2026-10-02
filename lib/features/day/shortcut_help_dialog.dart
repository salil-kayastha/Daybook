import 'package:flutter/material.dart';

import '../../core/theme/theme.dart';

const _shortcuts = [
  ('N', 'New task (focus quick-add)'),
  ('←/→ or J/K', 'Previous / next day'),
  ('T', 'Today'),
  ('↑/↓', 'Move selection between tasks'),
  ('E', 'Edit selected task'),
  ('X', 'Toggle done on selected task'),
  ('Delete', 'Delete selected task'),
  ('Cmd/Ctrl+Enter', 'Save / add (in quick-add)'),
  ('Esc', 'Close panel / clear selection'),
  ('?', 'Show this help'),
];

/// SPEC §7.6 "?": a short reference for the keyboard shortcuts.
Future<void> showShortcutHelpDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (context) => const _ShortcutHelpDialog(),
  );
}

class _ShortcutHelpDialog extends StatelessWidget {
  const _ShortcutHelpDialog();

  @override
  Widget build(BuildContext context) {
    final text = context.daybookText;
    final colors = context.daybookColors;
    return AlertDialog(
      title: const Text('Keyboard shortcuts'),
      content: SizedBox(
        width: 340,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final (key, description) in _shortcuts)
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: DaybookSpacing.xs,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 120,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: DaybookSpacing.sm,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: colors.surfaceAlt,
                          borderRadius: BorderRadius.circular(
                            DaybookRadii.chip,
                          ),
                        ),
                        child: Text(key, style: text.taskMeta),
                      ),
                    ),
                    const SizedBox(width: DaybookSpacing.sm),
                    Expanded(child: Text(description, style: text.body)),
                  ],
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
