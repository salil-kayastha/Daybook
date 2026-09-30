// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appDatabase)
final appDatabaseProvider = AppDatabaseProvider._();

final class AppDatabaseProvider
    extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
  AppDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDatabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDatabaseHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return appDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDatabase>(value),
    );
  }
}

String _$appDatabaseHash() => r'44154e51c3f3079ee293d8ad0ebd1e17cca871ed';

@ProviderFor(categoryRepository)
final categoryRepositoryProvider = CategoryRepositoryProvider._();

final class CategoryRepositoryProvider
    extends
        $FunctionalProvider<
          CategoryRepository,
          CategoryRepository,
          CategoryRepository
        >
    with $Provider<CategoryRepository> {
  CategoryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoryRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoryRepositoryHash();

  @$internal
  @override
  $ProviderElement<CategoryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CategoryRepository create(Ref ref) {
    return categoryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CategoryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CategoryRepository>(value),
    );
  }
}

String _$categoryRepositoryHash() =>
    r'e31e1cca21bad50dc1e94f4c4ca8effdf7fa5c79';

@ProviderFor(taskRepository)
final taskRepositoryProvider = TaskRepositoryProvider._();

final class TaskRepositoryProvider
    extends $FunctionalProvider<TaskRepository, TaskRepository, TaskRepository>
    with $Provider<TaskRepository> {
  TaskRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskRepositoryHash();

  @$internal
  @override
  $ProviderElement<TaskRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TaskRepository create(Ref ref) {
    return taskRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TaskRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TaskRepository>(value),
    );
  }
}

String _$taskRepositoryHash() => r'171d390ca9701c2a75afed8cb156f663ebd0b247';

@ProviderFor(activeCategories)
final activeCategoriesProvider = ActiveCategoriesProvider._();

final class ActiveCategoriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Category>>,
          List<Category>,
          Stream<List<Category>>
        >
    with $FutureModifier<List<Category>>, $StreamProvider<List<Category>> {
  ActiveCategoriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeCategoriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeCategoriesHash();

  @$internal
  @override
  $StreamProviderElement<List<Category>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Category>> create(Ref ref) {
    return activeCategories(ref);
  }
}

String _$activeCategoriesHash() => r'ae74d4ac9dbd3d789d0eb24e3797befe3ba95340';

@ProviderFor(tasksForDate)
final tasksForDateProvider = TasksForDateFamily._();

final class TasksForDateProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Task>>,
          List<Task>,
          Stream<List<Task>>
        >
    with $FutureModifier<List<Task>>, $StreamProvider<List<Task>> {
  TasksForDateProvider._({
    required TasksForDateFamily super.from,
    required DateTime super.argument,
  }) : super(
         retry: null,
         name: r'tasksForDateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$tasksForDateHash();

  @override
  String toString() {
    return r'tasksForDateProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Task>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Task>> create(Ref ref) {
    final argument = this.argument as DateTime;
    return tasksForDate(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TasksForDateProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$tasksForDateHash() => r'1e8c83c1102200467f111e27fd443456196df22f';

final class TasksForDateFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Task>>, DateTime> {
  TasksForDateFamily._()
    : super(
        retry: null,
        name: r'tasksForDateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TasksForDateProvider call(DateTime date) =>
      TasksForDateProvider._(argument: date, from: this);

  @override
  String toString() => r'tasksForDateProvider';
}

@ProviderFor(tasksInMonth)
final tasksInMonthProvider = TasksInMonthFamily._();

final class TasksInMonthProvider
    extends
        $FunctionalProvider<
          AsyncValue<Set<DateTime>>,
          Set<DateTime>,
          Stream<Set<DateTime>>
        >
    with $FutureModifier<Set<DateTime>>, $StreamProvider<Set<DateTime>> {
  TasksInMonthProvider._({
    required TasksInMonthFamily super.from,
    required DateTime super.argument,
  }) : super(
         retry: null,
         name: r'tasksInMonthProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$tasksInMonthHash();

  @override
  String toString() {
    return r'tasksInMonthProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Set<DateTime>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Set<DateTime>> create(Ref ref) {
    final argument = this.argument as DateTime;
    return tasksInMonth(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TasksInMonthProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$tasksInMonthHash() => r'82657a4e033dd7ad129ea510c52fd71c7bd90c35';

final class TasksInMonthFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Set<DateTime>>, DateTime> {
  TasksInMonthFamily._()
    : super(
        retry: null,
        name: r'tasksInMonthProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TasksInMonthProvider call(DateTime monthStart) =>
      TasksInMonthProvider._(argument: monthStart, from: this);

  @override
  String toString() => r'tasksInMonthProvider';
}

/// The `PageView` page currently on screen, so the app bar (Today pill,
/// date header) can react without every page rebuilding the controller.

@ProviderFor(CurrentDayPageIndex)
final currentDayPageIndexProvider = CurrentDayPageIndexProvider._();

/// The `PageView` page currently on screen, so the app bar (Today pill,
/// date header) can react without every page rebuilding the controller.
final class CurrentDayPageIndexProvider
    extends $NotifierProvider<CurrentDayPageIndex, int> {
  /// The `PageView` page currently on screen, so the app bar (Today pill,
  /// date header) can react without every page rebuilding the controller.
  CurrentDayPageIndexProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentDayPageIndexProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentDayPageIndexHash();

  @$internal
  @override
  CurrentDayPageIndex create() => CurrentDayPageIndex();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$currentDayPageIndexHash() =>
    r'6f56ab76720264170fcbb369773d06d4f0458f0b';

/// The `PageView` page currently on screen, so the app bar (Today pill,
/// date header) can react without every page rebuilding the controller.

abstract class _$CurrentDayPageIndex extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The category last used when creating/editing a task, in-memory only.
/// New tasks default to this category (or "Office" if never set).

@ProviderFor(LastUsedCategoryId)
final lastUsedCategoryIdProvider = LastUsedCategoryIdProvider._();

/// The category last used when creating/editing a task, in-memory only.
/// New tasks default to this category (or "Office" if never set).
final class LastUsedCategoryIdProvider
    extends $NotifierProvider<LastUsedCategoryId, String?> {
  /// The category last used when creating/editing a task, in-memory only.
  /// New tasks default to this category (or "Office" if never set).
  LastUsedCategoryIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lastUsedCategoryIdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lastUsedCategoryIdHash();

  @$internal
  @override
  LastUsedCategoryId create() => LastUsedCategoryId();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$lastUsedCategoryIdHash() =>
    r'b51ae9c1dea04e71dff94ede7524de1f754fd96a';

/// The category last used when creating/editing a task, in-memory only.
/// New tasks default to this category (or "Office" if never set).

abstract class _$LastUsedCategoryId extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
