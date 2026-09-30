import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../domain/enums.dart';
import 'category_dao.dart';
import 'settings_dao.dart';
import 'task_dao.dart';
import 'tables.dart';

part 'database.g.dart';

/// Local-only source of truth (offline-first, CLAUDE.md rule 1). The sync
/// engine (M5) is the only other thing allowed to touch Supabase directly.
@DriftDatabase(
  tables: [Categories, Tasks, LocalSettings],
  daos: [CategoryDao, TaskDao, SettingsDao],
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
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _seedDefaultCategories();
      await _seedSettingsRow();
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(localSettings);
        await _seedSettingsRow();
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
        ),
        CategoriesCompanion.insert(
          id: uuid.v4(),
          name: 'Personal',
          color: '#12B886',
          sortOrder: const Value(2),
          createdAt: now,
          updatedAt: now,
        ),
      ]);
    });
  }
}
