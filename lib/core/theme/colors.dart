import 'package:flutter/material.dart';

/// A full set of semantic color tokens for one theme variant (light or dark).
///
/// Frozen after the M0 style review — do not add new palettes or tweak
/// these values without a new design review. No widget may hardcode a
/// color; pull tokens from [DaybookColors] via `context.daybookColors`.
@immutable
class DaybookColors {
  const DaybookColors({
    required this.bg,
    required this.surface,
    required this.surfaceAlt,
    required this.ink,
    required this.inkMuted,
    required this.line,
    required this.primary,
    required this.onPrimary,
    required this.success,
    required this.warning,
    required this.danger,
  });

  final Color bg;
  final Color surface;
  final Color surfaceAlt;
  final Color ink;
  final Color inkMuted;
  final Color line;
  final Color primary;
  final Color onPrimary;
  final Color success;
  final Color warning;
  final Color danger;

  // ---- Frozen palette (SPEC §6.1) ----
  static const DaybookColors light = DaybookColors(
    bg: Color(0xFFFAF8F5),
    surface: Color(0xFFFFFFFF),
    surfaceAlt: Color(0xFFF1EEE8),
    ink: Color(0xFF1F2328),
    inkMuted: Color(0xFF6B7280),
    line: Color(0xFFE4E0D8),
    primary: Color(0xFF3B5BDB),
    onPrimary: Color(0xFFFFFFFF),
    success: Color(0xFF2F9E44),
    warning: Color(0xFFF08C00),
    danger: Color(0xFFE03131),
  );

  static const DaybookColors dark = DaybookColors(
    bg: Color(0xFF121316),
    surface: Color(0xFF1C1E22),
    surfaceAlt: Color(0xFF26292E),
    ink: Color(0xFFECEDEF),
    inkMuted: Color(0xFF9AA1AB),
    line: Color(0xFF2E3238),
    primary: Color(0xFF748FFC),
    onPrimary: Color(0xFF0E1116),
    success: Color(0xFF51CF66),
    warning: Color(0xFFFFA94D),
    danger: Color(0xFFFF6B6B),
  );

  /// User-selectable category colors (SPEC §6.1).
  static const List<Color> categoryPalette = [
    Color(0xFF4C6EF5), // indigo
    Color(0xFF12B886), // teal
    Color(0xFFF76707), // orange
    Color(0xFFE64980), // pink
    Color(0xFF7950F2), // violet
    Color(0xFF15AABF), // cyan
    Color(0xFF82C91E), // lime
    Color(0xFFFAB005), // amber
    Color(0xFF868E96), // gray
    Color(0xFFD6336C), // raspberry
  ];
}
