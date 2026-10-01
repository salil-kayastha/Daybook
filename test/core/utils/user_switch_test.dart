import 'package:daybook/core/utils/user_switch.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('shouldClearLocalData', () {
    test('first ever sign-in on this device: no stored id -> do not clear', () {
      expect(
        shouldClearLocalData(storedUserId: null, newUserId: 'user-1'),
        isFalse,
      );
    });

    test('same user signing in again (e.g. token refresh) -> do not clear', () {
      expect(
        shouldClearLocalData(storedUserId: 'user-1', newUserId: 'user-1'),
        isFalse,
      );
    });

    test('a different user signs in on this device -> clear', () {
      expect(
        shouldClearLocalData(storedUserId: 'user-1', newUserId: 'user-2'),
        isTrue,
      );
    });
  });
}
