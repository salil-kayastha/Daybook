import '../../domain/category.dart';
import '../../domain/enums.dart';
import '../../domain/local_time.dart';
import '../../domain/user_settings.dart';
import 'task_validation.dart';

enum QuickAddTokenKind { category, date, time }

/// One recognized span of the original input, for the live chip UI —
/// [rawText] is exactly what the user typed, so dismissing a chip can put
/// it back into the title verbatim (SPEC §7.4, M7).
class QuickAddToken {
  const QuickAddToken({required this.kind, required this.rawText});
  final QuickAddTokenKind kind;
  final String rawText;
}

class ParsedTask {
  const ParsedTask({
    required this.title,
    required this.categoryId,
    required this.categoryLabel,
    required this.taskDate,
    required this.timeMode,
    required this.startTime,
    required this.endTime,
    required this.tokens,
  });

  final String title;
  final String? categoryId;

  /// The matched category's name, for the chip label — null when
  /// [categoryId] just fell back to the default (nothing was typed/matched).
  final String? categoryLabel;
  final DateTime? taskDate;
  final TimeMode timeMode;
  final LocalTime? startTime;
  final LocalTime? endTime;
  final List<QuickAddToken> tokens;

  /// SPEC §7.4: empty title (after removing recognized tokens) is invalid.
  bool get isTitleValid => title.trim().isNotEmpty;

  /// Matches the DB `tasks_time_consistency` rule — a window needs
  /// `end > start`.
  String? get timeError => validateTaskTime(timeMode, startTime, endTime);

  bool get isValid => isTitleValid && timeError == null;
}

const _weekdayNames = [
  'monday',
  'tuesday',
  'wednesday',
  'thursday',
  'friday',
  'saturday',
  'sunday',
];
const _weekdayAbbrev = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];

/// Pure quick-add parser (SPEC §7.4, M7) — no I/O, fully unit-testable.
/// [settings] is accepted for API symmetry with other builders in this
/// codebase; nothing here currently depends on it (weekday resolution is
/// always "next strictly-future occurrence", independent of
/// `week_starts_on`).
ParsedTask parseQuickAdd(
  String text,
  DateTime now,
  List<Category> categories, {
  String? defaultCategoryId,
  UserSettings? settings,
  bool recognizeCategory = true,
  bool recognizeDate = true,
  bool recognizeTime = true,
}) {
  var remaining = text;
  final tokens = <QuickAddToken>[];

  String? categoryId;
  String? categoryLabel;
  if (recognizeCategory) {
    final match = RegExp(r'#(\w+)').firstMatch(remaining);
    if (match != null) {
      final tag = match.group(1)!.toLowerCase();
      final active = categories.where((c) => !c.isArchived).toList();
      final candidates = active
          .where((c) => c.name.toLowerCase().startsWith(tag))
          .toList();
      if (candidates.length == 1) {
        categoryId = candidates.single.id;
        categoryLabel = candidates.single.name;
        tokens.add(
          QuickAddToken(kind: QuickAddTokenKind.category, rawText: match[0]!),
        );
        remaining = _removeSpan(remaining, match.start, match.end);
      }
      // Unknown or ambiguous prefix: leave the raw "#tag" in the title.
    }
  }

  DateTime? taskDate;
  if (recognizeDate) {
    final today = DateTime(now.year, now.month, now.day);
    final result = _extractDate(remaining, today);
    if (result != null) {
      taskDate = result.date;
      tokens.add(
        QuickAddToken(kind: QuickAddTokenKind.date, rawText: result.rawText),
      );
      remaining = _removeSpan(remaining, result.start, result.end);
    }
  }

  var timeMode = TimeMode.none;
  LocalTime? startTime;
  LocalTime? endTime;
  if (recognizeTime) {
    final result = _extractTime(remaining);
    if (result != null) {
      timeMode = result.timeMode;
      startTime = result.start;
      endTime = result.end;
      tokens.add(
        QuickAddToken(kind: QuickAddTokenKind.time, rawText: result.rawText),
      );
      remaining = _removeSpan(remaining, result.spanStart, result.spanEnd);
    }
  }

  final title = remaining.replaceAll(RegExp(r'\s+'), ' ').trim();

  return ParsedTask(
    title: title,
    categoryId: categoryId ?? defaultCategoryId,
    categoryLabel: categoryLabel,
    taskDate: taskDate,
    timeMode: timeMode,
    startTime: startTime,
    endTime: endTime,
    tokens: tokens,
  );
}

