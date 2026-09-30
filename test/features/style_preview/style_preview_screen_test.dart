import 'package:daybook/core/theme/theme.dart';
import 'package:daybook/core/theme/theme_providers.dart';
import 'package:daybook/features/style_preview/style_preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

Widget _wrap(Widget child) {
  return ProviderScope(
    child: MaterialApp(
      theme: DaybookTheme.build(brightness: Brightness.light),
      darkTheme: DaybookTheme.build(brightness: Brightness.light),
      themeMode: ThemeMode.light,
      home: child,
    ),
  );
}

void main() {
  GoogleFonts.config.allowRuntimeFetching = false;

  testWidgets('renders every section and sample task tiles', (tester) async {
    await tester.pumpWidget(_wrap(const StylePreviewScreen()));

    expect(find.text('Style preview'), findsOneWidget);
    expect(find.text('Brightness'), findsOneWidget);
    expect(find.text('Typography'), findsOneWidget);
    expect(find.text('Task tiles'), findsOneWidget);

    // Sample tiles for each status/time-mode combo from SPEC §6.4.
    expect(find.text('Meeting'), findsOneWidget);
    expect(find.text('Watch handover videos'), findsOneWidget);
    expect(find.text('Buy bike parts'), findsOneWidget);
    expect(find.text('Go watch terraform videos'), findsOneWidget);
  });

  testWidgets('switching brightness updates the selectedThemeModeProvider', (
    tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: DaybookTheme.build(brightness: Brightness.light),
          darkTheme: DaybookTheme.build(brightness: Brightness.dark),
          themeMode: ThemeMode.light,
          home: const StylePreviewScreen(),
        ),
      ),
    );

    expect(container.read(selectedThemeModeProvider), ThemeMode.system);

    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();

    expect(container.read(selectedThemeModeProvider), ThemeMode.dark);
  });
}
