// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Signed-out users can only reach `/auth` (M4); everyone else needs to be
/// signed in. `/style-preview` is a permanent design reference but only
/// reachable in debug builds.

@ProviderFor(router)
final routerProvider = RouterProvider._();

/// Signed-out users can only reach `/auth` (M4); everyone else needs to be
/// signed in. `/style-preview` is a permanent design reference but only
/// reachable in debug builds.

final class RouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
  /// Signed-out users can only reach `/auth` (M4); everyone else needs to be
  /// signed in. `/style-preview` is a permanent design reference but only
  /// reachable in debug builds.
  RouterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'routerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$routerHash();

  @$internal
  @override
  $ProviderElement<GoRouter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoRouter create(Ref ref) {
    return router(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoRouter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoRouter>(value),
    );
  }
}

String _$routerHash() => r'd8f8c7fcd68578f38362103e726c5fb6fac22386';
