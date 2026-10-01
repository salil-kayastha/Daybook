import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/theme.dart';
import '../../core/widgets/daybook_button.dart';
import 'auth_form_controller.dart';

Future<void> showForgotPasswordSheet(
  BuildContext context, {
  required String initialEmail,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(DaybookRadii.sheet),
      ),
    ),
    builder: (_) => _ForgotPasswordSheet(initialEmail: initialEmail),
  );
}

class _ForgotPasswordSheet extends ConsumerStatefulWidget {
  const _ForgotPasswordSheet({required this.initialEmail});

  final String initialEmail;

  @override
  ConsumerState<_ForgotPasswordSheet> createState() =>
      _ForgotPasswordSheetState();
}

class _ForgotPasswordSheetState extends ConsumerState<_ForgotPasswordSheet> {
  late final _emailController = TextEditingController(
    text: widget.initialEmail,
  );
  bool _isSubmitting = false;
  String? _error;
  bool _sent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _isSubmitting = true;
      _error = null;
    });
    final error = await ref
        .read(authFormControllerProvider.notifier)
        .sendPasswordReset(_emailController.text.trim());
    if (!mounted) return;
    setState(() {
      _isSubmitting = false;
      _error = error;
      _sent = error == null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final text = context.daybookText;
    final colors = context.daybookColors;

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
          Text('Reset your password', style: text.sectionTitle),
          const SizedBox(height: DaybookSpacing.sm),
          if (_sent)
            Text(
              'Check your email for a link to reset your password.',
              style: text.body,
            )
          else ...[
            Text(
              "We'll email you a link to reset your password.",
              style: text.body.copyWith(color: colors.inkMuted),
            ),
            const SizedBox(height: DaybookSpacing.md),
            TextField(
              controller: _emailController,
              autofocus: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(hintText: 'Email', errorText: _error),
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: DaybookSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: DaybookButton(
                label: _isSubmitting ? 'Sending…' : 'Send reset link',
                onPressed: _isSubmitting ? null : _submit,
              ),
            ),
          ],
          const SizedBox(height: DaybookSpacing.lg),
        ],
      ),
    );
  }
}
