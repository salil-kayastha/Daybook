// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_guard_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Runs once per sign-in (M4): if a *different* account signed in on this
/// device than last time, wipes local categories/tasks first so two
/// accounts' data never mix (CLAUDE.md offline-first rules still apply —
/// this only ever runs against the local DB, never Supabase). The router
/// awaits this before letting navigation into the signed-in area proceed,
/// so there's no flicker of a previous account's data.

@ProviderFor(userGuard)
final userGuardProvider = UserGuardProvider._();

/// Runs once per sign-in (M4): if a *different* account signed in on this
/// device than last time, wipes local categories/tasks first so two
/// accounts' data never mix (CLAUDE.md offline-first rules still apply —
/// this only ever runs against the local DB, never Supabase). The router
/// awaits this before letting navigation into the signed-in area proceed,
/// so there's no flicker of a previous account's data.

final class UserGuardProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Runs once per sign-in (M4): if a *different* account signed in on this
  /// device than last time, wipes local categories/tasks first so two
  /// accounts' data never mix (CLAUDE.md offline-first rules still apply —
  /// this only ever runs against the local DB, never Supabase). The router
  /// awaits this before letting navigation into the signed-in area proceed,
  /// so there's no flicker of a previous account's data.
  UserGuardProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userGuardProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userGuardHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return userGuard(ref);
  }
}

String _$userGuardHash() => r'2a4da26fe9a810fd331564f39cce710fd206f7a3';
