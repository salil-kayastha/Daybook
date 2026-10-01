import 'package:daybook/core/utils/sync_initial.dart';
import 'package:daybook/data/local/database.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

/// SPEC §10 "Initial sync" combined with `SyncMetaDao`: the wipe-and-pull
/// step records itself as done, and a second check for the same user finds
/// it already done (never re-wipes).
void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.connect(NativeDatabase.memory());
  });

  tearDown(() => db.close());

  test('first check for a user id: nothing recorded yet, needs sync', () async {
    final done = await db.syncMetaDao.initialSyncDoneUserId();
    expect(
      needsInitialSync(doneForUserId: done, currentUserId: 'user-1'),
      isTrue,
    );
  });

  test('after marking done, the same user id never needs it again', () async {
    await db.syncMetaDao.markInitialSyncDone('user-1');

    final done = await db.syncMetaDao.initialSyncDoneUserId();
    expect(done, 'user-1');
    expect(
      needsInitialSync(doneForUserId: done, currentUserId: 'user-1'),
      isFalse,
    );
  });

  test(
    'a different user id signing in on this device needs it again',
    () async {
      await db.syncMetaDao.markInitialSyncDone('user-1');

      final done = await db.syncMetaDao.initialSyncDoneUserId();
      expect(
        needsInitialSync(doneForUserId: done, currentUserId: 'user-2'),
        isTrue,
      );
    },
  );

  test('marking done again for a new user overwrites the old record', () async {
    await db.syncMetaDao.markInitialSyncDone('user-1');
    await db.syncMetaDao.markInitialSyncDone('user-2');

    final done = await db.syncMetaDao.initialSyncDoneUserId();
    expect(done, 'user-2');
  });
}
