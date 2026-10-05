import 'package:flutter/material.dart';

/// Attached to [MaterialApp.scaffoldMessengerKey] (in `app.dart`) so any
/// part of the app — including the top-level error handler, which has no
/// [BuildContext] of its own — can surface a friendly snackbar (SPEC §11
/// M8, CLAUDE.md "never show raw exceptions").
final GlobalKey<ScaffoldMessengerState> globalMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

/// Shows a short, user-friendly message. Never pass a raw exception's
/// `toString()` here — translate it to plain language first.
void showFriendlyError(String message) {
  final messenger = globalMessengerKey.currentState;
  if (messenger == null) return;
  messenger.showSnackBar(SnackBar(content: Text(message)));
}
