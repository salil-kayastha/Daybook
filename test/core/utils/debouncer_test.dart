import 'package:daybook/core/utils/debouncer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Debouncer (SPEC §8 "debounced 2s" reschedule trigger)', () {
    test('runs once after the delay, even with repeated calls', () async {
      final debouncer = Debouncer(const Duration(milliseconds: 30));
      var calls = 0;

      debouncer.run(() => calls++);
      debouncer.run(() => calls++);
      debouncer.run(() => calls++);

      expect(calls, 0, reason: 'must not run before the delay elapses');
      await Future<void>.delayed(const Duration(milliseconds: 60));
      expect(calls, 1);
    });

    test(
      'immediate:true runs synchronously and cancels a pending debounce',
      () async {
        final debouncer = Debouncer(const Duration(milliseconds: 30));
        var calls = 0;

        debouncer.run(() => calls++);
        debouncer.run(() => calls++, immediate: true);

        expect(calls, 1, reason: 'immediate call runs right away');
        await Future<void>.delayed(const Duration(milliseconds: 60));
        expect(
          calls,
          1,
          reason: 'the earlier debounced call must have been cancelled',
        );
      },
    );

    test('dispose cancels a pending debounce', () async {
      final debouncer = Debouncer(const Duration(milliseconds: 20));
      var calls = 0;
      debouncer.run(() => calls++);
      debouncer.dispose();
      await Future<void>.delayed(const Duration(milliseconds: 40));
      expect(calls, 0);
    });

    test('a later call resets the delay window', () async {
      final debouncer = Debouncer(const Duration(milliseconds: 40));
      var calls = 0;

      debouncer.run(() => calls++);
      await Future<void>.delayed(const Duration(milliseconds: 25));
      debouncer.run(() => calls++); // resets the 40ms window
      await Future<void>.delayed(const Duration(milliseconds: 25));
      expect(calls, 0, reason: 'still within the reset window');

      await Future<void>.delayed(const Duration(milliseconds: 30));
      expect(calls, 1);
    });
  });
}
