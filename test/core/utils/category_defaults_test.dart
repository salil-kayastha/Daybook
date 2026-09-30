import 'package:daybook/core/utils/category_defaults.dart';
import 'package:daybook/domain/category.dart';
import 'package:flutter_test/flutter_test.dart';

Category _category({required String id, required String name}) {
  final now = DateTime(2026, 1, 1);
  return Category(
    id: id,
    name: name,
    color: '#4C6EF5',
    sortOrder: 0,
    createdAt: now,
    updatedAt: now,
  );
}

void main() {
  group('resolveDefaultCategoryId', () {
    final office = _category(id: 'office', name: 'Office');
    final personal = _category(id: 'personal', name: 'Personal');
    final active = [office, personal];

    test('no preference set: falls back to the first active category', () {
      expect(resolveDefaultCategoryId(active, null), office.id);
    });

    test('preferred category is active: it wins', () {
      expect(resolveDefaultCategoryId(active, personal.id), personal.id);
    });

    test('preferred category no longer exists (archived elsewhere): '
        'falls back to the first active category', () {
      expect(
        resolveDefaultCategoryId(active, 'no-longer-active-id'),
        office.id,
      );
    });

    test('no active categories at all: null', () {
      expect(resolveDefaultCategoryId(const [], office.id), isNull);
      expect(resolveDefaultCategoryId(const [], null), isNull);
    });
  });
}
