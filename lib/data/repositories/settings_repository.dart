import '../../domain/local_settings.dart';
import '../local/database.dart' as db;
import '../local/settings_dao.dart';

class SettingsRepository {
  SettingsRepository(this._dao);

  final SettingsDao _dao;

  Stream<LocalSettings> watch() => _dao.watch().map(_toDomain);

  Future<void> setDefaultCategory(String? categoryId) =>
      _dao.setDefaultCategory(categoryId);

  Future<void> setSelectedFilterCategory(String? categoryId) =>
      _dao.setSelectedFilterCategory(categoryId);

  Future<void> setLastSignedInUserId(String? userId) =>
      _dao.setLastSignedInUserId(userId);

  Future<void> setUseExactAlarms(bool value) => _dao.setUseExactAlarms(value);

  Future<void> setNotificationPermissionRequested(bool value) =>
      _dao.setNotificationPermissionRequested(value);

  LocalSettings _toDomain(db.LocalSetting row) {
    return LocalSettings(
      defaultCategoryId: row.defaultCategoryId,
      selectedFilterCategoryId: row.selectedFilterCategoryId,
      lastSignedInUserId: row.lastSignedInUserId,
      useExactAlarms: row.useExactAlarms,
      notificationPermissionRequested: row.notificationPermissionRequested,
    );
  }
}
