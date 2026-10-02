import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/theme/theme.dart';
import '../../core/utils/category_defaults.dart';
import '../../core/utils/quick_add_parser.dart';
import '../../domain/enums.dart';
import '../../domain/task.dart';
import 'day_providers.dart';

/// Web's persistent quick-add input (SPEC §7.4, M7): a pure parser
/// ([parseQuickAdd]) recognizes `#category`, dates and times live as the
/// user types, shown as dismissible chips under the field. Dismissing a
/// chip stops recognizing that kind of token (for this input) and the
/// original words fall back into the title.
class QuickAddField extends ConsumerStatefulWidget {
  const QuickAddField({
    super.key,
    required this.date,
    this.autofocus = false,
    this.focusNode,
  });

  final DateTime date;
  final bool autofocus;

  /// Shared with the keyboard-shortcuts handler (`N` focuses this field) —
  /// only the currently-visible day's [QuickAddField] is given one; others
  /// fall back to an internally-owned node.
  final FocusNode? focusNode;

  @override
  ConsumerState<QuickAddField> createState() => _QuickAddFieldState();
}

class _QuickAddFieldState extends ConsumerState<QuickAddField> {
  final _controller = TextEditingController();
  late final FocusNode _focusNode;
  bool _ownsFocusNode = false;

  bool _recognizeCategory = true;
  bool _recognizeDate = true;
  bool _recognizeTime = true;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _ownsFocusNode = widget.focusNode == null;
    _controller.addListener(_onChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onChanged);
    _controller.dispose();
    if (_ownsFocusNode) _focusNode.dispose();
    super.dispose();
  }

  void _onChanged() => setState(() {});

  ParsedTask _parse() {
    final categories = ref.read(activeCategoriesProvider).value ?? const [];
    final localSettings = ref.read(localSettingsProvider).value;
    final defaultCategoryId = resolveDefaultCategoryId(
      categories,
      localSettings?.defaultCategoryId,
    );
    return parseQuickAdd(
      _controller.text,
      DateTime.now(),
      categories,
      defaultCategoryId: defaultCategoryId,
      recognizeCategory: _recognizeCategory,
      recognizeDate: _recognizeDate,
      recognizeTime: _recognizeTime,
    );
  }

  void _dismiss(QuickAddTokenKind kind) {
    setState(() {
      switch (kind) {
        case QuickAddTokenKind.category:
          _recognizeCategory = false;
        case QuickAddTokenKind.date:
          _recognizeDate = false;
        case QuickAddTokenKind.time:
          _recognizeTime = false;
      }
    });
  }

  void _resetRecognition() {
    _recognizeCategory = true;
    _recognizeDate = true;
    _recognizeTime = true;
  }

  Future<void> _submit() async {
    final parsed = _parse();
    if (!parsed.isValid || parsed.categoryId == null) return;

    final now = DateTime.now().toUtc();
    final task = Task(
      id: const Uuid().v4(),
      categoryId: parsed.categoryId,
      title: parsed.title,
      taskDate:
          parsed.taskDate ??
          DateTime(widget.date.year, widget.date.month, widget.date.day),
      timeMode: parsed.timeMode,
      startTime: parsed.startTime,
      endTime: parsed.endTime,
      sortOrder: now.millisecondsSinceEpoch.toDouble(),
      createdAt: now,
      updatedAt: now,
    );
    await ref.read(taskRepositoryProvider).upsert(task);
    _controller.clear();
    setState(_resetRecognition);
    // SPEC §7.4: Enter adds and keeps the input focused for the next one.
    _focusNode.requestFocus();
  }

  void _clear() {
    _controller.clear();
    setState(_resetRecognition);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.daybookColors;
    final parsed = _parse();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Focus(
          onKeyEvent: (node, event) {
            if (event is KeyDownEvent &&
                event.logicalKey == LogicalKeyboardKey.escape) {
              _clear();
              return KeyEventResult.handled;
            }
            return KeyEventResult.ignored;
          },
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
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
          ),
        ),
        if (parsed.tokens.isNotEmpty) ...[
          const SizedBox(height: DaybookSpacing.xs),
          Wrap(
            spacing: DaybookSpacing.xs,
            runSpacing: DaybookSpacing.xs,
            children: [
              for (final token in parsed.tokens)
                _QuickAddChip(
                  label: _chipLabel(token, parsed),
                  onDismiss: () => _dismiss(token.kind),
                ),
            ],
          ),
        ],
      ],
    );
  }

  String _chipLabel(QuickAddToken token, ParsedTask parsed) {
    switch (token.kind) {
      case QuickAddTokenKind.category:
        return parsed.categoryLabel ?? token.rawText;
      case QuickAddTokenKind.date:
        final date = parsed.taskDate;
        return date == null
            ? token.rawText
            : '${date.year}-${date.month.toString().padLeft(2, '0')}-'
                  '${date.day.toString().padLeft(2, '0')}';
      case QuickAddTokenKind.time:
        final start = parsed.startTime;
        if (start == null) return token.rawText;
        final startLabel = _formatHour(start.hour, start.minute);
        final end = parsed.endTime;
        if (end == null) return startLabel;
        final endLabel = _formatHour(end.hour, end.minute);
        final suffix = parsed.timeMode == TimeMode.window ? ' · anytime' : '';
        return '$startLabel – $endLabel$suffix';
    }
  }

  String _formatHour(int hour, int minute) {
    final period = hour >= 12 ? 'PM' : 'AM';
    final h12 = hour % 12 == 0 ? 12 : hour % 12;
    final m = minute.toString().padLeft(2, '0');
    return '$h12:$m $period';
  }
}

class _QuickAddChip extends StatelessWidget {
  const _QuickAddChip({required this.label, required this.onDismiss});

  final String label;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final colors = context.daybookColors;
    final text = context.daybookText;

    return Container(
      padding: const EdgeInsets.only(
        left: DaybookSpacing.sm,
        right: DaybookSpacing.xs,
        top: 4,
        bottom: 4,
      ),
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(DaybookRadii.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: text.taskMeta),
          const SizedBox(width: DaybookSpacing.xs),
          Semantics(
            label: 'Dismiss $label',
            button: true,
            child: InkWell(
              borderRadius: BorderRadius.circular(DaybookRadii.pill),
              onTap: onDismiss,
              child: Icon(Icons.close, size: 14, color: colors.inkMuted),
            ),
          ),
        ],
      ),
    );
  }
}