String _removeSpan(String s, int start, int end) {
  return '${s.substring(0, start)} ${s.substring(end)}';
}

class _DateMatch {
  const _DateMatch(this.date, this.rawText, this.start, this.end);
  final DateTime date;
  final String rawText;
  final int start;
  final int end;
}

_DateMatch? _extractDate(String text, DateTime today) {
  final todayMatch = RegExp(
    r'\btoday\b',
    caseSensitive: false,
  ).firstMatch(text);
  if (todayMatch != null) {
    return _DateMatch(today, todayMatch[0]!, todayMatch.start, todayMatch.end);
  }

  final tomorrowMatch = RegExp(
    r'\btomorrow\b',
    caseSensitive: false,
  ).firstMatch(text);
  if (tomorrowMatch != null) {
    return _DateMatch(
      today.add(const Duration(days: 1)),
      tomorrowMatch[0]!,
      tomorrowMatch.start,
      tomorrowMatch.end,
    );
  }

  // Full names before abbreviations so "monday" isn't left with a dangling
  // "day" after a premature "mon" match.
  for (var i = 0; i < 7; i++) {
    final match = RegExp(
      '\\b${_weekdayNames[i]}\\b',
      caseSensitive: false,
    ).firstMatch(text);
    if (match != null) {
      return _DateMatch(
        _nextWeekday(today, i),
        match[0]!,
        match.start,
        match.end,
      );
    }
  }
  for (var i = 0; i < 7; i++) {
    final match = RegExp(
      '\\b${_weekdayAbbrev[i]}\\b',
      caseSensitive: false,
    ).firstMatch(text);
    if (match != null) {
      return _DateMatch(
        _nextWeekday(today, i),
        match[0]!,
        match.start,
        match.end,
      );
    }
  }

  final numeric = RegExp(r'\b(\d{1,2})/(\d{1,2})(?:/(\d{2,4}))?\b')
      .firstMatch(text);
  if (numeric != null) {
    final day = int.parse(numeric.group(1)!);
    final month = int.parse(numeric.group(2)!);
    final yearGroup = numeric.group(3);
    var year = yearGroup != null ? int.parse(yearGroup) : today.year;
    if (yearGroup != null && yearGroup.length == 2) year += 2000;
    if (month < 1 || month > 12 || day < 1 || day > 31) return null;
    var date = DateTime(year, month, day);
    if (date.month != month) return null; // e.g. 31/02 doesn't exist
    if (date.isBefore(today)) {
      date = DateTime(year + 1, month, day);
    }
    return _DateMatch(date, numeric[0]!, numeric.start, numeric.end);
  }

  return null;
}

/// 0 = Monday .. 6 = Sunday. Always strictly in the future — "today" must
/// be said explicitly to mean today (SPEC §7.4).
DateTime _nextWeekday(DateTime today, int targetIndex) {
  final todayIndex = today.weekday - 1; // DateTime.monday == 1
  var delta = (targetIndex - todayIndex) % 7;
  if (delta <= 0) delta += 7;
  return today.add(Duration(days: delta));
}

class _TimeMatch {
  const _TimeMatch({
    required this.timeMode,
    required this.start,
    required this.end,
    required this.rawText,
    required this.spanStart,
    required this.spanEnd,
  });
  final TimeMode timeMode;
  final LocalTime start;
  final LocalTime? end;
  final String rawText;
  final int spanStart;
  final int spanEnd;
}

