/// Snapshot shown in Settings' sync section and the Day screen's small
/// offline/syncing indicator (SPEC §10/§11 M5).
class SyncStatus {
  const SyncStatus({
    this.lastSyncedAt,
    this.pendingCount = 0,
    this.failedCount = 0,
    this.isSyncing = false,
    this.isInitialSyncing = false,
    this.isOnline = true,
  });

  final DateTime? lastSyncedAt;
  final int pendingCount;
  final int failedCount;
  final bool isSyncing;
  final bool isInitialSyncing;
  final bool isOnline;

  SyncStatus copyWith({
    DateTime? lastSyncedAt,
    int? pendingCount,
    int? failedCount,
    bool? isSyncing,
    bool? isInitialSyncing,
    bool? isOnline,
  }) {
    return SyncStatus(
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      pendingCount: pendingCount ?? this.pendingCount,
      failedCount: failedCount ?? this.failedCount,
      isSyncing: isSyncing ?? this.isSyncing,
      isInitialSyncing: isInitialSyncing ?? this.isInitialSyncing,
      isOnline: isOnline ?? this.isOnline,
    );
  }
}
