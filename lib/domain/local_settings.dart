import 'package:freezed_annotation/freezed_annotation.dart';

part 'local_settings.freezed.dart';

/// Local-only device settings (see `LocalSettings` table doc). Not part of
/// SPEC §4 yet — a placeholder for the eventual synced `user_settings`.
@freezed
abstract class LocalSettings with _$LocalSettings {
  const factory LocalSettings({
    String? defaultCategoryId,
    String? selectedFilterCategoryId,
  }) = _LocalSettings;
}
