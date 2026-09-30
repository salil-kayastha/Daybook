import '../../domain/category.dart';
import '../../domain/task.dart';

/// Result of [groupTasksForDay]: tasks bucketed by their active category,
/// plus one combined bucket for tasks whose category has been archived
/// (SPEC M3 — archived categories drop out of the filter/picker, but their
/// existing tasks still show, under one "Archived" section).
class DayTaskGroups {
  const DayTaskGroups({
    required this.byActiveCategoryId,
    required this.archived,
  });

  final Map<String, List<Task>> byActiveCategoryId;
  final List<Task> archived;
}

DayTaskGroups groupTasksForDay(List<Task> tasks, List<Category> allCategories) {
  final activeIds = {
    for (final c in allCategories.where((c) => !c.isArchived)) c.id,
  };
  final archivedIds = {
    for (final c in allCategories.where((c) => c.isArchived)) c.id,
  };

  final byActive = <String, List<Task>>{};
  final archived = <Task>[];

  for (final task in tasks) {
    final categoryId = task.categoryId;
    if (categoryId == null) continue;
    if (activeIds.contains(categoryId)) {
      byActive.putIfAbsent(categoryId, () => []).add(task);
    } else if (archivedIds.contains(categoryId)) {
      archived.add(task);
    }
  }

  return DayTaskGroups(byActiveCategoryId: byActive, archived: archived);
}
