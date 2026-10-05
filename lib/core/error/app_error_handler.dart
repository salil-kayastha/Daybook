import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

import 'global_messenger.dart';

/// Installs the app-wide error handlers (SPEC §11 M8): anything that
/// slips past a local try/catch is logged (never silently dropped) and
/// surfaces as one generic snackbar instead of a crash or a red error
/// screen in front of the user. Call once from `main()` before `runApp`.
void installAppErrorHandlers() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    _logAndNotify(details.exception, details.stack);
  };

  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    _logAndNotify(error, stack);
    return true;
  };
}

void _logAndNotify(Object error, StackTrace? stack) {
  developer.log(
    'Unhandled error',
    name: 'daybook.error',
    error: error,
    stackTrace: stack,
    level: 1000,
  );
  showFriendlyError("Something went wrong. We're on it — try again.");
}
