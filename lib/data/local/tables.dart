import 'package:drift/drift.dart';

import '../../domain/enums.dart';

/// Mirrors `public.categories` (SPEC §4). `userId` stays null until sync
/// (M4/M5) fills it in; not yet enforced not-null locally.
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

  @override
  Set<Column> get primaryKey => {id};
}

/// Local-only device settings — NOT part of the SPEC §4 remote schema yet.
/// A placeholder for the eventual `public.user_settings` table (added when
/// sync needs it); for now just the two things M3 needs to persist
/// per-device: the default category for quick-add/FAB, and the Day
/// screen's remembered filter chip. Always exactly one row (id 0).
class LocalSettings extends Table {
  IntColumn get id => integer().withDefault(const Constant(0))();
  TextColumn get defaultCategoryId =>
      text().nullable().references(Categories, #id)();
  TextColumn get selectedFilterCategoryId =>
      text().nullable().references(Categories, #id)();

  /// The Supabase user id last signed in on this device (M4). Used to
  /// detect an account switch — see `AppDatabase.clearAllLocalData`.
  TextColumn get lastSignedInUserId => text().nullable()();

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

  @override
  Set<Column> get primaryKey => {id};
}
