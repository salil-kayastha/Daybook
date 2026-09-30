/// Page 0 maps to this date; the Day screen's `PageView` swipes across
/// pages, which map to dates via pure functions (SPEC §7.2) so the mapping
/// stays DST-free — no `DateTime`/`Duration` arithmetic is used, only
/// proleptic-Gregorian calendar math (Howard Hinnant's `days_from_civil` /
/// `civil_from_days`).
final DateTime dayScreenEpoch = DateTime(2000, 1, 1);

final int _epochDays = _daysFromCivil(2000, 1, 1);

/// Converts a floating local date (year/month/day; time-of-day ignored) to
/// its `PageView` page index relative to [dayScreenEpoch].
int dateToPageIndex(DateTime date) {
  return _daysFromCivil(date.year, date.month, date.day) - _epochDays;
}

/// Converts a `PageView` page index back to a floating local date
/// (midnight, no timezone attached beyond `DateTime`'s local default).
DateTime pageIndexToDate(int pageIndex) {
  final (y, m, d) = _civilFromDays(_epochDays + pageIndex);
  return DateTime(y, m, d);
}

/// Days since 1970-01-01 for the proleptic Gregorian calendar date
/// (y, m, d). Pure integer arithmetic — no timezone involved.
int _daysFromCivil(int y, int m, int d) {
  final yy = y - (m <= 2 ? 1 : 0);
  final era = (yy >= 0 ? yy : yy - 399) ~/ 400;
  final yoe = yy - era * 400; // [0, 399]
  final doy = (153 * (m + (m > 2 ? -3 : 9)) + 2) ~/ 5 + d - 1; // [0, 365]
  final doe = yoe * 365 + yoe ~/ 4 - yoe ~/ 100 + doy; // [0, 146096]
  return era * 146097 + doe - 719468;
}

/// Inverse of [_daysFromCivil]: days since 1970-01-01 -> (year, month, day).
(int, int, int) _civilFromDays(int z) {
  final zz = z + 719468;
  final era = (zz >= 0 ? zz : zz - 146096) ~/ 146097;
  final doe = zz - era * 146097; // [0, 146096]
  final yoe =
      (doe - doe ~/ 1460 + doe ~/ 36524 - doe ~/ 146096) ~/ 365; // [0, 399]
  final y = yoe + era * 400;
  final doy = doe - (365 * yoe + yoe ~/ 4 - yoe ~/ 100); // [0, 365]
  final mp = (5 * doy + 2) ~/ 153; // [0, 11]
  final d = doy - (153 * mp + 2) ~/ 5 + 1; // [1, 31]
  final m = mp + (mp < 10 ? 3 : -9); // [1, 12]
  return (y + (m <= 2 ? 1 : 0), m, d);
}
