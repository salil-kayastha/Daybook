import 'package:daybook/core/utils/date_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('dateToPageIndex / pageIndexToDate', () {
    test('epoch maps to page 0', () {
      expect(dateToPageIndex(DateTime(2000, 1, 1)), 0);
      expect(pageIndexToDate(0), DateTime(2000, 1, 1));
    });

    test('round-trips for a wide range of dates', () {
      final dates = [
        DateTime(1900, 1, 1),
        DateTime(1970, 1, 1),
        DateTime(1999, 12, 31),
        DateTime(2000, 1, 1),
        DateTime(2000, 1, 2),
        DateTime(2024, 2, 29), // leap day
        DateTime(2026, 9, 30),
        DateTime(2100, 12, 31),
      ];
      for (final date in dates) {
        final page = dateToPageIndex(date);
        expect(pageIndexToDate(page), date, reason: 'round-trip for $date');
      }
    });

    test('adjacent pages are adjacent days, forward and backward', () {
      final today = DateTime(2026, 9, 30);
      final page = dateToPageIndex(today);

      expect(pageIndexToDate(page + 1), DateTime(2026, 10, 1));
      expect(pageIndexToDate(page - 1), DateTime(2026, 9, 29));
    });

    test('crosses a year boundary correctly', () {
      final dec31 = DateTime(2025, 12, 31);
      final jan1 = DateTime(2026, 1, 1);
      expect(dateToPageIndex(jan1) - dateToPageIndex(dec31), 1);
    });

    test('crosses a leap-year February correctly', () {
      final feb28 = DateTime(2024, 2, 28);
      final feb29 = DateTime(2024, 2, 29);
      final mar1 = DateTime(2024, 3, 1);
      expect(dateToPageIndex(feb29) - dateToPageIndex(feb28), 1);
      expect(dateToPageIndex(mar1) - dateToPageIndex(feb29), 1);
    });

    test('non-leap year skips Feb 29', () {
      final feb28 = DateTime(2025, 2, 28);
      final mar1 = DateTime(2025, 3, 1);
      expect(dateToPageIndex(mar1) - dateToPageIndex(feb28), 1);
    });

    test('dates before the epoch are negative pages', () {
      expect(dateToPageIndex(DateTime(1999, 12, 31)), -1);
      expect(pageIndexToDate(-1), DateTime(1999, 12, 31));
    });

    test('century boundary (2000 is a leap year)', () {
      final feb28 = DateTime(2000, 2, 28);
      final feb29 = DateTime(2000, 2, 29);
      final mar1 = DateTime(2000, 3, 1);
      expect(dateToPageIndex(feb29) - dateToPageIndex(feb28), 1);
      expect(dateToPageIndex(mar1) - dateToPageIndex(feb29), 1);
    });

    test('non-leap century boundary (1900 is not a leap year)', () {
      final feb28 = DateTime(1900, 2, 28);
      final mar1 = DateTime(1900, 3, 1);
      expect(dateToPageIndex(mar1) - dateToPageIndex(feb28), 1);
    });
  });

  group('addDays (move to tomorrow / pick date logic)', () {
    test('adding 1 day is "move to tomorrow"', () {
      expect(addDays(DateTime(2026, 9, 30), 1), DateTime(2026, 10, 1));
    });

    test('adding a negative number moves backward', () {
      expect(addDays(DateTime(2026, 9, 30), -1), DateTime(2026, 9, 29));
    });

    test('adding 0 is a no-op', () {
      expect(addDays(DateTime(2026, 9, 30), 0), DateTime(2026, 9, 30));
    });

    test('crosses a year boundary', () {
      expect(addDays(DateTime(2025, 12, 31), 1), DateTime(2026, 1, 1));
    });

    test('crosses a leap day', () {
      expect(addDays(DateTime(2024, 2, 28), 1), DateTime(2024, 2, 29));
      expect(addDays(DateTime(2024, 2, 29), 1), DateTime(2024, 3, 1));
    });

    test('stays on the correct calendar day across a US DST spring-forward '
        'date (pure calendar math, not affected by the host timezone)', () {
      // 2026-03-08 is the US DST spring-forward date; date.add(Duration)
      // arithmetic on a local DateTime can misbehave here. addDays must
      // still land exactly one calendar day later.
      expect(addDays(DateTime(2026, 3, 8), 1), DateTime(2026, 3, 9));
    });

    test('multi-day moves (e.g. "pick a date a week out")', () {
      expect(addDays(DateTime(2026, 9, 30), 7), DateTime(2026, 10, 7));
    });
  });
}
