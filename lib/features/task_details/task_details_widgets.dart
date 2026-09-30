import 'package:flutter/material.dart';

import '../../core/theme/theme.dart';
import '../../core/utils/color_utils.dart';
import '../../core/widgets/color_dot.dart';
import '../../core/widgets/daybook_button.dart';
import '../../domain/category.dart';
import '../../domain/checklist_item.dart';
import '../../domain/enums.dart';

class CategoryDropdown extends StatelessWidget {
  const CategoryDropdown({
    super.key,
    required this.categories,
    required this.selectedId,
    required this.onChanged,
  });

  final List<Category> categories;
  final String? selectedId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.daybookColors;
    if (categories.isEmpty) return const SizedBox.shrink();
    final validSelection = categories.any((c) => c.id == selectedId)
        ? selectedId
        : categories.first.id;

    return DropdownButtonFormField<String>(
      initialValue: validSelection,
      // Without this, the field/menu shrink-wrap their widest item instead
      // of the field's own width, so a long name overflows both the
      // closed field and the open menu rather than eliding.
      isExpanded: true,
      decoration: InputDecoration(
        labelText: 'Category',
        filled: true,
        fillColor: colors.surfaceAlt,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: DaybookSpacing.md,
          vertical: DaybookSpacing.sm,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DaybookRadii.card),
          borderSide: BorderSide.none,
        ),
      ),
      items: [
        for (final category in categories)
          DropdownMenuItem(
            value: category.id,
            child: Row(
              children: [
                ColorDot(color: colorFromHex(category.color)),
                const SizedBox(width: DaybookSpacing.sm),
                Expanded(
                  child: Text(
                    category.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
      ],
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
    );
  }
}

class TimeModeControl extends StatelessWidget {
  const TimeModeControl({
    super.key,
    required this.mode,
    required this.onChanged,
  });

  final TimeMode mode;
  final ValueChanged<TimeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<TimeMode>(
      segments: const [
        ButtonSegment(value: TimeMode.none, label: Text('No time')),
        ButtonSegment(value: TimeMode.at, label: Text('At time')),
        ButtonSegment(value: TimeMode.window, label: Text('Window')),
      ],
      selected: {mode},
      onSelectionChanged: (selection) => onChanged(selection.first),
    );
  }
}

class ChecklistEditor extends StatefulWidget {
  const ChecklistEditor({
    super.key,
    required this.items,
    required this.onAdd,
    required this.onToggle,
    required this.onRemove,
  });

  final List<ChecklistItem> items;
  final ValueChanged<String> onAdd;
  final ValueChanged<String> onToggle;
  final ValueChanged<String> onRemove;

  @override
  State<ChecklistEditor> createState() => _ChecklistEditorState();
}

class _ChecklistEditorState extends State<ChecklistEditor> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    widget.onAdd(_controller.text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.daybookColors;
    final text = context.daybookText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Checklist', style: text.sectionTitle),
        const SizedBox(height: DaybookSpacing.sm),
        for (final item in widget.items)
          Padding(
            padding: const EdgeInsets.only(bottom: DaybookSpacing.xs),
            child: Row(
              children: [
                Checkbox(
                  value: item.done,
                  onChanged: (_) => widget.onToggle(item.id),
                ),
                Expanded(
                  child: Text(
                    item.text,
                    style: text.body.copyWith(
                      color: item.done ? colors.inkMuted : colors.ink,
                      decoration: item.done ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ),
                Semantics(
                  label: 'Remove ${item.text}',
                  button: true,
                  child: IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: () => widget.onRemove(item.id),
                  ),
                ),
              ],
            ),
          ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(hintText: 'Add item'),
                onSubmitted: (_) => _submit(),
              ),
            ),
            IconButton(icon: const Icon(Icons.add), onPressed: _submit),
          ],
        ),
      ],
    );
  }
}

class StatusActions extends StatelessWidget {
  const StatusActions({
    super.key,
    required this.status,
    required this.onDone,
    required this.onCancel,
    required this.onRestore,
  });

  final TaskStatus status;
  final VoidCallback onDone;
  final VoidCallback onCancel;
  final VoidCallback onRestore;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: DaybookSpacing.sm,
      runSpacing: DaybookSpacing.sm,
      children: switch (status) {
        TaskStatus.todo => [
          DaybookButton(label: 'Mark done', onPressed: onDone),
          DaybookButton(
            label: 'Cancel task',
            variant: DaybookButtonVariant.secondary,
            onPressed: onCancel,
          ),
        ],
        TaskStatus.done => [
          DaybookButton(
            label: 'Restore to todo',
            variant: DaybookButtonVariant.secondary,
            onPressed: onRestore,
          ),
          DaybookButton(
            label: 'Cancel task',
            variant: DaybookButtonVariant.secondary,
            onPressed: onCancel,
          ),
        ],
        TaskStatus.cancelled => [
          DaybookButton(
            label: 'Restore to todo',
            variant: DaybookButtonVariant.secondary,
            onPressed: onRestore,
          ),
        ],
      },
    );
  }
}
