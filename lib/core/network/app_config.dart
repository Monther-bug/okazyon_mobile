class AppConfig {
  static const String baseUrl = 'http://127.0.0.1:8000/api/v1/';

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  static const String loginEndpoint = 'login';
  static const String registerEndpoint = 'register';
  static const String resetPasswordEndpoint = 'reset-password';
  static const String logoutEndpoint = 'logout';
  static const String sendOtpEndpoint = 'sendotp';
  static const String verifyOtpEndpoint = 'verifyotp';
  static const String fcmTokenEndpoint = 'fcm-token';
  static const String profileEndpoint = 'profile';
  static const String changePasswordEndpoint = 'change-password';
}
