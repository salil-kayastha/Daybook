import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/theme.dart';
import '../../core/widgets/daybook_button.dart';
import 'auth_form_controller.dart';
import 'forgot_password_sheet.dart';

/// Email + password auth (SPEC §7.1). Google sign-in is a later task.
class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) return;
    ref
        .read(authFormControllerProvider.notifier)
        .submit(email: email, password: password);
  }

  @override
  Widget build(BuildContext context) {
    final text = context.daybookText;
    final colors = context.daybookColors;
    final formState = ref.watch(authFormControllerProvider);
    final isWide = MediaQuery.sizeOf(context).width >= 700;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isWide
                  ? DaybookSpacing.screenPaddingWeb
                  : DaybookSpacing.screenPaddingPhone,
              vertical: DaybookSpacing.xl,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: formState.awaitingEmailConfirmation
                  ? _EmailConfirmationPending(
                      onBackToSignIn: () =>
                          ref.read(authFormControllerProvider.notifier).reset(),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Daybook',
                          textAlign: TextAlign.center,
                          style: text.displayDate,
                        ),
                        const SizedBox(height: DaybookSpacing.xs),
                        Text(
                          'Plan the day, one page at a time.',
                          textAlign: TextAlign.center,
                          style: text.subDate,
                        ),
                        const SizedBox(height: DaybookSpacing.xxl),
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [AutofillHints.email],
                          decoration: const InputDecoration(hintText: 'Email'),
                        ),
                        const SizedBox(height: DaybookSpacing.md),
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          autofillHints: const [AutofillHints.password],
                          decoration: const InputDecoration(
                            hintText: 'Password',
                          ),
                          onSubmitted: (_) => _submit(),
                        ),
                        if (formState.mode == AuthFormMode.signIn) ...[
                          const SizedBox(height: DaybookSpacing.sm),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => showForgotPasswordSheet(
                                context,
                                initialEmail: _emailController.text.trim(),
                              ),
                              child: const Text('Forgot password?'),
                            ),
                          ),
                        ],
                        if (formState.errorMessage != null) ...[
                          const SizedBox(height: DaybookSpacing.sm),
                          Text(
                            formState.errorMessage!,
                            style: text.taskMeta.copyWith(color: colors.danger),
                          ),
                        ],
                        const SizedBox(height: DaybookSpacing.lg),
                        DaybookButton(
                          label: formState.isSubmitting
                              ? (formState.mode == AuthFormMode.signIn
                                    ? 'Signing in…'
                                    : 'Creating account…')
                              : (formState.mode == AuthFormMode.signIn
                                    ? 'Sign in'
                                    : 'Create account'),
                          onPressed: formState.isSubmitting ? null : _submit,
                        ),
                        const SizedBox(height: DaybookSpacing.md),
                        TextButton(
                          onPressed: formState.isSubmitting
                              ? null
                              : () => ref
                                    .read(authFormControllerProvider.notifier)
                                    .toggleMode(),
                          child: Text(
                            formState.mode == AuthFormMode.signIn
                                ? "Don't have an account? Create one"
                                : 'Already have an account? Sign in',
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmailConfirmationPending extends StatelessWidget {
  const _EmailConfirmationPending({required this.onBackToSignIn});

  final VoidCallback onBackToSignIn;

  @override
  Widget build(BuildContext context) {
    final text = context.daybookText;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Check your email',
          textAlign: TextAlign.center,
          style: text.displayDate,
        ),
        const SizedBox(height: DaybookSpacing.sm),
        Text(
          'Check your email to confirm your account, then sign in.',
          textAlign: TextAlign.center,
          style: text.body,
        ),
        const SizedBox(height: DaybookSpacing.xl),
        DaybookButton(label: 'Back to sign in', onPressed: onBackToSignIn),
      ],
    );
  }
}
