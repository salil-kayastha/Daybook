import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/error/global_messenger.dart';
import 'core/router/router.dart';
import 'core/theme/theme.dart';
import 'core/theme/theme_providers.dart';
import 'core/utils/date_page.dart';
import 'data/notifications/notification_tap.dart';
import 'data/sync/sync_status.dart';
import 'features/notifications/notification_providers.dart';
import 'features/sync/sync_providers.dart';

class DaybookApp extends ConsumerStatefulWidget {
  const DaybookApp({super.key});

  @override
  ConsumerState<DaybookApp> createState() => _DaybookAppState();
}

class _DaybookAppState extends ConsumerState<DaybookApp>
    with WidgetsBindingObserver {
  int _lastSeenFailedCount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    pendingNotificationTap.addListener(_handlePendingNotificationTap);
    _checkColdStartLaunch();
    ref.read(syncEngineProvider).status.addListener(_handleSyncStatusTick);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    pendingNotificationTap.removeListener(_handlePendingNotificationTap);
    ref.read(syncEngineProvider).status.removeListener(_handleSyncStatusTick);
    super.dispose();
  }

  void _handleSyncStatusTick() {
    _handleSyncStatus(ref.read(syncEngineProvider).status.value);
  }

  /// SPEC §11 M8 "friendly snackbars for sync failures": fires once per
  /// *new* failure (edge-triggered on the count rising), not on every
  /// status tick, so it doesn't nag on every push attempt while offline.
  void _handleSyncStatus(SyncStatus status) {
    if (status.failedCount > _lastSeenFailedCount) {
      showFriendlyError(
        status.failedCount == 1
            ? "Couldn't sync one change. It'll keep retrying — check "
                  'Settings for details.'
            : "Couldn't sync ${status.failedCount} changes. They'll keep "
                  'retrying — check Settings for details.',
      );
    }
    _lastSeenFailedCount = status.failedCount;
  }

  /// SPEC §8: a cold start via a notification tap doesn't go through the
  /// plugin's tap callback — it has to be read once via
  /// `getNotificationAppLaunchDetails` after `initialize()` has run.
  Future<void> _checkColdStartLaunch() async {
    final details = await ref
        .read(notificationSchedulerProvider)
        .launchDetails();
    if (details?.didNotificationLaunchApp ?? false) {
      pendingNotificationTap.value = details!.notificationResponse?.payload;
    }
  }

  void _handlePendingNotificationTap() {
    final payload = pendingNotificationTap.value;
    if (payload == null) return;
    pendingNotificationTap.value = null;

    final router = ref.read(routerProvider);
    if (payload == 'evening') {
      final tomorrow = addDays(DateTime.now(), 1);
      router.go('/?date=${_formatDate(tomorrow)}&focusQuickAdd=1');
    } else {
      router.go('/');
    }
  }

  String _formatDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  /// SPEC §10/§8 "when to sync"/"reschedule triggers": app resume.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final engine = ref.read(syncEngineProvider);
      engine.schedulePush(immediate: true);
      engine.pull();
      ref.read(notificationReschedulerProvider).request(debounce: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(selectedThemeModeProvider);
    final router = ref.watch(routerProvider);

    // Keeps the sync lifecycle (initial sync / push / realtime) running
    // app-wide, independent of which route is on screen — see
    // `SyncBootstrap`'s doc comment.
    ref.watch(syncBootstrapProvider);

    // Same for notifications — see `NotificationBootstrap`'s doc comment.
    ref.watch(notificationBootstrapProvider);

    return MaterialApp.router(
      title: 'Daybook',
      scaffoldMessengerKey: globalMessengerKey,
      debugShowCheckedModeBanner: false,
      theme: DaybookTheme.build(brightness: Brightness.light),
      darkTheme: DaybookTheme.build(brightness: Brightness.dark),
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
