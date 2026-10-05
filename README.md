# Daybook

A personal calendar + to-do app: a full-screen single-day view, tasks grouped by category, offline-first with two-way Supabase sync. See `docs/SPEC.md` for the full product and technical spec, and `CLAUDE.md` for the rules this repo is built under.

- Package/bundle id: `io.daybook.app` (Android `applicationId`/`namespace`, iOS bundle id, and the `io.daybook.app://login-callback` deep-link scheme all match — keep them that way if you ever change it).
- Version: `1.0.0+1` (`pubspec.yaml` — bump the build number on every release, the version on every user-visible change).

## Setup

1. **Supabase project** — create one, then follow `docs/SPEC.md` §5 "Supabase manual setup checklist": run the init SQL, enable email auth, set Auth → URL Configuration, confirm realtime replication is on for `tasks`/`categories`/`user_settings`.
2. **`env.json`** (git-ignored, create it yourself):
   ```json
   { "SUPABASE_URL": "...", "SUPABASE_PUBLISHABLE_KEY": "..." }
   ```
   Use the **publishable key**, never the service-role key (CLAUDE.md rule 3).
3. **Web Drift files** — see "Web setup (Drift/sqlite3 wasm)" below; not fetched by `pub get`.
4. ```
   flutter pub get
   dart run build_runner build --delete-conflicting-outputs
   ```

## Run

```
flutter run -d chrome --web-port=3000 --dart-define-from-file=env.json
flutter run --dart-define-from-file=env.json
flutter analyze && flutter test
```

**Web must run on port 3000** (`--web-port=3000`): the Supabase project's Site URL is set to `http://localhost:3000`, and auth flows (email confirmation, password reset) redirect back to the Site URL. Running on any other port breaks those redirects.

## Web setup (Drift/sqlite3 wasm)

The local database (Drift/SQLite, offline-first — see CLAUDE.md rule 1) runs on web via a wasm build of SQLite, in a worker so queries don't block the UI thread. That needs two binary/JS files checked into `web/`, which are **not** fetched by `flutter pub get`:

- `web/sqlite3.wasm` — from the `sqlite3` Dart package's GitHub release matching the `sqlite3` version pinned in `pubspec.lock`:
  `https://github.com/simolus3/sqlite3.dart/releases/download/sqlite3-<version>/sqlite3.wasm`
- `web/drift_worker.js` — from the `drift` package's GitHub release matching the `drift` version pinned in `pubspec.lock`:
  `https://github.com/simolus3/drift/releases/download/drift-<version>/drift_worker.js`

Currently pinned to **sqlite3 3.6.0** and **drift 2.35.0**.

