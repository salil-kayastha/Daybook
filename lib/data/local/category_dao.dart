import 'package:drift/drift.dart';

import 'database.dart';
import 'tables.dart';

part 'category_dao.g.dart';

@DriftAccessor(tables: [Categories])
class CategoryDao extends DatabaseAccessor<AppDatabase>
    with _$CategoryDaoMixin {
  CategoryDao(super.db);

  Stream<List<Category>> watchActive() {
    return (select(categories)
          ..where((c) => c.deletedAt.isNull() & c.isArchived.equals(false))
          ..orderBy([(c) => OrderingTerm(expression: c.sortOrder)]))
        .watch();
  }

  /// Active and archived (but not deleted) categories, for the Manage
  /// Categories screen and the archived-tasks grouping on the Day screen.
  Stream<List<Category>> watchAll() {
    return (select(categories)
          ..where((c) => c.deletedAt.isNull())
          ..orderBy([(c) => OrderingTerm(expression: c.sortOrder)]))
        .watch();
  }

  Future<void> upsert(CategoriesCompanion entry) =>
      into(categories).insertOnConflictUpdate(entry);

  Future<Category?> getById(String id) =>
      (select(categories)..where((c) => c.id.equals(id))).getSingleOrNull();

  Future<List<Category>> getAll() => select(categories).get();
}
