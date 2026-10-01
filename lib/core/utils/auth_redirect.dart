/// Pure go_router redirect decision (M4): signed-out users can only reach
/// `/auth`; signed-in users are bounced away from it. Returns the path to
/// redirect to, or null to allow the navigation as-is.
String? resolveAuthRedirect({
  required bool isSignedIn,
  required String location,
}) {
  const authPath = '/auth';
  if (!isSignedIn && location != authPath) return authPath;
  if (isSignedIn && location == authPath) return '/';
  return null;
}
