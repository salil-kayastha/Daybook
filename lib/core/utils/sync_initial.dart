/// Whether the one-time "wipe local test data, pull everything fresh" step
/// (SPEC §10 "Initial sync") still needs to run for [currentUserId] on this
/// device. Runs once per user id, never again afterward — including across
/// sign-out/sign-in cycles for the *same* user, so a second sign-in doesn't
/// re-wipe data that's already correctly synced.
bool needsInitialSync({
  required String? doneForUserId,
  required String currentUserId,
}) {
  return doneForUserId != currentUserId;
}
