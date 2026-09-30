import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/theme.dart';
import '../../core/utils/color_utils.dart';
import '../../domain/category.dart';
import 'day_providers.dart';

/// `[All]` + one colored chip per active category (SPEC §7.2). Selection
/// is persisted locally (per device, not synced — CLAUDE.md offline rule).
class CategoryFilterChips extends ConsumerWidget {
  const CategoryFilterChips({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
  });

  final List<Category> categories;
  final String? selectedCategoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (categories.isEmpty) return const SizedBox.shrink();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _FilterChip(
            label: 'All',
            color: null,
            selected: selectedCategoryId == null,
            onTap: () => ref
                .read(settingsRepositoryProvider)
                .setSelectedFilterCategory(null),
          ),
          for (final category in categories) ...[
            const SizedBox(width: DaybookSpacing.sm),
            _FilterChip(
              label: category.name,
              color: colorFromHex(category.color),
              selected: selectedCategoryId == category.id,
              onTap: () => ref
                  .read(settingsRepositoryProvider)
                  .setSelectedFilterCategory(category.id),
            ),
          ],
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final Color? color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.daybookColors;
    final text = context.daybookText;

    return InkWell(
      borderRadius: BorderRadius.circular(DaybookRadii.pill),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: DaybookSpacing.md,
          vertical: DaybookSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: selected ? colors.primary : colors.surfaceAlt,
          borderRadius: BorderRadius.circular(DaybookRadii.pill),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (color != null) ...[
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: DaybookSpacing.xs),
            ],
            Text(
              label,
              style: text.taskMeta.copyWith(
                color: selected ? colors.onPrimary : colors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
