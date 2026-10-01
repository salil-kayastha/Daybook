import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/router.dart';
import 'core/theme/theme.dart';
import 'core/theme/theme_providers.dart';

class DaybookApp extends ConsumerWidget {
  const DaybookApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(selectedThemeModeProvider);
    final router = ref.watch(routerProvider);

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
