import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import '../../features/categories/manage_categories_screen.dart';
import '../../features/day/day_screen.dart';
import '../../features/style_preview/style_preview_screen.dart';

/// Auth redirect (M4) and the rest of the routes are added in later
/// milestones. `/style-preview` is a permanent design reference but only
/// reachable in debug builds.
final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const DayScreen()),
    GoRoute(
      path: '/categories',
      builder: (context, state) => const ManageCategoriesScreen(),
    ),
    if (kDebugMode)
      GoRoute(
        path: '/style-preview',
        builder: (context, state) => const StylePreviewScreen(),
      ),
  ],
);
