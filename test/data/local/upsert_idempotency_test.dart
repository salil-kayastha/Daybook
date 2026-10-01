import 'package:daybook/data/local/database.dart';
import 'package:drift/drift.dart' hide isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

/// Retrying a push must never create duplicates (SPEC §10) — client-
/// generated UUIDs + `upsert(onConflict: id)` on the Supabase side. This
/// exercises the same idempotency property against the local Drift upsert
/// (`insertOnConflictUpdate`) that `TaskDao`/`CategoryDao` use, and that
/// `SyncEngine` relies on when applying a pulled/pushed row twice (e.g. a
/// retried push after a dropped response, or the same realtime event
/// firing a pull twice).
void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.connect(NativeDatabase.memory());
  });

  tearDown(() => db.close());

  test('upserting the same task id twice results in exactly one row', () async {
    final now = DateTime.now().toUtc();
    final companion = TasksCompanion.insert(
      id: 'task-1',
      title: 'First write',
      taskDate: DateTime(2026, 1, 1),
      createdAt: now,
      updatedAt: now,
    );

    await db.taskDao.upsert(companion);
    await db.taskDao.upsert(
      companion.copyWith(title: const Value('Retried write, same id')),
    );
    await db.taskDao.upsert(
      companion.copyWith(title: const Value('Retried again, same id')),
    );

    final rows = await db.select(db.tasks).get();
    expect(rows, hasLength(1));
    expect(rows.single.title, 'Retried again, same id');
  });

  test(
    'upserting the same category id twice results in exactly one row',
    () async {
      // onCreate seeds Office/Personal (M1) — clear them for a clean count.
      await db.delete(db.categories).go();

      final now = DateTime.now().toUtc();
      final companion = CategoriesCompanion.insert(
        id: 'cat-1',
        name: 'Office',
        color: '#4C6EF5',
        createdAt: now,
        updatedAt: now,
      );

      await db.categoryDao.upsert(companion);
      await db.categoryDao.upsert(companion);
      await db.categoryDao.upsert(companion);

      final rows = await db.select(db.categories).get();
      expect(rows, hasLength(1));
    },
  );
}
