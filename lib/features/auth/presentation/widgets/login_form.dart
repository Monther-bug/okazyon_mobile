import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:okazyon_mobile/core/constants/colors.dart';
import 'package:okazyon_mobile/core/constants/sizes.dart';
import 'package:okazyon_mobile/core/utils/validators.dart';
import 'package:okazyon_mobile/core/widgets/custom_button.dart';
import 'package:okazyon_mobile/core/widgets/custom_text_field.dart';
import 'package:okazyon_mobile/features/auth/presentation/controllers/auth_controller.dart';
import 'package:okazyon_mobile/features/auth/presentation/controllers/login_controller.dart';
import 'package:okazyon_mobile/features/auth/presentation/screens/forgot_password_screen.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final loginFormState = ref.watch(loginFormControllerProvider);
    final controllers = ref.watch(loginTextControllersProvider);

    return Form(
      key: formKey,
      child: Column(
        children: [
          CustomTextField(
            labelText: context.tr('phoneNumber'),
            hintText: context.tr('enterPhone'),
            controller: controllers['phone']!,
            validator: (value) => CustomValidator.phone(value, context),
            suffixIcon: Iconsax.mobile,
          ),
          SizedBox(height: AppSizes.widgetSpacing),
          CustomTextField(
            labelText: context.tr('password'),
            hintText: context.tr('enterPassword'),
            controller: controllers['password']!,
            validator: (value) => CustomValidator.password(value, context),
            suffixIcon: Iconsax.lock,
            obscureText: loginFormState.obscurePassword,
            prefixIcon:
                loginFormState.obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
            onSuffixIconPressed: () {
              ref
                  .read(loginFormControllerProvider.notifier)
                  .togglePasswordVisibility();
            },
          ),
          SizedBox(height: AppSizes.widgetSpacing),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed:
                  authState.isLoading
                      ? null
                      : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPasswordScreen(),
                          ),
                        );
                      },
              child: Text(
                context.tr('forgotPassword'),
                style: const TextStyle(color: AppColors.primary),
              ),
            ),
          ),
          SizedBox(height: AppSizes.widgetSpacing),
          CustomButton(
            text:
                authState.isLoading
                    ? context.tr('loggingIn')
                    : context.tr('login'),
            onPressed:
                authState.isLoading
                    ? null
                    : () {
                      if (formKey.currentState?.validate() ?? false) {
                        ref
                            .read(authControllerProvider.notifier)
                            .login(
                              phone: controllers['phone']!.text,
                              password: controllers['password']!.text,
                            );
                      }
                    },
          ),
        ],
      ),
    );
  }
}
