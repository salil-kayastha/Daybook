import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/empty_state.dart';
import '../../data/sync/sync_status.dart';
import '../../domain/category.dart';
import '../sync/sync_providers.dart';
import 'day_providers.dart';

/// Picks the right empty state for the Day screen (SPEC §11 M8): no
/// categories at all, offline with nothing ever synced down, an empty
/// filtered category, or just an empty day — each with its own next
/// action rather than one generic message.
class DayEmptyState extends ConsumerWidget {
  const DayEmptyState({
    super.key,
    required this.activeCategories,
    required this.allCategories,
    required this.selectedFilterCategoryId,
    required this.isWide,
  });

  final List<Category> activeCategories;
  final List<Category> allCategories;
  final String? selectedFilterCategoryId;
  final bool isWide;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncEngine = ref.watch(syncEngineProvider);
    return ValueListenableBuilder<SyncStatus>(
      valueListenable: syncEngine.status,
      builder: (context, status, _) {
        // Categories are seeded for every real account on first sync — zero
        // of them while offline means this device has never synced down
        // anything, not just "an empty day".
        if (!status.isOnline && allCategories.isEmpty) {
          return const EmptyState(
            message:
                "You're offline and nothing has been downloaded to this "
                'device yet. Connect to the internet to sync.',
          );
        }

        if (activeCategories.isEmpty) {
          return EmptyState(
            message: 'No categories yet. Create one to start planning.',
            actionLabel: 'Manage categories',
            onAction: () => context.push('/categories'),
          );
        }

        if (selectedFilterCategoryId != null) {
          final name = allCategories
              .where((c) => c.id == selectedFilterCategoryId)
              .map((c) => c.name)
              .firstOrNull;
          return EmptyState(
            message: name == null
                ? 'Nothing in this category today.'
                : 'Nothing in $name today.',
            actionLabel: 'Show all categories',
            onAction: () => ref
                .read(settingsRepositoryProvider)
                .setSelectedFilterCategory(null),
          );
        }

        return EmptyState(
          message: isWide
              ? 'Nothing planned. Add a task above or press N.'
              : 'Nothing planned. Tap + to add your first task.',
        );
      },
    );
  }
}
