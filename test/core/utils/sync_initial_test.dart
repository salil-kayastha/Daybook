import 'package:daybook/core/utils/sync_initial.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('needsInitialSync (SPEC §10 "Initial sync" — once per user id)', () {
    test('never run on this device: needs it', () {
      expect(
        needsInitialSync(doneForUserId: null, currentUserId: 'user-1'),
        isTrue,
      );
    });

    test('already done for this exact user: does not need it again', () {
      expect(
        needsInitialSync(doneForUserId: 'user-1', currentUserId: 'user-1'),
        isFalse,
      );
    });

    test('done for a different user id: needs it (account switch)', () {
      expect(
        needsInitialSync(doneForUserId: 'user-1', currentUserId: 'user-2'),
        isTrue,
      );
    });

    test(
      'same user signs out and back in: still marked done, does not re-wipe',
      () {
        // Simulates the sign-out/sign-in cycle: `doneForUserId` persists
        // across it (only sign-out clears categories/tasks, not sync_meta
        // isn't even written there — this models "still the same id").
        const doneForUserId = 'user-1';
        expect(
          needsInitialSync(
            doneForUserId: doneForUserId,
            currentUserId: 'user-1',
          ),
          isFalse,
        );
      },
    );
  });
}
