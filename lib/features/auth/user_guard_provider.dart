import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/utils/user_switch.dart';
import '../../data/local/database_provider.dart';
import '../day/day_providers.dart';
import 'auth_providers.dart';

part 'user_guard_provider.g.dart';

/// Runs once per sign-in (M4): if a *different* account signed in on this
/// device than last time, wipes local categories/tasks first so two
/// accounts' data never mix (CLAUDE.md offline-first rules still apply —
/// this only ever runs against the local DB, never Supabase). The router
/// awaits this before letting navigation into the signed-in area proceed,
/// so there's no flicker of a previous account's data.
@Riverpod(keepAlive: true)
Future<void> userGuard(Ref ref) async {
  final user =
      ref.watch(authStateChangesProvider).value?.session?.user ??
      ref.read(authRepositoryProvider).currentUser;
  if (user == null) return;

  final settingsRepository = ref.read(settingsRepositoryProvider);
  final settings = await settingsRepository.watch().first;

  if (shouldClearLocalData(
    storedUserId: settings.lastSignedInUserId,
    newUserId: user.id,
  )) {
    await ref.read(appDatabaseProvider).clearAllLocalData();
  }

  if (settings.lastSignedInUserId != user.id) {
    await settingsRepository.setLastSignedInUserId(user.id);
  }
}
