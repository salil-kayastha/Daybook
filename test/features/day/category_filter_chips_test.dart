import 'package:daybook/core/theme/theme.dart';
import 'package:daybook/domain/category.dart';
import 'package:daybook/features/day/category_filter_chips.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Category _cat(String id, String name) {
  final now = DateTime.utc(2026, 1, 1);
  return Category(
    id: id,
    name: name,
    color: '#4C6EF5',
    sortOrder: 0,
    createdAt: now,
    updatedAt: now,
  );
}

Widget _wrap(Widget child) {
  return ProviderScope(
    child: MaterialApp(
      theme: DaybookTheme.build(brightness: Brightness.light),
      home: Scaffold(body: child),
    ),
  );
}

void main() {
  testWidgets('All + each category chip exposes a selected semantics state', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();

    await tester.pumpWidget(
      _wrap(
        CategoryFilterChips(
          categories: [_cat('office', 'Office'), _cat('personal', 'Personal')],
          selectedCategoryId: 'office',
        ),
      ),
    );

    final all = tester.getSemantics(find.bySemanticsLabel('All categories'));
    // ignore: deprecated_member_use
    expect(all.hasFlag(SemanticsFlag.isSelected), isFalse);

    final office = tester.getSemantics(
      find.bySemanticsLabel('Office category'),
    );
    // ignore: deprecated_member_use
    expect(office.hasFlag(SemanticsFlag.isSelected), isTrue);

    final personal = tester.getSemantics(
      find.bySemanticsLabel('Personal category'),
    );
    // ignore: deprecated_member_use
    expect(personal.hasFlag(SemanticsFlag.isSelected), isFalse);
    handle.dispose();
  });

  testWidgets('each chip meets the 48dp minimum tap target', (tester) async {
    final handle = tester.ensureSemantics();

    await tester.pumpWidget(
      _wrap(
        CategoryFilterChips(
          categories: [_cat('office', 'Office')],
          selectedCategoryId: null,
        ),
      ),
    );

    final size = tester.getSize(find.bySemanticsLabel('Office category'));
    expect(size.height, greaterThanOrEqualTo(48));
    handle.dispose();
  });
}
