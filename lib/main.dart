import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'core/config/env.dart';
import 'core/error/app_error_handler.dart';

/// Kept alive for the app's lifetime (SPEC §11 M8, web a11y): on web,
/// Flutter normally only builds its semantics tree once it *detects* a
/// screen reader, which happens too late (or never) for Lighthouse/axe,
/// which read the DOM once on page load. Forcing it on immediately is
/// what makes the semantics tree exist for those tools to find at all —
/// see the "what Lighthouse can/can't measure" note in the M8 report.
// ignore: unused_element
SemanticsHandle? _semanticsHandle;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  installAppErrorHandlers();
  if (kIsWeb) {
    _semanticsHandle = SemanticsBinding.instance.ensureSemantics();
  }

  if (kDebugMode &&
      (Env.supabaseUrl.isEmpty || Env.supabasePublishableKey.isEmpty)) {
    throw StateError(
      'SUPABASE_URL and/or SUPABASE_PUBLISHABLE_KEY are empty. Run with '
      '--dart-define-from-file=env.json (see README "Setup").',
    );
  }

  await Supabase.initialize(
    url: Env.supabaseUrl,
    publishableKey: Env.supabasePublishableKey,
  );

  runApp(const ProviderScope(child: DaybookApp()));
}
