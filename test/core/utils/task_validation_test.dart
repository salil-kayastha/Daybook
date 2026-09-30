import 'package:daybook/core/utils/task_validation.dart';
import 'package:daybook/domain/enums.dart';
import 'package:daybook/domain/local_time.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('validateTaskTime (tasks_time_consistency)', () {
    test('none is always valid, even with stray times', () {
      expect(validateTaskTime(TimeMode.none, null, null), isNull);
      expect(
        validateTaskTime(TimeMode.none, const LocalTime(9, 0), null),
        isNull,
      );
    });

    test('at requires a start time', () {
      expect(validateTaskTime(TimeMode.at, null, null), isNotNull);
      expect(
        validateTaskTime(TimeMode.at, const LocalTime(9, 0), null),
        isNull,
      );
    });

    test('at ignores end time', () {
      expect(
        validateTaskTime(
          TimeMode.at,
          const LocalTime(9, 0),
          const LocalTime(1, 0),
        ),
        isNull,
      );
    });

    test('window requires a start time', () {
      expect(
        validateTaskTime(TimeMode.window, null, const LocalTime(10, 0)),
        isNotNull,
      );
    });

    test('window requires an end time', () {
      expect(
        validateTaskTime(TimeMode.window, const LocalTime(9, 0), null),
        isNotNull,
      );
    });

    test('window requires end > start', () {
      expect(
        validateTaskTime(
          TimeMode.window,
          const LocalTime(9, 0),
          const LocalTime(9, 0),
        ),
        isNotNull,
        reason: 'equal start/end is invalid',
      );
      expect(
        validateTaskTime(
          TimeMode.window,
          const LocalTime(18, 0),
          const LocalTime(9, 0),
        ),
        isNotNull,
        reason: 'end before start is invalid',
      );
    });

    test('window valid when end after start', () {
      expect(
        validateTaskTime(
          TimeMode.window,
          const LocalTime(9, 0),
          const LocalTime(18, 0),
        ),
        isNull,
      );
    });
  });
}
