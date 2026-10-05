import 'package:daybook/core/theme/theme.dart';
import 'package:daybook/core/widgets/task_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child, {double textScale = 1.0, double width = 360}) {
  return MaterialApp(
    theme: DaybookTheme.build(brightness: Brightness.light),
    home: MediaQuery(
      data: MediaQueryData(
        size: Size(width, 800),
        textScaler: TextScaler.linear(textScale),
      ),
      child: Scaffold(
        body: SizedBox(width: width, child: child),
      ),
    ),
  );
}

void main() {
  testWidgets(
    'combined semantics label includes title, category, time and status',
    (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        _wrap(
          const TaskTile(
            title: 'Write report',
            categoryColor: Colors.blue,
            categoryLabel: 'Office',
            status: TaskTileStatus.todo,
            timeMode: TaskTileTimeMode.at,
            timeLabel: '2:00 PM',
          ),
        ),
      );

      expect(
        find.bySemanticsLabel(
          'Write report, Office category, at 2:00 PM, not done',
        ),
        findsOneWidget,
      );
      handle.dispose();
    },
  );

  testWidgets('done status is reflected in the combined label', (tester) async {
    final handle = tester.ensureSemantics();

    await tester.pumpWidget(
      _wrap(
        const TaskTile(
          title: 'Write report',
          categoryColor: Colors.blue,
          status: TaskTileStatus.done,
        ),
      ),
    );

    expect(
      find.bySemanticsLabel('Write report, no time, done'),
      findsOneWidget,
    );
    handle.dispose();
  });

  testWidgets('checkbox has an explicit Mark done / Mark not done label', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();

    var toggled = false;
    await tester.pumpWidget(
      _wrap(
        TaskTile(
          title: 'Write report',
          categoryColor: Colors.blue,
          status: TaskTileStatus.todo,
          onToggle: () => toggled = true,
        ),
      ),
    );

    expect(find.bySemanticsLabel('Mark done'), findsOneWidget);
    await tester.tap(find.bySemanticsLabel('Mark done'));
    expect(toggled, isTrue);
    handle.dispose();
  });

  testWidgets('checkbox hit area is at least 48dp (SPEC §11 M8)', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();

    await tester.pumpWidget(
      _wrap(
        TaskTile(
          title: 'Write report',
          categoryColor: Colors.blue,
          status: TaskTileStatus.todo,
          onToggle: () {},
        ),
      ),
    );

    final size = tester.getSize(find.bySemanticsLabel('Mark done'));
    expect(size.width, greaterThanOrEqualTo(48));
    expect(size.height, greaterThanOrEqualTo(48));
    handle.dispose();
  });

  testWidgets('renders at 1.3x text scale on a 360px phone without overflow', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const TaskTile(
          title: 'A fairly long task title that could wrap awkwardly',
          categoryColor: Colors.blue,
          categoryLabel: 'Office',
          status: TaskTileStatus.todo,
          timeMode: TaskTileTimeMode.window,
          timeLabel: '9:00 AM – 6:00 PM',
        ),
        textScale: 1.3,
      ),
    );

    expect(tester.takeException(), isNull);
  });
}
