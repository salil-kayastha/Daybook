import 'package:daybook/core/theme/breakpoints.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('layoutModeForWidth (SPEC §7.6)', () {
    test('699px: phone', () {
      expect(layoutModeForWidth(699), DayLayoutMode.phone);
    });

    test('700px: two-pane (phone boundary is exclusive)', () {
      expect(layoutModeForWidth(700), DayLayoutMode.twoPane);
    });

    test('1099px: two-pane', () {
      expect(layoutModeForWidth(1099), DayLayoutMode.twoPane);
    });

    test('1100px: three-pane (wide boundary is inclusive)', () {
      expect(layoutModeForWidth(1100), DayLayoutMode.threePane);
    });

    test('well below phone max', () {
      expect(layoutModeForWidth(360), DayLayoutMode.phone);
    });

    test('well above wide min', () {
      expect(layoutModeForWidth(1920), DayLayoutMode.threePane);
    });
  });
}
