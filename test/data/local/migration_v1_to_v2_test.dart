import 'dart:io';

import 'package:daybook/data/local/database.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

/// Reproduces a real device upgrading from schemaVersion 1 (categories +
/// tasks only) to 2 (adds `local_settings`), against an on-disk sqlite
/// file — isolating the migration logic from any web/worker behavior.
void main() {
  test('opening a v1 database upgrades it to v2 without error', () async {
    final path =
        '${Directory.systemTemp.path}/daybook_migration_test_${DateTime.now().microsecondsSinceEpoch}.sqlite';
    final file = File(path);
    addTearDown(() {
      if (file.existsSync()) file.deleteSync();
    });

    final v1 = NativeDatabase(file);
    await v1.ensureOpen(_FakeUser());
    await v1.runCustom('''
      CREATE TABLE categories (
        id TEXT NOT NULL PRIMARY KEY,
        user_id TEXT NULL,
        name TEXT NOT NULL,
        color TEXT NOT NULL,
        icon TEXT NULL,
        sort_order REAL NOT NULL DEFAULT 0,
        is_archived INTEGER NOT NULL DEFAULT 0,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        deleted_at INTEGER NULL
      );
    ''', []);
    await v1.runCustom('''
      CREATE TABLE tasks (
        id TEXT NOT NULL PRIMARY KEY,
        user_id TEXT NULL,
        category_id TEXT NULL REFERENCES categories (id),
        title TEXT NOT NULL,
        notes TEXT NULL,
        checklist TEXT NOT NULL DEFAULT '[]',
        task_date INTEGER NOT NULL,
        time_mode TEXT NOT NULL DEFAULT 'none',
        start_time TEXT NULL,
        end_time TEXT NULL,
        status TEXT NOT NULL DEFAULT 'todo',
        completed_at INTEGER NULL,
        sort_order REAL NOT NULL DEFAULT 0,
        recurrence_rule TEXT NULL,
        recurrence_parent_id TEXT NULL,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        deleted_at INTEGER NULL
      );
    ''', []);
    await v1.runCustom('PRAGMA user_version = 1;', []);
    await v1.close();

    final db = AppDatabase.connect(NativeDatabase(file));
    addTearDown(db.close);

    final settings = await db.settingsDao.watch().first;
    expect(settings.id, 0);
  });
}

class _FakeUser extends QueryExecutorUser {
  @override
  Future<void> beforeOpen(
    QueryExecutor executor,
    OpeningDetails details,
  ) async {}

  @override
  int get schemaVersion => 1;
}
