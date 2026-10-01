import 'package:daybook/data/local/database.dart';
import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.connect(NativeDatabase.memory());
  });

  tearDown(() => db.close());

  test('clearAllLocalData wipes categories/tasks, reseeds defaults, and '
      'resets category-referencing settings (account switch — M4)', () async {
    // Let onCreate's seeding finish, then add an extra category + task.
    final seeded = await db.select(db.categories).get();
    expect(seeded, hasLength(2));

    final now = DateTime.now().toUtc();
    await db
        .into(db.categories)
        .insert(
          CategoriesCompanion.insert(
            id: 'extra-category',
            name: 'Extra',
            color: '#000000',
            createdAt: now,
            updatedAt: now,
          ),
        );
    await db
        .into(db.tasks)
        .insert(
          TasksCompanion.insert(
            id: 'extra-task',
            categoryId: const Value('extra-category'),
            title: 'Leftover task',
            taskDate: DateTime(2026, 1, 1),
            createdAt: now,
            updatedAt: now,
          ),
        );
    await db.settingsDao.setDefaultCategory('extra-category');
    await db.settingsDao.setSelectedFilterCategory('extra-category');

    await db.clearAllLocalData();

    final tasksAfter = await db.select(db.tasks).get();
    expect(tasksAfter, isEmpty);

    final categoriesAfter = await db.select(db.categories).get();
    expect(categoriesAfter, hasLength(2));
    expect(categoriesAfter.map((c) => c.name).toSet(), {'Office', 'Personal'});

    final settingsAfter = await db.settingsDao.watch().first;
    expect(settingsAfter.defaultCategoryId, isNull);
    expect(settingsAfter.selectedFilterCategoryId, isNull);
  });
}
