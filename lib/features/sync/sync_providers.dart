import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/local/database_provider.dart';
import '../../data/sync/sync_engine.dart';
import '../auth/auth_providers.dart';
import '../auth/user_guard_provider.dart';

part 'sync_providers.g.dart';

@Riverpod(keepAlive: true)
Connectivity connectivity(Ref ref) => Connectivity();

@Riverpod(keepAlive: true)
SyncEngine syncEngine(Ref ref) {
  final engine = SyncEngine(
    database: ref.watch(appDatabaseProvider),
    client: Supabase.instance.client,
    connectivity: ref.watch(connectivityProvider),
  );
  ref.onDispose(engine.dispose);
  return engine;
}

/// Starts (and restarts, on user change) the sync lifecycle: initial sync
/// if needed, a push of anything pending, then realtime (SPEC §10 "when to
/// sync": sign-in). Watched from [DaybookApp] so it runs app-wide,
/// independent of which route is on screen — the "Setting up your data…"
/// state surfaces via `SyncEngine.status`, not by blocking navigation (the
/// router's own gate is [userGuardProvider], which this awaits first so
/// the account-switch wipe always finishes before initial sync starts).
@Riverpod(keepAlive: true)
class SyncBootstrap extends _$SyncBootstrap {
  @override
  Future<void> build() async {
    final authState = ref.watch(authStateChangesProvider).value;
    final user =
        authState?.session?.user ??
        ref.read(authRepositoryProvider).currentUser;
    final engine = ref.watch(syncEngineProvider);

    if (user == null) {
      engine.stopRealtime();
      return;
    }

    await ref.read(userGuardProvider.future);
    await engine.runInitialSyncIfNeeded(user.id);
    await engine.push();
    engine.startRealtime(user.id);
  }
}
