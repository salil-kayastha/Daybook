// ignore_for_file: prefer_initializing_formals
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/utils/sync_initial.dart';
import '../../core/utils/sync_merge.dart';
import '../../domain/enums.dart';
import '../local/database.dart';
import '../local/outbox_dao.dart';
import 'pull_paginator.dart';
import 'row_codec.dart';
import 'sync_status.dart';

/// The only thing besides [AuthRepository] allowed to talk to Supabase
/// directly (CLAUDE.md rule 1) — every screen only reads/writes the local
/// Drift DB via repositories. Implements SPEC §10: outbox push, paginated
/// pull, last-write-wins merge, realtime, connectivity-triggered sync, and
/// the one-time per-device initial sync.
class SyncEngine {
  SyncEngine({
    required AppDatabase database,
    required SupabaseClient client,
    required Connectivity connectivity,
  }) : _db = database,
       _client = client,
       _connectivity = connectivity {
    _connectivitySub = _connectivity.onConnectivityChanged.listen(
      _onConnectivityChanged,
    );
    unawaited(_connectivity.checkConnectivity().then(_onConnectivityChanged));
  }

  final AppDatabase _db;
  final SupabaseClient _client;
  final Connectivity _connectivity;

  late final StreamSubscription<List<ConnectivityResult>> _connectivitySub;
  Timer? _debounceTimer;
  Timer? _backoffTimer;
  bool _pushing = false;
  bool _pushAgainAfterCurrent = false;
  bool _isOnline = true;
  RealtimeChannel? _channel;

  final ValueNotifier<SyncStatus> status = ValueNotifier(const SyncStatus());

  /// Debounced push trigger (SPEC §10 write path step 3), called by every
  /// repository write. [immediate] skips the 1s debounce — used when
  /// connectivity just came back so queued offline edits go out promptly.
  void schedulePush({bool immediate = false}) {
    _debounceTimer?.cancel();
    if (immediate) {
      unawaited(push());
      return;
    }
    _debounceTimer = Timer(const Duration(seconds: 1), () {
      unawaited(push());
    });
  }

  /// Pushes every pending outbox entry, categories → tasks → user_settings
  /// (SPEC §10 dependency order). Re-entrant calls while a push is already
  /// running are coalesced into one extra pass after the current one
  /// finishes, rather than running concurrently.
  Future<void> push() async {
    if (_pushing) {
      _pushAgainAfterCurrent = true;
      return;
    }
    if (!_isOnline) return;
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;

    _pushing = true;
    status.value = status.value.copyWith(isSyncing: true);
    try {
      final entries = await _db.outboxDao.pendingOrderedByDependency();
      for (final entry in entries) {
        await _pushEntry(entry, userId);
      }
    } finally {
      _pushing = false;
      await _refreshCounts();
      status.value = status.value.copyWith(isSyncing: false);
      if (_pushAgainAfterCurrent) {
        _pushAgainAfterCurrent = false;
        unawaited(push());
      }
    }
  }

  Future<void> _pushEntry(OutboxEntry entry, String userId) async {
    try {
      await _performUpsert(entry.targetTable, entry.rowId, userId);
      await _db.outboxDao.remove(entry.id);
    } on PostgrestException catch (e) {
      if (_isAuthError(e)) {
        if (await _tryRefreshSession()) {
          try {
            await _performUpsert(entry.targetTable, entry.rowId, userId);
            await _db.outboxDao.remove(entry.id);
            return;
          } catch (e2) {
            await _db.outboxDao.markRetrying(entry.id, error: e2.toString());
            await _scheduleBackoffRetry();
            return;
          }
        }
        await _db.outboxDao.markRetrying(entry.id, error: e.message);
        await _scheduleBackoffRetry();
      } else {
        // Non-auth 4xx (e.g. a check-constraint violation) won't succeed
        // on retry — surface it in Settings instead of retrying forever.
        await _db.outboxDao.markFailed(entry.id, error: e.message);
      }
    } catch (e) {
      await _db.outboxDao.markRetrying(entry.id, error: e.toString());
      await _scheduleBackoffRetry();
    }
  }

