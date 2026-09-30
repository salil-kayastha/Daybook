import 'package:daybook/core/theme/theme.dart';
import 'package:daybook/domain/category.dart';
import 'package:daybook/features/task_details/task_details_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

List<Category> _categoriesWithLongName() {
  final now = DateTime(2026, 1, 1);
  final longName = '${'A' * 55} Name'; // exactly 60 chars (SPEC §4 cap)
  return [
    Category(
      id: 'long',
      name: longName,
      color: '#4C6EF5',
      sortOrder: 0,
      createdAt: now,
      updatedAt: now,
    ),
    Category(
      id: 'short',
      name: 'Office',
      color: '#12B886',
      sortOrder: 1,
      createdAt: now,
      updatedAt: now,
    ),
  ];
}

Widget _wrap(Widget child, {required Brightness brightness}) {
  return MaterialApp(
    theme: DaybookTheme.build(brightness: brightness),
    home: MediaQuery(
      data: MediaQueryData(textScaler: TextScaler.linear(1.3)),
      child: Scaffold(
        body: Padding(padding: const EdgeInsets.all(16), child: child),
      ),
    ),
  );
}

void main() {
  GoogleFonts.config.allowRuntimeFetching = false;

  for (final brightness in [Brightness.light, Brightness.dark]) {
    testWidgets(
      'CategoryDropdown with a long name and 1.3x text scale does not '
      'overflow ($brightness)',
      (tester) async {
        final categories = _categoriesWithLongName();

        await tester.pumpWidget(
          _wrap(
            CategoryDropdown(
              categories: categories,
              selectedId: categories.first.id,
              onChanged: (_) {},
            ),
            brightness: brightness,
          ),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.textContaining('AAAA'), findsOneWidget);

        // Open the dropdown menu and check the popup too.
        await tester.tap(find.byType(DropdownButtonFormField<String>));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
      },
    );
  }
}
