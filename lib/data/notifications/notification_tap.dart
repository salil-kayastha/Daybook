import 'package:flutter/foundation.dart';

/// Set by both the foreground and background notification-tap callbacks
/// (SPEC §8, M6). `app.dart` listens and consumes it once the router
/// exists — this decouples the plugin's isolate-unsafe callback shape from
/// the widget tree, and also covers cold-start launches (the launch
/// payload is pushed here the same way after `getNotificationAppLaunchDetails`
/// resolves).
///
/// Values: `'morning'` or `'evening'` (matches the payload set when
/// scheduling — see `NotificationScheduler.rescheduleAll`).
final ValueNotifier<String?> pendingNotificationTap = ValueNotifier<String?>(
  null,
);
