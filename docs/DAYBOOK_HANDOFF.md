# Daybook: Project Handoff

*Last updated: 2 October 2026. Save a copy in the repo as `docs/STATUS.md`. Contains no secrets.*

## 1. What Daybook is
A personal calendar + to-do app by Salil Kayastha. Main screen is a **full-screen single-day view** (swipe left/right to change day) with tasks grouped by **category**. Tasks are **timed**, **time-window** ("anytime 9-6") or **untimed**. Syncs across Android and web through Supabase. Built by Claude Code from `CLAUDE.md` and `docs/SPEC.md`, one milestone at a time. iOS is not built yet.

## 2. Status

| Milestone | What | Status |
|---|---|---|
| M0 | Setup, theme tokens, style preview (indigo palette chosen, terracotta rejected) | Done |
| M1 | Local Drift DB + swipeable Day screen (web fix for Drift added) | Done |
| M2 | Task CRUD, details sheet, done/cancelled, move to tomorrow | Done |
| M3 | Category management + filter chips (dropdown overflow fixed) | Done |
| M4 | Email + password auth (Google skipped), session persistence | Done |
| M5 | Offline-first sync (outbox, push, pull, realtime) | Done, tested on Chrome + Android |
| M6 | Local notifications (morning summary, evening "plan tomorrow") | Done after a scheduling fix |
| M7 | Web polish: 3 layouts, keyboard shortcuts, quick-add parser (187 tests passing at that point) | Done |
| M8 | Polish, accessibility, identity, release setup, docs | Done |

**MVP (SPEC Phase 1) is complete.** Daybook 1.0 is in a one-week personal beta, then a small friends beta.

## 3. Key decisions (and why)
- **Flutter + Riverpod + go_router + Drift + Supabase.** Drift is the source of truth; the UI never calls Supabase directly (offline-first).
- **Sync:** outbox + push in dependency order (categories, tasks, settings); pull by **server** `updated_at` cursor; **last-write-wins**; realtime events only trigger a pull; soft delete only (`deleted_at`).
- **Floating local date/time:** `task_date` and times are never converted to UTC, so "9 AM" stays 9 AM.
- **Notifications are local**, scheduled on the device (7-day rolling window). Server push is a later option.
- **Task tiles have no horizontal swipe** (conflicts with day swiping). Actions live in a long-press menu and the details sheet.
- **Auth:** email + password only for now. Google sign-in is deferred.
- **Design:** warm paper background, indigo primary `#3B5BDB`, Fraunces for the date, Inter for text. Tokens live in `lib/core/theme/`; no hardcoded colours or sizes in widgets.

## 4. Environments (non-secret identifiers)
- **Web (live):** https://daybook.salilkayastha.com.np, hosted on Cloudflare Pages. Pages project name is **`daybook-c0o`** (default address `daybook-c0o.pages.dev`). DNS for `salilkayastha.com.np` is on Cloudflare; CNAME `daybook` points to `daybook-c0o.pages.dev`.
- **Supabase:** project URL `https://uknwpxnkzmfrvciyrvnn.supabase.co`. Tables: `categories`, `tasks`, `user_settings` (RLS on). A signup trigger creates Office + Personal categories and a settings row.
- **Supabase Auth URLs:** Site URL = the custom domain. Redirect URLs include the custom domain, `daybook-c0o.pages.dev`, `http://localhost:3000/**` and `io.daybook.app://login-callback`.
- **Android:** package/bundle id `io.daybook.app` (placeholder, change before any store release). Version 1.0.0+N: raise N for every APK.
- **Secrets live only in** `env.json` (keys `SUPABASE_URL`, `SUPABASE_PUBLISHABLE_KEY`) and `key.properties` + the release keystore. All git-ignored. **Back up the keystore in two places.**
- **Commands**
  - Web dev: `flutter run -d chrome --web-port=3000 --dart-define-from-file=env.json`
  - Phone: `flutter run --dart-define-from-file=env.json`
  - Android release: `flutter build apk --release --dart-define-from-file=env.json`
  - Web build + deploy: `flutter build web --release --dart-define-from-file=env.json` then `npx wrangler pages deploy build/web --project-name daybook-c0o`

