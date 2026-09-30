// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_debug_seed.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Debug-only sample data (M1) so the Day screen layout can be eyeballed
/// before task CRUD exists (M2). No-op outside debug builds; no-op if any
/// task already exists (so it only seeds once).

@ProviderFor(debugSeed)
final debugSeedProvider = DebugSeedProvider._();

/// Debug-only sample data (M1) so the Day screen layout can be eyeballed
/// before task CRUD exists (M2). No-op outside debug builds; no-op if any
/// task already exists (so it only seeds once).

final class DebugSeedProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Debug-only sample data (M1) so the Day screen layout can be eyeballed
  /// before task CRUD exists (M2). No-op outside debug builds; no-op if any
  /// task already exists (so it only seeds once).
  DebugSeedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'debugSeedProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$debugSeedHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return debugSeed(ref);
  }
}

String _$debugSeedHash() => r'6bf41849cec237bc2eccb75a1b0345fa0f427d5e';
