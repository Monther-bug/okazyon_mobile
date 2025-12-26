import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:okazyon_mobile/core/constants/colors.dart';
import 'package:okazyon_mobile/core/constants/sizes.dart';
import 'package:okazyon_mobile/core/utils/validators.dart';
import 'package:okazyon_mobile/core/widgets/custom_button.dart';
import 'package:okazyon_mobile/core/widgets/custom_text_field.dart';
import 'package:okazyon_mobile/features/auth/presentation/controllers/auth_controller.dart';
import 'package:okazyon_mobile/features/auth/presentation/controllers/signup_controller.dart';
import 'package:okazyon_mobile/features/auth/presentation/screens/otp_screen.dart';

class SignupForm extends ConsumerStatefulWidget {
  const SignupForm({super.key});

  @override
  ConsumerState<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends ConsumerState<SignupForm> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final signupFormState = ref.watch(signupFormControllerProvider);
    final controllers = ref.watch(signupTextControllersProvider);
    final authState = ref.watch(authControllerProvider);

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            hintText: context.tr('fullName'), // "full name" in screenshot
            controller: controllers['username']!,
            validator: (value) => CustomValidator.username(value, context),
            prefixIcon: Iconsax.user,
          ),
          SizedBox(height: AppSizes.widgetSpacing),
          CustomTextField(
            hintText: context.tr('phoneNumber'),
            controller: controllers['phone']!,
            validator: (value) => CustomValidator.phone(value, context),
            keyboardType: TextInputType.phone,
            prefixIcon: Iconsax.mobile,
          ),
          SizedBox(height: AppSizes.widgetSpacing),
          CustomTextField(
            hintText: context.tr('password'),
            controller: controllers['password']!,
            validator: (value) => CustomValidator.password(value, context),
            prefixIcon: Iconsax.key,
            suffixIcon:
                signupFormState.obscurePassword
                    ? Iconsax.eye_slash
                    : Iconsax.eye,
            obscureText: signupFormState.obscurePassword,
            onSuffixIconPressed: () {
              ref
                  .read(signupFormControllerProvider.notifier)
                  .togglePasswordVisibility();
            },
          ),
          SizedBox(height: AppSizes.widgetSpacing),
          CustomTextField(
            hintText: context.tr('confirmPassword'),
            controller: controllers['confirmPassword']!,
            validator:
                (value) => CustomValidator.confirmPassword(
                  value,
                  controllers['password']!.text,
                  context,
                ),
            prefixIcon: Iconsax.key,
            suffixIcon:
                signupFormState.obscureConfirmPassword
                    ? Iconsax.eye_slash
                    : Iconsax.eye,
            obscureText: signupFormState.obscureConfirmPassword,
            onSuffixIconPressed: () {
              ref
                  .read(signupFormControllerProvider.notifier)
                  .toggleConfirmPasswordVisibility();
            },
          ),
          SizedBox(height: AppSizes.widgetSpacing),
          // Email field added for UI consistency with screenshot
          CustomTextField(
            hintText: context.tr('emailOptional'),
            // No controller for now as it's optional and not supported by backend yet
            prefixIcon: Iconsax.sms,
          ),
          SizedBox(height: AppSizes.widgetSpacing),
          Row(
            children: [
              Checkbox(
                value: signupFormState.agreeToTerms,
                activeColor: AppColors.primary,
                onChanged:
                    authState.isLoading
                        ? null
                        : (value) {
                          ref
                              .read(signupFormControllerProvider.notifier)
                              .toggleAgreeToTerms(value);
                        },
              ),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                    ),
                    children: [
                      TextSpan(text: context.tr('iAgreeToThe')),
                      TextSpan(
                        text:
                            ' ${context.tr('termsOfService')}.', // Added period and space
                        style: const TextStyle(
                          color: AppColors.error,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.error,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.widgetSpacing),
          CustomButton(
            text:
                authState.isLoading
                    ? context.tr(
                      'sendingOtp',
                    ) // Assuming key exists or fallback
                    : 'Send OTP', // Explicitly using screenshot text
            backgroundColor: AppColors.primary,
            textColor: AppColors.white,
            onPressed:
                authState.isLoading
                    ? null
                    : () async {
                      if (!signupFormState.agreeToTerms) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'You must agree to the Terms & Privacy Policy',
                            ),
                          ),
                        );
                        return;
                      }
                      if (formKey.currentState?.validate() ?? false) {
                        final success = await ref
                            .read(authControllerProvider.notifier)
                            .signup(
                              username: controllers['username']!.text,
                              phone: controllers['phone']!.text,
                              password: controllers['password']!.text,
                              confirmPassword:
                                  controllers['confirmPassword']!.text,
                              agreeToTerms: signupFormState.agreeToTerms,
                            );

                        if (success && context.mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => OtpScreen(
                                    phone: controllers['phone']!.text,
                                    password: controllers['password']!.text,
                                  ),
                            ),
                          );
                        }
                      }
                    },
          ),
        ],
      ),
    );
  }
}
