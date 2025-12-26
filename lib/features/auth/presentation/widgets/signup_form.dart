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
            suffixIcon: Iconsax.user,
            labelText: context.tr('username'),
            hintText: context.tr('chooseUsername'),
            controller: controllers['username']!,
            validator: (value) => CustomValidator.username(value, context),
          ),
          SizedBox(height: AppSizes.widgetSpacing),
          CustomTextField(
            suffixIcon: Iconsax.mobile,
            labelText: context.tr('phoneNumber'),
            hintText: context.tr('enterPhone'),
            controller: controllers['phone']!,
            validator: (value) => CustomValidator.phone(value, context),
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: AppSizes.widgetSpacing),
          CustomTextField(
            suffixIcon: Iconsax.lock,
            labelText: context.tr('password'),
            hintText: context.tr('createStrongPassword'),
            controller: controllers['password']!,
            validator: (value) => CustomValidator.password(value, context),
            obscureText: signupFormState.obscurePassword,
            prefixIcon:
                signupFormState.obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
            onSuffixIconPressed: () {
              ref
                  .read(signupFormControllerProvider.notifier)
                  .togglePasswordVisibility();
            },
          ),
          SizedBox(height: AppSizes.widgetSpacing),
          CustomTextField(
            suffixIcon: Iconsax.lock,
            labelText: context.tr('confirmPassword'),
            hintText: context.tr('enterPasswordAgain'),
            controller: controllers['confirmPassword']!,
            validator:
                (value) => CustomValidator.confirmPassword(
                  value,
                  controllers['password']!.text,
                  context,
                ),
            obscureText: signupFormState.obscureConfirmPassword,
            prefixIcon:
                signupFormState.obscureConfirmPassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
            onSuffixIconPressed: () {
              ref
                  .read(signupFormControllerProvider.notifier)
                  .toggleConfirmPasswordVisibility();
            },
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
                        text: context.tr('termsOfService'),
                        style: const TextStyle(color: AppColors.primary),
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                      TextSpan(text: context.tr('and')),
                      TextSpan(
                        text: context.tr('privacyPolicy'),
                        style: const TextStyle(color: AppColors.primary),
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                      TextSpan(text: context.tr('dot')),
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
                    ? context.tr('creatingAccount')
                    : context.tr('signUpCta'),
            onPressed:
                authState.isLoading
                    ? null
                    : () {
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
                        ref
                            .read(authControllerProvider.notifier)
                            .signup(
                              username: controllers['username']!.text,
                              phone: controllers['phone']!.text,
                              password: controllers['password']!.text,
                              confirmPassword:
                                  controllers['confirmPassword']!.text,
                              agreeToTerms: signupFormState.agreeToTerms,
                            );
                      }
                    },
          ),
        ],
      ),
    );
  }
}
