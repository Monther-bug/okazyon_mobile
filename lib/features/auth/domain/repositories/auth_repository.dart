import '../entities/auth_response.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<AuthResponse> login({required String phone, required String password});
  Future<AuthResponse> loginWithGoogle();

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

  Future<AppUser> getProfile();

  Future<AppUser> updateProfile({
    String? username,
    String? firstName,
    String? lastName,
    String? phone,
  });

  Future<void> registerFcmToken({required String token});

  Future<bool> isLoggedIn();
  Future<AppUser?> getCurrentUser();
  Future<String?> getAuthToken();
}
