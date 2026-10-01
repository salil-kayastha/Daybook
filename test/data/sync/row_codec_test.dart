import 'dart:convert';

import 'package:daybook/data/local/database.dart';
import 'package:daybook/data/sync/row_codec.dart';
import 'package:daybook/domain/enums.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('formatLocalDate / parseLocalDate (floating local date)', () {
    test('formats as yyyy-MM-dd with zero-padding', () {
      expect(formatLocalDate(DateTime(2026, 1, 5)), '2026-01-05');
    });

    test('round-trips', () {
      final date = DateTime(2026, 12, 31);
      expect(parseLocalDate(formatLocalDate(date)), date);
    });
  });

  group('taskFromRemoteJson (floating local times, CLAUDE.md rule 5)', () {
    test(
      'keeps start/end time as the raw HH:mm:ss string (no UTC conversion)',
      () {
        final companion = taskFromRemoteJson({
          'id': 'task-1',
          'user_id': 'user-1',
          'category_id': null,
          'title': 'Meeting',
          'notes': null,
          'checklist': [],
          'task_date': '2026-01-05',
          'time_mode': 'at',
          'start_time': '09:00:00',
          'end_time': null,
          'status': 'todo',
          'completed_at': null,
          'sort_order': 0.0,
          'recurrence_rule': null,
          'recurrence_parent_id': null,
          'created_at': '2026-01-01T00:00:00Z',
          'updated_at': '2026-01-01T00:00:00Z',
          'deleted_at': null,
        });
        expect(companion.startTime.value, '09:00:00');
        expect(companion.taskDate.value, DateTime(2026, 1, 5));
      },
    );

    test('tolerates a category_id that has not arrived locally yet', () {
      final companion = taskFromRemoteJson({
        'id': 'task-1',
        'user_id': 'user-1',
        'category_id': 'not-yet-pulled-category',
        'title': 'Orphaned task',
        'notes': null,
        'checklist': [],
        'task_date': '2026-01-05',
        'time_mode': 'none',
        'start_time': null,
        'end_time': null,
        'status': 'todo',
        'completed_at': null,
        'sort_order': 0.0,
        'recurrence_rule': null,
        'recurrence_parent_id': null,
        'created_at': '2026-01-01T00:00:00Z',
        'updated_at': '2026-01-01T00:00:00Z',
        'deleted_at': null,
      });
      // Doesn't throw, and just stores the FK value as-is (nullable locally).
      expect(companion.categoryId.value, 'not-yet-pulled-category');
    });
  });

  group('taskToRemoteJson', () {
    test('serializes task_date as yyyy-MM-dd and the local "HH:mm" time as '
        '"HH:mm:ss" — never UTC-converted (CLAUDE.md rule 5)', () {
      final row = Task(
        id: 'task-1',
        title: 'Meeting',
        checklist: jsonEncode([
          {'id': 'c1', 'text': 'Prep slides', 'done': false},
        ]),
        taskDate: DateTime(2026, 3, 7),
        timeMode: TimeMode.at,
        startTime: '09:00',
        status: TaskStatus.todo,
        sortOrder: 0,
        createdAt: DateTime.utc(2026, 1, 1),
        updatedAt: DateTime.utc(2026, 1, 1),
        syncState: SyncState.pending,
        localChangedAt: DateTime.utc(2026, 1, 1),
      );

      final json = taskToRemoteJson(row, userId: 'user-1');

      expect(json['task_date'], '2026-03-07');
      expect(json['start_time'], '09:00:00');
      expect(json['end_time'], isNull);
      expect(json['user_id'], 'user-1');
      expect(json['checklist'], [
        {'id': 'c1', 'text': 'Prep slides', 'done': false},
      ]);
    });
  });
}