  Future<void> _performUpsert(
    String tableName,
    String rowId,
    String userId,
  ) async {
    switch (tableName) {
      case tableNameCategories:
        final local = await _db.categoryDao.getById(rowId);
        if (local == null) return;
        final json = categoryToRemoteJson(local, userId: userId);
        final result = await _client
            .from('categories')
            .upsert(json, onConflict: 'id')
            .select()
            .single();
        await _db.categoryDao.upsert(categoryFromRemoteJson(result));
      case tableNameTasks:
        final local = await _db.taskDao.getById(rowId);
        if (local == null) return;
        final json = taskToRemoteJson(local, userId: userId);
        final result = await _client
            .from('tasks')
            .upsert(json, onConflict: 'id')
            .select()
            .single();
        await _db.taskDao.upsert(taskFromRemoteJson(result));
      case tableNameUserSettings:
        final local = await _db.userSettingsDao.getById(rowId);
        if (local == null) return;
        final json = userSettingsToRemoteJson(local, userId: userId);
        final result = await _client
            .from('user_settings')
            .upsert(json, onConflict: 'user_id')
            .select()
            .single();
        await _db.userSettingsDao.upsert(userSettingsFromRemoteJson(result));
    }
  }

  bool _isAuthError(PostgrestException e) {
    return e.code == 'PGRST301' ||
        e.message.toLowerCase().contains('jwt') ||
        e.message.toLowerCase().contains('expired');
  }

