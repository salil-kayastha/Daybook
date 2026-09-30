/// Fractional-index midpoint for drag-reordering (SPEC M3): the moved row
/// gets a new `sortOrder` strictly between its new neighbors, so every
/// other row's `sortOrder` stays untouched. Pass `null` for a missing
/// neighbor (top/bottom of the list).
double sortOrderBetween(double? before, double? after) {
  if (before == null && after == null) return 0;
  if (before == null) return after! - 1;
  if (after == null) return before + 1;
  return (before + after) / 2;
}

/// The `sortOrder` a newly-created row should get to land at the end of
/// [existingOrders] (empty list -> 0).
double sortOrderAppendingTo(Iterable<double> existingOrders) {
  if (existingOrders.isEmpty) return 0;
  return existingOrders.reduce((a, b) => a > b ? a : b) + 1;
}
