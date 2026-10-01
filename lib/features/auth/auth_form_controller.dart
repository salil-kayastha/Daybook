import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/utils/auth_error_mapping.dart';
import 'auth_providers.dart';

part 'auth_form_controller.g.dart';

enum AuthFormMode { signIn, signUp }

class AuthFormState {
  const AuthFormState({
    this.mode = AuthFormMode.signIn,
    this.isSubmitting = false,
    this.errorMessage,
    this.awaitingEmailConfirmation = false,
  });

  final AuthFormMode mode;
  final bool isSubmitting;
  final String? errorMessage;

  /// True after sign-up when Supabase requires the user to confirm their
  /// email before the account is usable (`AuthResponse.session == null`).
  final bool awaitingEmailConfirmation;

  AuthFormState copyWith({
    AuthFormMode? mode,
    bool? isSubmitting,
    String? errorMessage,
    bool clearError = false,
    bool? awaitingEmailConfirmation,
  }) {
    return AuthFormState(
      mode: mode ?? this.mode,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      awaitingEmailConfirmation:
          awaitingEmailConfirmation ?? this.awaitingEmailConfirmation,
    );
  }
}

@riverpod
class AuthFormController extends _$AuthFormController {
  @override
  AuthFormState build() => const AuthFormState();

  void reset() => state = const AuthFormState();

  void toggleMode() {
    state = state.copyWith(
      mode: state.mode == AuthFormMode.signIn
          ? AuthFormMode.signUp
          : AuthFormMode.signIn,
      clearError: true,
    );
  }

  Future<void> submit({required String email, required String password}) async {
    state = state.copyWith(isSubmitting: true, clearError: true);
    final repository = ref.read(authRepositoryProvider);
    try {
      if (state.mode == AuthFormMode.signIn) {
        await repository.signInWithPassword(email: email, password: password);
        state = state.copyWith(isSubmitting: false);
      } else {
        final response = await repository.signUpWithPassword(
          email: email,
          password: password,
        );
        state = state.copyWith(
          isSubmitting: false,
          awaitingEmailConfirmation: response.session == null,
        );
      }
    } catch (error) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: mapAuthError(error),
      );
    }
  }

  /// Returns a friendly error message, or null on success.
  Future<String?> sendPasswordReset(String email) async {
    try {
      await ref.read(authRepositoryProvider).resetPasswordForEmail(email);
      return null;
    } catch (error) {
      return mapAuthError(error);
    }
  }
}
