import 'package:drift/drift.dart';

import 'database.dart';
import 'tables.dart';

part 'settings_dao.g.dart';

@DriftAccessor(tables: [LocalSettings])
class SettingsDao extends DatabaseAccessor<AppDatabase>
    with _$SettingsDaoMixin {
  SettingsDao(super.db);

  Stream<LocalSetting> watch() {
    return (select(localSettings)..where((s) => s.id.equals(0))).watchSingle();
  }

  Future<void> setDefaultCategory(String? categoryId) async {
    await into(localSettings).insertOnConflictUpdate(
      LocalSettingsCompanion.insert(
        id: const Value(0),
        defaultCategoryId: Value(categoryId),
      ),
    );
  }

  Future<void> setSelectedFilterCategory(String? categoryId) async {
    await into(localSettings).insertOnConflictUpdate(
      LocalSettingsCompanion.insert(
        id: const Value(0),
        selectedFilterCategoryId: Value(categoryId),
      ),
    );
  }

  Future<void> setLastSignedInUserId(String? userId) async {
    await into(localSettings).insertOnConflictUpdate(
      LocalSettingsCompanion.insert(
        id: const Value(0),
        lastSignedInUserId: Value(userId),
      ),
    );
  }

  Future<void> setUseExactAlarms(bool value) async {
    await into(localSettings).insertOnConflictUpdate(
      LocalSettingsCompanion.insert(
        id: const Value(0),
        useExactAlarms: Value(value),
      ),
    );
  }

  Future<void> setNotificationPermissionRequested(bool value) async {
    await into(localSettings).insertOnConflictUpdate(
      LocalSettingsCompanion.insert(
        id: const Value(0),
        notificationPermissionRequested: Value(value),
      ),
    );
  }
}
