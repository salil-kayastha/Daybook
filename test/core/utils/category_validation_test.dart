import 'package:daybook/core/utils/category_validation.dart';
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
  group('validateCategoryName', () {
    test('empty name is invalid', () {
      expect(validateCategoryName('', const []), isNotNull);
      expect(validateCategoryName('   ', const []), isNotNull);
    });

    test('name at 60 chars is valid, 61 is not', () {
      final sixty = 'a' * 60;
      final sixtyOne = 'a' * 61;
      expect(validateCategoryName(sixty, const []), isNull);
      expect(validateCategoryName(sixtyOne, const []), isNotNull);
    });

    test('duplicate active name is rejected, case-insensitively', () {
      final existing = [_category(id: '1', name: 'Office')];
      expect(validateCategoryName('Office', existing), isNotNull);
      expect(validateCategoryName('office', existing), isNotNull);
      expect(validateCategoryName('OFFICE', existing), isNotNull);
      expect(validateCategoryName('  office  ', existing), isNotNull);
    });

    test('distinct name is accepted', () {
      final existing = [_category(id: '1', name: 'Office')];
      expect(validateCategoryName('Personal', existing), isNull);
    });

    test('editing a category does not collide with itself', () {
      final existing = [
        _category(id: '1', name: 'Office'),
        _category(id: '2', name: 'Personal'),
      ];
      expect(
        validateCategoryName('Office', existing, excludingId: '1'),
        isNull,
        reason: 'unchanged name during edit must not self-collide',
      );
      expect(
        validateCategoryName('Personal', existing, excludingId: '1'),
        isNotNull,
        reason: 'still collides with a different existing category',
      );
    });
  });
}
