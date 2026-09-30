import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/theme.dart';
import '../../core/utils/color_utils.dart';
import '../../core/utils/reorder.dart';
import '../../core/widgets/color_dot.dart';
import '../../domain/category.dart';
import '../day/day_providers.dart';
import 'category_edit_sheet.dart';

/// Create/rename/recolor/reorder/archive categories (SPEC M3). Reachable
/// from the Day screen's app bar — there's no Settings screen yet (M7).
class ManageCategoriesScreen extends ConsumerWidget {
  const ManageCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allAsync = ref.watch(allCategoriesProvider);
    final settingsAsync = ref.watch(localSettingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createCategory(context, ref),
        child: const Icon(Icons.add),
      ),
      body: allAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (all) {
          final active = all.where((c) => !c.isArchived).toList();
          final archived = all.where((c) => c.isArchived).toList();
          final defaultId = settingsAsync.value?.defaultCategoryId;

          return ListView(
            padding: const EdgeInsets.symmetric(vertical: DaybookSpacing.lg),
            children: [
              ReorderableListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                buildDefaultDragHandles: false,
                onReorderItem: (oldIndex, newIndex) =>
                    _handleReorder(ref, active, oldIndex, newIndex),
                children: [
                  for (final (index, category) in active.indexed)
                    _CategoryRow(
                      key: ValueKey(category.id),
                      category: category,
                      index: index,
                      isDefault: category.id == defaultId,
                      onTap: () =>
                          _editCategory(context, ref, active, category),
                      onSetDefault: () => ref
                          .read(settingsRepositoryProvider)
                          .setDefaultCategory(category.id),
                      onArchive: () => ref
                          .read(categoryRepositoryProvider)
                          .archive(category),
                    ),
                ],
              ),
              if (archived.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    DaybookSpacing.lg,
                    DaybookSpacing.xl,
                    DaybookSpacing.lg,
                    DaybookSpacing.sm,
                  ),
                  child: Text(
                    'ARCHIVED',
                    style: context.daybookText.sectionTitle.copyWith(
                      color: context.daybookColors.inkMuted,
                    ),
                  ),
                ),
                for (final category in archived)
                  _CategoryRow(
                    key: ValueKey(category.id),
                    category: category,
                    isDefault: false,
                    archivedRow: true,
                    onTap: () => _editCategory(context, ref, active, category),
                    onSetDefault: null,
                    onUnarchive: () => ref
                        .read(categoryRepositoryProvider)
                        .unarchive(category),
                  ),
              ],
            ],
          );
        },
      ),
    );
  }

  Future<void> _handleReorder(
    WidgetRef ref,
    List<Category> active,
    int oldIndex,
    int newIndex,
  ) async {
    final moved = active[oldIndex];
    final reordered = [...active]
      ..removeAt(oldIndex)
      ..insert(newIndex, moved);
    final movedIndex = reordered.indexOf(moved);
    final before = movedIndex > 0 ? reordered[movedIndex - 1].sortOrder : null;
    final after = movedIndex < reordered.length - 1
        ? reordered[movedIndex + 1].sortOrder
        : null;
    final newSortOrder = sortOrderBetween(before, after);
    await ref.read(categoryRepositoryProvider).reorder(moved, newSortOrder);
  }

  Future<void> _createCategory(BuildContext context, WidgetRef ref) async {
    final active =
        ref
            .read(allCategoriesProvider)
            .value
            ?.where((c) => !c.isArchived)
            .toList() ??
        const [];
    final result = await showCategoryEditSheet(context, existingActive: active);
    if (result == null) return;
    final maxOrder = active.isEmpty
        ? 0.0
        : active.map((c) => c.sortOrder).reduce((a, b) => a > b ? a : b) + 1;
    await ref
        .read(categoryRepositoryProvider)
        .create(name: result.name, color: result.colorHex, sortOrder: maxOrder);
  }

  Future<void> _editCategory(
    BuildContext context,
    WidgetRef ref,
    List<Category> active,
    Category category,
  ) async {
    final result = await showCategoryEditSheet(
      context,
      existingActive: active,
      editing: category,
    );
    if (result == null) return;
    final repo = ref.read(categoryRepositoryProvider);
    if (result.name != category.name) {
      await repo.rename(category, result.name);
    }
    if (result.colorHex != category.color) {
      await repo.updateColor(category, result.colorHex);
    }
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({
    super.key,
    required this.category,
    required this.isDefault,
    required this.onTap,
    this.index,
    this.onSetDefault,
    this.onArchive,
    this.onUnarchive,
    this.archivedRow = false,
  });

  final Category category;
  final bool isDefault;
  final bool archivedRow;

  /// Position within the active list; required to wire the drag handle.
  final int? index;
  final VoidCallback onTap;
  final VoidCallback? onSetDefault;
  final VoidCallback? onArchive;
  final VoidCallback? onUnarchive;

  @override
  Widget build(BuildContext context) {
    final colors = context.daybookColors;
    final text = context.daybookText;
    final color = colorFromHex(category.color);

    return ListTile(
      onTap: onTap,
      leading: ColorDot(color: color, diameter: 16),
      title: Text(
        category.name,
        style: text.taskTitle.copyWith(
          color: archivedRow ? colors.inkMuted : colors.ink,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (onSetDefault != null)
            Semantics(
              label: isDefault ? 'Default category' : 'Set as default',
              button: true,
              child: IconButton(
                icon: Icon(
                  isDefault ? Icons.star : Icons.star_border,
                  color: isDefault ? colors.warning : colors.inkMuted,
                ),
                onPressed: isDefault ? null : onSetDefault,
              ),
            ),
          if (onArchive != null)
            Semantics(
              label: 'Archive ${category.name}',
              button: true,
              child: IconButton(
                icon: const Icon(Icons.archive_outlined),
                onPressed: onArchive,
              ),
            ),
          if (onUnarchive != null)
            Semantics(
              label: 'Unarchive ${category.name}',
              button: true,
              child: IconButton(
                icon: const Icon(Icons.unarchive_outlined),
                onPressed: onUnarchive,
              ),
            ),
          if (!archivedRow && index != null)
            ReorderableDragStartListener(
              index: index!,
              child: Icon(Icons.drag_handle, color: colors.inkMuted),
            ),
        ],
      ),
    );
  }
}
