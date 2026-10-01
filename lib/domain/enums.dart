/// Mirrors the Postgres `time_mode` check constraint (SPEC §4).
enum TimeMode { none, at, window }

/// Mirrors the Postgres `status` check constraint (SPEC §4).
enum TaskStatus { todo, done, cancelled }

/// Local-only sync bookkeeping (SPEC §10, M5) — never sent to Supabase.
enum SyncState { pending, synced }
