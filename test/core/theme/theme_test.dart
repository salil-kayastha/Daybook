import 'package:daybook/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  group('DaybookTheme.build', () {
    test('light uses the frozen SPEC §6.1 light tokens', () {
      final theme = DaybookTheme.build(brightness: Brightness.light);
      final tokens = theme.extension<DaybookThemeExtension>()!;

      expect(tokens.colors.bg, DaybookColors.light.bg);
      expect(tokens.colors.primary, DaybookColors.light.primary);
      expect(theme.brightness, Brightness.light);
      expect(theme.scaffoldBackgroundColor, DaybookColors.light.bg);
    });

    test('dark uses the frozen SPEC §6.1 dark tokens', () {
      final theme = DaybookTheme.build(brightness: Brightness.dark);
      final tokens = theme.extension<DaybookThemeExtension>()!;

      expect(tokens.colors.bg, DaybookColors.dark.bg);
      expect(theme.brightness, Brightness.dark);
    });

    test('category palette has 10 user-selectable colors', () {
      expect(DaybookColors.categoryPalette.length, 10);
      expect(DaybookColors.categoryPalette.toSet().length, 10);
    });
  });
}
