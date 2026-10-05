# Daybook — Product & Technical Spec

Version 1.0 · Personal-use app · Android + iOS + Web · Flutter + Supabase

---

## 1. Product overview

**Daybook** merges a calendar with a categorized to-do list. Google Calendar shows events on a timeline but has no true full-screen "one day at a time" planner and no category-based task lists. Daybook is **day-first**: you live in a full-screen day view, swipe to move between days, and plan tasks grouped by category.

### Principles
1. **Day-first.** Today is always one tap away; a day fills the whole screen.
2. **Three kinds of tasks:** exact time, time window ("anytime 9–6"), no time.
3. **Fast entry.** Typing on a phone is slow, so the laptop/web experience must be excellent (keyboard shortcuts, quick-add).
4. **Planning ritual.** Evening prompt to plan tomorrow, morning summary of today.
5. **Works offline.** Never block the UI on the network.

### Reference sketch (user's handwritten note) — what it means
```
29th September, 2026            <- full-screen day, date header

[office] — category
- meeting (9 a.m.) tap for details          <- timed task
- watch handover videos (9–6) anytime       <- time-window task

[personal] — category
- write blog — tap for details              <- task with details/notes
    (details) operate distributed services such as Kafka, RabbitMQ, Redis inside k8s
- ~~go~~ watch terraform videos — no time   <- untimed task
- buy bike parts — no time
```
Also visible: strikethrough for finished/cancelled items.

---

## 2. Feature list by phase

