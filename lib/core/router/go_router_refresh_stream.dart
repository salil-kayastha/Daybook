import 'dart:async';

import 'package:flutter/foundation.dart';

/// go_router 18 doesn't ship a stream-to-Listenable adapter (older
/// versions did); this is the standard hand-written equivalent, used to
/// make the router re-evaluate `redirect` on every auth state change.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
