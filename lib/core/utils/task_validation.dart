import '../../domain/enums.dart';
import '../../domain/local_time.dart';

/// Mirrors the `tasks_time_consistency` check constraint (SPEC §4):
/// `none` has no times, `at` requires a start, `window` requires
/// `end > start`. Returns a user-facing message, or null when valid.
String? validateTaskTime(
  TimeMode mode,
  LocalTime? startTime,
  LocalTime? endTime,
) {
  switch (mode) {
    case TimeMode.none:
      return null;
    case TimeMode.at:
      if (startTime == null) return 'Pick a start time.';
      return null;
    case TimeMode.window:
      if (startTime == null) return 'Pick a start time.';
      if (endTime == null) return 'Pick an end time.';
      if (!(endTime > startTime)) return 'End time must be after start time.';
      return null;
  }
}
