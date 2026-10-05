import 'package:flutter/material.dart';

import '../../core/theme/theme.dart';

/// Shown while the Day screen's providers are still resolving (first frame
/// after launch, or a cold page in the `PageView`) so there's a silhouette
/// of the real layout instead of a blank flash or a lone spinner (SPEC §11
/// M8). Static (no shimmer animation/package) — skips entirely under
/// reduced motion by virtue of not animating in the first place.
class DaySkeleton extends StatelessWidget {
  const DaySkeleton({super.key, required this.isWide});

  final bool isWide;

  @override
  Widget build(BuildContext context) {
    final colors = context.daybookColors;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isWide
            ? DaybookSpacing.screenPaddingWeb
            : DaybookSpacing.screenPaddingPhone,
        vertical: DaybookSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _bar(colors, width: 200, height: 40),
          const SizedBox(height: DaybookSpacing.sm),
          _bar(colors, width: 140, height: 16),
          const SizedBox(height: DaybookSpacing.lg),
          Row(
            children: [
              _chip(colors),
              const SizedBox(width: DaybookSpacing.sm),
              _chip(colors),
              const SizedBox(width: DaybookSpacing.sm),
              _chip(colors),
            ],
          ),
          const SizedBox(height: DaybookSpacing.xl),
          _bar(colors, width: 100, height: 14),
          const SizedBox(height: DaybookSpacing.sm),
          for (var i = 0; i < 3; i++) ...[
            _bar(colors, width: double.infinity, height: 64),
            const SizedBox(height: DaybookSpacing.sm),
          ],
        ],
      ),
    );
  }

  Widget _bar(
    DaybookColors colors, {
    required double width,
    required double height,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(DaybookRadii.chip),
      ),
    );
  }

  Widget _chip(DaybookColors colors) {
    return Container(
      width: 72,
      height: 32,
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(DaybookRadii.pill),
      ),
    );
  }
}