## 5. Gotchas already solved (do not rediscover)
1. **Drift on web** needs `sqlite3.wasm` and `drift_worker.js` in `web/` plus the `web:` option. Replace both whenever drift/sqlite3 versions change. Stop and restart the app after changing `web/` files.
2. **Key rename:** use `publishableKey:` (the `anonKey` parameter is deprecated) and `SUPABASE_PUBLISHABLE_KEY`.
3. **First sync wipes local test data once** per user id, then pulls the server's data. Sign-out pushes pending changes (warns if some fail) and then clears local data.
4. **Release builds:** INTERNET permission must be in the **main** manifest. R8 is off. Debug tools are hidden in release.
5. **Notifications:** timezone must be initialised and the local zone set before scheduling; manifest receivers and core-library desugaring are required; inexact scheduling is the default; Android battery must be **Unrestricted** for Daybook; iOS permission is requested after the first task. Known limit: morning text is computed when scheduled, so it can be stale until the app syncs.
6. **Notification small icon is separate from the launcher icon.** It must be a white-on-transparent silhouette (`ic_stat_daybook`).
7. **Cloudflare:** the long per-deployment preview URL (`<id>.daybook-c0o.pages.dev`) failed with an SSL error, while the main address works. A custom domain needs **both** the DNS record **and** adding it under Pages, Custom domains.
8. **Web routing is hash-style** (`/#/auth`). Email confirmation and password-reset links on the live domain must be tested. If they fail, switch to path URLs (the `_redirects` file already supports it).
9. **Supabase free tier:** projects pause after about a week of no activity (use Restore). The built-in email sender has a small hourly limit, so friends should sign up one at a time.
10. **Category dropdown overflow** was fixed in the shared picker; keep using that widget.

## 6. Open items (check these first)
- [ ] **Notification icon fix** (Daybook "D" silhouette instead of the Flutter logo). Prompt was given; confirm it is done and verified after a clean reinstall.
- [ ] Commit M8 and the icon fix; bump the build number; build and test the release APK on your own phone (sync, a reminder with the app closed, no debug tools).
- [ ] Test **email confirmation and password-reset links** on the live domain.
- [ ] Share `daybook.apk` + `Daybook_Beta_Guide.pdf` with friends. Add the real logo to the guide cover (the cover currently has a stand-in "D").
- [ ] Verify two guide statements: typed quick-add shortcuts on the phone, and dark mode following the system setting.
- [ ] Keystore backed up; `git status` shows `env.json`, `key.properties`, keystore untracked.
- [ ] Decide when to close open sign-ups.

## 7. Beta week: how to log issues
One line per note, with the day and time:
> `Tue 8:05am [bug] morning reminder arrived 6 minutes late (Pixel, Android 14)`
> `Thu [friction] moving 4 unfinished tasks to today needs 4 long-presses`
> `Fri [missing] wanted to repeat "gym" every Monday`

Types: **bug**, **friction**, **missing**. Note the device or browser. Watch especially: reminder timing, sync speed between laptop and phone, what happens to unfinished tasks at day end, whether the evening planning habit sticks.

## 8. Phase 2 backlog (order to be decided by beta notes)
1. **Carry-over** of unfinished tasks to today (likely first)
2. **Recurring tasks**
3. **Timeline view** (hour grid) for a day
4. **Week and month views**
5. **Search** and an Overdue section

Later options: Google sign-in (Supabase Phase 6 in the setup guide is not done), iOS build (needs a Mac and a paid Apple developer account), home-screen widget, server push so morning reminders reflect laptop edits, per-task reminders.

## 9. Working agreements
- **Template workflow (user preference):** every request is first expanded into the 8-element prompt template (role, task, context, reasoning, stop conditions, output format, example, clarifying questions), shown with "Does this look right? Any changes before I proceed?", and only executed after confirmation.
- Claude Code works **one milestone at a time**; start each prompt with "Read CLAUDE.md and docs/SPEC.md first", ask for a short bullet plan before coding, and require `dart format`, `flutter analyze` and `flutter test` to pass.
- Always verify on **both Android and Chrome**, and test release behaviour for anything platform-sensitive.
- Commit after each approved milestone. Claude should update `docs/STATUS.md` when a milestone or fix is completed.
- Keep secrets out of chats and Git: only the publishable key is ever in the app.

## 10. How to resume

**Fresh Claude chat:** upload this file, then send:
```
Read DAYBOOK_HANDOFF.md. Daybook beta testing is done. Here are my notes from the week:
[paste your notes]
Sort them into bugs, friction and missing features, propose a fix order, and follow my template workflow before executing anything.
```

**Claude Code:** save this file as `docs/STATUS.md`, then start with:
```
Read CLAUDE.md, docs/SPEC.md and docs/STATUS.md first. Daybook 1.0 is in beta. Fix this issue only: [paste one bug]. Give me a short plan first, find the root cause before changing code, and run format, analyze and tests.
```
