/// Spacing scale in dp (SPEC §6.3).
abstract final class DaybookSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;

  /// Screen horizontal padding.
  static const double screenPaddingPhone = 16;
  static const double screenPaddingWeb = 24;
}

/// Corner radii in dp (SPEC §6.3).
abstract final class DaybookRadii {
  static const double chip = 8;
  static const double card = 12;
  static const double sheet = 20;
  static const double pill = 999;
}
