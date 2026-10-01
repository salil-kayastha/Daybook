import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// The one deliberate exception to "UI never talks to Supabase directly"
/// (CLAUDE.md rule 1): identity isn't app data, it can't be offline-first,
/// and SPEC §7.1 has the Auth screen call Supabase Auth. Every other
/// screen still only reads/writes the local Drift DB.
class AuthRepository {
  AuthRepository(this._client);

  final SupabaseClient _client;

  /// Mobile deep link registered in the Android manifest / iOS Info.plist.
  static const _mobileRedirect = 'io.daybook.app://login-callback';

  User? get currentUser => _client.auth.currentUser;

  Stream<AuthState> get onAuthStateChange => _client.auth.onAuthStateChange;

  Future<void> signInWithPassword({
    required String email,
    required String password,
  }) {
    return _client.auth.signInWithPassword(email: email, password: password);
  }

  /// Returns the resulting [AuthResponse]; `response.session == null`
  /// means Supabase requires email confirmation before the account is
  /// usable — the caller shows the "check your email" state for that.
  Future<AuthResponse> signUpWithPassword({
    required String email,
    required String password,
  }) {
    return _client.auth.signUp(
      email: email,
      password: password,
      emailRedirectTo: _emailRedirectTo(),
    );
  }

  Future<void> resetPasswordForEmail(String email) {
    return _client.auth.resetPasswordForEmail(
      email,
      redirectTo: _emailRedirectTo(),
    );
  }

  Future<void> signOut() => _client.auth.signOut();

  String _emailRedirectTo() {
    if (kIsWeb) return Uri.base.origin;
    return _mobileRedirect;
  }
}
