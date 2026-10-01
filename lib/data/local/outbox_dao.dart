import 'package:drift/drift.dart';

import 'database.dart';
import 'tables.dart';

part 'outbox_dao.g.dart';

const tableNameCategories = 'categories';
const tableNameTasks = 'tasks';
const tableNameUserSettings = 'user_settings';

@DriftAccessor(tables: [OutboxEntries])
class OutboxDao extends DatabaseAccessor<AppDatabase> with _$OutboxDaoMixin {
  OutboxDao(super.db);

  /// Enqueues a push for (tableName, rowId), coalescing with any existing
  /// pending/failed entry for the same row (SPEC §10 "coalesce multiple
  /// pending ops for the same row into one") — the entry just references
  /// the row id, so re-reading the row at push time naturally picks up
  /// whatever the latest write left behind.
  Future<void> enqueue({
    required String tableName,
    required String rowId,
  }) async {
    final existing =
        await (select(outboxEntries)..where(
              (o) => o.targetTable.equals(tableName) & o.rowId.equals(rowId),
            ))
            .getSingleOrNull();
    if (existing != null) {
      await (update(
        outboxEntries,
      )..where((o) => o.id.equals(existing.id))).write(
        OutboxEntriesCompanion(
          createdAt: Value(DateTime.now().toUtc()),
          attempts: const Value(0),
          status: const Value('pending'),
          lastError: const Value(null),
        ),
      );
      return;
    }
    await into(outboxEntries).insert(
      OutboxEntriesCompanion.insert(
        targetTable: tableName,
        rowId: rowId,
        createdAt: DateTime.now().toUtc(),
      ),
    );
  }

  /// All pending entries, categories before tasks before user_settings
  /// (SPEC §10 push dependency order) — see `sortByPushOrder` below.
  Future<List<OutboxEntry>> pendingOrderedByDependency() async {
    final rows = await (select(
      outboxEntries,
    )..where((o) => o.status.equals('pending'))).get();
    return sortByPushOrder(rows, (r) => r.targetTable);
  }

  Future<void> remove(int id) =>
      (delete(outboxEntries)..where((o) => o.id.equals(id))).go();

  Future<void> removeForRow({
    required String tableName,
    required String rowId,
  }) =>
      (delete(outboxEntries)..where(
            (o) => o.targetTable.equals(tableName) & o.rowId.equals(rowId),
          ))
          .go();

  Future<void> markRetrying(int id, {required String error}) async {
    await (update(outboxEntries)..where((o) => o.id.equals(id))).write(
      OutboxEntriesCompanion(
        attempts: Value((await _attempts(id)) + 1),
        lastError: Value(error),
      ),
    );
  }

  Future<void> markFailed(int id, {required String error}) async {
    await (update(outboxEntries)..where((o) => o.id.equals(id))).write(
      OutboxEntriesCompanion(
        status: const Value('failed'),
        lastError: Value(error),
      ),
    );
  }

  Future<int> _attempts(int id) async {
    final row = await (select(
      outboxEntries,
    )..where((o) => o.id.equals(id))).getSingle();
    return row.attempts;
  }

  Stream<int> watchPendingCount() {
    final query = selectOnly(outboxEntries)
      ..addColumns([outboxEntries.id.count()])
      ..where(outboxEntries.status.equals('pending'));
    return query.watchSingle().map(
      (row) => row.read(outboxEntries.id.count()) ?? 0,
    );
  }

  /// Highest `attempts` among currently-pending entries, for the push
  /// retry backoff calculation (SPEC §10: 2s → 5min cap).
  Future<int> maxPendingAttempts() async {
    final rows = await (select(
      outboxEntries,
    )..where((o) => o.status.equals('pending'))).get();
    if (rows.isEmpty) return 0;
    return rows.map((r) => r.attempts).reduce((a, b) => a > b ? a : b);
  }

  Stream<int> watchFailedCount() {
    final query = selectOnly(outboxEntries)
      ..addColumns([outboxEntries.id.count()])
      ..where(outboxEntries.status.equals('failed'));
    return query.watchSingle().map(
      (row) => row.read(outboxEntries.id.count()) ?? 0,
    );
  }
}

/// Push dependency order (SPEC §10 M5): categories must land before tasks
/// that reference them, and both before user_settings (which references a
/// category id too). Pure/sortable so it's unit-testable without a DB.
int syncTablePriority(String tableName) {
  switch (tableName) {
    case tableNameCategories:
      return 0;
    case tableNameTasks:
      return 1;
    case tableNameUserSettings:
      return 2;
    default:
      return 3;
  }
}

List<T> sortByPushOrder<T>(List<T> rows, String Function(T) tableNameOf) {
  final sorted = [...rows];
  sorted.sort(
    (a, b) =>
        syncTablePriority(tableNameOf(a))
            .compareTo(syncTablePriority(tableNameOf(b))),
  );
  return sorted;
}
