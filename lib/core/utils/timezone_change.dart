/// Pure decision for SPEC §8's "re-detect the zone at every start": the
/// scheduler always re-queries the device zone, but only actually calls
/// `tz.setLocalLocation` (and therefore only needs to reschedule because of
/// a zone change specifically) when it's different from what was already
/// active.
bool shouldUpdateTimezone({
  required String? previousZoneId,
  required String newZoneId,
}) {
  return previousZoneId != newZoneId;
}
