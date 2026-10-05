import '../../core/utils/date_page.dart';

/// `PageView` needs non-negative indices, but [dateToPageIndex] can be
/// negative (dates before the epoch). These helpers shift the pure
/// date<->page mapping into a `[0, dayPageCount)` window spanning roughly
/// [dayPageWindowYears] years either side of *today* — plenty for a
/// personal daybook.
///
/// Deliberately centered on today (computed once, at app start) rather
/// than on the fixed [dayScreenEpoch] (2000-01-01): a window centered on
/// a fixed epoch only stays small near that epoch, and grows without
/// bound as real time moves away from it. By late 2026 a ±100-year
/// epoch-centered window already put "today" ~46,000 pages in, giving
/// `PageView` a ~19-million-pixel initial scroll offset — large enough to
/// trip `RenderSliverFixedExtentBoxAdaptor`'s floating-point precision
/// (`computeMaxScrollOffset()` not landing on an exact multiple of
/// `itemExtent`), which debug builds catch as a layout assertion
/// (`RenderBox.size accessed beyond the scope of resize...`, `Null check
/// operator used on a null value`) and release builds silently tolerate —
/// the exact cause of the "blank screen in debug, fine in release" bug.
/// Re-centering on today keeps the index — and so the pixel offset —
/// bounded to roughly [dayPageWindowYears] years no matter what year it
/// actually is, permanently, not just today.
const int dayPageWindowYears = 50;
final int _dayPageWindowDays = 365 * dayPageWindowYears;
final int dayPageOffset = _dayPageWindowDays - dateToPageIndex(DateTime.now());
final int dayPageCount = _dayPageWindowDays * 2;

int controllerIndexForDate(DateTime date) =>
    dateToPageIndex(date) + dayPageOffset;

DateTime dateForControllerIndex(int index) =>
    pageIndexToDate(index - dayPageOffset);
