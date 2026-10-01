import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'core/config/env.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
