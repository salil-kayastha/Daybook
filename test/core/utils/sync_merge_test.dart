import 'package:daybook/core/utils/sync_merge.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('localWinsMerge (SPEC §10 last-write-wins)', () {
    test('local newer and pending: local wins', () {
      final result = localWinsMerge(
        isPending: true,
        localChangedAt: DateTime.utc(2026, 1, 2),
        remoteUpdatedAt: DateTime.utc(2026, 1, 1),
      );
      expect(result, isTrue);
    });

    test('remote newer and local pending: remote wins', () {
      final result = localWinsMerge(
        isPending: true,
        localChangedAt: DateTime.utc(2026, 1, 1),
        remoteUpdatedAt: DateTime.utc(2026, 1, 2),
      );
      expect(result, isFalse);
    });

    test('local not pending (already synced): remote always wins', () {
      final result = localWinsMerge(
        isPending: false,
        localChangedAt: DateTime.utc(2026, 1, 5),
        remoteUpdatedAt: DateTime.utc(2026, 1, 1),
      );
      expect(result, isFalse);
    });

    test('equal timestamps, pending: remote wins (not strictly after)', () {
      final same = DateTime.utc(2026, 1, 1);
      final result = localWinsMerge(
        isPending: true,
        localChangedAt: same,
        remoteUpdatedAt: same,
      );
      expect(result, isFalse);
    });

    test('remote row carries a deletion (deleted_at set) and local is not '
        'pending: remote (the deletion) applies', () {
      // The deletion itself is just a normal field on the remote row by
      // the time it reaches localWinsMerge — this asserts the merge rule
      // doesn't special-case it away from a synced local row.
      final result = localWinsMerge(
        isPending: false,
        localChangedAt: DateTime.utc(2026, 1, 1),
        remoteUpdatedAt: DateTime.utc(2026, 1, 2),
      );
      expect(result, isFalse);
    });

    test('local has a pending delete newer than a remote update: local delete wins', () {
      final result = localWinsMerge(
        isPending: true,
        localChangedAt: DateTime.utc(2026, 1, 3),
        remoteUpdatedAt: DateTime.utc(2026, 1, 2),
      );
      expect(result, isTrue);
    });
  });
}