_TimeMatch? _extractTime(String text) {
  final rangeRe = RegExp(
    r'\b(\d{1,2})(?::(\d{2}))?\s*(am|pm)?\s*-\s*(\d{1,2})(?::(\d{2}))?\s*(am|pm)?\b',
    caseSensitive: false,
  );
  final range = rangeRe.firstMatch(text);
  if (range != null) {
    var startHour = int.parse(range.group(1)!);
    final startMinute = int.parse(range.group(2) ?? '0');
    final startMeridiem = range.group(3)?.toLowerCase();
    var endHour = int.parse(range.group(4)!);
    final endMinute = int.parse(range.group(5) ?? '0');
    final endMeridiem = range.group(6)?.toLowerCase();

    if (startMeridiem != null && endMeridiem != null) {
      startHour = _to24Hour(startHour, startMeridiem);
      endHour = _to24Hour(endHour, endMeridiem);
    } else if (startMeridiem != null) {
      // Only the start gave am/pm ("9am-6"): assume the end shares it,
      // unless that reads backwards and a PM bump fixes it ("9am-6" =>
      // 09:00-18:00, not 09:00-06:00).
      startHour = _to24Hour(startHour, startMeridiem);
      var candidateEnd = _to24Hour(endHour, startMeridiem);
      if (candidateEnd <= startHour && candidateEnd + 12 <= 23) {
        candidateEnd += 12;
      }
      endHour = candidateEnd;
    } else if (endMeridiem != null) {
      // Only the end gave am/pm ("2-3pm"): assume the start shares it,
      // same fallback ("2-3pm" => 14:00-15:00, not 02:00-15:00).
      endHour = _to24Hour(endHour, endMeridiem);
      var candidateStart = _to24Hour(startHour, endMeridiem);
      if (candidateStart >= endHour && candidateStart - 12 >= 0) {
        candidateStart -= 12;
      }
      startHour = candidateStart;
    } else {
      // Neither side gave am/pm: if the end looks smaller than the start,
      // assume the end is PM ("9-6" => 09:00-18:00; "12-1" => 12:00-13:00).
      if (endHour < startHour && endHour < 12) endHour += 12;
    }
    if (startHour > 23 || endHour > 23) return null;

    // "anytime"/"between" anywhere in the text turns the range into a
    // window (SPEC §7.4) — fold the keyword into the same time token.
    final keyword = RegExp(
      r'\b(anytime|between)\b',
      caseSensitive: false,
    ).firstMatch(text);
    final isWindow = keyword != null;

    var spanStart = range.start;
    var spanEnd = range.end;
    if (keyword != null) {
      if (keyword.start < spanStart) spanStart = keyword.start;
      if (keyword.end > spanEnd) spanEnd = keyword.end;
    }
    final rawText = isWindow ? text.substring(spanStart, spanEnd) : range[0]!;

    return _TimeMatch(
      timeMode: isWindow ? TimeMode.window : TimeMode.at,
      start: LocalTime(startHour, startMinute),
      end: LocalTime(endHour, endMinute),
      rawText: rawText,
      spanStart: isWindow ? spanStart : range.start,
      spanEnd: isWindow ? spanEnd : range.end,
    );
  }

  final singleRe = RegExp(
    r'\b(\d{1,2})(?::(\d{2}))?\s*(am|pm)?\b',
    caseSensitive: false,
  );
  for (final match in singleRe.allMatches(text)) {
    final meridiem = match.group(3)?.toLowerCase();
    final hour = int.parse(match.group(1)!);
    final minute = int.parse(match.group(2) ?? '0');
    if (meridiem == null && hour < 13) {
      continue; // ambiguous bare number (e.g. plain "9") — not a time.
    }
    if (hour > 23) continue;
    final resolvedHour = meridiem != null ? _to24Hour(hour, meridiem) : hour;
    return _TimeMatch(
      timeMode: TimeMode.at,
      start: LocalTime(resolvedHour, minute),
      end: null,
      rawText: match[0]!,
      spanStart: match.start,
      spanEnd: match.end,
    );
  }

  return null;
}

int _to24Hour(int hour12, String meridiem) {
  final h = hour12 % 12;
  return meridiem == 'pm' ? h + 12 : h;
}
