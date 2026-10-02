# CLAUDE.md — Daybook

Permanent rules for every Claude Code session in this repo. Full detail lives in `docs/SPEC.md`. **Read it before starting any milestone.** If this file and SPEC.md disagree, this file wins.

## What Daybook is
A personal calendar + to-do app. The main screen is a **full-screen single-day view** (swipe left/right to change day) with tasks grouped by **category** (Office, Personal, custom). Tasks can be **timed** ("meeting 9am"), **time-window** ("anytime 9–6"), or **untimed** ("no time"). Syncs across Android, iOS and web through Supabase. Single user, personal use.

Auth is **email + password only for now**. Google sign-in is deferred to a later task — do not build it until asked.

## Stack (do not change without asking)
- Flutter (stable channel), Dart 3, null-safety, targets: android, ios, web
- State: `flutter_riverpod` (with `riverpod_annotation` + codegen)
- Routing: `go_router`
- Local DB (offline-first): `drift` (SQLite; wasm on web)
- Backend: Supabase (Postgres, Auth, Realtime) via `supabase_flutter`
- Notifications: `flutter_local_notifications` + `timezone` + `flutter_timezone`
- Fonts: `google_fonts` (Inter, Fraunces)
- Models: `freezed` + `json_serializable`
- Tests: `flutter_test`, `mocktail`

## Non-negotiable rules
1. **Offline-first.** The UI reads and writes ONLY the local Drift DB. Never call Supabase directly from a widget. Only the sync layer talks to Supabase.
2. **Never hardcode** colors, font sizes, spacing or radii in widgets. Use theme tokens from `lib/core/theme/` (`DaybookColors`, `DaybookSpacing`, `DaybookText`). Support light and dark.
3. **Secrets:** only the Supabase URL and publishable key, passed via `--dart-define` or `.env` (git-ignored). Never commit keys. Never use the service-role key in the app. Use `publishableKey:` in `Supabase.initialize` (`anonKey` is deprecated).
4. **Row Level Security stays on** for every table. Any new table needs RLS policies in the same migration.
5. **Dates:** a task's `task_date` and times are *floating local* values (date + time-of-day, no timezone). Never convert them to UTC. Only `created_at`, `updated_at`, `deleted_at`, `completed_at` are UTC timestamps.
6. **Soft delete only** (`deleted_at`). Hard deletes break sync.
7. **Feature-first folders** (see SPEC §9). Widgets stay small; logic lives in providers/repositories, not widgets.
8. **Responsive:** every screen must work at 360px phone width and ≥1100px web width (two/three-pane on wide screens).
9. **Accessibility:** tap targets ≥ 48dp, text contrast ≥ 4.5:1, support system font scaling, add `Semantics` labels to icon-only buttons.
10. **No new dependency** without stating why and checking it supports android + ios + web.

## Workflow
- Work **one milestone at a time** (SPEC §11). Do not start the next until the current one's acceptance criteria pass.
- Before coding a milestone: restate the plan in a short bullet list and wait for a go-ahead if anything in the spec is ambiguous.
- After coding: run `dart format .`, `flutter analyze` (must be clean), `flutter test` (must pass). Report results.
- Write unit tests for: date logic, sort ordering, recurrence (when built), sync merge rules, quick-add parser, notification scheduling logic.
- Commit per milestone with a message like `M3: category sections + task CRUD`.
- Prefer small, reviewable diffs. Don't refactor unrelated code.
- If a requirement is missing or contradictory, **ask** instead of guessing.

## Commands
```
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run -d chrome --web-port=3000 --dart-define-from-file=env.json
flutter run --dart-define-from-file=env.json
flutter analyze && flutter test
```
`env.json` (git-ignored): `{ "SUPABASE_URL": "...", "SUPABASE_PUBLISHABLE_KEY": "..." }`

Web dev must run on port 3000 (`--web-port=3000`) — the Supabase project's Site URL is `http://localhost:3000`, and auth redirects (email confirmation, password reset) depend on it.

Web also needs `web/sqlite3.wasm` and `web/drift_worker.js` checked in (not fetched by `pub get`) — see README "Web setup" for where to download them and when to re-download after bumping `drift`/`sqlite3`.

## Sync notes (M5)
- First sync on a new device/user id wipes local tasks/categories/outbox **once** then pulls everything fresh (`SyncMeta.initialSyncDoneUserId`, checked by `needsInitialSync`). It must never run a second time for the same user id — don't "fix" stale-looking local data by re-triggering this; use "Sync now" in Settings instead.
- Sign-out pushes pending changes first, warns if any can't upload, then clears the local DB/outbox/cursors — it does not wipe on sign-in to the *same* user again.

## Notifications (Android) — gotchas (M6)
- **Manifest** (`android/app/src/main/AndroidManifest.xml`) needs `POST_NOTIFICATIONS`, `SCHEDULE_EXACT_ALARM`, `RECEIVE_BOOT_COMPLETED`, plus explicit `<receiver>` entries for `com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver` and `...ScheduledNotificationBootReceiver` — this plugin version ships no manifest of its own, so these are required, not optional.
- **`build.gradle.kts`** needs `isCoreLibraryDesugaringEnabled = true` + the `desugar_jdk_libs` dependency (already set) or the Android build fails.
- **Timezone init order matters**: `tz.initializeTimeZones()` then `tz.setLocalLocation(...)` must happen before any `zonedSchedule` call — `NotificationScheduler.initialize()`/`_applyLocalTimezone()` already handles this; don't call `zonedSchedule` before `initialize()` has completed.
- **Never call `_plugin.cancelAll()` inside `rescheduleAll()`.** It previously did, and since reschedule runs on *every* ambient trigger (resume, sync pull, any task write), it was silently wiping out anything else pending — including one-off debug test schedules. `rescheduleAll` now cancels only its own known ids (`notificationIdFor`) before rewriting them. `cancelAll()` the method still exists and is correct to use for sign-out.
- **Inexact alarms (`inexactAllowWhileIdle`, the default) can be deferred by Android's Doze/battery system for several minutes** — a 1-minute debug test not firing exactly on time is expected, not a bug. Use the exact-mode debug button (or the user's "Exact time" Settings toggle) to test precise delivery; it requires the `SCHEDULE_EXACT_ALARM` grant.
- **Debug tools** (debug builds only, Settings → Notifications): "Send test notification now" (`.show()`, immediate), "Schedule test in 1 minute" / "2 min (exact)" (real `zonedSchedule` path), "Show scheduled" (reads `pendingNotificationRequests()` — note this API does *not* return the actual trigger time, only id/title/body, so the list decodes the date from our own id scheme instead).
- To verify scheduling actually reached the OS (not just the in-app debug list), use `adb shell dumpsys alarm | grep -A3 daybook` and `adb shell dumpsys notification` — more reliable ground truth than anything the plugin reports back to Dart.

## Definition of done (every milestone)
Acceptance criteria met · analyzer clean · tests pass · works on Android emulator and Chrome · light and dark checked · no hardcoded style values · SPEC checklist ticked.
