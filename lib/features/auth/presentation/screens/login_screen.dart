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
              Text(
                context.tr('appTitle'),
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(width: 40, height: 4, color: Colors.red),
              SizedBox(height: AppSizes.screenHeight(context) * 0.1),
              const LoginForm(),
              SizedBox(height: AppSizes.widgetSpacing),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(context.tr('dontHaveAccount')),
                  TextButton(
                    onPressed:
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
                      style: const TextStyle(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSizes.widgetSpacing),
              Text(context.tr('orContinueWith')),
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
            ],
          ),
        ),
      ),
    );
  }
}
