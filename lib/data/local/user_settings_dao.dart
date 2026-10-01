import 'package:drift/drift.dart';

import 'database.dart';
import 'tables.dart';

part 'user_settings_dao.g.dart';

@DriftAccessor(tables: [UserSettingsTable])
class UserSettingsDao extends DatabaseAccessor<AppDatabase>
    with _$UserSettingsDaoMixin {
  UserSettingsDao(super.db);

  Stream<UserSettingsRow?> watch(String userId) {
    return (select(
      userSettingsTable,
    )..where((s) => s.userId.equals(userId))).watchSingleOrNull();
  }

  Future<UserSettingsRow?> getById(String userId) => (select(
    userSettingsTable,
  )..where((s) => s.userId.equals(userId))).getSingleOrNull();

  Future<void> upsert(UserSettingsTableCompanion entry) =>
      into(userSettingsTable).insertOnConflictUpdate(entry);
}
