import 'package:daybook/core/theme/theme.dart';
import 'package:daybook/core/widgets/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: DaybookTheme.build(brightness: Brightness.light),
    home: Scaffold(body: child),
  );
}

void main() {
  testWidgets('shows the message and no button when there is no action', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const EmptyState(message: 'Nothing here')));

    expect(find.text('Nothing here'), findsOneWidget);
    expect(find.byType(OutlinedButton), findsNothing);
  });

  testWidgets('shows an action button that fires onAction when tapped', (
    tester,
  ) async {
    var tapped = false;
    await tester.pumpWidget(
      _wrap(
        EmptyState(
          message: 'No categories yet.',
          actionLabel: 'Manage categories',
          onAction: () => tapped = true,
        ),
      ),
    );

    expect(find.text('Manage categories'), findsOneWidget);
    await tester.tap(find.text('Manage categories'));
    expect(tapped, isTrue);
  });

  test('actionLabel and onAction must both be set or both be null', () {
    expect(
      () => EmptyState(message: 'x', actionLabel: 'Go'),
      throwsAssertionError,
    );
    expect(
      () => EmptyState(message: 'x', onAction: () {}),
      throwsAssertionError,
    );
  });
}
