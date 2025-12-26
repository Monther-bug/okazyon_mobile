import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:okazyon_mobile/features/main_nav/presentation/screens/main_nav_screen.dart';

import '../../domain/usecases/send_otp_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../providers/auth_providers.dart';

// OTP State
class OtpState {
  final int timerValue;
  final bool isTimerActive;
  final bool isLoading;
  final String? error;

  const OtpState({
    this.timerValue = 60,
    this.isTimerActive = true,
    this.isLoading = false,
    this.error,
  });

  OtpState copyWith({
    int? timerValue,
    bool? isTimerActive,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return OtpState(
      timerValue: timerValue ?? this.timerValue,
      isTimerActive: isTimerActive ?? this.isTimerActive,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
    );
  }
}

// OTP Controller
class OtpController extends StateNotifier<OtpState> {
  final VerifyOtpUseCase _verifyOtpUseCase;
  final SendOtpUseCase _sendOtpUseCase;
  final LoginUseCase _loginUseCase;
  Timer? _timer;

  OtpController({
    required VerifyOtpUseCase verifyOtpUseCase,
    required SendOtpUseCase sendOtpUseCase,
    required LoginUseCase loginUseCase,
  }) : _verifyOtpUseCase = verifyOtpUseCase,
       _sendOtpUseCase = sendOtpUseCase,
       _loginUseCase = loginUseCase,
       super(const OtpState()) {
    startTimer();
  }

  void startTimer() {
    state = state.copyWith(timerValue: 60, isTimerActive: true);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.timerValue > 0) {
        state = state.copyWith(timerValue: state.timerValue - 1);
      } else {
        state = state.copyWith(isTimerActive: false);
        timer.cancel();
      }
    });
  }

  Future<void> verifyOtp(
    String otp,
    BuildContext context,
    String phone, [
    String? password,
  ]) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final isVerified = await _verifyOtpUseCase.call(phone: phone, otp: otp);

      if (isVerified) {
        state = state.copyWith(isLoading: false);

        if (password != null) {
          try {
            // Auto-login
            await _loginUseCase.call(phone: phone, password: password);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    context.tr('otpVerifiedSuccessfully') ??
                        'OTP Verified Successfully',
                  ),
                  backgroundColor: Colors.green,
                ),
              );
              // Navigate to MainNavScreen (Home)
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const MainNavScreen()),
                (route) => false,
              );
            }
          } catch (e) {
            // Login failed? Navigate to LoginScreen
            if (context.mounted) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            }
          }
        } else {
          // No password (e.g. Forgot Password flow), just verify
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  context.tr('otpVerifiedSuccessfully') ??
                      'OTP Verified Successfully',
                ),
                backgroundColor: Colors.green,
              ),
            );
            // Return true or handle explicitly if needed
            // For now we don't navigate automatically, caller handles listeners if any
          }
        }
      } else {
        state = state.copyWith(
          isLoading: false,
          error:
              context.mounted
                  ? context.tr('invalidOtpCode')
                  : 'Invalid OTP code',
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> resendOtp(String phone) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _sendOtpUseCase.call(
        phone: phone,
        purpose: 'verification',
      ); // Assuming purpose
      startTimer();
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

// Provider
final otpControllerProvider =
    StateNotifierProvider.autoDispose<OtpController, OtpState>(
      (ref) => OtpController(
        verifyOtpUseCase: ref.read(verifyOtpUseCaseProvider),
        sendOtpUseCase: ref.read(sendOtpUseCaseProvider),
        loginUseCase: ref.read(loginUseCaseProvider),
      ),
    );
