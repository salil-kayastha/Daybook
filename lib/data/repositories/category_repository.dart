import 'package:drift/drift.dart' show Value;
import 'package:uuid/uuid.dart';

import '../../domain/category.dart';
import '../local/category_dao.dart';
import '../local/database.dart' as db;

class CategoryRepository {
  CategoryRepository(this._dao);

  final CategoryDao _dao;
  static const _uuid = Uuid();

  Stream<List<Category>> watchActive() =>
      _dao.watchActive().map((rows) => rows.map(_toDomain).toList());

  Stream<List<Category>> watchAll() =>
      _dao.watchAll().map((rows) => rows.map(_toDomain).toList());

  Future<void> create({
    required String name,
    required String color,
    required double sortOrder,
  }) {
    final now = DateTime.now().toUtc();
    return _dao.upsert(
      db.CategoriesCompanion.insert(
        id: _uuid.v4(),
        name: name,
        color: color,
        sortOrder: Value(sortOrder),
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  Future<void> rename(Category category, String newName) {
    return _upsert(category.copyWith(name: newName));
  }

  Future<void> updateColor(Category category, String hexColor) {
    return _upsert(category.copyWith(color: hexColor));
  }

  Future<void> reorder(Category category, double newSortOrder) {
    return _upsert(category.copyWith(sortOrder: newSortOrder));
  }

  Future<void> archive(Category category) {
    return _upsert(category.copyWith(isArchived: true));
  }

  Future<void> unarchive(Category category) {
    return _upsert(category.copyWith(isArchived: false));
  }

  Future<void> _upsert(Category category) {
    final now = DateTime.now().toUtc();
    return _dao.upsert(
      db.CategoriesCompanion.insert(
        id: category.id,
        userId: Value(category.userId),
        name: category.name,
        color: category.color,
        icon: Value(category.icon),
        sortOrder: Value(category.sortOrder),
        isArchived: Value(category.isArchived),
        createdAt: category.createdAt,
        updatedAt: now,
        deletedAt: Value(category.deletedAt),
      ),
    );
  }

  Category _toDomain(db.Category row) {
    return Category(
      id: row.id,
      userId: row.userId,
      name: row.name,
      color: row.color,
      icon: row.icon,
      sortOrder: row.sortOrder,
      isArchived: row.isArchived,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      deletedAt: row.deletedAt,
    );
  }
}
