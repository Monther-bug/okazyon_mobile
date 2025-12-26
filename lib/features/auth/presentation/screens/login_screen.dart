import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:okazyon_mobile/core/constants/colors.dart';
import 'package:okazyon_mobile/core/constants/sizes.dart';
import 'package:okazyon_mobile/core/widgets/google_button.dart';
import 'package:okazyon_mobile/features/auth/presentation/controllers/auth_controller.dart';
import 'package:okazyon_mobile/features/auth/presentation/screens/signup_screen.dart';
import 'package:okazyon_mobile/features/auth/presentation/widgets/login_form.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      if (next.error != null && next.error != previous?.error) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(next.error!)));
        ref.read(authControllerProvider.notifier).clearError();
      }

      if (next.isAuthenticated && !(previous?.isAuthenticated ?? false)) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(context.tr('loginSuccessful')),
              backgroundColor: Colors.green,
            ),
          );
      }
    });

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: AppSizes.pagePadding,
            right: AppSizes.pagePadding,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: AppSizes.screenHeight(context) * 0.1),
              Column(
                children: [
                  Text(
                    context.tr('appTitle'),
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(width: 40, height: 4, color: AppColors.primary),
                ],
              ),
              SizedBox(height: AppSizes.screenHeight(context) * 0.08),
              const LoginForm(),
              SizedBox(height: AppSizes.widgetSpacing),
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: AppColors.grey.withValues(alpha: 0.3),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      context.tr(
                        'or',
                      ), // "or" key should be usually lowercased in design but tr might be uppercase
                      style: const TextStyle(color: AppColors.error),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: AppColors.grey.withValues(alpha: 0.3),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSizes.widgetSpacing),
              GoogleButton(
                onPressed:
                    authState.isLoading
                        ? null
                        : () {
                          ref
                              .read(authControllerProvider.notifier)
                              .loginWithGoogle();
                        },
              ),
              SizedBox(height: AppSizes.widgetSpacing),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    context.tr('dontHaveAccount'),
                  ), // Map manually if needed: "don't have an account?"
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap:
                        authState.isLoading
                            ? null
                            : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignupScreen(),
                                ),
                              );
                            },
                    child: Text(
                      context.tr('signUp'),
                      style: const TextStyle(
                        color: AppColors.error,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
