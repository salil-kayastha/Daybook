import 'package:daybook/core/utils/quick_add_parser.dart';
import 'package:daybook/domain/category.dart';
import 'package:daybook/domain/enums.dart';
import 'package:daybook/domain/local_time.dart';
import 'package:flutter_test/flutter_test.dart';

Category _cat(String id, String name, {bool archived = false}) {
  final now = DateTime.utc(2026, 1, 1);
  return Category(
    id: id,
    name: name,
    color: '#4C6EF5',
    sortOrder: 0,
    isArchived: archived,
    createdAt: now,
    updatedAt: now,
  );
}

void main() {
  // A fixed Thursday so weekday-relative tests are deterministic.
  final thursday = DateTime(2026, 1, 1, 10);
  final categories = [
    _cat('office', 'Office'),
    _cat('personal', 'Personal'),
    _cat('health', 'Health'),
    _cat('home', 'Home'),
    _cat('homework', 'Homework'),
    _cat('archived-cat', 'Archived', archived: true),
  ];

  ParsedTask parse(String text, {DateTime? now, String? defaultCategoryId}) {
    return parseQuickAdd(
      text,
      now ?? thursday,
      categories,
      defaultCategoryId: defaultCategoryId,
    );
  }

  group('category (#tag)', () {
    test('case-insensitive unique-prefix match', () {
      final r = parse('meeting 9am #office');
      expect(r.categoryId, 'office');
      expect(r.title, 'meeting');
    });

    test('unknown tag stays in the title, falls back to default category', () {
      final r = parse('#nonexistent do thing', defaultCategoryId: 'office');
      expect(r.categoryId, 'office');
      expect(r.title, '#nonexistent do thing');
    });

    test('ambiguous prefix (matches two categories) is not recognized', () {
      final r = parse('fix bug #ho', defaultCategoryId: 'office');
      expect(r.categoryId, 'office'); // falls back, #ho stays unmatched
      expect(r.title, 'fix bug #ho');
    });

    test('archived categories are never matched', () {
      final r = parse('#archived thing', defaultCategoryId: 'office');
      expect(r.categoryId, 'office');
      expect(r.title, '#archived thing');
    });
  });

  group('dates', () {
    test('"today" must be explicit', () {
      final r = parse('standup today');
      expect(r.taskDate, DateTime(2026, 1, 1));
      expect(r.title, 'standup');
    });

    test('"tomorrow"', () {
      final r = parse('buy bike parts tomorrow #personal');
      expect(r.taskDate, DateTime(2026, 1, 2));
      expect(r.categoryId, 'personal');
      expect(r.title, 'buy bike parts');
    });

    test('weekday abbreviation, e.g. "mon"', () {
      // thursday = 2026-01-01; next Monday is 2026-01-05.
      final r = parse('gym mon 6:30am #health');
      expect(r.taskDate, DateTime(2026, 1, 5));
      expect(r.startTime, const LocalTime(6, 30));
      expect(r.categoryId, 'health');
      expect(r.title, 'gym');
    });

    test('full weekday name, e.g. "monday"', () {
      final r = parse('standup monday');
      expect(r.taskDate, DateTime(2026, 1, 5));
      expect(r.title, 'standup');
    });

    test('"mon" inside "monitor" is never a weekday', () {
      final r = parse('monitor setup');
      expect(r.taskDate, isNull);
      expect(r.title, 'monitor setup');
    });

    test('"sat" inside "satellite" is never a weekday', () {
      final r = parse('fix satellite dish');
      expect(r.taskDate, isNull);
      expect(r.title, 'fix satellite dish');
    });

    test('"sat" on a Saturday means NEXT Saturday (7 days out)', () {
      final saturday = DateTime(2026, 1, 3, 10); // 2026-01-03 is a Saturday
      final r = parse('park run sat', now: saturday);
      expect(r.taskDate, DateTime(2026, 1, 10));
    });

    test('"sat" on a Friday means tomorrow', () {
      final friday = DateTime(2026, 1, 2, 10); // 2026-01-02 is a Friday
      final r = parse('park run sat', now: friday);
      expect(r.taskDate, DateTime(2026, 1, 3));
    });

    test('dd/mm', () {
      final r = parse('pay rent 5/10');
      expect(r.taskDate, DateTime(2026, 10, 5));
      expect(r.title, 'pay rent');
    });

    test('dd/mm/yyyy', () {
      final r = parse('book flight 20/6/2027');
      expect(r.taskDate, DateTime(2027, 6, 20));
    });

    test('no yesterday / no past dates: rolls dd/mm to next year', () {
      // thursday = 2026-01-01; "31/12" without a year would be in the
      // past relative to... actually 31/12/2026 is still ahead of
      // 2026-01-01, so use a date already passed this year instead.
      final laterInYear = DateTime(2026, 6, 15, 10);
      final r = parse('anniversary 1/1', now: laterInYear);
      expect(r.taskDate, DateTime(2027, 1, 1));
    });

    test('year boundary: date still ahead this year is not rolled', () {
      final r = parse('nye party 31/12'); // now = 2026-01-01
      expect(r.taskDate, DateTime(2026, 12, 31));
    });

    test('end-of-month date', () {
      final r = parse('report due 28/2');
      expect(r.taskDate, DateTime(2026, 2, 28));
    });

    test('leap day in a leap year is valid', () {
      final r = parse('leap party 29/2', now: DateTime(2028, 1, 1, 10));
      expect(r.taskDate, DateTime(2028, 2, 29));
    });

    test(
      'leap day in a non-leap year does not match (invalid calendar date)',
      () {
        final r = parse('leap party 29/2', now: DateTime(2026, 1, 1, 10));
        expect(r.taskDate, isNull);
        expect(r.title, 'leap party 29/2');
      },
    );
  });

  group('times', () {
    test('9am', () {
      final r = parse('meeting 9am #office');
      expect(r.timeMode, TimeMode.at);
      expect(r.startTime, const LocalTime(9, 0));
      expect(r.endTime, isNull);
    });

    test('9:30am', () {
      final r = parse('call 9:30am');
      expect(r.startTime, const LocalTime(9, 30));
    });

    test('24h "14:30"', () {
      final r = parse('standup 14:30');
      expect(r.startTime, const LocalTime(14, 30));
      expect(r.timeMode, TimeMode.at);
    });

    test('9pm', () {
      final r = parse('call mom 7pm');
      expect(r.startTime, const LocalTime(19, 0));
      expect(r.title, 'call mom');
    });

    test('bare range "9-6" => 09:00 to 18:00, mode "at"', () {
      final r = parse('errand 9-6');
      expect(r.timeMode, TimeMode.at);
      expect(r.startTime, const LocalTime(9, 0));
      expect(r.endTime, const LocalTime(18, 0));
    });

    test('"lunch 12-1" => 12:00 to 13:00', () {
      final r = parse('lunch 12-1');
      expect(r.startTime, const LocalTime(12, 0));
      expect(r.endTime, const LocalTime(13, 0));
      expect(r.title, 'lunch');
    });

    test('"report 14:30-16:00" stays 24h, mode "at"', () {
      final r = parse('report 14:30-16:00');
      expect(r.timeMode, TimeMode.at);
      expect(r.startTime, const LocalTime(14, 30));
      expect(r.endTime, const LocalTime(16, 0));
    });

    test('explicit meridiem range "9am-6pm"', () {
      final r = parse('shift 9am-6pm');
      expect(r.startTime, const LocalTime(9, 0));
      expect(r.endTime, const LocalTime(18, 0));
    });

    test(
      'meridiem on the end only "2-3pm" => 14:00-15:00, not 02:00-15:00',
      () {
        final r = parse('call 2-3pm');
        expect(r.startTime, const LocalTime(14, 0));
        expect(r.endTime, const LocalTime(15, 0));
      },
    );

    test('meridiem on the start only "9am-6" => 09:00-18:00', () {
      final r = parse('shift 9am-6');
      expect(r.startTime, const LocalTime(9, 0));
      expect(r.endTime, const LocalTime(18, 0));
    });

    test('"anytime" turns a range into a window', () {
      final r = parse('watch videos 9-6 anytime');
      expect(r.timeMode, TimeMode.window);
      expect(r.startTime, const LocalTime(9, 0));
      expect(r.endTime, const LocalTime(18, 0));
      expect(r.title, 'watch videos');
    });

    test('"between" turns a range into a window: "10-2 between"', () {
      final r = parse('plan 10-2 between');
      expect(r.timeMode, TimeMode.window);
      expect(r.startTime, const LocalTime(10, 0));
      expect(r.endTime, const LocalTime(14, 0));
    });

    test('window validation matches the DB rule (end > start)', () {
      // Can't easily produce an invalid window via the parser's own PM-
      // bump heuristic, so this checks the exposed validation directly.
      const r = ParsedTask(
        title: 'x',
        categoryId: null,
        categoryLabel: null,
        taskDate: null,
        timeMode: TimeMode.window,
        startTime: LocalTime(10, 0),
        endTime: LocalTime(10, 0),
        tokens: [],
      );
      expect(r.timeError, isNotNull);
      expect(r.isValid, isFalse);
    });
  });

  group('title extraction', () {
    test('"tomorrow" alone is invalid (empty title)', () {
      final r = parse('tomorrow');
      expect(r.title, isEmpty);
      expect(r.isValid, isFalse);
    });

    test('duplicate spaces collapse in the title', () {
      final r = parse('buy   milk    today');
      expect(r.title, 'buy milk');
    });

    test('uppercase input still recognizes tokens', () {
      final r = parse('MEETING 9AM #OFFICE');
      expect(r.categoryId, 'office');
      expect(r.startTime, const LocalTime(9, 0));
      expect(r.title, 'MEETING');
    });

    test('plain text with no recognizable tokens is valid as-is', () {
      final r = parse('write blog post');
      expect(r.title, 'write blog post');
      expect(r.taskDate, isNull);
      expect(r.timeMode, TimeMode.none);
      expect(r.isValid, isTrue);
    });
  });

  group('dismissing a chip (recognize flags)', () {
    test('disabling date recognition leaves the raw words in the title', () {
      final r = parseQuickAdd(
        'buy milk tomorrow',
        thursday,
        categories,
        recognizeDate: false,
      );
      expect(r.taskDate, isNull);
      expect(r.title, 'buy milk tomorrow');
    });

    test('disabling category recognition leaves the raw tag in the title', () {
      final r = parseQuickAdd(
        'meeting #office',
        thursday,
        categories,
        recognizeCategory: false,
      );
      expect(r.categoryId, isNull);
      expect(r.title, 'meeting #office');
    });

    test('disabling time recognition leaves the raw time in the title', () {
      final r = parseQuickAdd(
        'call 9am',
        thursday,
        categories,
        recognizeTime: false,
      );
      expect(r.timeMode, TimeMode.none);
      expect(r.title, 'call 9am');
    });
  });
}
