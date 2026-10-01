// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(connectivity)
final connectivityProvider = ConnectivityProvider._();

final class ConnectivityProvider
    extends $FunctionalProvider<Connectivity, Connectivity, Connectivity>
    with $Provider<Connectivity> {
  ConnectivityProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'connectivityProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$connectivityHash();

  @$internal
  @override
  $ProviderElement<Connectivity> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Connectivity create(Ref ref) {
    return connectivity(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Connectivity value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Connectivity>(value),
    );
  }
}

String _$connectivityHash() => r'e66720f09edf1a8b09e450e1eaedd51da9443f0e';

@ProviderFor(syncEngine)
final syncEngineProvider = SyncEngineProvider._();

final class SyncEngineProvider
    extends $FunctionalProvider<SyncEngine, SyncEngine, SyncEngine>
    with $Provider<SyncEngine> {
  SyncEngineProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncEngineProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncEngineHash();

  @$internal
  @override
  $ProviderElement<SyncEngine> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SyncEngine create(Ref ref) {
    return syncEngine(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncEngine value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncEngine>(value),
    );
  }
}

String _$syncEngineHash() => r'5332d690adf091c03c28140d01edc66c0ce41ba3';

/// Starts (and restarts, on user change) the sync lifecycle: initial sync
/// if needed, a push of anything pending, then realtime (SPEC §10 "when to
/// sync": sign-in). Watched from [DaybookApp] so it runs app-wide,
/// independent of which route is on screen — the "Setting up your data…"
/// state surfaces via `SyncEngine.status`, not by blocking navigation (the
/// router's own gate is [userGuardProvider], which this awaits first so
/// the account-switch wipe always finishes before initial sync starts).

@ProviderFor(SyncBootstrap)
final syncBootstrapProvider = SyncBootstrapProvider._();

/// Starts (and restarts, on user change) the sync lifecycle: initial sync
/// if needed, a push of anything pending, then realtime (SPEC §10 "when to
/// sync": sign-in). Watched from [DaybookApp] so it runs app-wide,
/// independent of which route is on screen — the "Setting up your data…"
/// state surfaces via `SyncEngine.status`, not by blocking navigation (the
/// router's own gate is [userGuardProvider], which this awaits first so
/// the account-switch wipe always finishes before initial sync starts).
final class SyncBootstrapProvider
    extends $AsyncNotifierProvider<SyncBootstrap, void> {
  /// Starts (and restarts, on user change) the sync lifecycle: initial sync
  /// if needed, a push of anything pending, then realtime (SPEC §10 "when to
  /// sync": sign-in). Watched from [DaybookApp] so it runs app-wide,
  /// independent of which route is on screen — the "Setting up your data…"
  /// state surfaces via `SyncEngine.status`, not by blocking navigation (the
  /// router's own gate is [userGuardProvider], which this awaits first so
  /// the account-switch wipe always finishes before initial sync starts).
  SyncBootstrapProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncBootstrapProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncBootstrapHash();

  @$internal
  @override
  SyncBootstrap create() => SyncBootstrap();
}

String _$syncBootstrapHash() => r'01197e7aef9f8b4b1665a5797be62e3a8636e11f';

/// Starts (and restarts, on user change) the sync lifecycle: initial sync
/// if needed, a push of anything pending, then realtime (SPEC §10 "when to
/// sync": sign-in). Watched from [DaybookApp] so it runs app-wide,
/// independent of which route is on screen — the "Setting up your data…"
/// state surfaces via `SyncEngine.status`, not by blocking navigation (the
/// router's own gate is [userGuardProvider], which this awaits first so
/// the account-switch wipe always finishes before initial sync starts).

abstract class _$SyncBootstrap extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
