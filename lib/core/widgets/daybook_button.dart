import 'package:flutter/material.dart';

import '../theme/theme.dart';

enum DaybookButtonVariant { primary, secondary, danger }

/// Shared button matching SPEC §6.4 sizing (48dp min tap target, pill shape).
class DaybookButton extends StatelessWidget {
  const DaybookButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = DaybookButtonVariant.primary,
  });

  final String label;
  final VoidCallback? onPressed;
  final DaybookButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final colors = context.daybookColors;
    final text = context.daybookText;

    final (background, foreground, border) = switch (variant) {
      DaybookButtonVariant.primary => (colors.primary, colors.onPrimary, null),
      DaybookButtonVariant.secondary => (
        colors.surface,
        colors.ink,
        colors.line,
      ),
      DaybookButtonVariant.danger => (colors.danger, colors.onPrimary, null),
    };

    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          textStyle: text.button,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DaybookRadii.pill),
            side: border != null ? BorderSide(color: border) : BorderSide.none,
          ),
          padding: const EdgeInsets.symmetric(horizontal: DaybookSpacing.lg),
        ),
        child: Text(label),
      ),
    );
  }
}
