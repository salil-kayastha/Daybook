import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';

/// Mirrors `public.categories` (SPEC §4). `userId` is null until the
/// device has signed in (M4); sync starts populating it then.
@freezed
abstract class Category with _$Category {
  const factory Category({
    required String id,
    String? userId,
    required String name,

    /// Hex string like `#4C6EF5` (SPEC §6.1 category palette).
    required String color,
    String? icon,
    required double sortOrder,
    @Default(false) bool isArchived,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
  }) = _Category;
}
