// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(notificationScheduler)
final notificationSchedulerProvider = NotificationSchedulerProvider._();

final class NotificationSchedulerProvider
    extends
        $FunctionalProvider<
          NotificationScheduler,
          NotificationScheduler,
          NotificationScheduler
        >
    with $Provider<NotificationScheduler> {
  NotificationSchedulerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationSchedulerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationSchedulerHash();

  @$internal
  @override
  $ProviderElement<NotificationScheduler> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NotificationScheduler create(Ref ref) {
    return notificationScheduler(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotificationScheduler value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotificationScheduler>(value),
    );
  }
}

String _$notificationSchedulerHash() =>
    r'648e8933a0cf15cde0d56e4ad61a6395ad5e3151';

/// The signed-in user's synced notification settings (SPEC §8), for the
/// Settings screen's Notifications section.

@ProviderFor(currentUserSettings)
final currentUserSettingsProvider = CurrentUserSettingsProvider._();

/// The signed-in user's synced notification settings (SPEC §8), for the
/// Settings screen's Notifications section.

final class CurrentUserSettingsProvider
    extends
        $FunctionalProvider<
          AsyncValue<UserSettings?>,
          UserSettings?,
          Stream<UserSettings?>
        >
    with $FutureModifier<UserSettings?>, $StreamProvider<UserSettings?> {
  /// The signed-in user's synced notification settings (SPEC §8), for the
  /// Settings screen's Notifications section.
  CurrentUserSettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserSettingsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUserSettingsHash();

  @$internal
  @override
  $StreamProviderElement<UserSettings?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<UserSettings?> create(Ref ref) {
    return currentUserSettings(ref);
  }
}

String _$currentUserSettingsHash() =>
    r'077d7654c23b969b355c6c9d9a9b085559c19e5a';

/// Debounced "rebuild and reschedule" trigger (SPEC §8), used by both the
/// repositories (after a task/settings write) and [NotificationBootstrap]
/// (after sign-in, app resume, sync pull). Deliberately does its
/// `ref.read`s lazily inside [_run] rather than `ref.watch`ing
/// `userSettingsRepositoryProvider` at build time — the repositories
/// themselves watch *this* provider to get a ping callback, so watching
/// them back here would be a circular provider dependency.

@ProviderFor(notificationRescheduler)
final notificationReschedulerProvider = NotificationReschedulerProvider._();

/// Debounced "rebuild and reschedule" trigger (SPEC §8), used by both the
/// repositories (after a task/settings write) and [NotificationBootstrap]
/// (after sign-in, app resume, sync pull). Deliberately does its
/// `ref.read`s lazily inside [_run] rather than `ref.watch`ing
/// `userSettingsRepositoryProvider` at build time — the repositories
/// themselves watch *this* provider to get a ping callback, so watching
/// them back here would be a circular provider dependency.

final class NotificationReschedulerProvider
    extends
        $FunctionalProvider<
          NotificationRescheduler,
          NotificationRescheduler,
          NotificationRescheduler
        >
    with $Provider<NotificationRescheduler> {
  /// Debounced "rebuild and reschedule" trigger (SPEC §8), used by both the
  /// repositories (after a task/settings write) and [NotificationBootstrap]
  /// (after sign-in, app resume, sync pull). Deliberately does its
  /// `ref.read`s lazily inside [_run] rather than `ref.watch`ing
  /// `userSettingsRepositoryProvider` at build time — the repositories
  /// themselves watch *this* provider to get a ping callback, so watching
  /// them back here would be a circular provider dependency.
  NotificationReschedulerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationReschedulerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationReschedulerHash();

  @$internal
  @override
  $ProviderElement<NotificationRescheduler> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NotificationRescheduler create(Ref ref) {
    return notificationRescheduler(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotificationRescheduler value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotificationRescheduler>(value),
    );
  }
}

String _$notificationReschedulerHash() =>
    r'39d9e0a25c33246c329c061e263a13464456f698';

/// Starts (and restarts, on user change) the notification lifecycle:
/// initialize, then an immediate reschedule, then reschedule again after
/// every sync pull (SPEC §8 "reschedule triggers"). App start/resume is
/// triggered from `app.dart`; post-write reschedules come from the
/// repositories — both go through [NotificationRescheduler].

@ProviderFor(NotificationBootstrap)
final notificationBootstrapProvider = NotificationBootstrapProvider._();

/// Starts (and restarts, on user change) the notification lifecycle:
/// initialize, then an immediate reschedule, then reschedule again after
/// every sync pull (SPEC §8 "reschedule triggers"). App start/resume is
/// triggered from `app.dart`; post-write reschedules come from the
/// repositories — both go through [NotificationRescheduler].
final class NotificationBootstrapProvider
    extends $AsyncNotifierProvider<NotificationBootstrap, void> {
  /// Starts (and restarts, on user change) the notification lifecycle:
  /// initialize, then an immediate reschedule, then reschedule again after
  /// every sync pull (SPEC §8 "reschedule triggers"). App start/resume is
  /// triggered from `app.dart`; post-write reschedules come from the
  /// repositories — both go through [NotificationRescheduler].
  NotificationBootstrapProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationBootstrapProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationBootstrapHash();

  @$internal
  @override
  NotificationBootstrap create() => NotificationBootstrap();
}

String _$notificationBootstrapHash() =>
    r'6a14ce845f7cef54e0041a8c938103a15f90269d';

/// Starts (and restarts, on user change) the notification lifecycle:
/// initialize, then an immediate reschedule, then reschedule again after
/// every sync pull (SPEC §8 "reschedule triggers"). App start/resume is
/// triggered from `app.dart`; post-write reschedules come from the
/// repositories — both go through [NotificationRescheduler].

abstract class _$NotificationBootstrap extends $AsyncNotifier<void> {
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
