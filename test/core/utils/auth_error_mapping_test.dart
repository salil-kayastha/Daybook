import 'package:daybook/core/utils/auth_error_mapping.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  group('mapAuthError', () {
    test('wrong password / bad credentials', () {
      final error = AuthException('Invalid login', code: 'invalid_credentials');
      expect(mapAuthError(error), 'Incorrect email or password.');
    });

    test('unconfirmed email', () {
      final error = AuthException(
        'Email not confirmed',
        code: 'email_not_confirmed',
      );
      expect(mapAuthError(error), contains('confirm your email'));
    });

    test('user already exists (sign-up)', () {
      final error = AuthException('User exists', code: 'user_already_exists');
      expect(mapAuthError(error), contains('already exists'));
    });

    test('email_exists code also maps to already-exists', () {
      final error = AuthException('Email exists', code: 'email_exists');
      expect(mapAuthError(error), contains('already exists'));
    });

    test('weak password (min 8 chars)', () {
      final error = AuthException('Password too short', code: 'weak_password');
      expect(mapAuthError(error), 'Password must be at least 8 characters.');
    });

    test('email rate limit', () {
      final error = AuthException(
        'Rate limited',
        code: 'over_email_send_rate_limit',
      );
      expect(mapAuthError(error), contains('Too many attempts'));
    });

    test('general request rate limit', () {
      final error = AuthException(
        'Rate limited',
        code: 'over_request_rate_limit',
      );
      expect(mapAuthError(error), contains('Too many attempts'));
    });

    test('network error via AuthRetryableFetchException', () {
      final error = AuthRetryableFetchException();
      expect(mapAuthError(error), contains('Network error'));
    });

    test('network error via generic SocketException-like text', () {
      final error = Exception('SocketException: Failed host lookup');
      expect(mapAuthError(error), contains('Network error'));
    });

    test('unknown AuthException code falls back to the raw message', () {
      final error = AuthException('Something specific happened');
      expect(mapAuthError(error), 'Something specific happened');
    });

    test('completely unknown error gets a generic friendly fallback', () {
      final error = Object();
      expect(mapAuthError(error), 'Something went wrong. Please try again.');
    });
  });
}
