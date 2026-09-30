// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Which brightness mode is active app-wide.

@ProviderFor(SelectedThemeMode)
final selectedThemeModeProvider = SelectedThemeModeProvider._();

/// Which brightness mode is active app-wide.
final class SelectedThemeModeProvider
    extends $NotifierProvider<SelectedThemeMode, ThemeMode> {
  /// Which brightness mode is active app-wide.
  SelectedThemeModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedThemeModeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedThemeModeHash();

  @$internal
  @override
  SelectedThemeMode create() => SelectedThemeMode();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeMode>(value),
    );
  }
}

String _$selectedThemeModeHash() => r'b2b50e0eb38e76c57ff7477f9819ae8ba65c8b32';

/// Which brightness mode is active app-wide.

abstract class _$SelectedThemeMode extends $Notifier<ThemeMode> {
  ThemeMode build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ThemeMode, ThemeMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ThemeMode, ThemeMode>,
              ThemeMode,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
