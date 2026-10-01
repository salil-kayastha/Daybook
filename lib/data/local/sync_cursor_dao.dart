import 'package:drift/drift.dart';

import 'database.dart';
import 'tables.dart';

part 'sync_cursor_dao.g.dart';

@DriftAccessor(tables: [SyncCursors])
class SyncCursorDao extends DatabaseAccessor<AppDatabase>
    with _$SyncCursorDaoMixin {
  SyncCursorDao(super.db);

  Future<DateTime?> get(String tableName) async {
    final row = await (select(
      syncCursors,
    )..where((c) => c.targetTable.equals(tableName))).getSingleOrNull();
    return row?.lastPulledAt;
  }

  Future<void> set(String tableName, DateTime lastPulledAt) {
    return into(syncCursors).insertOnConflictUpdate(
      SyncCursorsCompanion.insert(
        targetTable: tableName,
        lastPulledAt: Value(lastPulledAt),
      ),
    );
  }

  /// The most recent cursor across all tables, for the Settings "last
  /// synced" display.
  Future<DateTime?> latest() async {
    final rows = await select(syncCursors).get();
    final values = rows
        .map((r) => r.lastPulledAt)
        .whereType<DateTime>()
        .toList();
    if (values.isEmpty) return null;
    return values.reduce((a, b) => a.isAfter(b) ? a : b);
  }

  Future<void> reset() => delete(syncCursors).go();
}
