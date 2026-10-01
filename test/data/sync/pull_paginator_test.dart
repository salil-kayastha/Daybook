import 'package:daybook/data/sync/pull_paginator.dart';
import 'package:flutter_test/flutter_test.dart';

class _Row {
  const _Row(this.id, this.updatedAt);
  final int id;
  final DateTime updatedAt;
}

void main() {
  group('pullAllPages (SPEC §10 pagination loop)', () {
    test('loops until a page shorter than pageSize is returned', () async {
      // 3 pages of 2 (pageSize) then a final short page of 1 -> 4 fetches.
      final allRows = List.generate(
        7,
        (i) => _Row(i, DateTime.utc(2026, 1, 1).add(Duration(minutes: i))),
      );
      final fetchedCursors = <DateTime?>[];
      final applied = <_Row>[];

      await pullAllPages<_Row>(
        initialCursor: null,
        pageSize: 2,
        fetchPage: (cursor, limit) async {
          fetchedCursors.add(cursor);
          final start = cursor == null
              ? 0
              : allRows.indexWhere((r) => r.updatedAt.isAfter(cursor));
          if (start == -1) return const [];
          return allRows.skip(start).take(limit).toList();
        },
        updatedAtOf: (row) => row.updatedAt,
        applyPage: (rows) async => applied.addAll(rows),
      );

      expect(applied.map((r) => r.id).toList(), [0, 1, 2, 3, 4, 5, 6]);
      expect(fetchedCursors.length, 4); // 2,2,2,1 rows per fetch
    });

    test('empty first page: applyPage is never called', () async {
      var applyCalled = false;
      await pullAllPages<_Row>(
        initialCursor: null,
        fetchPage: (cursor, limit) async => const [],
        updatedAtOf: (row) => row.updatedAt,
        applyPage: (rows) async => applyCalled = true,
      );
      expect(applyCalled, isFalse);
    });

    test(
      'exactly one full page then nothing: stops after the short page',
      () async {
        final rows = List.generate(
          3,
          (i) => _Row(i, DateTime.utc(2026, 1, 1).add(Duration(minutes: i))),
        );
        var calls = 0;
        await pullAllPages<_Row>(
          initialCursor: null,
          pageSize: 3,
          fetchPage: (cursor, limit) async {
            calls++;
            return cursor == null ? rows : const [];
          },
          updatedAtOf: (row) => row.updatedAt,
          applyPage: (rows) async {},
        );
        // 3 rows on a page of size 3 is NOT short, so the loop fetches again
        // once more and sees an empty page before stopping.
        expect(calls, 2);
      },
    );

    test('starts from the given initial cursor', () async {
      final seen = <DateTime?>[];
      await pullAllPages<_Row>(
        initialCursor: DateTime.utc(2025, 6, 1),
        fetchPage: (cursor, limit) async {
          seen.add(cursor);
          return const [];
        },
        updatedAtOf: (row) => row.updatedAt,
        applyPage: (rows) async {},
      );
      expect(seen.single, DateTime.utc(2025, 6, 1));
    });
  });
}
