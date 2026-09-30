import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

/// Resolved text styles for one theme variant (SPEC §6.2).
///
/// Built from a [DaybookColors] instance so muted/ink colors match the
/// active light/dark palette.
@immutable
class DaybookText {
  const DaybookText({
    required this.displayDate,
    required this.subDate,
    required this.sectionTitle,
    required this.taskTitle,
    required this.taskMeta,
    required this.body,
    required this.button,
  });

  factory DaybookText.from(DaybookColors colors) {
    return DaybookText(
      displayDate: GoogleFonts.fraunces(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: colors.ink,
      ),
      subDate: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: colors.inkMuted,
      ),
      sectionTitle: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
        color: colors.ink,
      ),
      taskTitle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: colors.ink,
      ),
      taskMeta: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: colors.inkMuted,
      ),
      body: GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: colors.ink,
      ),
      button: GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: colors.ink,
      ),
    );
  }

  /// "29 September"
  final TextStyle displayDate;

  /// "Tuesday · 2026"
  final TextStyle subDate;

  /// Category headers, uppercase.
  final TextStyle sectionTitle;

  /// Task tile title text.
  final TextStyle taskTitle;

  /// Time chip, notes hint.
  final TextStyle taskMeta;

  /// Details/notes body copy.
  final TextStyle body;

  /// Button label.
  final TextStyle button;
}
