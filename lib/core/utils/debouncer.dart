import 'dart:async';

/// Coalesces rapid repeated calls into one, [duration] after the last call
/// — used for the "debounced 2s" reschedule trigger (SPEC §8, M6) and the
/// "debounced 1s" sync push trigger (SPEC §10, M5). A real [Timer] under
/// the hood, but the [duration] is constructor-injected so tests can use a
/// short one instead of waiting out the real interval.
class Debouncer {
  Debouncer(this.duration);

  final Duration duration;
  Timer? _timer;

  /// Runs [action] after [duration] from the last call, cancelling any
  /// still-pending call. [immediate] skips the wait and runs right away
  /// (still cancels a pending debounced call, so it isn't double-invoked).
  void run(void Function() action, {bool immediate = false}) {
    _timer?.cancel();
    if (immediate) {
      action();
      return;
    }
    _timer = Timer(duration, action);
  }

  void dispose() => _timer?.cancel();
}
