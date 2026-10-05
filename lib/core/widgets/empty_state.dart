import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Illustration-free empty state (SPEC §11 M8): a short message plus one
/// clear next action, built only from theme tokens. [actionLabel]/[onAction]
/// are both-or-neither — a state with nothing useful to do just omits them.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.message,
    this.actionLabel,
    this.onAction,
  }) : assert(
         (actionLabel == null) == (onAction == null),
         'actionLabel and onAction must both be set or both be null',
       );

  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final text = context.daybookText;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: DaybookSpacing.xxxl),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, style: text.body, textAlign: TextAlign.center),
            if (actionLabel != null) ...[
              const SizedBox(height: DaybookSpacing.lg),
              OutlinedButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
