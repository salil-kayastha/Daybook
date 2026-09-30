import 'package:flutter/material.dart';

import '../../core/theme/theme.dart';
import '../../core/utils/category_validation.dart';
import '../../core/widgets/color_dot.dart';
import '../../core/widgets/daybook_button.dart';
import '../../domain/category.dart';

class CategoryEditResult {
  const CategoryEditResult({required this.name, required this.colorHex});

  final String name;
  final String colorHex;
}

/// Create/rename/recolor sheet, shared by both flows (SPEC M3: name +
/// 10-color palette from SPEC §6.1).
Future<CategoryEditResult?> showCategoryEditSheet(
  BuildContext context, {
  required List<Category> existingActive,
  Category? editing,
}) {
  return showModalBottomSheet<CategoryEditResult>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(DaybookRadii.sheet),
      ),
    ),
    builder: (context) =>
        _CategoryEditSheet(existingActive: existingActive, editing: editing),
  );
}

class _CategoryEditSheet extends StatefulWidget {
  const _CategoryEditSheet({required this.existingActive, this.editing});

  final List<Category> existingActive;
  final Category? editing;

  @override
  State<_CategoryEditSheet> createState() => _CategoryEditSheetState();
}

class _CategoryEditSheetState extends State<_CategoryEditSheet> {
  late final TextEditingController _nameController = TextEditingController(
    text: widget.editing?.name ?? '',
  );
  late String _colorHex =
      widget.editing?.color ?? DaybookColors.categoryPalette.first.toHex();
  String? _error;

  void _submit() {
    final name = _nameController.text;
    final error = validateCategoryName(
      name,
      widget.existingActive,
      excludingId: widget.editing?.id,
    );
    if (error != null) {
      setState(() => _error = error);
      return;
    }
    Navigator.of(context)
        .pop(CategoryEditResult(name: name.trim(), colorHex: _colorHex));
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = context.daybookText;
    final colors = context.daybookColors;
    final isEditing = widget.editing != null;

    return Padding(
      padding: EdgeInsets.only(
        left: DaybookSpacing.lg,
        right: DaybookSpacing.lg,
        top: DaybookSpacing.lg,
        bottom: MediaQuery.viewInsetsOf(context).bottom + DaybookSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isEditing ? 'Edit category' : 'New category',
            style: text.sectionTitle,
          ),
          const SizedBox(height: DaybookSpacing.md),
          TextField(
            controller: _nameController,
            autofocus: !isEditing,
            decoration: InputDecoration(hintText: 'Name', errorText: _error),
            onChanged: (_) {
              if (_error != null) setState(() => _error = null);
            },
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: DaybookSpacing.md),
          Text('Color', style: text.taskMeta.copyWith(color: colors.inkMuted)),
          const SizedBox(height: DaybookSpacing.sm),
          Wrap(
            spacing: DaybookSpacing.sm,
            runSpacing: DaybookSpacing.sm,
            children: [
              for (final color in DaybookColors.categoryPalette)
                _Swatch(
                  color: color,
                  selected: color.toHex() == _colorHex,
                  onTap: () => setState(() => _colorHex = color.toHex()),
                ),
            ],
          ),
          const SizedBox(height: DaybookSpacing.lg),
          SizedBox(
            width: double.infinity,
            child: DaybookButton(
              label: isEditing ? 'Save' : 'Create',
              onPressed: _submit,
            ),
          ),
        ],
      ),
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.daybookColors;
    return Semantics(
      label: 'Select color',
      button: true,
      selected: selected,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(DaybookRadii.pill),
        child: Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: selected ? colors.ink : Colors.transparent,
              width: 2,
            ),
          ),
          child: ColorDot(color: color, diameter: 24),
        ),
      ),
    );
  }
}

extension on Color {
  String toHex() =>
      '#${(toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
}
