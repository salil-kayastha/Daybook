import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/utils/debouncer.dart';
import '../../data/local/database_provider.dart';
import '../../data/notifications/notification_scheduler.dart';
import '../../data/repositories/user_settings_repository.dart'
    show userSettingsFromRow;
import '../../domain/user_settings.dart';
import '../auth/auth_providers.dart';
import '../auth/user_guard_provider.dart';
import '../day/day_providers.dart';
import '../sync/sync_providers.dart';

part 'notification_providers.g.dart';

@Riverpod(keepAlive: true)
NotificationScheduler notificationScheduler(Ref ref) {
  return NotificationScheduler(database: ref.watch(appDatabaseProvider));
}

/// The signed-in user's synced notification settings (SPEC §8), for the
/// Settings screen's Notifications section.
@riverpod
Stream<UserSettings?> currentUserSettings(Ref ref) {
  final userId = ref.watch(authRepositoryProvider).currentUser?.id;
  if (userId == null) return Stream.value(null);
  return ref.watch(userSettingsRepositoryProvider).watch(userId);
}

/// Debounced "rebuild and reschedule" trigger (SPEC §8), used by both the
/// repositories (after a task/settings write) and [NotificationBootstrap]
/// (after sign-in, app resume, sync pull). Deliberately does its
/// `ref.read`s lazily inside [_run] rather than `ref.watch`ing
/// `userSettingsRepositoryProvider` at build time — the repositories
/// themselves watch *this* provider to get a ping callback, so watching
/// them back here would be a circular provider dependency.
@Riverpod(keepAlive: true)
NotificationRescheduler notificationRescheduler(Ref ref) {
  final rescheduler = NotificationRescheduler(ref);
  ref.onDispose(rescheduler.dispose);
  return rescheduler;
}

class NotificationRescheduler {
  NotificationRescheduler(this._ref, [Duration? debounceDuration])
    : _debouncer = Debouncer(debounceDuration ?? const Duration(seconds: 2));

  final Ref _ref;
  final Debouncer _debouncer;

  /// [debounce] true (the default) waits 2s so rapid edits coalesce into
  /// one rebuild; pass false for triggers that should apply immediately
  /// (app start/resume, post sync-pull, sign-in).
  void request({bool debounce = true}) {
    _debouncer.run(() => unawaited(_run()), immediate: !debounce);
  }

  Future<void> _run() async {
    final user = _ref.read(authRepositoryProvider).currentUser;
    if (user == null) return;

    final scheduler = _ref.read(notificationSchedulerProvider);
    await _maybeRequestPermissionAfterFirstTask(scheduler);

    // Reads the DAO directly, NOT userSettingsRepositoryProvider — that
    // provider watches notificationReschedulerProvider (for the post-write
    // ping), so reading it back from here would be a circular provider
    // dependency (confirmed via a live crash: `CircularDependencyError` on
    // every reschedule attempt, which silently killed scheduling entirely
    // since it was thrown inside an unawaited Future).
    final database = _ref.read(appDatabaseProvider);
    final row = await database.userSettingsDao.getById(user.id);
    final settings = row == null ? null : userSettingsFromRow(row);
    await scheduler.rescheduleAll(settings: settings);
  }

  /// SPEC §8: request the OS notification permission after the first task
  /// is created, not at first launch — and only once, ever, on this
  /// device.
  Future<void> _maybeRequestPermissionAfterFirstTask(
    NotificationScheduler scheduler,
  ) async {
    final settingsRepo = _ref.read(settingsRepositoryProvider);
    final localSettings = await settingsRepo.watch().first;
    if (localSettings.notificationPermissionRequested) return;

    final hasAnyTask =
        (await _ref.read(appDatabaseProvider).taskDao.getAll()).isNotEmpty;
    if (!hasAnyTask) return;

    await scheduler.requestPermission();
    await settingsRepo.setNotificationPermissionRequested(true);
  }

  void dispose() => _debouncer.dispose();
}

/// Starts (and restarts, on user change) the notification lifecycle:
/// initialize, then an immediate reschedule, then reschedule again after
/// every sync pull (SPEC §8 "reschedule triggers"). App start/resume is
/// triggered from `app.dart`; post-write reschedules come from the
/// repositories — both go through [NotificationRescheduler].
@Riverpod(keepAlive: true)
class NotificationBootstrap extends _$NotificationBootstrap {
  DateTime? _lastSeenSyncedAt;

  @override
  Future<void> build() async {
    final authState = ref.watch(authStateChangesProvider).value;
    final user =
        authState?.session?.user ??
        ref.read(authRepositoryProvider).currentUser;
    final scheduler = ref.watch(notificationSchedulerProvider);
    final engine = ref.watch(syncEngineProvider);
    final rescheduler = ref.watch(notificationReschedulerProvider);

    if (user == null) {
      await scheduler.cancelAll();
      return;
    }

    await ref.read(userGuardProvider.future);
    await scheduler.initialize();
    rescheduler.request(debounce: false);

    void onSyncStatusChanged() {
      final syncedAt = engine.status.value.lastSyncedAt;
      if (syncedAt != _lastSeenSyncedAt) {
        _lastSeenSyncedAt = syncedAt;
        rescheduler.request(debounce: false);
      }
    }

    engine.status.addListener(onSyncStatusChanged);
    ref.onDispose(() => engine.status.removeListener(onSyncStatusChanged));
  }
}
