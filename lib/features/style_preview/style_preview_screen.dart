import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/theme.dart';
import '../../core/theme/theme_providers.dart';
import '../../core/widgets/color_dot.dart';
import '../../core/widgets/daybook_button.dart';
import '../../core/widgets/task_tile.dart';

/// Permanent design reference (debug builds only): all text styles, sample
/// task tiles, category chips and buttons, with a light/dark toggle. The
/// frozen indigo palette (SPEC §6.1) is the only palette — see
/// [DaybookColors].
class StylePreviewScreen extends ConsumerWidget {
  const StylePreviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(selectedThemeModeProvider);
    final colors = context.daybookColors;
    final text = context.daybookText;

    final isWide = MediaQuery.sizeOf(context).width >= 700;

    return Scaffold(
      appBar: AppBar(title: const Text('Style preview')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isWide
                ? DaybookSpacing.screenPaddingWeb
                : DaybookSpacing.screenPaddingPhone,
            vertical: DaybookSpacing.lg,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionTitle('Brightness'),
                const SizedBox(height: DaybookSpacing.sm),
                Wrap(
                  spacing: DaybookSpacing.sm,
                  children: [ThemeMode.light, ThemeMode.dark, ThemeMode.system]
                      .map((m) {
                        return ChoiceChip(
                          label: Text(switch (m) {
                            ThemeMode.light => 'Light',
                            ThemeMode.dark => 'Dark',
                            ThemeMode.system => 'System',
                          }),
                          selected: themeMode == m,
                          onSelected: (_) => ref
                              .read(selectedThemeModeProvider.notifier)
                              .set(m),
                        );
                      })
                      .toList(),
                ),
                const SizedBox(height: DaybookSpacing.xxl),

                _SectionTitle('Typography'),
                const SizedBox(height: DaybookSpacing.sm),
                Text('29 September', style: text.displayDate),
                Text('Tuesday · 2026', style: text.subDate),
                const SizedBox(height: DaybookSpacing.sm),
                Text('OFFICE', style: text.sectionTitle),
                const SizedBox(height: DaybookSpacing.sm),
                Text('Meeting with design team', style: text.taskTitle),
                Text('9:00 AM · notes', style: text.taskMeta),
                const SizedBox(height: DaybookSpacing.sm),
                Text(
                  'Operate distributed services such as Kafka, RabbitMQ, '
                  'Redis inside k8s.',
                  style: text.body,
                ),
                const SizedBox(height: DaybookSpacing.sm),
                Text('Button label', style: text.button),
                const SizedBox(height: DaybookSpacing.xxl),

                _SectionTitle('Category colors'),
                const SizedBox(height: DaybookSpacing.sm),
                Wrap(
                  spacing: DaybookSpacing.md,
                  runSpacing: DaybookSpacing.md,
                  children: DaybookColors.categoryPalette
                      .map((c) => ColorDot(color: c, diameter: 24))
                      .toList(),
                ),
                const SizedBox(height: DaybookSpacing.xxl),

                _SectionTitle('Category filter chips'),
                const SizedBox(height: DaybookSpacing.sm),
                Wrap(
                  spacing: DaybookSpacing.sm,
                  children: const [
                    _FilterChipPreview(label: 'All', selected: true),
                    _FilterChipPreview(label: 'Office', selected: false),
                    _FilterChipPreview(label: 'Personal', selected: false),
                  ],
                ),
                const SizedBox(height: DaybookSpacing.xxl),

                _SectionTitle('Category section header'),
                const SizedBox(height: DaybookSpacing.sm),
                CategorySectionHeader(
                  name: 'Office',
                  color: DaybookColors.categoryPalette[0],
                  count: 2,
                ),
                const SizedBox(height: DaybookSpacing.xxl),

                _SectionTitle('Task tiles'),
                const SizedBox(height: DaybookSpacing.sm),
                Column(
                  children: [
                    TaskTile(
                      title: 'Meeting',
                      categoryColor: DaybookColors.categoryPalette[0],
                      status: TaskTileStatus.todo,
                      timeMode: TaskTileTimeMode.at,
                      timeLabel: '9:00 AM',
                    ),
                    const SizedBox(height: DaybookSpacing.sm),
                    TaskTile(
                      title: 'Watch handover videos',
                      categoryColor: DaybookColors.categoryPalette[0],
                      status: TaskTileStatus.todo,
                      timeMode: TaskTileTimeMode.window,
                      timeLabel: '9 AM – 6 PM · anytime',
                    ),
                    const SizedBox(height: DaybookSpacing.sm),
                    TaskTile(
                      title: 'Write blog',
                      categoryColor: DaybookColors.categoryPalette[1],
                      status: TaskTileStatus.todo,
                    ),
                    const SizedBox(height: DaybookSpacing.sm),
                    TaskTile(
                      title: 'Buy bike parts',
                      categoryColor: DaybookColors.categoryPalette[1],
                      status: TaskTileStatus.done,
                    ),
                    const SizedBox(height: DaybookSpacing.sm),
                    TaskTile(
                      title: 'Go watch terraform videos',
                      categoryColor: DaybookColors.categoryPalette[1],
                      status: TaskTileStatus.cancelled,
                    ),
                  ],
                ),
                const SizedBox(height: DaybookSpacing.xxl),

                _SectionTitle('Buttons'),
                const SizedBox(height: DaybookSpacing.sm),
                Wrap(
                  spacing: DaybookSpacing.sm,
                  runSpacing: DaybookSpacing.sm,
                  children: [
                    DaybookButton(label: 'Add task', onPressed: () {}),
                    DaybookButton(
                      label: 'Cancel',
                      variant: DaybookButtonVariant.secondary,
                      onPressed: () {},
                    ),
                    DaybookButton(
                      label: 'Delete',
                      variant: DaybookButtonVariant.danger,
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: DaybookSpacing.xxl),

                _SectionTitle('Surfaces'),
                const SizedBox(height: DaybookSpacing.sm),
                Row(
                  children: [
                    _SwatchLabel('bg', colors.bg),
                    _SwatchLabel('surface', colors.surface),
                    _SwatchLabel('surfaceAlt', colors.surfaceAlt),
                  ],
                ),
                const SizedBox(height: DaybookSpacing.sm),
                Row(
                  children: [
                    _SwatchLabel('primary', colors.primary),
                    _SwatchLabel('success', colors.success),
                    _SwatchLabel('warning', colors.warning),
                    _SwatchLabel('danger', colors.danger),
                  ],
                ),
                const SizedBox(height: DaybookSpacing.xxxl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(label, style: context.daybookText.sectionTitle);
  }
}

class _FilterChipPreview extends StatelessWidget {
  const _FilterChipPreview({required this.label, required this.selected});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = context.daybookColors;
    final text = context.daybookText;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DaybookSpacing.md,
        vertical: DaybookSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: selected ? colors.primary : colors.surfaceAlt,
        borderRadius: BorderRadius.circular(DaybookRadii.pill),
      ),
      child: Text(
        label,
        style: text.taskMeta.copyWith(
          color: selected ? colors.onPrimary : colors.ink,
        ),
      ),
    );
  }
}

class _SwatchLabel extends StatelessWidget {
  const _SwatchLabel(this.label, this.color);

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final text = context.daybookText;
    final colors = context.daybookColors;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(DaybookRadii.card),
              border: Border.all(color: colors.line),
            ),
          ),
          const SizedBox(height: DaybookSpacing.xs),
          Text(label, style: text.taskMeta),
        ],
      ),
    );
  }
}
