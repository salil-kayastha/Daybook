// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings_dao.dart';

// ignore_for_file: type=lint
mixin _$UserSettingsDaoMixin on DatabaseAccessor<AppDatabase> {
  $CategoriesTable get categories => attachedDatabase.categories;
  $UserSettingsTableTable get userSettingsTable =>
      attachedDatabase.userSettingsTable;
  UserSettingsDaoManager get managers => UserSettingsDaoManager(this);
}

class UserSettingsDaoManager {
  final _$UserSettingsDaoMixin _db;
  UserSettingsDaoManager(this._db);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db.attachedDatabase, _db.categories);
  $$UserSettingsTableTableTableManager get userSettingsTable =>
      $$UserSettingsTableTableTableManager(
        _db.attachedDatabase,
        _db.userSettingsTable,
      );
}
