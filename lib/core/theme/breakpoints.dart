/// Responsive breakpoints (SPEC §7.6, M7). Phone stays the SPEC §7.2 single-
/// pane swipe layout below [phoneMax]; two-pane (rail + day) from
/// [phoneMax] up to (not including) [wideMin]; three-pane (rail + day +
/// details) at [wideMin] and above.
abstract final class DaybookBreakpoints {
  static const double phoneMax = 700;
  static const double wideMin = 1100;

  /// Day view's own max width once docked between the rail and the
  /// details panel in three-pane layout (SPEC §7.6).
  static const double dayViewMaxWidth = 720;

  /// Width of the left rail (mini calendar + category filters).
  static const double railWidth = 240;

  /// Width of the details panel/side-sheet in two- and three-pane layouts.
  static const double detailsWidth = 400;
}

enum DayLayoutMode { phone, twoPane, threePane }

/// Pure breakpoint decision (SPEC §7.6) — unit-tested at the boundary
/// widths (699/700/1099/1100) so the cutoffs never silently drift.
DayLayoutMode layoutModeForWidth(double width) {
  if (width < DaybookBreakpoints.phoneMax) return DayLayoutMode.phone;
  if (width < DaybookBreakpoints.wideMin) return DayLayoutMode.twoPane;
  return DayLayoutMode.threePane;
}
