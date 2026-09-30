import 'package:daybook/core/utils/task_grouping.dart';
import 'package:daybook/domain/category.dart';
import 'package:daybook/domain/task.dart';
import 'package:flutter_test/flutter_test.dart';

Category _category({
  required String id,
  required String name,
  bool isArchived = false,
}) {
  final now = DateTime(2026, 1, 1);
  return Category(
    id: id,
    name: name,
    color: '#4C6EF5',
    sortOrder: 0,
    isArchived: isArchived,
    createdAt: now,
    updatedAt: now,
  );
}

Task _task({required String id, required String? categoryId}) {
  final now = DateTime(2026, 1, 1);
  return Task(
    id: id,
    categoryId: categoryId,
    title: id,
    taskDate: DateTime(2026, 9, 30),
    sortOrder: 0,
    createdAt: now,
    updatedAt: now,
  );
}

void main() {
  group('groupTasksForDay (archive visibility rules)', () {
    test('tasks in an active category are bucketed by categoryId', () {
      final office = _category(id: 'office', name: 'Office');
      final tasks = [
        _task(id: 't1', categoryId: 'office'),
        _task(id: 't2', categoryId: 'office'),
      ];

      final result = groupTasksForDay(tasks, [office]);

      expect(result.byActiveCategoryId['office']?.map((t) => t.id), [
        't1',
        't2',
      ]);
      expect(result.archived, isEmpty);
    });

    test('tasks in an archived category go to the archived bucket', () {
      final oldCategory = _category(id: 'old', name: 'Old', isArchived: true);
      final tasks = [_task(id: 't1', categoryId: 'old')];

      final result = groupTasksForDay(tasks, [oldCategory]);

      expect(result.byActiveCategoryId, isEmpty);
      expect(result.archived.map((t) => t.id), ['t1']);
    });

    test('mixed active and archived categories split correctly', () {
      final office = _category(id: 'office', name: 'Office');
      final oldCategory = _category(id: 'old', name: 'Old', isArchived: true);
      final tasks = [
        _task(id: 'active-task', categoryId: 'office'),
        _task(id: 'archived-task', categoryId: 'old'),
      ];

      final result = groupTasksForDay(tasks, [office, oldCategory]);

      expect(result.byActiveCategoryId['office']?.map((t) => t.id), [
        'active-task',
      ]);
      expect(result.archived.map((t) => t.id), ['archived-task']);
    });

    test('archiving a category moves its tasks from active to archived', () {
      final tasks = [_task(id: 't1', categoryId: 'office')];
      final whileActive = _category(id: 'office', name: 'Office');
      final afterArchiving = _category(
        id: 'office',
        name: 'Office',
        isArchived: true,
      );

      final before = groupTasksForDay(tasks, [whileActive]);
      expect(before.byActiveCategoryId['office'], hasLength(1));
      expect(before.archived, isEmpty);

      final after = groupTasksForDay(tasks, [afterArchiving]);
      expect(after.byActiveCategoryId, isEmpty);
      expect(after.archived, hasLength(1));
    });

    test('task with no category is dropped from both buckets', () {
      final office = _category(id: 'office', name: 'Office');
      final tasks = [_task(id: 't1', categoryId: null)];

      final result = groupTasksForDay(tasks, [office]);

      expect(result.byActiveCategoryId, isEmpty);
      expect(result.archived, isEmpty);
    });

    test('empty task list produces empty buckets', () {
      final office = _category(id: 'office', name: 'Office');
      final result = groupTasksForDay(const [], [office]);
      expect(result.byActiveCategoryId, isEmpty);
      expect(result.archived, isEmpty);
    });
  });
}
