import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../domain/enums.dart';
import 'category_dao.dart';
import 'outbox_dao.dart';
import 'settings_dao.dart';
import 'sync_cursor_dao.dart';
import 'sync_meta_dao.dart';
import 'task_dao.dart';
import 'tables.dart';
import 'user_settings_dao.dart';

part 'database.g.dart';

/// Local-only source of truth (offline-first, CLAUDE.md rule 1). The sync
/// engine (M5) is the only other thing allowed to touch Supabase directly.
@DriftDatabase(
  tables: [
    Categories,
    Tasks,
    LocalSettings,
    UserSettingsTable,
    OutboxEntries,
    SyncCursors,
    SyncMeta,
  ],
  daos: [
    CategoryDao,
    TaskDao,
    SettingsDao,
    UserSettingsDao,
    OutboxDao,
    SyncCursorDao,
    SyncMetaDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase()
    : super(
        driftDatabase(
          name: 'daybook',
          web: DriftWebOptions(
            sqlite3Wasm: Uri.parse('sqlite3.wasm'),
            driftWorker: Uri.parse('drift_worker.js'),
          ),
        ),
      );

  /// For widget/unit tests: pass an in-memory `NativeDatabase` executor.
  AppDatabase.connect(super.connection);

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _seedDefaultCategories();
      await _seedSettingsRow();
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        // createTable uses the current (code-defined) schema, so the new
        // table already has every column added since — including
        // lastSignedInUserId. Don't also run the `from < 3` addColumn step.
        await m.createTable(localSettings);
        await _seedSettingsRow();
      } else if (from < 3) {
        await m.addColumn(localSettings, localSettings.lastSignedInUserId);
      }
      if (from < 4) {
        await m.addColumn(categories, categories.syncState);
        await m.addColumn(categories, categories.localChangedAt);
        await m.addColumn(tasks, tasks.syncState);
        await m.addColumn(tasks, tasks.localChangedAt);
        await m.createTable(userSettingsTable);
        await m.createTable(outboxEntries);
        await m.createTable(syncCursors);
        await m.createTable(syncMeta);
        await _enqueueExistingRowsForPush();
      }
    },
  );

  Future<void> _seedSettingsRow() async {
    await into(localSettings)
        .insertOnConflictUpdate(const LocalSettingsCompanion(id: Value(0)));
  }

  Future<void> _seedDefaultCategories() async {
    const uuid = Uuid();
    final now = DateTime.now().toUtc();
    await batch((b) {
      b.insertAll(categories, [
        CategoriesCompanion.insert(
          id: uuid.v4(),
          name: 'Office',
          color: '#4C6EF5',
          sortOrder: const Value(1),
          createdAt: now,
          updatedAt: now,
          syncState: const Value(SyncState.pending),
          localChangedAt: Value(now),
        ),
        CategoriesCompanion.insert(
          id: uuid.v4(),
          name: 'Personal',
          color: '#12B886',
          sortOrder: const Value(2),
          createdAt: now,
          updatedAt: now,
          syncState: const Value(SyncState.pending),
          localChangedAt: Value(now),
        ),
      ]);
    });
  }

  /// M5 upgrade only: rows created before sync existed predate the outbox,
  /// so without this they'd sit `syncState = pending` forever without ever
  /// actually being pushed. Enqueues every existing category/task once.
  Future<void> _enqueueExistingRowsForPush() async {
    final now = DateTime.now().toUtc();
    final categoryIds = await (select(categories).map((c) => c.id)).get();
    final taskIds = await (select(tasks).map((t) => t.id)).get();
    await batch((b) {
      b.insertAll(outboxEntries, [
        for (final id in categoryIds)
          OutboxEntriesCompanion.insert(
            targetTable: tableNameCategories,
            rowId: id,
            createdAt: now,
          ),
        for (final id in taskIds)
          OutboxEntriesCompanion.insert(
            targetTable: tableNameTasks,
            rowId: id,
            createdAt: now,
          ),
      ], mode: InsertMode.insertOrIgnore);
    });
  }

  /// Wipes all local categories/tasks and reseeds the defaults, for the
  /// "a different account signed in on this device" case (M4) — so two
  /// accounts' data never mix locally. Does **not** touch
  /// `lastSignedInUserId` (the caller sets that right after).
  Future<void> clearAllLocalData() async {
    await transaction(() async {
      await delete(tasks).go();
      await delete(categories).go();
      await delete(userSettingsTable).go();
      await delete(outboxEntries).go();
      await delete(syncCursors).go();
      await delete(syncMeta).go();
      await (update(localSettings)..where((s) => s.id.equals(0))).write(
        const LocalSettingsCompanion(
          defaultCategoryId: Value(null),
          selectedFilterCategoryId: Value(null),
        ),
      );
      await _seedDefaultCategories();
    });
  }

  /// Sign-out (M5): unlike [clearAllLocalData], does NOT reseed default
  /// categories — the next sign-in (same or different account) starts
  /// from an empty local DB and pulls fresh via the initial-sync path.
  Future<void> clearForSignOut() async {
    await transaction(() async {
      await delete(tasks).go();
      await delete(categories).go();
      await delete(userSettingsTable).go();
      await delete(outboxEntries).go();
      await delete(syncCursors).go();
      await delete(syncMeta).go();
      await (update(localSettings)..where((s) => s.id.equals(0))).write(
        const LocalSettingsCompanion(
          defaultCategoryId: Value(null),
          selectedFilterCategoryId: Value(null),
          lastSignedInUserId: Value(null),
        ),
      );
    });
  }
}
