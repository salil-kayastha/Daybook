import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Single registration point for all web/desktop keyboard shortcuts
/// (SPEC §7.6, M7). Single-key shortcuts are ignored while a text field has
/// focus or while [isBlocked] (a dialog/sheet is open) — except Esc, which
/// always fires so it can close whatever's open.
///
/// Deliberately does NOT bind any Ctrl/Cmd combination other than
/// Cmd/Ctrl+Enter, to avoid clashing with browser-reserved shortcuts
/// (Ctrl+N, Ctrl+T, Ctrl+W, ...). That combo and Esc are handled locally by
/// [QuickAddField] itself (next to the text it affects) rather than here,
/// since they only ever act on that one field.
class DayKeyboardShortcuts extends StatefulWidget {
  const DayKeyboardShortcuts({
    super.key,
    required this.child,
    required this.isBlocked,
    required this.onNewTask,
    required this.onPreviousDay,
    required this.onNextDay,
    required this.onToday,
    required this.onMoveSelection,
    required this.onEditSelected,
    required this.onToggleSelectedDone,
    required this.onDeleteSelected,
    required this.onEscape,
    required this.onShowHelp,
  });

  final Widget child;

  /// True while a dialog/modal sheet is open — blocks every shortcut
  /// except Esc.
  final bool isBlocked;

  final VoidCallback onNewTask;
  final VoidCallback onPreviousDay;
  final VoidCallback onNextDay;
  final VoidCallback onToday;

  /// -1 for Up (previous task), +1 for Down (next task).
  final ValueChanged<int> onMoveSelection;
  final VoidCallback onEditSelected;
  final VoidCallback onToggleSelectedDone;
  final VoidCallback onDeleteSelected;
  final VoidCallback onEscape;
  final VoidCallback onShowHelp;

  @override
  State<DayKeyboardShortcuts> createState() => _DayKeyboardShortcutsState();
}

class _DayKeyboardShortcutsState extends State<DayKeyboardShortcuts> {
  final _focusNode = FocusNode(debugLabel: 'DayKeyboardShortcuts');

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  bool _isTextFieldFocused() {
    final focused = FocusManager.instance.primaryFocus;
    final focusContext = focused?.context;
    if (focusContext == null) return false;
    if (focusContext.widget is EditableText) return true;
    return focusContext.findAncestorWidgetOfExactType<EditableText>() != null;
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final key = event.logicalKey;

    if (key == LogicalKeyboardKey.escape) {
      widget.onEscape();
      return KeyEventResult.handled;
    }

    if (_isTextFieldFocused() || widget.isBlocked) {
      return KeyEventResult.ignored;
    }

    switch (key) {
      case LogicalKeyboardKey.keyN:
        widget.onNewTask();
        return KeyEventResult.handled;
      case LogicalKeyboardKey.arrowLeft:
      case LogicalKeyboardKey.keyJ:
        widget.onPreviousDay();
        return KeyEventResult.handled;
      case LogicalKeyboardKey.arrowRight:
      case LogicalKeyboardKey.keyK:
        widget.onNextDay();
        return KeyEventResult.handled;
      case LogicalKeyboardKey.keyT:
        widget.onToday();
        return KeyEventResult.handled;
      case LogicalKeyboardKey.arrowUp:
        widget.onMoveSelection(-1);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.arrowDown:
        widget.onMoveSelection(1);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.keyE:
        widget.onEditSelected();
        return KeyEventResult.handled;
      case LogicalKeyboardKey.keyX:
        widget.onToggleSelectedDone();
        return KeyEventResult.handled;
      case LogicalKeyboardKey.delete:
        widget.onDeleteSelected();
        return KeyEventResult.handled;
    }

    if (event.character == '?') {
      widget.onShowHelp();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _handleKey,
      child: widget.child,
    );
  }
}
