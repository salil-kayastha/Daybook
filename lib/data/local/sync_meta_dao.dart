import 'package:drift/drift.dart';

import 'database.dart';
import 'tables.dart';

part 'sync_meta_dao.g.dart';

@DriftAccessor(tables: [SyncMeta])
class SyncMetaDao extends DatabaseAccessor<AppDatabase>
    with _$SyncMetaDaoMixin {
  SyncMetaDao(super.db);

  Future<String?> initialSyncDoneUserId() async {
    final row = await (select(
      syncMeta,
    )..where((s) => s.id.equals(0))).getSingleOrNull();
    return row?.initialSyncDoneUserId;
  }

  Future<void> markInitialSyncDone(String userId) {
    return into(syncMeta).insertOnConflictUpdate(
      SyncMetaCompanion.insert(
        id: const Value(0),
        initialSyncDoneUserId: Value(userId),
      ),
    );
  }

  Future<void> reset() => (delete(syncMeta)..where((s) => s.id.equals(0))).go();
}
