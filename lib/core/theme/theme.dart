import 'package:flutter/material.dart';

import 'colors.dart';
import 'spacing.dart';
import 'text.dart';
import 'theme_extension.dart';

export 'colors.dart';
export 'spacing.dart';
export 'text.dart';
export 'theme_extension.dart';

/// Builds a [ThemeData] for the given brightness, using the frozen palette.
abstract final class DaybookTheme {
  static ThemeData build({required Brightness brightness}) {
    final colors = brightness == Brightness.light
        ? DaybookColors.light
        : DaybookColors.dark;
    final text = DaybookText.from(colors);

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: colors.primary,
      onPrimary: colors.onPrimary,
      secondary: colors.primary,
      onSecondary: colors.onPrimary,
      error: colors.danger,
      onError: colors.onPrimary,
      surface: colors.surface,
      onSurface: colors.ink,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colors.bg,
      canvasColor: colors.bg,
      dividerColor: colors.line,
      splashFactory: InkRipple.splashFactory,
      textTheme: TextTheme(
        headlineMedium: text.displayDate,
        labelMedium: text.subDate,
        labelLarge: text.sectionTitle,
        titleMedium: text.taskTitle,
        bodySmall: text.taskMeta,
        bodyMedium: text.body,
        labelSmall: text.button,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.bg,
        foregroundColor: colors.ink,
        elevation: 0,
        titleTextStyle: text.displayDate,
      ),
      cardTheme: CardThemeData(
        color: colors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DaybookRadii.card),
          side: BorderSide(color: colors.line),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colors.surfaceAlt,
        labelStyle: text.taskMeta,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DaybookRadii.chip),
        ),
        side: BorderSide.none,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
          textStyle: text.button,
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DaybookRadii.pill),
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        shape: const StadiumBorder(),
      ),
      extensions: [DaybookThemeExtension(colors: colors, text: text)],
    );
  }
}
