import 'package:drift/drift.dart';

import '../../domain/enums.dart';

/// Epoch used as the default `local_changed_at` for rows that existed
/// before M5 added sync columns — always older than any real remote
/// `updated_at`, so the merge rule in [AppDatabase] treats them correctly.
final syncEpoch = DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);

/// Mirrors `public.categories` (SPEC §4). `userId` stays null until sync
/// (M4/M5) fills it in; not yet enforced not-null locally. `syncState`/
/// `localChangedAt` are local-only sync bookkeeping (SPEC §10).
class Categories extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().nullable()();
  TextColumn get name => text().withLength(min: 1, max: 60)();
  TextColumn get color => text()();
  TextColumn get icon => text().nullable()();
  RealColumn get sortOrder => real().withDefault(const Constant(0))();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  TextColumn get syncState =>
      textEnum<SyncState>().withDefault(Constant(SyncState.pending.name))();
  DateTimeColumn get localChangedAt =>
      dateTime().withDefault(Constant(syncEpoch))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Local-only device settings — NOT part of the SPEC §4 remote schema, and
/// NOT synced (M5): selected filter / default category picker state is
/// per-device UI state, deliberately distinct from the synced
/// [UserSettingsTable] below. Always exactly one row (id 0).
class LocalSettings extends Table {
  IntColumn get id => integer().withDefault(const Constant(0))();
  TextColumn get defaultCategoryId =>
      text().nullable().references(Categories, #id)();
  TextColumn get selectedFilterCategoryId =>
      text().nullable().references(Categories, #id)();

  /// The Supabase user id last signed in on this device (M4). Used to
  /// detect an account switch — see `AppDatabase.clearAllLocalData`.
  TextColumn get lastSignedInUserId => text().nullable()();

  /// Android only (M6): use exact alarms (`SCHEDULE_EXACT_ALARM`) instead
  /// of the default inexact `AlarmManagerPlus` scheduling. Device-local —
  /// battery/permission tradeoffs don't travel with the account.
  BoolColumn get useExactAlarms =>
      boolean().withDefault(const Constant(false))();

  /// Whether the OS notification-permission prompt has been shown on this
  /// device yet (M6) — requested after the first task is created, not at
  /// launch, and only once (SPEC §8).
  BoolColumn get notificationPermissionRequested =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Mirrors `public.tasks` (SPEC §4). `taskDate`/`startTime`/`endTime` are
/// floating local values stored verbatim — never converted to UTC
/// (CLAUDE.md rule 5). `checklist` is JSON-encoded text (mirrors the
/// remote jsonb column); `startTime`/`endTime` are "HH:mm" text.
class Tasks extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().nullable()();
  TextColumn get categoryId => text().nullable().references(Categories, #id)();
  TextColumn get title => text().withLength(min: 1, max: 300)();
  TextColumn get notes => text().nullable()();
  TextColumn get checklist => text().withDefault(const Constant('[]'))();
  DateTimeColumn get taskDate => dateTime()();
  TextColumn get timeMode =>
      textEnum<TimeMode>().withDefault(Constant(TimeMode.none.name))();
  TextColumn get startTime => text().nullable()();
  TextColumn get endTime => text().nullable()();
  TextColumn get status =>
      textEnum<TaskStatus>().withDefault(Constant(TaskStatus.todo.name))();
  DateTimeColumn get completedAt => dateTime().nullable()();
  RealColumn get sortOrder => real().withDefault(const Constant(0))();
  TextColumn get recurrenceRule => text().nullable()();
  TextColumn get recurrenceParentId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  TextColumn get syncState =>
      textEnum<SyncState>().withDefault(Constant(SyncState.pending.name))();
  DateTimeColumn get localChangedAt =>
      dateTime().withDefault(Constant(syncEpoch))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Mirrors `public.user_settings` (SPEC §4) — the synced counterpart to
/// [LocalSettings]. One row per signed-in user id (there's only ever one
/// signed-in user on this device at a time; M4's account-switch guard
/// wipes local data, including this table, before a different user's row
/// would otherwise appear).
@DataClassName('UserSettingsRow')
class UserSettingsTable extends Table {
  TextColumn get userId => text()();
  BoolColumn get morningEnabled =>
      boolean().withDefault(const Constant(true))();

  /// "HH:mm:ss" floating local time (CLAUDE.md rule 5), mirrors Postgres
  /// `time`. Not yet read by any screen — M6 wires notification scheduling.
  TextColumn get morningTime =>
      text().withDefault(const Constant('07:30:00'))();
  BoolColumn get eveningEnabled =>
      boolean().withDefault(const Constant(true))();
  TextColumn get eveningTime =>
      text().withDefault(const Constant('21:00:00'))();
  TextColumn get themeMode => text().withDefault(const Constant('system'))();
  IntColumn get weekStartsOn => integer().withDefault(const Constant(1))();
  TextColumn get defaultCategoryId =>
      text().nullable().references(Categories, #id)();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get syncState =>
      textEnum<SyncState>().withDefault(Constant(SyncState.pending.name))();
  DateTimeColumn get localChangedAt =>
      dateTime().withDefault(Constant(syncEpoch))();

  @override
  Set<Column> get primaryKey => {userId};
}

/// Push worklist (SPEC §10, M5): one row per (table, row) that has local
/// changes not yet confirmed on the server. [SyncEngine.push] coalesces
/// repeated writes to the same row into a single entry — see
/// `OutboxDao.enqueue`.
class OutboxEntries extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Which local table the row lives in (`tableNameCategories` etc. from
  /// `outbox_dao.dart`). Named `targetTable`, not `tableName` — the latter
  /// is reserved by drift's `Table.tableName` (the SQL table name override).
  TextColumn get targetTable => text()();
  TextColumn get rowId => text()();

  /// Always `'upsert'` today — soft deletes are just a `deleted_at` field
  /// upsert (CLAUDE.md rule 6, no hard deletes). Kept as a column so a
  /// future hard-delete op doesn't need a schema change.
  TextColumn get op => text().withDefault(const Constant('upsert'))();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();

  /// `'pending'` (still retrying) or `'failed'` (a non-retriable 4xx — shown
  /// in Settings; `SyncEngine.retryFailed` or a fresh local write on the
  /// same row moves it back to `'pending'`).
  TextColumn get status => text().withDefault(const Constant('pending'))();
  TextColumn get lastError => text().nullable()();
}

/// Per-table pull cursor (SPEC §10): the server `updated_at` of the newest
/// row pulled so far. Deliberately the *server* clock, never the device's
/// (comment per M5 instructions: using the device clock here would make
/// pull-pagination skip or re-fetch rows under clock skew).
class SyncCursors extends Table {
  TextColumn get targetTable => text()();
  DateTimeColumn get lastPulledAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {targetTable};
}

/// Singleton row (id 0) tracking whether the one-time "this device's local
/// data is test data, wipe and pull everything fresh" step has run for the
/// currently signed-in user id (SPEC §10 "Initial sync").
@DataClassName('SyncMetaRow')
class SyncMeta extends Table {
  IntColumn get id => integer().withDefault(const Constant(0))();
  TextColumn get initialSyncDoneUserId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
