# Daybook

A personal calendar + to-do app. See `docs/SPEC.md` for the full product and technical spec, and `CLAUDE.md` for the rules this repo is built under.

## Setup

```
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run -d chrome --web-port=3000 --dart-define-from-file=env.json
flutter run --dart-define-from-file=env.json
flutter analyze && flutter test
```

`env.json` (git-ignored): `{ "SUPABASE_URL": "...", "SUPABASE_PUBLISHABLE_KEY": "..." }`

**Web must run on port 3000** (`--web-port=3000`): the Supabase project's Site URL is set to `http://localhost:3000`, and auth flows (email confirmation, password reset) redirect back to the Site URL. Running on any other port breaks those redirects.

## Web setup (Drift/sqlite3 wasm)

The local database (Drift/SQLite, offline-first — see CLAUDE.md rule 1) runs on web via a wasm build of SQLite, in a worker so queries don't block the UI thread. That needs two binary/JS files checked into `web/`, which are **not** fetched by `flutter pub get`:

- `web/sqlite3.wasm` — from the `sqlite3` Dart package's GitHub release matching the `sqlite3` version pinned in `pubspec.lock`:
  `https://github.com/simolus3/sqlite3.dart/releases/download/sqlite3-<version>/sqlite3.wasm`
- `web/drift_worker.js` — from the `drift` package's GitHub release matching the `drift` version pinned in `pubspec.lock`:
  `https://github.com/simolus3/drift/releases/download/drift-<version>/drift_worker.js`

Currently pinned to **sqlite3 3.6.0** and **drift 2.35.0**.

**When you bump `drift` or `sqlite3` in `pubspec.yaml`:** re-download both files from the matching release tag above and replace the ones in `web/`. A mismatched `sqlite3.wasm`/`drift_worker.js` pair (or a pair that doesn't match the Dart-side package version) is a common source of web-only Drift errors, including `Invalid argument(s): When compiling to the web, the 'web' parameter needs to be set` if the files are missing entirely.

## Notifications debug tools (debug builds only)

Settings → Notifications (scroll down) has a DEBUG section: "Send test notification now" (fires immediately), "Schedule test in 1 minute" / "2 min (exact)" (schedules via the real code path, not a shortcut), and "Show scheduled" (lists what's currently pending). See CLAUDE.md "Notifications (Android) — gotchas" for what to check when a scheduled notification doesn't fire — in particular, `adb shell dumpsys alarm` is more trustworthy than the in-app list for confirming something actually reached the OS.
