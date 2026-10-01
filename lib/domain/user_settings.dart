import 'package:freezed_annotation/freezed_annotation.dart';

import 'enums.dart';

part 'user_settings.freezed.dart';

/// Mirrors `public.user_settings` (SPEC §4) — synced (M5), unlike
/// [LocalSettings] which stays device-local. `morningTime`/`eveningTime`
/// are floating local "HH:mm:ss" (CLAUDE.md rule 5); not yet read by any
/// screen — M6 wires notification scheduling to these.
@freezed
abstract class UserSettings with _$UserSettings {
  const factory UserSettings({
    required String userId,
    @Default(true) bool morningEnabled,
    @Default('07:30:00') String morningTime,
    @Default(true) bool eveningEnabled,
    @Default('21:00:00') String eveningTime,
    @Default('system') String themeMode,
    @Default(1) int weekStartsOn,
    String? defaultCategoryId,
    required DateTime updatedAt,
    @Default(SyncState.pending) SyncState syncState,
    required DateTime localChangedAt,
  }) = _UserSettings;
}
