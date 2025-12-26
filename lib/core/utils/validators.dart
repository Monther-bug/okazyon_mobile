import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CustomValidator {
  static String? email(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return context.tr('pleaseEnterEmail');
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return context.tr('pleaseEnterValidEmail');
    }
    return null;
  }

  static String? password(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return context.tr('pleaseEnterPassword');
    }
    if (value.length < 6) {
      return context.tr('passwordMinLength');
    }
    return null;
  }

  static String? username(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return context.tr('pleaseEnterUsername');
    }
    return null;
  }

  static String? confirmPassword(
    String? value,
    String password,
    BuildContext context,
  ) {
    if (value == null || value.isEmpty) {
      return context.tr('pleaseConfirmPassword');
    }
    if (value != password) {
      return context.tr('passwordsDoNotMatch');
    }
    return null;
  }

  static String? phone(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return context.tr('pleaseEnterPhone');
    }
    String phoneNumber = value.replaceAll(RegExp(r'[^\d]'), '');

    if (phoneNumber.length < 10) {
      return context.tr('pleaseEnterValidPhone');
    }
    return null;
  }
}
