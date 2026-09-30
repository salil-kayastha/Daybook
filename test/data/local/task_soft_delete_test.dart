import 'package:daybook/data/local/database.dart';
import 'package:drift/drift.dart' hide isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.connect(NativeDatabase.memory());
  });

  tearDown(() => db.close());

  test('soft delete (deleted_at set) hides a task from queries but keeps '
      'the row (CLAUDE.md rule 6)', () async {
    final now = DateTime.now().toUtc();
    const categoryId = 'cat-1';
    const taskId = 'task-1';
    final date = DateTime(2026, 9, 30);

    await db
        .into(db.categories)
        .insert(
          CategoriesCompanion.insert(
            id: categoryId,
            name: 'Office',
            color: '#4C6EF5',
            createdAt: now,
            updatedAt: now,
          ),
        );

    await db
        .into(db.tasks)
        .insert(
          TasksCompanion.insert(
            id: taskId,
            categoryId: const Value(categoryId),
            title: 'Test task',
            taskDate: date,
            createdAt: now,
            updatedAt: now,
          ),
        );

    expect(await db.taskDao.watchForDate(date).first, hasLength(1));

    await db
        .into(db.tasks)
        .insertOnConflictUpdate(
          TasksCompanion.insert(
            id: taskId,
            categoryId: const Value(categoryId),
            title: 'Test task',
            taskDate: date,
            createdAt: now,
            updatedAt: now,
            deletedAt: Value(now),
          ),
        );

    expect(
      await db.taskDao.watchForDate(date).first,
      isEmpty,
      reason: 'soft-deleted task must not appear in the query',
    );

    final rawRows = await db.select(db.tasks).get();
    expect(
      rawRows,
      hasLength(1),
      reason: 'the row itself must still exist (soft delete, not hard delete)',
    );
    expect(rawRows.single.deletedAt, isNotNull);
  });

  test(
    'soft delete also hides the date from watchDatesWithTasksInRange',
    () async {
      final now = DateTime.now().toUtc();
      const categoryId = 'cat-1';
      const taskId = 'task-1';
      final date = DateTime(2026, 9, 30);

      await db
          .into(db.categories)
          .insert(
            CategoriesCompanion.insert(
              id: categoryId,
              name: 'Office',
              color: '#4C6EF5',
              createdAt: now,
              updatedAt: now,
            ),
          );
      await db
          .into(db.tasks)
          .insert(
            TasksCompanion.insert(
              id: taskId,
              categoryId: const Value(categoryId),
              title: 'Test task',
              taskDate: date,
              createdAt: now,
              updatedAt: now,
              deletedAt: Value(now),
            ),
          );

      final dates = await db.taskDao
          .watchDatesWithTasksInRange(
            DateTime(2026, 9, 1),
            DateTime(2026, 10, 1),
          )
          .first;

      expect(dates, isEmpty);
    },
  );
}