### Phase 1 — MVP (build now)
- Email+password sign-in (Supabase Auth). Google sign-in is deferred — see "Later tasks" below.
- Full-screen **Day screen** with swipe left/right, "Today" button, date-jump picker
- Categories: Office and Personal seeded; create/edit/reorder/archive; color per category
- Tasks: create, edit, delete (soft), mark done, mark cancelled, restore
- Time modes: `none`, `at` (start, optional end), `window` (start + end)
- Task details: title, notes, checklist, category, date, time mode
- Category filter (show one category or all)
- Move to tomorrow / pick another date
- Offline-first local DB + two-way sync + realtime updates
- Morning notification (today's tasks) + evening notification ("Plan tomorrow")
- Light/dark theme
- Web responsive layout (two/three pane) + keyboard shortcuts + quick-add bar

### Phase 2
- Auto carry-over of unfinished tasks (with a review prompt)
- Recurring tasks
- Timeline view toggle for the day (hour grid)
- Week and month views
- Quick-add natural-language parsing improvements
- Search
- Overdue section

### Phase 3 (list only, not detailed)
Home-screen widget · Google Calendar read-only overlay · tags · weekly review · server-sent push (FCM + Supabase Edge Function) · attachments · export.

### Later tasks (deferred, not phase-scheduled)
- **Google sign-in.** Email+password ships first; Google OAuth (mobile `google_sign_in` + `signInWithIdToken`, web `signInWithOAuth(OAuthProvider.google)`) is added in a later task, not part of M4.

---

## 3. Key decisions and why

| Decision | Why | Trade-off |
|---|---|---|
| Riverpod | Testable, no BuildContext dependence, great for streams from Drift | Learning curve; codegen step |
| Drift (SQLite) as source of truth | Real SQL queries for "tasks for date X", reactive streams, works on web via wasm | Extra setup on web (wasm + worker files) |
| Outbox sync + last-write-wins | Simple, robust for a single user with a few devices | A concurrent edit of the same task on two devices keeps the later write (acceptable for personal use) |
| Floating local date/time for tasks | "9 AM meeting" must stay 9 AM if you travel | Not suitable for multi-timezone teams (out of scope) |
| Local notifications, scheduled on-device | Reliable, no server needed, works offline | Content is computed when scheduled; see §8 for staleness handling |
| Soft delete | Lets deletions sync between devices | Need periodic purge (Phase 3) |
| Client-generated UUIDs | Create tasks offline without ID conflicts | Must be UUID v4 |

**Web setup note:** the "wasm + worker files" trade-off above means two files must live in `web/` and are not fetched by `flutter pub get`: `web/sqlite3.wasm` (from the `sqlite3` package's GitHub release matching its `pubspec.lock` version) and `web/drift_worker.js` (from the `drift` package's GitHub release matching its `pubspec.lock` version). Currently pinned to sqlite3 3.6.0 and drift 2.35.0. Re-download both, from the matching release tag, whenever `drift`/`sqlite3` are bumped — see README "Web setup" for the exact URLs. Missing or mismatched files surface as a Drift error on web only (e.g. `Invalid argument(s): When compiling to the web, the 'web' parameter needs to be set`), since native (Android/iOS) doesn't need them.

---

## 4. Data model (Supabase / Postgres)

Run as migration `supabase/migrations/0001_init.sql` (paste into Supabase SQL Editor for the first setup).

```sql
-- ============ Extensions ============
create extension if not exists "pgcrypto";

-- ============ Helper: updated_at trigger ============
create or replace function public.set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

-- ============ categories ============
create table public.categories (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null default auth.uid() references auth.users(id) on delete cascade,
  name        text not null check (char_length(name) between 1 and 60),
  color       text not null default '#4C6EF5' check (color ~ '^#[0-9A-Fa-f]{6}$'),
  icon        text,
  sort_order  double precision not null default 0,
  is_archived boolean not null default false,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now(),
  deleted_at  timestamptz
);
create index categories_user_updated_idx on public.categories (user_id, updated_at);

-- ============ tasks ============
create table public.tasks (
  id              uuid primary key default gen_random_uuid(),
  user_id         uuid not null default auth.uid() references auth.users(id) on delete cascade,
  category_id     uuid references public.categories(id) on delete set null,
  title           text not null check (char_length(title) between 1 and 300),
  notes           text,
  checklist       jsonb not null default '[]'::jsonb,   -- [{"id":"uuid","text":"...","done":false}]
  task_date       date not null,                        -- floating local date
  time_mode       text not null default 'none' check (time_mode in ('none','at','window')),
  start_time      time,                                 -- floating local time
  end_time        time,
  status          text not null default 'todo' check (status in ('todo','done','cancelled')),
  completed_at    timestamptz,
  sort_order      double precision not null default 0,
  recurrence_rule text,                                 -- Phase 2 (RFC5545 RRULE string)
  recurrence_parent_id uuid references public.tasks(id) on delete set null,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now(),
  deleted_at      timestamptz,
  constraint tasks_time_consistency check (
    (time_mode = 'none'   and start_time is null and end_time is null) or
    (time_mode = 'at'     and start_time is not null) or
    (time_mode = 'window' and start_time is not null and end_time is not null and end_time > start_time)
  )
);
create index tasks_user_date_idx    on public.tasks (user_id, task_date) where deleted_at is null;
create index tasks_user_updated_idx on public.tasks (user_id, updated_at);

-- ============ user_settings ============
create table public.user_settings (
  user_id          uuid primary key default auth.uid() references auth.users(id) on delete cascade,
  morning_enabled  boolean not null default true,
  morning_time     time    not null default '07:30',
  evening_enabled  boolean not null default true,
  evening_time     time    not null default '21:00',
  theme_mode       text    not null default 'system' check (theme_mode in ('system','light','dark')),
  week_starts_on   smallint not null default 1 check (week_starts_on between 0 and 6), -- 0=Sun,1=Mon
  default_category_id uuid references public.categories(id) on delete set null,
  updated_at       timestamptz not null default now()
);

-- ============ updated_at triggers ============
create trigger categories_updated  before update on public.categories
  for each row execute function public.set_updated_at();
create trigger tasks_updated       before update on public.tasks
  for each row execute function public.set_updated_at();
create trigger user_settings_updated before update on public.user_settings
  for each row execute function public.set_updated_at();

-- ============ Row Level Security ============
alter table public.categories    enable row level security;
alter table public.tasks         enable row level security;
alter table public.user_settings enable row level security;

create policy "own categories" on public.categories
  for all using (user_id = (select auth.uid())) with check (user_id = (select auth.uid()));
create policy "own tasks" on public.tasks
  for all using (user_id = (select auth.uid())) with check (user_id = (select auth.uid()));
create policy "own settings" on public.user_settings
  for all using (user_id = (select auth.uid())) with check (user_id = (select auth.uid()));

-- ============ Seed defaults on signup ============
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  insert into public.categories (user_id, name, color, sort_order) values
    (new.id, 'Office',   '#4C6EF5', 1),
    (new.id, 'Personal', '#12B886', 2);
  insert into public.user_settings (user_id) values (new.id);
  return new;
end;
$$;
create trigger on_auth_user_created after insert on auth.users
  for each row execute function public.handle_new_user();

-- ============ Realtime ============
alter publication supabase_realtime add table public.tasks, public.categories, public.user_settings;
```

### Sort order inside a category on the Day screen
1. `status = todo` first, then `done`, then `cancelled` (done/cancelled sink to the bottom, shown struck through)
2. Within todo: `time_mode = at` by `start_time`; then `window` by `start_time`; then `none` by `sort_order`, then `created_at`.

### Dart domain models (freezed)
`Category`, `Task`, `ChecklistItem`, `UserSettings`, enums `TimeMode { none, at, window }`, `TaskStatus { todo, done, cancelled }`. Mirror the columns above 1:1 (camelCase in Dart, snake_case in JSON).

---

## 5. Supabase manual setup checklist (done by the user, not Claude Code)

1. Create a Supabase project. Copy **Project URL** and **publishable key** into `env.json`.
2. SQL Editor → run `0001_init.sql`.
3. Auth → Providers: enable **Email** (confirm email ON). Google provider setup is deferred until the Google sign-in task.
4. Auth → URL Configuration: add site URL and redirect URLs (`http://localhost:3000/**` for dev, the deployed web URL later, and the mobile deep link `io.daybook.app://login-callback`).
5. Database → Replication: confirm `tasks`, `categories`, `user_settings` are in the `supabase_realtime` publication.

When the Google sign-in task is picked up later: Google Cloud Console → create OAuth clients (**Web**, **Android** with package name + SHA-1, **iOS**); put the Web client ID/secret into Supabase's Google provider; enable it in Auth → Providers.

---

## 6. Design system

Mood: calm, paper-like, focused. Warm neutrals, one confident accent, no visual noise.

### 6.1 Color tokens

**Light**
| Token | Hex | Use |
|---|---|---|
| `bg` | `#FAF8F5` | screen background (warm paper) |
| `surface` | `#FFFFFF` | cards, sheets |
| `surfaceAlt` | `#F1EEE8` | chips, inputs, hover |
| `ink` | `#1F2328` | primary text |
| `inkMuted` | `#6B7280` | secondary text |
| `line` | `#E4E0D8` | dividers, borders |
| `primary` | `#3B5BDB` | buttons, active date, links |
| `onPrimary` | `#FFFFFF` | text on primary |
| `success` | `#2F9E44` | done check |
| `warning` | `#F08C00` | overdue / time-window accent |
| `danger` | `#E03131` | delete |

**Dark**
| Token | Hex |
|---|---|
| `bg` | `#121316` |
| `surface` | `#1C1E22` |
| `surfaceAlt` | `#26292E` |
| `ink` | `#ECEDEF` |
| `inkMuted` | `#9AA1AB` |
| `line` | `#2E3238` |
| `primary` | `#748FFC` |
| `onPrimary` | `#0E1116` |
| `success` | `#51CF66` |
| `warning` | `#FFA94D` |
| `danger` | `#FF6B6B` |

**Category palette (user-selectable, 10 colors):**
`#4C6EF5` indigo · `#12B886` teal · `#F76707` orange · `#E64980` pink · `#7950F2` violet · `#15AABF` cyan · `#82C91E` lime · `#FAB005` amber · `#868E96` gray · `#D6336C` raspberry.
Category color is shown as a 4dp left bar / dot and a 12%-opacity tint on the section header. It is never the only carrier of meaning (also show the category name).

### 6.2 Typography
- **Fraunces** (serif) — date header and screen titles only. Adds a "journal" feel.
- **Inter** — everything else.

| Style | Font | Size / weight | Use |
|---|---|---|---|
| `displayDate` | Fraunces | 32 / 600 | "29 September" |
| `subDate` | Inter | 14 / 500 muted | "Tuesday · 2026" |
| `sectionTitle` | Inter | 13 / 700, uppercase, letter-spacing 0.8 | Category headers |
| `taskTitle` | Inter | 16 / 500 | Task text |
| `taskMeta` | Inter | 12 / 500 muted | Time chip, notes hint |
| `body` | Inter | 15 / 400 | Details/notes |
| `button` | Inter | 15 / 600 | Buttons |

Respect system text scaling up to 1.3×.

### 6.3 Spacing, shape, motion
- Spacing scale (dp): 4, 8, 12, 16, 24, 32, 48. Screen horizontal padding 16 (phone), 24 (web).
- Radius: 8 (chips), 12 (task cards, inputs), 20 (bottom sheets top corners), 999 (pills, FAB).
- Elevation: prefer 1px `line` borders over shadows; sheets use a soft shadow.
- Motion: 200ms ease-out for page changes and checkbox; check animation 150ms with light haptic on mobile. Respect reduced-motion setting.

### 6.4 Component styles
- **Task tile:** rounded-12 card on `surface`, left 4dp category-color bar, checkbox (24dp circle), title, right-aligned time chip. Done → title struck through + `inkMuted`, checkbox filled `success`. Cancelled → struck through + `inkMuted` + small "cancelled" label.
- **Time chip:** `at` → clock icon + "9:00 AM" (with "– 10:00 AM" if end). `window` → hourglass icon + "9 AM – 6 PM · anytime" in `warning` tint. `none` → no chip (section "No time" subheading).
- **Category section header:** colored dot + uppercase name + task count + collapse chevron.
- **FAB:** primary color, "+" icon, bottom-right (phone); on web the quick-add bar replaces it.

---

## 7. Screens and UX

### 7.1 Auth screen
- Logo wordmark "Daybook" (Fraunces), tagline "Plan the day, one page at a time."
- Email + password fields, **Sign in / Create account** toggle, "Forgot password". No social sign-in buttons yet — Google sign-in is a later task; the screen should leave room above the divider-less form for it to be added without a redesign.
- Errors shown inline; loading states on buttons.

### 7.2 Day screen (the heart of the app) — phone layout
```
┌──────────────────────────────┐
│ ‹ (menu)            [Today]  │  top bar: menu, "Today" pill (visible only when not on today), calendar icon
│                              │
│ 29 September                 │  displayDate
│ Tuesday · 2026    3/7 done   │  subDate + progress
│ [All] [Office] [Personal]    │  category filter chips (horizontal scroll)
│──────────────────────────────│
│ ● OFFICE · 2                 │
│ ▌☐ Meeting        🕘 9:00 AM │
│ ▌☐ Watch handover videos     │
│      ⏳ Anytime 9 AM–6 PM     │
│                              │
│ ● PERSONAL · 3               │
│ ▌☐ Write blog        ▸ notes │
│ NO TIME                      │
│ ▌☐ Watch Terraform videos    │
│ ▌☐ Buy bike parts            │
│                              │
│                         (+)  │
└──────────────────────────────┘
```
Behavior:
- **Full screen:** hides the status-bar clutter; content scrolls vertically inside a page; the whole day is one page.
- **Swipe left → next day, swipe right → previous day** using a `PageView` (index 0 = a fixed epoch date, e.g. 2000-01-01; ~73,000 pages; page index ↔ date via pure functions with unit tests). Preload ±1 page. Animate 200ms.
- Tasks tiles must **not** use horizontal swipe gestures (would conflict with page swipe). Per-task actions live in a long-press menu and the details sheet.
- **Tap tile** → Task details bottom sheet (7.3). **Tap checkbox** → toggle done (haptic). **Long-press** → menu: Edit, Move to tomorrow, Pick date, Cancel task, Delete.
- "Today" pill jumps to today with animation.
- Calendar icon → date-picker sheet with month grid; days with tasks show a dot.
- Empty day: friendly empty state ("Nothing planned. Add your first task.") + add button.
- Empty categories are hidden unless the filter selects them.
- Section collapse state remembered per category (local only).
- Pull-to-refresh triggers a sync.

### 7.3 Task details sheet / page
Fields: title (autofocus on create), category dropdown (colored), date, time mode segmented control **[No time | At time | Window]** with time pickers, notes (multiline, auto-grow, plain text now, markdown later), checklist (add/reorder/toggle), status actions (Done / Cancel / Restore), delete.
- Phone: modal bottom sheet (draggable, up to 90% height). Web: right-hand panel.
- Autosave on change (debounced 400ms); no explicit save button, except on create where "Add" is the primary button.

### 7.4 Quick add
- Phone: FAB → small sheet with a single text field, category chips and time-mode chips; **Enter** adds and keeps sheet open for the next task.
- Web: persistent input at the top of the day pane, focus with `N` or `/`.
- **Parser (Phase 1 minimal, pure function with tests):** `#personal` → category (case-insensitive prefix match); `tomorrow`, `today`, `mon..sun`, `dd/mm` → date; `9am`, `14:30`, `9-6` / `9am-6pm` → `at` or `window` (window when the phrase is "9-6 anytime" or contains "anytime"/"between"). Unparsed remainder is the title. Show parsed chips live under the input so the user can correct.

### 7.5 Settings
Account (email, sign out), theme, week start, notification toggles + times, default category, manage categories (drag to reorder, color, rename, archive), "Sync now" + last-synced time, app version.

### 7.6 Web / wide layouts
| Width | Layout |
|---|---|
| < 700px | Phone layout (single pane, swipe) |
| 700–1099px | Two pane: left rail (mini month calendar + category filters + "Today"), main = Day view. Details open as a side sheet |
| ≥ 1100px | Three pane: left rail · Day view (max width 720, centered) · Details panel |

On web, swipe is replaced by **arrow buttons** and keyboard (mouse users don't swipe); touch-screen laptops still get swipe.

**Keyboard shortcuts (web, ignored while typing in a text field):**
`N` new task · `←/→` or `J/K` prev/next day · `T` today · `/` search (Phase 2) · `E` edit selected · `X` toggle done on selected · `Delete` delete selected · `↑/↓` move selection · `Cmd/Ctrl+Enter` save · `Esc` close panel · `?` show shortcut help.

---

## 8. Notifications

**Approach:** schedule **local** notifications on each device from the local DB. Works offline, no server.

| Notification | When | Content |
|---|---|---|
| Morning summary | `morning_time` daily (default 07:30) | Title: "Good morning — N tasks today". Body: first 3 task titles (timed ones first) + "+K more". Tap → opens today's Day screen. |
| Evening planning | `evening_time` daily (default 21:00) | Title: "Plan tomorrow". Body: "Tomorrow has N tasks. Add or review them." (or "Nothing planned for tomorrow yet."). Tap → opens tomorrow's Day screen with quick-add focused. |
| Timed task reminder (Phase 2) | 10 min before `at` tasks (configurable) | Task title + time |

**Rules**
1. Use `zonedSchedule` with `flutter_timezone` to get the device zone. Re-detect zone on every app start; reschedule if it changed.
2. **Rolling window:** because content differs each day and iOS allows only 64 pending notifications, schedule the next **7 days** of morning + evening notifications, each with content computed for that specific day.
3. **Reschedule triggers:** app start, app resume, after every sync pull, after any task/setting change (debounced 2s), and on device reboot (Android `RECEIVE_BOOT_COMPLETED`).
4. **Staleness (known limitation):** if you add a task from the laptop and don't open the phone, the phone's scheduled notification text is old. Mitigation: body always ends with "Tap to see the latest", and the tap opens live data. Phase 3 adds server push (FCM + Supabase Edge Function on a cron) to fix this properly.
5. Android: notification channels `daily_summary` and `planning`; request `POST_NOTIFICATIONS` (Android 13+); use inexact-but-reliable scheduling by default, `SCHEDULE_EXACT_ALARM` only if the user enables "exact time" in settings.
6. iOS: request permission after the first task is created (not at first launch); add the required `AppDelegate` setup.
7. Web: notifications are best-effort (only while the tab is open). Show a small info note in Settings: "Reminders are delivered on your phone."
8. Pure function `buildDailyNotifications(tasks, settings, now)` returns the list of notifications to schedule — fully unit-tested.

---

## 9. Architecture and folder structure

```
daybook/
├─ CLAUDE.md
├─ docs/SPEC.md
├─ env.json                       (git-ignored)
├─ supabase/migrations/0001_init.sql
├─ lib/
│  ├─ main.dart
│  ├─ app.dart                    # MaterialApp.router, theme, providers bootstrap
│  ├─ core/
│  │  ├─ theme/                   # colors.dart, text.dart, spacing.dart, theme.dart
│  │  ├─ router/                  # go_router config, auth redirect
│  │  ├─ utils/                   # date_utils.dart (page<->date), time_of_day utils
│  │  ├─ config/                  # env (SUPABASE_URL...)
│  │  └─ widgets/                 # shared: DaybookButton, ColorDot, EmptyState...
│  ├─ data/
│  │  ├─ local/                   # drift database, tables, DAOs
│  │  ├─ remote/                  # supabase client wrappers (used only by sync)
│  │  ├─ sync/                    # sync_engine.dart, outbox, realtime listener
│  │  └─ repositories/            # TaskRepository, CategoryRepository, SettingsRepository
│  ├─ domain/                     # freezed models + enums
│  └─ features/
│     ├─ auth/                    # auth_screen, auth_controller
│     ├─ day/                     # day_screen, day_page, task_tile, category_section,
│     │                           # day_controller, date_picker_sheet, quick_add
│     ├─ task_details/            # details sheet/panel, checklist editor
│     ├─ categories/              # manage categories
│     ├─ settings/
│     └─ notifications/           # scheduler, builder (pure), permissions
└─ test/                          # mirrors lib/ structure
```

**Data flow:** Widget → Riverpod controller → Repository → Drift (write + enqueue outbox row) → UI updates from Drift stream. Sync engine drains the outbox to Supabase and merges remote changes into Drift.

---

## 10. Sync and offline rules

**Local tables** = same columns as remote, plus a local-only `sync_state` (`synced | pending`) on `tasks`, `categories`, `user_settings`, and an `outbox` table `(id, table, row_id, op, created_at, attempts)`.

**Write path**
1. Repository writes the row to Drift with `updated_at = now()` (local) and `sync_state = pending`.
2. Insert an outbox entry (coalesce multiple pending ops for the same row into one).
3. Trigger `SyncEngine.push()` (debounced 1s; immediate if online).

**Push:** for each outbox entry, `upsert` the row to Supabase (`onConflict: id`). On success mark `synced`, remove the outbox entry. On network error keep it and retry with exponential backoff (2s → 5min cap). On 401 refresh the session; on 4xx validation errors log and mark the entry `failed` (surface in Settings).

**Pull:** keep `last_pulled_at` per table (server `updated_at` of the newest row seen). Fetch `where updated_at > last_pulled_at order by updated_at limit 500`, loop until fewer than 500 rows. Merge rule: **last-write-wins** by `updated_at`. If the local row is `pending`, compare: keep whichever `updated_at` is newer (the server value is authoritative after a successful push). Soft-deleted rows (`deleted_at` set) are applied as deletions locally (hidden by queries).

**Realtime:** subscribe to `postgres_changes` for the three tables filtered by `user_id`. On any event, run a pull (don't trust the payload alone). Reconnect automatically; run a full pull on reconnect.

**When to sync:** app start, resume, sign-in, pull-to-refresh, after local writes (push), connectivity regained (`connectivity_plus`), realtime event.

**Initial sync (first login on a device):** pull everything (paginated), then start realtime.

**Sign-out:** clear local DB and cancel notifications.

**Tests required:** merge rule cases (local newer / remote newer / remote deleted), outbox coalescing, page↔date mapping, pagination loop.

---

## 11. Build order with acceptance criteria

Each milestone must pass its criteria and the global definition of done in CLAUDE.md.

**M0 — Project setup + style preview**
- Create Flutter project (`android`, `ios`, `web`), add packages, `env.json` loading, folder structure, theme tokens (light+dark).
- Build a `/style-preview` screen showing: both palettes, all text styles, sample task tiles (todo/done/cancelled/timed/window), category chips, buttons, and a light/dark toggle. Also provide **one alternative** palette (e.g. a warmer or a cooler accent) selectable at the top for comparison.
- *Acceptance:* runs on Chrome + Android emulator; user can eyeball and choose; chosen tokens are then frozen in `theme/`.

**M1 — Local database + Day screen (no backend)**
- Drift schema, DAOs, repositories, seed Office/Personal categories locally.
- Day screen with PageView swipe, date header, category sections, correct sort order, "No time" subheading, Today pill, date-picker sheet.
- *Acceptance:* swiping left/right changes the date (both directions, 30+ swipes stable); timed tasks sort by start time; "No time" tasks appear under their own subheading within each category; Today pill appears only off-today and jumps back; page↔date mapping unit-tested including DST-free floating dates and year boundaries.

**M2 — Task CRUD + details**
- Add/edit/delete tasks; details sheet with all fields; time mode control; done/cancelled with strikethrough; move to tomorrow; long-press menu; checklist.
- *Acceptance:* every field persists after app restart; constraints from `tasks_time_consistency` are enforced in the UI (window requires end > start); done tasks sink to the bottom; validation messages shown.

**M3 — Categories management + filter**
- Category CRUD, colors, reorder, archive; filter chips on Day screen; default category.
- *Acceptance:* archiving hides the category from filters and the picker but keeps existing tasks visible under "Archived"; reorder persists.

**M4 — Auth + Supabase connection**
- Email/password sign-in, auth redirect in router, sign-out, session persistence. Google sign-in is a later task, not part of M4.
- *Acceptance:* new account gets Office and Personal categories via the DB trigger (verified in Supabase); sign-in works on Android and Chrome; unauthenticated users can't reach Day screen.

**M5 — Sync**
- Outbox, push, pull, realtime, connectivity handling, sync status in Settings.
- *Acceptance:* create a task on Chrome → appears on the Android emulator within ~3 seconds; edit offline on Android (airplane mode), reconnect → change reaches Chrome; delete propagates; merge rule tests pass; no duplicate rows after repeated retries.

**M6 — Notifications**
- Settings UI for times/toggles, permission flow, scheduler with 7-day rolling window, builder function with tests, tap handling to route to the right day.
- *Acceptance:* setting morning time to 2 minutes from now fires a notification with correct task titles; evening notification opens tomorrow's screen with quick-add focused; rescheduling occurs after a task change; survives device reboot on Android.

**M7 — Web polish: layouts + keyboard + quick-add**
- Responsive 1/2/3-pane layouts, keyboard shortcuts, quick-add bar with the parser and live chips, arrow-button navigation.
- *Acceptance:* at 1280px width the three-pane layout shows; `N`, `J/K`, `T`, `X`, `E`, `Esc` all work and are ignored while typing; parser test-suite passes (at least 20 cases including `buy bike parts tomorrow #personal`, `meeting 9am #office`, `watch videos 9-6 anytime`).

**M8 — Polish + release prep**
- Empty states, loading skeletons, error snackbars, haptics, reduced-motion, accessibility pass, app icon + splash, Android/iOS bundle ids (`io.daybook.app`), deploy web build (Firebase Hosting, Netlify or Cloudflare Pages), release build signing notes.
- *Acceptance:* Lighthouse a11y ≥ 90 on web; TalkBack can complete "add task" and "mark done"; analyzer clean; README has setup + release steps.

**Phase 2 milestones** (later, specced when reached): P2-1 carry-over prompt, P2-2 recurring tasks, P2-3 timeline view, P2-4 week/month views, P2-5 search.

---

## 12. Testing strategy
- **Unit:** date/page mapping, sorting, quick-add parser, notification builder, sync merge, outbox coalescing.
- **Widget:** task tile states, Day screen empty/non-empty, details form validation.
- **Integration (one happy path):** sign in (mock) → add task → mark done → swipe day.
- **Manual sync matrix (before each release):** create/edit/delete on each of web+Android and confirm on the other; airplane-mode edit; two-device conflict.
- Keep tests fast; CI (GitHub Actions) runs `flutter analyze` and `flutter test` on push.

---

## 13. Security and privacy
- RLS on all tables (see §4). Verify with a second test account that user B cannot read user A's rows.
- Only the publishable key in the client. Never the service-role key.
- HTTPS only. Password rules delegated to Supabase (min length 8 in Auth settings).
- Clear local DB on sign-out.
- No analytics or third-party trackers in MVP.

---

## 14. Naming, IDs, misc
- App name: **Daybook**. Bundle/package id: `io.daybook.app` (change if you own a domain, and change it *before* the first release).
- Min versions: Android 8.0 (API 26) · iOS 13.
- Default locale English; use `intl` from day one so strings can be localized later. Date formats follow device locale; 12h/24h follows device setting.

---

## 15. First prompt to paste into Claude Code

```
Read CLAUDE.md and docs/SPEC.md fully. We are building Daybook.

Do Milestone M0 only:
1. Add the packages listed in CLAUDE.md (verify each supports android+ios+web).
2. Create the folder structure from SPEC §9 and env loading via --dart-define-from-file (env.json uses `SUPABASE_PUBLISHABLE_KEY`).
3. Implement the theme tokens from SPEC §6 (light + dark) in lib/core/theme/.
4. Build the /style-preview screen described in M0, including ONE alternative palette I can compare.
5. Run dart format, flutter analyze, flutter test and report results.

Before writing code, give me a short bullet plan. Do not start M1 until I approve the style.
```

---

## 16. Progress checklist
- [x] M0 Setup + style preview
- [x] M1 Local DB + Day screen
- [x] M2 Task CRUD + details
- [x] M3 Categories + filter
- [x] M4 Auth + Supabase
- [x] M5 Sync
- [x] M6 Notifications
- [x] M7 Web polish
- [x] M8 Release prep
