/// Mirrors the Postgres `time_mode` check constraint (SPEC §4).
enum TimeMode { none, at, window }

/// Mirrors the Postgres `status` check constraint (SPEC §4).
enum TaskStatus { todo, done, cancelled }
