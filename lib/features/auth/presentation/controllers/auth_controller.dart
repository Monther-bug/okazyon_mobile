import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/send_otp_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import '../../domain/usecases/change_password_usecase.dart';
import '../providers/auth_providers.dart';

/// Authentication State
class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final String? error;
  final String? user; // username or display name

  const AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.error,
    this.user,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    String? error,
    String? user,
    bool clearError = false,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      error: clearError ? null : (error ?? this.error),
      user: user ?? this.user,
    );
  }
}

class AuthController extends StateNotifier<AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final SendOtpUseCase _sendOtpUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;
  final ChangePasswordUseCase _changePasswordUseCase;

  AuthController({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required SendOtpUseCase sendOtpUseCase,
    required VerifyOtpUseCase verifyOtpUseCase,
    required ResetPasswordUseCase resetPasswordUseCase,
    required ChangePasswordUseCase changePasswordUseCase,
  }) : _loginUseCase = loginUseCase,
       _registerUseCase = registerUseCase,
       _logoutUseCase = logoutUseCase,
       _sendOtpUseCase = sendOtpUseCase,
       _verifyOtpUseCase = verifyOtpUseCase,
       _resetPasswordUseCase = resetPasswordUseCase,
       _changePasswordUseCase = changePasswordUseCase,
       super(const AuthState());

  // ... (existing login method) ...

  Future<void> sendOtp({required String phone, required String purpose}) async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _sendOtpUseCase.call(phone: phone, purpose: purpose);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: _getErrorMessage(e));
    }
  }

  Future<bool> verifyOtp({required String phone, required String otp}) async {
    if (state.isLoading) return false;
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final isVerified = await _verifyOtpUseCase.call(phone: phone, otp: otp);
      state = state.copyWith(isLoading: false);
      return isVerified;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: _getErrorMessage(e));
      return false;
    }
  }

  Future<void> resetPassword({
    required String phone,
    required String otp,
    required String newPassword,
  }) async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _resetPasswordUseCase.call(
        phone: phone,
        otp: otp,
        newPassword: newPassword,
      );
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: _getErrorMessage(e));
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _changePasswordUseCase.call(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: _getErrorMessage(e));
    }
  }

  // ... (existing methods like login, signup, logout) ...

  Future<void> login({required String phone, required String password}) async {
    if (state.isLoading) return;

    if (phone.trim().isEmpty) {
      state = state.copyWith(error: 'Phone number is required');
      return;
    }
    if (password.trim().isEmpty) {
      state = state.copyWith(error: 'Password is required');
      return;
    }

    state = state.copyWith(
      isLoading: true,
      clearError: true,
      isAuthenticated: false,
    );

    try {
      final result = await _loginUseCase.call(
        phone: phone.trim(),
        password: password.trim(),
      );

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        user: result.user.username,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        error: _getErrorMessage(e),
      );
    }
  }

  Future<void> signup({
    required String username,
    required String phone,
    required String password,
    required String confirmPassword,
    required bool agreeToTerms,
  }) async {
    if (state.isLoading) return;

    if (username.trim().isEmpty) {
      state = state.copyWith(error: 'Username is required');
      return;
    }
    if (phone.trim().isEmpty) {
      state = state.copyWith(error: 'Phone number is required');
      return;
    }
    if (!agreeToTerms) {
      state = state.copyWith(
        error: 'You must agree to the Terms & Privacy Policy',
      );
      return;
    }
    if (password.trim().isEmpty) {
      state = state.copyWith(error: 'Password is required');
      return;
    }
    if (password != confirmPassword) {
      state = state.copyWith(error: 'Passwords do not match');
      return;
    }

    state = state.copyWith(
      isLoading: true,
      clearError: true,
      isAuthenticated: false,
    );

    try {
      final result = await _registerUseCase.call(
        username: username.trim(),
        email: phone.trim(), // Using phone as email for now
        password: password.trim(),
        phone: phone.trim(),
      );

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        user: result.user.username,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        error: _getErrorMessage(e),
      );
    }
  }

  Future<void> loginWithGoogle() async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true, clearError: true);
    await Future.delayed(const Duration(seconds: 1));
    state = state.copyWith(
      isLoading: false,
      error: 'Google login not implemented yet',
    );
  }

  Future<void> logout() async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true);
    try {
      await _logoutUseCase.call();
      state = const AuthState();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: _getErrorMessage(e));
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  String _getErrorMessage(dynamic error) {
    final s = error.toString().toLowerCase();
    if (s.contains('401') || s.contains('unauthorized')) {
      return 'Invalid phone number or password';
    }
    if (s.contains('422') || s.contains('validation')) {
      return 'Please check your input and try again';
    }
    if (s.contains('409') || s.contains('conflict')) {
      return 'Phone number already exists';
    }
    if (s.contains('timeout')) {
      return 'Request timed out. Try again.';
    }
    if (s.contains('network') ||
        s.contains('socket') ||
        s.contains('connection')) {
      return 'Network error. Check your internet connection';
    }
    if (s.contains('server') || s.contains('500')) {
      return 'Server error. Please try later';
    }
    return 'An error occurred. Please try again';
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) => AuthController(
    loginUseCase: ref.read(loginUseCaseProvider),
    registerUseCase: ref.read(registerUseCaseProvider),
    logoutUseCase: ref.read(logoutUseCaseProvider),
    sendOtpUseCase: ref.read(sendOtpUseCaseProvider),
    verifyOtpUseCase: ref.read(verifyOtpUseCaseProvider),
    resetPasswordUseCase: ref.read(resetPasswordUseCaseProvider),
    changePasswordUseCase: ref.read(changePasswordUseCaseProvider),
  ),
);
