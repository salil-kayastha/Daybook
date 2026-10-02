import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/breakpoints.dart';
import '../../core/theme/theme.dart';
import '../../core/utils/color_utils.dart';
import 'day_providers.dart';
import 'month_calendar_grid.dart';

/// Left rail for two/three-pane web layouts (SPEC §7.6, M7): mini month
/// calendar, category filter list (same persisted selection as the phone
/// filter chips), a Today button, and Settings access.
class LeftRail extends ConsumerWidget {
  const LeftRail({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    required this.onToday,
  });

  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final VoidCallback onToday;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.daybookColors;
    final text = context.daybookText;
    final categoriesAsync = ref.watch(activeCategoriesProvider);
    final settingsAsync = ref.watch(localSettingsProvider);
    final selectedFilterId = settingsAsync.value?.selectedFilterCategoryId;

    return Container(
      width: DaybookBreakpoints.railWidth,
      padding: const EdgeInsets.all(DaybookSpacing.md),
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: colors.line)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onToday,
                child: const Text('Today'),
              ),
            ),
            const SizedBox(height: DaybookSpacing.lg),
            MonthCalendarGrid(
              selectedDate: selectedDate,
              onDateSelected: onDateSelected,
            ),
            const SizedBox(height: DaybookSpacing.xl),
            Text(
              'CATEGORIES',
              style: text.sectionTitle.copyWith(color: colors.inkMuted),
            ),
            const SizedBox(height: DaybookSpacing.sm),
            _RailFilterRow(
              label: 'All',
              color: null,
              selected: selectedFilterId == null,
              onTap: () => ref
                  .read(settingsRepositoryProvider)
                  .setSelectedFilterCategory(null),
            ),
            for (final category in categoriesAsync.value ?? const [])
              _RailFilterRow(
                label: category.name,
                color: colorFromHex(category.color),
                selected: selectedFilterId == category.id,
                onTap: () => ref
                    .read(settingsRepositoryProvider)
                    .setSelectedFilterCategory(category.id),
              ),
            const SizedBox(height: DaybookSpacing.xl),
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: () => context.push('/categories'),
                icon: const Icon(Icons.category_outlined, size: 18),
                label: const Text('Manage categories'),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: () => context.push('/settings'),
                icon: const Icon(Icons.settings_outlined, size: 18),
                label: const Text('Settings'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RailFilterRow extends StatelessWidget {
  const _RailFilterRow({
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

    return Material(
      color: selected ? colors.surfaceAlt : Colors.transparent,
      borderRadius: BorderRadius.circular(DaybookRadii.chip),
      child: InkWell(
        borderRadius: BorderRadius.circular(DaybookRadii.chip),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: DaybookSpacing.sm,
            vertical: DaybookSpacing.sm,
          ),
          child: Row(
            children: [
              if (color != null) ...[
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: DaybookSpacing.sm),
              ] else
                const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: text.body.copyWith(
                    color: selected ? colors.ink : colors.inkMuted,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
