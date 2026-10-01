import 'package:daybook/data/local/outbox_dao.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('sortByPushOrder (SPEC §10 push dependency order)', () {
    test('categories before tasks before user_settings', () {
      final input = [
        tableNameUserSettings,
        tableNameTasks,
        tableNameCategories,
      ];
      final sorted = sortByPushOrder(input, (s) => s);
      expect(sorted, [
        tableNameCategories,
        tableNameTasks,
        tableNameUserSettings,
      ]);
    });

    test('stable-ish for an already-mixed list of many rows', () {
      final input = [
        tableNameTasks,
        tableNameCategories,
        tableNameTasks,
        tableNameUserSettings,
        tableNameCategories,
      ];
      final sorted = sortByPushOrder(input, (s) => s);
      final priorities = sorted.map(syncTablePriority).toList();
      expect(priorities, [0, 0, 1, 1, 2]);
    });

    test('syncTablePriority: categories < tasks < user_settings', () {
      expect(
        syncTablePriority(tableNameCategories),
        lessThan(syncTablePriority(tableNameTasks)),
      );
      expect(
        syncTablePriority(tableNameTasks),
        lessThan(syncTablePriority(tableNameUserSettings)),
      );
    });
  });
}
