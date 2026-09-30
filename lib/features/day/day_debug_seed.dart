import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'day_providers.dart';

part 'day_debug_seed.g.dart';

/// Debug-only sample data (M1) so the Day screen layout can be eyeballed
/// before task CRUD exists (M2). No-op outside debug builds; no-op if any
/// task already exists (so it only seeds once).
@Riverpod(keepAlive: true)
Future<void> debugSeed(Ref ref) async {
  if (!kDebugMode) return;

  final taskRepo = ref.watch(taskRepositoryProvider);
  if (await taskRepo.countAll() > 0) return;

  final categories = await ref
      .watch(categoryRepositoryProvider)
      .watchActive()
      .first;
  if (categories.isEmpty) return;

  final office = categories.firstWhere(
    (c) => c.name == 'Office',
    orElse: () => categories.first,
  );
  final personal = categories.firstWhere(
    (c) => c.name == 'Personal',
    orElse: () => categories.first,
  );

  await taskRepo.seedDebugSamplesForDate(
    office.id,
    personal.id,
    DateTime.now(),
  );
}
