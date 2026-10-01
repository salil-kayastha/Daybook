/// Last-write-wins merge rule for a pulled remote row (SPEC §10, M5).
///
/// If the local row has unpushed changes (`pending`), keep it only when its
/// `local_changed_at` is strictly newer than the remote `updated_at` —
/// otherwise the remote row wins and the local pending change is dropped.
/// A synced (non-pending) local row never wins; the remote row is always
/// authoritative once there's nothing local left to protect.
///
/// Clock skew between devices can only affect this one case (comparing a
/// still-pending local write against the server's `updated_at`) — once a
/// row is pushed, the server's own clock stamps `updated_at` and all
/// devices compare against that single source of truth.
bool localWinsMerge({
  required bool isPending,
  required DateTime localChangedAt,
  required DateTime remoteUpdatedAt,
}) {
  if (!isPending) return false;
  return localChangedAt.isAfter(remoteUpdatedAt);
}
