import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/local/database.dart' show AppDatabase;
import '../../data/repositories/category_repository.dart';
import '../../data/repositories/task_repository.dart';
import '../../domain/category.dart';
import '../../domain/task.dart';

part 'day_providers.g.dart';

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
}

@Riverpod(keepAlive: true)
CategoryRepository categoryRepository(Ref ref) {
  final database = ref.watch(appDatabaseProvider);
  return CategoryRepository(database.categoryDao);
}

@Riverpod(keepAlive: true)
TaskRepository taskRepository(Ref ref) {
  final database = ref.watch(appDatabaseProvider);
  return TaskRepository(database.taskDao);
}

@riverpod
Stream<List<Category>> activeCategories(Ref ref) {
  return ref.watch(categoryRepositoryProvider).watchActive();
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