**When you bump `drift` or `sqlite3` in `pubspec.yaml`:** re-download both files from the matching release tag above and replace the ones in `web/`. A mismatched `sqlite3.wasm`/`drift_worker.js` pair (or a pair that doesn't match the Dart-side package version) is a common source of web-only Drift errors, including `Invalid argument(s): When compiling to the web, the 'web' parameter needs to be set` if the files are missing entirely. The deployed site serves these with a short (1h) cache lifetime (`web/_headers`) specifically so a version bump reaches returning visitors promptly.

## First-sync rule (M5)

First sync on a new device/user id wipes local tasks/categories/outbox **once** then pulls everything fresh (`SyncMeta.initialSyncDoneUserId`, checked by `needsInitialSync`). It must never run a second time for the same user id — don't "fix" stale-looking local data by re-triggering this; use "Sync now" in Settings instead. Sign-out pushes pending changes first, warns if any can't upload, then clears the local DB/outbox/cursors — it does not wipe on sign-in to the *same* user again.

## Notifications (Android) — gotchas (M6)

- **Manifest** needs `POST_NOTIFICATIONS`, `SCHEDULE_EXACT_ALARM`, `RECEIVE_BOOT_COMPLETED`, plus explicit `<receiver>` entries for `ScheduledNotificationReceiver`/`ScheduledNotificationBootReceiver` — this plugin version ships no manifest of its own.
- **Timezone init order matters**: `tz.initializeTimeZones()` then `tz.setLocalLocation(...)` must happen before any `zonedSchedule` call.
- **Inexact alarms can be deferred by Doze/battery optimization for several minutes** — a 1-minute debug test not firing exactly on time is expected. Use the exact-mode debug button to test precise delivery (requires the `SCHEDULE_EXACT_ALARM` grant).
- **Debug tools** (debug builds only, Settings → Notifications → scroll down): "Send test notification now", "Schedule test in 1 minute" / "2 min (exact)", "Show scheduled". To verify scheduling actually reached the OS (not just the in-app debug list), use `adb shell dumpsys alarm | grep -A3 daybook` and `adb shell dumpsys notification`.
- These debug tools (and `/style-preview`) are gated behind `kDebugMode` in code (`lib/features/settings/notifications_settings_section.dart`, `lib/core/router/router.dart`) — a `flutter build apk --release`/`flutter build web --release` build compiles with `kDebugMode == false`, so they are structurally unreachable in release, not just hidden by a setting.

## Notification icon (M8 follow-up)

Android notifications use a dedicated small icon, `ic_stat_daybook` (`android/app/src/main/res/drawable-{m,h,x,xx,xxx}dpi/ic_stat_daybook.png`) — a white silhouette on a transparent background, set via `AndroidInitializationSettings('ic_stat_daybook')` and `icon: 'ic_stat_daybook'` on every `AndroidNotificationDetails` in `lib/data/notifications/notification_scheduler.dart`, with `color: DaybookColors.light.primary` for the accent tint. **Never point this at `@mipmap/ic_launcher`** — Android requires a monochrome silhouette for the status-bar icon and silently falls back to the default white Flutter logo if given a full-color image, which is exactly the bug this setup avoids.

To regenerate it (e.g. after changing the app's mark), edit and rerun `tool/gen_notification_icon.py` (`pip install Pillow` first) rather than hand-editing the PNGs — it draws a page-with-folded-corner glyph at 384px and downsamples to each density. `android/app/src/main/res/raw/keep.xml` protects the `ic_stat_*` drawables from R8 resource shrinking if it's ever turned on (shrinking is off today).

## Accessibility (M8)

- Semantics labels on every icon-only button, task tiles (title/category/time/status combined into one label), filter chips (selected state) and the checkbox (done/not-done), 48dp minimum tap targets, and the light/dark palette is 4.5:1-contrast-checked for all text usages (muted text, time chips, category "default" marker, error text) — `warning`/`danger` in the light theme were darkened slightly from the original M0 values to pass; see the comment in `lib/core/theme/colors.dart`.
- Web calls `SemanticsBinding.instance.ensureSemantics()` on startup (`lib/main.dart`) so the semantics tree exists immediately instead of only after Flutter detects a screen reader — this is what lets Lighthouse/axe find it at all.
  **What Lighthouse can and can't actually measure here, honestly:** Flutter web paints its UI to a `<canvas>`, not real styled DOM. `ensureSemantics()` makes Flutter also maintain a parallel, normally-invisible tree of real DOM nodes with ARIA roles/labels/bounding boxes positioned over the canvas — Lighthouse's audits that read the **DOM** (accessible-name-on-button/link/etc., focusable/tabbable elements, tap-target bounding-box size, ARIA role correctness) genuinely work against that tree and should reflect the Semantics work above. Lighthouse's **color-contrast** audit specifically samples a real DOM text node's computed CSS color against its background — since the visible text is canvas-painted pixels, not a styled DOM text node, that specific audit can't reliably see it; expect it to no-op or under-report regardless of the token fixes, which are correct for real users but not necessarily reflected in that one Lighthouse sub-score. Manual verification (a screen reader, a contrast picker on an actual screenshot) is the only way to be sure beyond what's in this repo.
- **Not verified in this repo**: a real screen reader pass (TalkBack/VoiceOver) and the actual Lighthouse score on the deployed URL — both require running the deployed site, which only you can do.

## Android release signing

Release builds use `android/key.properties` (git-ignored) if present, falling back to the debug keystore otherwise (so `flutter run --release` keeps working without one — see `android/app/build.gradle.kts`). **Generate your own upload keystore — never one Claude Code generates for you:**

```
keytool -genkey -v -keystore ~/upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Store `upload-keystore.jks` **outside the repo** (e.g. `~/keys/`, or wherever your password manager/backup covers) — it is never committed (`.gitignore` excludes `*.jks`, `*.keystore`, and `key.properties`). Then create `android/key.properties`:

```
storePassword=<your store password>
keyPassword=<your key password>
keyAlias=upload
storeFile=/absolute/path/to/upload-keystore.jks
```

**⚠️ Backup your keystore.** If you lose `upload-keystore.jks` or its password, you can never update the app under the same Play Store listing again — there is no recovery. Back it up somewhere durable (password manager attachment, encrypted cloud backup) the day you create it, before you ever upload a release.

Build and install:

```
flutter build apk --release --dart-define-from-file=env.json
adb install -r build/app/outputs/flutter-apk/app-release.apk
```

(R8/code shrinking is **not** currently enabled — `android/app/build.gradle.kts` doesn't set `isMinifyEnabled`, so nothing is being stripped and no keep rules are needed today. If you turn on minification later for a smaller APK, re-check that flutter_local_notifications' manifest-declared receivers and anything else referenced only by string/reflection still survive — Drift and Supabase are pure Dart, compiled by Flutter's own AOT pipeline, so R8 never touches them regardless.)

## Web deployment (Cloudflare Pages)

```
flutter build web --release --dart-define-from-file=env.json
```

`web/_redirects` (SPA rewrite so refreshing e.g. `/day/2026-03-05` doesn't 404) and `web/_headers` (serves `sqlite3.wasm` as `application/wasm`, short-caches it and `drift_worker.js`) are already in `web/` and get copied into `build/web/` by the build.

**Deploy steps:**
1. [dash.cloudflare.com](https://dash.cloudflare.com) → **Workers & Pages** → **Create** → **Pages** → **Upload assets** (or connect the git repo and set the build output directory to `build/web` if you want git-triggered deploys).
2. Project name: anything (e.g. `daybook`) — this becomes `<name>.pages.dev`.
3. Drag-and-drop (or point the build) at the **`build/web`** folder specifically, not the repo root.
4. Deploy. Cloudflare gives you a `https://<name>.pages.dev` URL.

(Or via Wrangler CLI: `npx wrangler pages deploy build/web --project-name=daybook`.)

**Then in Supabase → Authentication → URL Configuration**, add your deployed URL:
- Site URL: keep `http://localhost:3000` for development, or switch per-environment if you set up separate Supabase projects for dev/prod.
- Redirect URLs: add `https://<name>.pages.dev/**` alongside the existing `http://localhost:3000/**` and `io.daybook.app://login-callback` — **don't remove the localhost one**, it's still needed for local development.

**Not verified in this repo**: sign-in, sync, and the Drift database actually working on the deployed URL — that requires the live deployment, which only you can do. After deploying, sign in once and confirm a task created there appears after a refresh (confirms the wasm DB initialized) and on another device (confirms sync).

## iOS (not built yet)

The iOS project exists (bundle id `io.daybook.app`, deep-link scheme configured, icon/splash generated) but has never been built or run — that needs a Mac with Xcode, which this environment doesn't have access to verify beyond `flutter build web`/`apk`. Before building for iOS you'll need:
- An Apple Developer account (free for simulator/local device testing, paid $99/yr for TestFlight/App Store).
- To open `ios/Runner.xcworkspace` in Xcode and set your own Team under Signing & Capabilities.
- `flutter build ios` (simulator) or `flutter build ipa` (device/TestFlight), run from a Mac.
- Push/local notification permission usage strings in `Info.plist` if not already present (check before shipping — not audited here).
- Re-verify the deep link (`io.daybook.app://login-callback`) actually opens the app on a real device; iOS Universal Links are an alternative worth considering later if the custom scheme proves unreliable with some mail clients.

## Debug-only tools

Settings → Notifications (debug builds only) has test-notification buttons (see "Notifications" above) and `/style-preview` is a design reference route. Both are compiled out of release builds via `kDebugMode` — confirmed structurally, not just hidden by a runtime flag.
