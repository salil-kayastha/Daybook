import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/router.dart';
import 'core/theme/theme.dart';
import 'core/theme/theme_providers.dart';
import 'features/sync/sync_providers.dart';

class DaybookApp extends ConsumerStatefulWidget {
  const DaybookApp({super.key});

  @override
  ConsumerState<DaybookApp> createState() => _DaybookAppState();
}

class _DaybookAppState extends ConsumerState<DaybookApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// SPEC §10 "when to sync": app resume.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final engine = ref.read(syncEngineProvider);
      engine.schedulePush(immediate: true);
      engine.pull();
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

    return MaterialApp.router(
      title: 'Daybook',
      debugShowCheckedModeBanner: false,
      theme: DaybookTheme.build(brightness: Brightness.light),
      darkTheme: DaybookTheme.build(brightness: Brightness.dark),
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
