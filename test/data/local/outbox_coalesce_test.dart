import 'package:daybook/data/local/database.dart';
import 'package:daybook/data/local/outbox_dao.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.connect(NativeDatabase.memory());
  });

  tearDown(() => db.close());

  test('enqueue coalesces repeated writes to the same row into one entry '
      '(SPEC §10 outbox coalescing)', () async {
    await db.outboxDao.enqueue(tableName: tableNameTasks, rowId: 'task-1');
    await db.outboxDao.enqueue(tableName: tableNameTasks, rowId: 'task-1');
    await db.outboxDao.enqueue(tableName: tableNameTasks, rowId: 'task-1');

    final pending = await db.outboxDao.pendingOrderedByDependency();
    expect(pending, hasLength(1));
    expect(pending.single.rowId, 'task-1');
  });

  test('different rows get separate outbox entries', () async {
    await db.outboxDao.enqueue(tableName: tableNameTasks, rowId: 'task-1');
    await db.outboxDao.enqueue(tableName: tableNameTasks, rowId: 'task-2');

    final pending = await db.outboxDao.pendingOrderedByDependency();
    expect(pending.map((e) => e.rowId).toSet(), {'task-1', 'task-2'});
  });

  test(
    're-enqueuing a failed entry resets it back to pending with 0 attempts',
    () async {
      await db.outboxDao.enqueue(tableName: tableNameTasks, rowId: 'task-1');
      final entry = (await db.outboxDao.pendingOrderedByDependency()).single;
      await db.outboxDao.markFailed(entry.id, error: 'check constraint');
      expect(await db.outboxDao.watchFailedCount().first, 1);

      // A fresh local write on the same row re-enqueues it.
      await db.outboxDao.enqueue(tableName: tableNameTasks, rowId: 'task-1');

      expect(await db.outboxDao.watchFailedCount().first, 0);
      expect(await db.outboxDao.watchPendingCount().first, 1);
    },
  );

  test(
    'same (table, row) across two different tables stays separate',
    () async {
      await db.outboxDao.enqueue(tableName: tableNameTasks, rowId: 'same-id');
      await db.outboxDao.enqueue(
        tableName: tableNameCategories,
        rowId: 'same-id',
      );

      final pending = await db.outboxDao.pendingOrderedByDependency();
      expect(pending, hasLength(2));
    },
  );
}
