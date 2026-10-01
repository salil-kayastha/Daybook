import 'package:daybook/core/utils/timezone_change.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'shouldUpdateTimezone (SPEC §8 "re-detect the zone at every start")',
    () {
      test('no previous zone (first run): update', () {
        expect(
          shouldUpdateTimezone(
            previousZoneId: null,
            newZoneId: 'Asia/Kathmandu',
          ),
          isTrue,
        );
      });

      test('same zone as before: no update needed', () {
        expect(
          shouldUpdateTimezone(
            previousZoneId: 'Asia/Kathmandu',
            newZoneId: 'Asia/Kathmandu',
          ),
          isFalse,
        );
      });

      test('device travelled to a different zone: update', () {
        expect(
          shouldUpdateTimezone(
            previousZoneId: 'Asia/Kathmandu',
            newZoneId: 'America/New_York',
          ),
          isTrue,
        );
      });
    },
  );
}
