import '../../domain/category.dart';

/// Category name rules (SPEC M3): required, 1-60 chars, no duplicate
/// *active* name (case-insensitive). [excludingId] lets an edit compare
/// against every other category without tripping on itself.
String? validateCategoryName(
  String name,
  List<Category> existingActive, {
  String? excludingId,
}) {
  final trimmed = name.trim();
  if (trimmed.isEmpty) return 'Name is required.';
  if (trimmed.length > 60) return 'Name must be 60 characters or fewer.';

  final normalized = trimmed.toLowerCase();
  final isDuplicate = existingActive.any(
    (c) => c.id != excludingId && c.name.trim().toLowerCase() == normalized,
  );
  if (isDuplicate) return 'A category with this name already exists.';

  return null;
}
