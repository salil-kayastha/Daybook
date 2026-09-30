import '../../core/utils/date_page.dart';

/// `PageView` needs non-negative indices, but [dateToPageIndex] can be
/// negative (dates before the epoch). These helpers shift the pure
/// date<->page mapping into a `[0, dayPageCount)` window spanning roughly
/// 100 years either side of the epoch — plenty for a personal daybook.
const int dayPageWindowYears = 100;
const int dayPageOffset = 365 * dayPageWindowYears;
const int dayPageCount = dayPageOffset * 2;

int controllerIndexForDate(DateTime date) =>
    dateToPageIndex(date) + dayPageOffset;

DateTime dateForControllerIndex(int index) =>
    pageIndexToDate(index - dayPageOffset);
