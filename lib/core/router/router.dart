import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/utils/auth_redirect.dart';
import '../../features/auth/auth_providers.dart';
import '../../features/auth/auth_screen.dart';
import '../../features/auth/user_guard_provider.dart';
import '../../features/categories/manage_categories_screen.dart';
import '../../features/day/day_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/style_preview/style_preview_screen.dart';
import 'go_router_refresh_stream.dart';

part 'router.g.dart';

/// Signed-out users can only reach `/auth` (M4); everyone else needs to be
/// signed in. `/style-preview` is a permanent design reference but only
/// reachable in debug builds.
@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final refreshStream = GoRouterRefreshStream(authRepository.onAuthStateChange);
  ref.onDispose(refreshStream.dispose);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: refreshStream,
    redirect: (context, state) async {
      final isSignedIn = authRepository.currentUser != null;
      final decision = resolveAuthRedirect(
        isSignedIn: isSignedIn,
        location: state.matchedLocation,
      );
      if (decision != null) return decision;

      // Let an account switch finish clearing local data before any
      // signed-in screen reads it.
      if (isSignedIn) {
        await ref.read(userGuardProvider.future);
      }
      return null;
    },
    routes: [
      GoRoute(path: '/auth', builder: (context, state) => const AuthScreen()),
      GoRoute(
        path: '/',
        builder: (context, state) {
          // Set by a notification tap (SPEC §8, M6) — see `app.dart`.
          final dateParam = state.uri.queryParameters['date'];
          return DayScreen(
            initialDate: dateParam != null ? _parseDate(dateParam) : null,
            focusQuickAdd: state.uri.queryParameters['focusQuickAdd'] == '1',
          );
        },
      ),
      GoRoute(
        path: '/categories',
        builder: (context, state) => const ManageCategoriesScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      if (kDebugMode)
        GoRoute(
          path: '/style-preview',
          builder: (context, state) => const StylePreviewScreen(),
        ),
    ],
  );
}

DateTime? _parseDate(String value) {
  final parts = value.split('-');
  if (parts.length != 3) return null;
  final y = int.tryParse(parts[0]);
  final m = int.tryParse(parts[1]);
  final d = int.tryParse(parts[2]);
  if (y == null || m == null || d == null) return null;
  return DateTime(y, m, d);
}
