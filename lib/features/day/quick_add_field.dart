import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/theme/theme.dart';
import '../../core/utils/category_defaults.dart';
import '../../domain/task.dart';
import 'day_providers.dart';

/// Web's persistent title-only add input, pinned at the top of the day
/// pane (SPEC §7.4 — the parser and live chips are M7; this is the
/// minimal M2 version: title in, task created with the default category).
class QuickAddField extends ConsumerStatefulWidget {
  const QuickAddField({super.key, required this.date, this.autofocus = false});

  final DateTime date;
  final bool autofocus;

  @override
  ConsumerState<QuickAddField> createState() => _QuickAddFieldState();
}

class _QuickAddFieldState extends ConsumerState<QuickAddField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final title = _controller.text.trim();
    if (title.isEmpty) return;

    final categories = ref.read(activeCategoriesProvider).value ?? const [];
    final settings = ref.read(localSettingsProvider).value;
    final categoryId = resolveDefaultCategoryId(
      categories,
      settings?.defaultCategoryId,
    );
    if (categoryId == null) return;

    final now = DateTime.now().toUtc();
    final task = Task(
      id: const Uuid().v4(),
      categoryId: categoryId,
      title: title,
      taskDate: DateTime(widget.date.year, widget.date.month, widget.date.day),
      sortOrder: now.millisecondsSinceEpoch.toDouble(),
      createdAt: now,
      updatedAt: now,
    );
    await ref.read(taskRepositoryProvider).upsert(task);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.daybookColors;
    return TextField(
      controller: _controller,
      autofocus: widget.autofocus,
      decoration: InputDecoration(
        hintText: 'Add a task and press Enter…',
        filled: true,
        fillColor: colors.surface,
        prefixIcon: const Icon(Icons.add),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DaybookRadii.card),
          borderSide: BorderSide(color: colors.line),
        ),
      ),
      onSubmitted: (_) => _submit(),
    );
  }
}
