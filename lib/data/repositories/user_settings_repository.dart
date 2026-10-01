import 'package:drift/drift.dart' show Value;

import '../../domain/enums.dart';
import '../../domain/user_settings.dart';
import '../local/database.dart' as db;
import '../local/outbox_dao.dart';
import '../local/user_settings_dao.dart';

class UserSettingsRepository {
  UserSettingsRepository(
    this._dao,
    this._outboxDao,
    this._requestPush, [
    this._requestReschedule,
  ]);

  final UserSettingsDao _dao;
  final OutboxDao _outboxDao;
  final void Function() _requestPush;

  /// Pings `NotificationBootstrap.requestReschedule`, debounced 2s (SPEC
  /// §8, M6) — optional so tests don't need to supply it.
  final void Function()? _requestReschedule;

  Stream<UserSettings?> watch(String userId) => _dao
      .watch(userId)
      .map((row) => row == null ? null : userSettingsFromRow(row));

  Future<UserSettings?> getById(String userId) async {
    final row = await _dao.getById(userId);
    return row == null ? null : userSettingsFromRow(row);
  }

  Future<void> upsert(UserSettings settings) async {
    final now = DateTime.now().toUtc();
    await _dao.upsert(
      db.UserSettingsTableCompanion.insert(
        userId: settings.userId,
        morningEnabled: Value(settings.morningEnabled),
        morningTime: Value(settings.morningTime),
        eveningEnabled: Value(settings.eveningEnabled),
        eveningTime: Value(settings.eveningTime),
        themeMode: Value(settings.themeMode),
        weekStartsOn: Value(settings.weekStartsOn),
        defaultCategoryId: Value(settings.defaultCategoryId),
        updatedAt: now,
        syncState: const Value(SyncState.pending),
        localChangedAt: Value(now),
      ),
    );
    await _outboxDao.enqueue(
      tableName: tableNameUserSettings,
      rowId: settings.userId,
    );
    _requestPush();
    _requestReschedule?.call();
  }
}

/// Shared with `NotificationRescheduler` (M6), which reads the DAO
/// directly rather than through `userSettingsRepositoryProvider` — that
/// provider depends on the rescheduler (for the post-write ping), so
/// reading it back from inside the rescheduler would be a circular
/// provider dependency. See the "reschedule" doc comment in
/// `notification_providers.dart`.
UserSettings userSettingsFromRow(db.UserSettingsRow row) {
  return UserSettings(
    userId: row.userId,
    morningEnabled: row.morningEnabled,
    morningTime: row.morningTime,
    eveningEnabled: row.eveningEnabled,
    eveningTime: row.eveningTime,
    themeMode: row.themeMode,
    weekStartsOn: row.weekStartsOn,
    defaultCategoryId: row.defaultCategoryId,
    updatedAt: row.updatedAt,
    syncState: row.syncState,
    localChangedAt: row.localChangedAt,
  );
}
