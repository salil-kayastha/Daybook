import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/theme/theme.dart';
import '../../domain/enums.dart';
import '../../domain/task.dart';
import 'category_section.dart';
import 'day_providers.dart';
import 'quick_add_field.dart';

/// One day's content: date header, progress, and a category section per
/// active category (empty categories hidden — SPEC §7.2).
class DayPage extends ConsumerWidget {
  const DayPage({
    super.key,
    required this.date,
    required this.onOpenDetails,
    required this.onLongPressTask,
  });

  final DateTime date;
  final ValueChanged<Task> onOpenDetails;
  final ValueChanged<Task> onLongPressTask;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = context.daybookText;
    final categoriesAsync = ref.watch(activeCategoriesProvider);
    final tasksAsync = ref.watch(tasksForDateProvider(date));
    final isWide = MediaQuery.sizeOf(context).width >= 700;

    return categoriesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data: (categories) {
        return tasksAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
          data: (tasks) {
            final byCategory = <String, List<Task>>{};
            for (final task in tasks) {
              final key = task.categoryId ?? '';
              byCategory.putIfAbsent(key, () => []).add(task);
            }

            final doneCount = tasks
                .where((t) => t.status == TaskStatus.done)
                .length;

            final nonEmptyCategories = categories
                .where((c) => (byCategory[c.id]?.isNotEmpty ?? false))
                .toList();

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isWide
                    ? DaybookSpacing.screenPaddingWeb
                    : DaybookSpacing.screenPaddingPhone,
                vertical: DaybookSpacing.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('d MMMM').format(date),
                    style: text.displayDate,
                  ),
                  const SizedBox(height: DaybookSpacing.xs),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('EEEE · yyyy').format(date),
                        style: text.subDate,
                      ),
                      if (tasks.isNotEmpty)
                        Text(
                          '$doneCount/${tasks.length} done',
                          style: text.subDate,
                        ),
                    ],
                  ),
                  if (isWide) ...[
                    const SizedBox(height: DaybookSpacing.lg),
                    QuickAddField(date: date),
                  ],
                  const SizedBox(height: DaybookSpacing.xl),
                  if (nonEmptyCategories.isEmpty)
                    _EmptyDay(text: text)
                  else
                    for (final category in nonEmptyCategories) ...[
                      CategorySection(
                        category: category,
                        tasks: byCategory[category.id]!,
                        onToggle: (task) =>
                            ref.read(taskRepositoryProvider).toggleDone(task),
                        onOpenDetails: onOpenDetails,
                        onLongPressTask: onLongPressTask,
                      ),
                      const SizedBox(height: DaybookSpacing.xl),
                    ],
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _EmptyDay extends StatelessWidget {
  const _EmptyDay({required this.text});

  final DaybookText text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: DaybookSpacing.xxxl),
      child: Center(
        child: Text(
          'Nothing planned. Add your first task.',
          style: text.body,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
