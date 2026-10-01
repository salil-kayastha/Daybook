import 'package:daybook/core/utils/auth_redirect.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('resolveAuthRedirect', () {
    test('signed out, not on /auth -> redirect to /auth', () {
      expect(resolveAuthRedirect(isSignedIn: false, location: '/'), '/auth');
      expect(
        resolveAuthRedirect(isSignedIn: false, location: '/categories'),
        '/auth',
      );
      expect(
        resolveAuthRedirect(isSignedIn: false, location: '/settings'),
        '/auth',
      );
    });

    test('signed out, already on /auth -> no redirect', () {
      expect(resolveAuthRedirect(isSignedIn: false, location: '/auth'), isNull);
    });

    test('signed in, on /auth -> redirect to /', () {
      expect(resolveAuthRedirect(isSignedIn: true, location: '/auth'), '/');
    });

    test('signed in, elsewhere -> no redirect', () {
      expect(resolveAuthRedirect(isSignedIn: true, location: '/'), isNull);
      expect(
        resolveAuthRedirect(isSignedIn: true, location: '/categories'),
        isNull,
      );
      expect(
        resolveAuthRedirect(isSignedIn: true, location: '/settings'),
        isNull,
      );
    });
  });
}
