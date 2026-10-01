/// Generic "fetch pages until a short page" pull loop (SPEC §10 M5):
/// `where updated_at > cursor order by updated_at limit pageSize`, looping
/// until a page comes back shorter than [pageSize]. Kept generic/pure (no
/// Supabase types) so it's unit-testable with a fake [fetchPage].
Future<void> pullAllPages<T>({
  required DateTime? initialCursor,
  required Future<List<T>> Function(DateTime? cursor, int limit) fetchPage,
  required DateTime Function(T row) updatedAtOf,
  required Future<void> Function(List<T> rows) applyPage,
  int pageSize = 500,
}) async {
  var cursor = initialCursor;
  while (true) {
    final page = await fetchPage(cursor, pageSize);
    if (page.isEmpty) return;
    await applyPage(page);
    cursor = updatedAtOf(page.last);
    if (page.length < pageSize) return;
  }
}
