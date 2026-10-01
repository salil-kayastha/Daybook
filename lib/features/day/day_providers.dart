import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/local/database_provider.dart';
import '../../data/repositories/category_repository.dart';
import '../../data/repositories/settings_repository.dart';
import '../../data/repositories/task_repository.dart';
import '../../data/repositories/user_settings_repository.dart';
import '../../domain/category.dart';
import '../../domain/local_settings.dart';
import '../../domain/task.dart';
import '../notifications/notification_providers.dart';
import '../sync/sync_providers.dart';

part 'day_providers.g.dart';

@Riverpod(keepAlive: true)
CategoryRepository categoryRepository(Ref ref) {
  final database = ref.watch(appDatabaseProvider);
  final engine = ref.watch(syncEngineProvider);
  return CategoryRepository(
    database.categoryDao,
    database.outboxDao,
    engine.schedulePush,
  );
}

@Riverpod(keepAlive: true)
TaskRepository taskRepository(Ref ref) {
  final database = ref.watch(appDatabaseProvider);
  final engine = ref.watch(syncEngineProvider);
  final rescheduler = ref.watch(notificationReschedulerProvider);
  return TaskRepository(
    database.taskDao,
    database.outboxDao,
    engine.schedulePush,
    rescheduler.request,
  );
}

@Riverpod(keepAlive: true)
SettingsRepository settingsRepository(Ref ref) {
  final database = ref.watch(appDatabaseProvider);
  return SettingsRepository(database.settingsDao);
}

@Riverpod(keepAlive: true)
UserSettingsRepository userSettingsRepository(Ref ref) {
  final database = ref.watch(appDatabaseProvider);
  final engine = ref.watch(syncEngineProvider);
  final rescheduler = ref.watch(notificationReschedulerProvider);
  return UserSettingsRepository(
    database.userSettingsDao,
    database.outboxDao,
    engine.schedulePush,
    rescheduler.request,
  );
}

@riverpod
Stream<List<Category>> activeCategories(Ref ref) {
  return ref.watch(categoryRepositoryProvider).watchActive();
}

/// Active and archived categories, for the Manage Categories screen and
/// the archived-tasks grouping on the Day screen.
@riverpod
Stream<List<Category>> allCategories(Ref ref) {
  return ref.watch(categoryRepositoryProvider).watchAll();
}

@riverpod
Stream<LocalSettings> localSettings(Ref ref) {
  return ref.watch(settingsRepositoryProvider).watch();
}

@riverpod
Stream<List<Task>> tasksForDate(Ref ref, DateTime date) {
  return ref.watch(taskRepositoryProvider).watchForDate(date);
}

@riverpod
Stream<Set<DateTime>> tasksInMonth(Ref ref, DateTime monthStart) {
  final nextMonth = DateTime(monthStart.year, monthStart.month + 1, 1);
  return ref
      .watch(taskRepositoryProvider)
      .watchDatesWithTasksInRange(monthStart, nextMonth);
}

/// The `PageView` page currently on screen, so the app bar (Today pill,
/// date header) can react without every page rebuilding the controller.
@riverpod
class CurrentDayPageIndex extends _$CurrentDayPageIndex {
  @override
  int build() => 0;

  void set(int index) => state = index;
}
