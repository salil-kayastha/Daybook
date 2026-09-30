import 'package:flutter/foundation.dart';

/// A floating local time-of-day (no timezone), matching the Postgres
/// `time` columns used by `start_time`/`end_time` (SPEC §4, rule 5).
@immutable
class LocalTime implements Comparable<LocalTime> {
  const LocalTime(this.hour, this.minute)
    : assert(hour >= 0 && hour < 24, 'hour must be 0..23'),
      assert(minute >= 0 && minute < 60, 'minute must be 0..59');

  factory LocalTime.fromMinutes(int minutesSinceMidnight) {
    return LocalTime(minutesSinceMidnight ~/ 60, minutesSinceMidnight % 60);
  }

  final int hour;
  final int minute;

  int get minutesSinceMidnight => hour * 60 + minute;

  /// "09:00"
  String format24() =>
      '${hour.toString().padLeft(2, '0')}:'
      '${minute.toString().padLeft(2, '0')}';

  @override
  int compareTo(LocalTime other) =>
      minutesSinceMidnight.compareTo(other.minutesSinceMidnight);

  bool operator <(LocalTime other) => compareTo(other) < 0;
  bool operator <=(LocalTime other) => compareTo(other) <= 0;
  bool operator >(LocalTime other) => compareTo(other) > 0;
  bool operator >=(LocalTime other) => compareTo(other) >= 0;

  @override
  bool operator ==(Object other) =>
      other is LocalTime && other.hour == hour && other.minute == minute;

  @override
  int get hashCode => Object.hash(hour, minute);

  @override
  String toString() => 'LocalTime(${format24()})';
}
