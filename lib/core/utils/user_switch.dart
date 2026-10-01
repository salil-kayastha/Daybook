/// Pure decision (M4): should this device's local data be wiped before
/// using it under [newUserId]? True only when a *different* account was
/// previously signed in on this device — never on this device's first
/// ever sign-in (nothing to protect against yet), and never just because
/// the same user's session refreshed.
bool shouldClearLocalData({
  required String? storedUserId,
  required String newUserId,
}) {
  return storedUserId != null && storedUserId != newUserId;
}