  Future<bool> _tryRefreshSession() async {
    try {
      await _client.auth.refreshSession();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> _scheduleBackoffRetry() async {
    if (_backoffTimer != null) return;
    final attempts = await _db.outboxDao.maxPendingAttempts();
    final seconds = (2 * (1 << attempts.clamp(0, 8))).clamp(2, 300);
    _backoffTimer = Timer(Duration(seconds: seconds), () {
      _backoffTimer = null;
      unawaited(push());
    });
  }

  /// Pulls categories, then tasks, then user_settings (SPEC §10: categories
  /// before tasks so a task's `category_id` FK resolves locally whenever
  /// possible — see [row_codec.taskFromRemoteJson] for the case where it
  /// still hasn't arrived).
  Future<void> pull() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;
    status.value = status.value.copyWith(isSyncing: true);
    try {
      await _pullTable(tableNameCategories, userId);
      await _pullTable(tableNameTasks, userId);
      await _pullTable(tableNameUserSettings, userId);
    } finally {
      await _refreshCounts();
      status.value = status.value.copyWith(
        isSyncing: false,
        lastSyncedAt: DateTime.now().toUtc(),
      );
    }
  }

  Future<void> _pullTable(String tableName, String userId) async {
    final cursor = await _db.syncCursorDao.get(tableName);
    await pullAllPages<Map<String, dynamic>>(
      initialCursor: cursor,
      fetchPage: (c, limit) async {
        final builder = _client.from(tableName).select().eq('user_id', userId);
        final filtered = c == null
            ? builder
            : builder.gt('updated_at', c.toUtc().toIso8601String());
        final rows = await filtered.order('updated_at').limit(limit);
        return (rows as List).cast<Map<String, dynamic>>();
      },
      updatedAtOf: (row) => DateTime.parse(row['updated_at'] as String).toUtc(),
      applyPage: (rows) async {
        for (final row in rows) {
          await _applyRemoteRow(tableName, row);
        }
        await _db.syncCursorDao.set(
          tableName,
          DateTime.parse(rows.last['updated_at'] as String).toUtc(),
        );
      },
    );
  }

  Future<void> _applyRemoteRow(
    String tableName,
    Map<String, dynamic> json,
  ) async {
    switch (tableName) {
      case tableNameCategories:
        await _applyCategory(json);
      case tableNameTasks:
        await _applyTask(json);
      case tableNameUserSettings:
        await _applyUserSettings(json);
    }
  }

  Future<void> _applyCategory(Map<String, dynamic> json) async {
    final id = json['id'] as String;
    final remoteUpdatedAt = DateTime.parse(json['updated_at'] as String)
        .toUtc();
    final local = await _db.categoryDao.getById(id);
    if (local != null &&
        localWinsMerge(
          isPending: local.syncState == SyncState.pending,
          localChangedAt: local.localChangedAt,
          remoteUpdatedAt: remoteUpdatedAt,
        )) {
      return;
    }
    await _db.categoryDao.upsert(categoryFromRemoteJson(json));
    await _db.outboxDao.removeForRow(tableName: tableNameCategories, rowId: id);
  }

  Future<void> _applyTask(Map<String, dynamic> json) async {
    final id = json['id'] as String;
    final remoteUpdatedAt = DateTime.parse(json['updated_at'] as String)
        .toUtc();
    final local = await _db.taskDao.getById(id);
    if (local != null &&
        localWinsMerge(
          isPending: local.syncState == SyncState.pending,
          localChangedAt: local.localChangedAt,
          remoteUpdatedAt: remoteUpdatedAt,
        )) {
      return;
    }
    await _db.taskDao.upsert(taskFromRemoteJson(json));
    await _db.outboxDao.removeForRow(tableName: tableNameTasks, rowId: id);
  }

  Future<void> _applyUserSettings(Map<String, dynamic> json) async {
    final userId = json['user_id'] as String;
    final remoteUpdatedAt = DateTime.parse(json['updated_at'] as String)
        .toUtc();
    final local = await _db.userSettingsDao.getById(userId);
    if (local != null &&
        localWinsMerge(
          isPending: local.syncState == SyncState.pending,
          localChangedAt: local.localChangedAt,
          remoteUpdatedAt: remoteUpdatedAt,
        )) {
      return;
    }
    await _db.userSettingsDao.upsert(userSettingsFromRemoteJson(json));
    await _db.outboxDao.removeForRow(
      tableName: tableNameUserSettings,
      rowId: userId,
    );
  }

  /// SPEC §10 "Initial sync": the first time *this device* sees [userId],
  /// its local data is test data — wipe once and pull everything fresh.
  /// Never runs again for the same user id (even across sign-out/in).
  Future<void> runInitialSyncIfNeeded(String userId) async {
    final done = await _db.syncMetaDao.initialSyncDoneUserId();
    if (!needsInitialSync(doneForUserId: done, currentUserId: userId)) {
      return;
    }
    status.value = status.value.copyWith(isInitialSyncing: true);
    try {
      await _db.transaction(() async {
        await _db.delete(_db.tasks).go();
        await _db.delete(_db.categories).go();
        await _db.delete(_db.userSettingsTable).go();
        await _db.delete(_db.outboxEntries).go();
        await _db.syncCursorDao.reset();
      });
      await pull();
      await _db.syncMetaDao.markInitialSyncDone(userId);
    } finally {
      status.value = status.value.copyWith(isInitialSyncing: false);
    }
  }

  /// Subscribes to `postgres_changes` for the three synced tables, filtered
  /// by `user_id` (SPEC §10). Any event just triggers a pull — the payload
  /// itself is never trusted as the data. `subscribe`'s callback fires on
  /// every (re)connect, which doubles as "run a full pull on reconnect".
  void startRealtime(String userId) {
    stopRealtime();
    RealtimeChannel channel = _client.channel('sync:$userId');
    for (final table in [
      tableNameCategories,
      tableNameTasks,
      tableNameUserSettings,
    ]) {
      channel = channel.onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: table,
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'user_id',
          value: userId,
        ),
        callback: (_) => unawaited(pull()),
      );
    }
    _channel = channel
      ..subscribe((status, [error]) {
        if (status == RealtimeSubscribeStatus.subscribed) {
          unawaited(pull());
        }
      });
  }

  void stopRealtime() {
    final channel = _channel;
    _channel = null;
    if (channel != null) {
      unawaited(_client.removeChannel(channel));
    }
  }

  Future<void> _refreshCounts() async {
    final pending = await _db.outboxDao.watchPendingCount().first;
    final failed = await _db.outboxDao.watchFailedCount().first;
    final lastSynced = await _db.syncCursorDao.latest();
    status.value = status.value.copyWith(
      pendingCount: pending,
      failedCount: failed,
      lastSyncedAt: lastSynced ?? status.value.lastSyncedAt,
    );
  }

  void _onConnectivityChanged(List<ConnectivityResult> results) {
    final online = results.any((r) => r != ConnectivityResult.none);
    final wasOffline = !_isOnline;
    _isOnline = online;
    status.value = status.value.copyWith(isOnline: online);
    if (online && wasOffline) {
      schedulePush(immediate: true);
      unawaited(pull());
    }
  }

  void dispose() {
    _debounceTimer?.cancel();
    _backoffTimer?.cancel();
    unawaited(_connectivitySub.cancel());
    stopRealtime();
    status.dispose();
  }
}
