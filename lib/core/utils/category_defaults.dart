import '../../domain/category.dart';

/// The category quick-add/FAB/create-mode details sheet should default to:
/// [preferredId] (the saved default, or the last-used category) if it's
/// still active, else the first active category, else null if there are
/// none. A single source of truth so every call site falls back the same
/// way when the preferred category has been archived.
String? resolveDefaultCategoryId(
  List<Category> activeCategories,
  String? preferredId,
) {
  if (preferredId != null) {
    final preferred = activeCategories.where((c) => c.id == preferredId);
    if (preferred.isNotEmpty) return preferredId;
  }
  if (activeCategories.isEmpty) return null;
  return activeCategories.first.id;
}
