import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/network/app_config.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login({
    required String phone,
    required String password,
  });

  Future<void> register({
    String? email,
    required String password,
    required String username,
    String? firstName,
    String? lastName,
    String? phone,
  });

  Future<void> logout();

  Future<void> resetPassword({
    required String phone,
    required String otp,
    required String newPassword,
  });

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  });

  Future<void> sendOtp({required String phone, required String purpose});

  Future<bool> verifyOtp({required String phone, required String otp});

  Future<UserModel> getProfile();

  Future<UserModel> updateProfile({
    String? username,
    String? firstName,
    String? lastName,
    String? phone,
  });

  Future<void> registerFcmToken({required String token});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio = DioClient.instance;

  @override
  Future<AuthResponseModel> login({
    required String phone,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        AppConfig.loginEndpoint,
        data: {'phone_number': phone, 'password': password},
      );

      if (response.statusCode == 200) {
        return AuthResponseModel.fromJson(response.data);
      } else {
        throw ApiException(
          'Login failed',
          statusCode: response.statusCode,
          data: response.data,
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<void> register({
    String? email,
    required String password,
    required String username,
    String? firstName,
    String? lastName,
    String? phone,
  }) async {
    try {
      // Backend expects 'first_name', 'phone_number', 'password', 'password_confirmation'
      final data = {
        'first_name': firstName ?? username,
        if (email != null && email.isNotEmpty) 'email': email,
        'password': password,
        'password_confirmation': password,
        'phone_number': phone,
      };

      final response = await _dio.post(AppConfig.registerEndpoint, data: data);

      if (response.statusCode != 201 && response.statusCode != 200) {
        throw ApiException(
          'Registration failed',
          statusCode: response.statusCode,
          data: response.data,
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _dio.post(AppConfig.logoutEndpoint);

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('user_data');
    } on DioException catch (e) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('user_data');

      throw _handleDioError(e);
    }
  }

  @override
  Future<void> resetPassword({
    required String phone,
    required String otp,
    required String newPassword,
  }) async {
    try {
      final response = await _dio.post(
        AppConfig.resetPasswordEndpoint,
        data: {
          'phone_number': phone,
          'otp': otp,
          'password': newPassword,
          'password_confirmation': newPassword,
        },
      );

      if (response.statusCode != 200) {
        throw ApiException(
          'Reset password failed',
          statusCode: response.statusCode,
          data: response.data,
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final response = await _dio.post(
        AppConfig.changePasswordEndpoint,
        data: {
          'current_password': currentPassword,
          'password': newPassword,
          'password_confirmation': confirmPassword,
        },
      );

      if (response.statusCode != 200) {
        throw ApiException(
          'Change password failed',
          statusCode: response.statusCode,
          data: response.data,
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<void> sendOtp({required String phone, required String purpose}) async {
    try {
      final response = await _dio.post(
        AppConfig.sendOtpEndpoint,
        data: {'phone_number': phone, 'purpose': purpose},
      );

      if (response.statusCode != 200) {
        throw ApiException(
          'Send OTP failed',
          statusCode: response.statusCode,
          data: response.data,
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<bool> verifyOtp({required String phone, required String otp}) async {
    try {
      final response = await _dio.post(
        AppConfig.verifyOtpEndpoint,
        data: {'phone_number': phone, 'otp': otp},
      );

      if (response.statusCode == 200) {
        return response.data['verified'] ?? true;
      } else {
        return false;
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<UserModel> getProfile() async {
    try {
      final response = await _dio.get(AppConfig.profileEndpoint);

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['user'] ?? response.data);
      } else {
        throw ApiException(
          'Get profile failed',
          statusCode: response.statusCode,
          data: response.data,
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<UserModel> updateProfile({
    String? username,
    String? firstName,
    String? lastName,
    String? phone,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (username != null) data['username'] = username;
      if (firstName != null) data['first_name'] = firstName;
      if (lastName != null) data['last_name'] = lastName;
      if (phone != null) data['phone'] = phone;

      final response = await _dio.put(AppConfig.profileEndpoint, data: data);

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['user'] ?? response.data);
      } else {
        throw ApiException(
          'Update profile failed',
          statusCode: response.statusCode,
          data: response.data,
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<void> registerFcmToken({required String token}) async {
    try {
      final response = await _dio.post(
        AppConfig.fcmTokenEndpoint,
        data: {'token': token},
      );

      if (response.statusCode != 200) {
        throw ApiException(
          'FCM token registration failed',
          statusCode: response.statusCode,
          data: response.data,
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException('Connection timeout');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final data = e.response?.data;

        if (statusCode == 422 && data is Map<String, dynamic>) {
          final errors = data['errors'] as Map<String, dynamic>?;
          if (errors != null) {
            final formattedErrors = <String, List<String>>{};
            errors.forEach((key, value) {
              if (value is List) {
                formattedErrors[key] = value.cast<String>();
              }
            });
            return ValidationException(formattedErrors);
          }
        }

        final message = data?['message'] ?? 'Request failed';
        return ApiException(message, statusCode: statusCode, data: data);
      default:
        return NetworkException('Network error occurred');
    }
  }
}
