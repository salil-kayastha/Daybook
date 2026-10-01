import 'package:supabase_flutter/supabase_flutter.dart';

/// Maps a Supabase auth error to a friendly, user-facing message. Matches
/// on [AuthException.code] — the raw string GoTrue returns (see
/// https://supabase.com/docs/guides/auth/debugging/error-codes) — rather
/// than parsing [AuthException.message], which is not guaranteed stable.
String mapAuthError(Object error) {
  if (error is AuthRetryableFetchException) {
    return 'Network error. Check your connection and try again.';
  }

  if (error is AuthException) {
    switch (error.code) {
      case 'invalid_credentials':
        return 'Incorrect email or password.';
      case 'email_not_confirmed':
        return 'Please confirm your email before signing in. '
            'Check your inbox for the confirmation link.';
      case 'user_already_exists':
      case 'email_exists':
        return 'An account with this email already exists. '
            'Try signing in instead.';
      case 'weak_password':
        return 'Password must be at least 8 characters.';
      case 'over_email_send_rate_limit':
      case 'over_request_rate_limit':
        return 'Too many attempts. Please wait a moment and try again.';
    }

    final message = error.message.toLowerCase();
    if (message.contains('already registered') ||
        message.contains('already exists')) {
      return 'An account with this email already exists. '
          'Try signing in instead.';
    }
    if (message.contains('password') && message.contains('8')) {
      return 'Password must be at least 8 characters.';
    }
    return error.message;
  }

  final text = error.toString().toLowerCase();
  if (text.contains('socketexception') ||
      text.contains('network') ||
      text.contains('failed host lookup')) {
    return 'Network error. Check your connection and try again.';
  }

  return 'Something went wrong. Please try again.';
}
