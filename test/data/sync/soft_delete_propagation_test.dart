import 'package:daybook/data/local/database.dart';
import 'package:daybook/data/sync/row_codec.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

/// SPEC §10 pull: "Include soft-deleted rows (deleted_at set) and apply
/// them locally." Simulates a pulled remote row with `deleted_at` set and
/// checks it's applied the same way a local soft delete is (CLAUDE.md rule
/// 6 — hidden by queries, row kept).
void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.connect(NativeDatabase.memory());
  });

  tearDown(() => db.close());

  test('a pulled soft-deleted task is hidden but the row is kept', () async {
    final createdAt = DateTime.utc(2026, 1, 1);
    final deletedAt = DateTime.utc(2026, 1, 3);
    final date = DateTime(2026, 1, 1);

    // First pull: the task exists, not deleted.
    await db.taskDao.upsert(
      taskFromRemoteJson({
        'id': 'task-1',
        'user_id': 'user-1',
        'category_id': null,
        'title': 'Remote task',
        'notes': null,
        'checklist': [],
        'task_date': formatLocalDate(date),
        'time_mode': 'none',
        'start_time': null,
        'end_time': null,
        'status': 'todo',
        'completed_at': null,
        'sort_order': 0.0,
        'recurrence_rule': null,
        'recurrence_parent_id': null,
        'created_at': createdAt.toIso8601String(),
        'updated_at': createdAt.toIso8601String(),
        'deleted_at': null,
      }),
    );
    expect(await db.taskDao.watchForDate(date).first, hasLength(1));

    // A later pull picks up a newer version with deleted_at set — SyncEngine
    // applies it via the same `upsert`, same as the first write.
    await db.taskDao.upsert(
      taskFromRemoteJson({
        'id': 'task-1',
        'user_id': 'user-1',
        'category_id': null,
        'title': 'Remote task',
        'notes': null,
        'checklist': [],
        'task_date': formatLocalDate(date),
        'time_mode': 'none',
        'start_time': null,
        'end_time': null,
        'status': 'todo',
        'completed_at': null,
        'sort_order': 0.0,
        'recurrence_rule': null,
        'recurrence_parent_id': null,
        'created_at': createdAt.toIso8601String(),
        'updated_at': deletedAt.toIso8601String(),
        'deleted_at': deletedAt.toIso8601String(),
      }),
    );

    expect(
      await db.taskDao.watchForDate(date).first,
      isEmpty,
      reason: 'a pulled deletion must hide the task from queries',
    );
    final rawRows = await db.select(db.tasks).get();
    expect(
      rawRows,
      hasLength(1),
      reason: 'the row itself must still exist (soft delete, not hard delete)',
    );
    // Drift round-trips the instant correctly but reconstructs it as a
    // local-zone DateTime (not UTC-flagged) — compare via `.toUtc()` rather
    // than raw `==`, which in Dart also considers the UTC/local flag.
    expect(rawRows.single.deletedAt!.toUtc(), deletedAt);
  });

  test('a pulled soft-deleted category is hidden from watchActive', () async {
    // onCreate seeds Office/Personal (M1) — clear them for a clean slate.
    await db.delete(db.categories).go();
    final now = DateTime.utc(2026, 1, 1);

    await db.categoryDao.upsert(
      categoryFromRemoteJson({
        'id': 'cat-1',
        'user_id': 'user-1',
        'name': 'Office',
        'color': '#4C6EF5',
        'icon': null,
        'sort_order': 1.0,
        'is_archived': false,
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
        'deleted_at': now.toIso8601String(),
      }),
    );

    expect(await db.categoryDao.watchActive().first, isEmpty);
    expect(await db.select(db.categories).get(), hasLength(1));
  });
}
