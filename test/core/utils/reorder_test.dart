import 'package:daybook/core/utils/reorder.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('sortOrderBetween', () {
    test('empty list: no neighbors gives 0', () {
      expect(sortOrderBetween(null, null), 0);
    });

    test('moved to the very top: before neighbor only missing', () {
      expect(sortOrderBetween(null, 5), 4);
    });

    test('moved to the very bottom: after neighbor only missing', () {
      expect(sortOrderBetween(5, null), 6);
    });

    test('moved between two neighbors: exact midpoint', () {
      expect(sortOrderBetween(1, 3), 2);
    });

    test('midpoint works for fractional neighbors too', () {
      expect(sortOrderBetween(1.0, 1.5), 1.25);
    });

    test('repeated inserts between the same two neighbors keep narrowing', () {
      // Simulates dragging a new item between 1 and 2 three times in a row
      // without ever touching the neighbors' own sortOrder.
      var order = sortOrderBetween(1, 2);
      expect(order, 1.5);
      order = sortOrderBetween(1, order);
      expect(order, 1.25);
      order = sortOrderBetween(1, order);
      expect(order, 1.125);
    });

    test('only moving the dragged row: neighbors are never recomputed', () {
      // [a=0, b=1, c=2] -> move c between a and b: c should land at 0.5,
      // and this function is never asked to touch a's or b's sortOrder.
      final newCSortOrder = sortOrderBetween(0, 1);
      expect(newCSortOrder, 0.5);
    });
  });

  group('sortOrderAppendingTo', () {
    test('empty list starts at 0', () {
      expect(sortOrderAppendingTo(const []), 0);
    });

    test('appends after the current max', () {
      expect(sortOrderAppendingTo([1, 5, 3]), 6);
    });

    test('single existing item', () {
      expect(sortOrderAppendingTo([2.5]), 3.5);
    });
  });
}
