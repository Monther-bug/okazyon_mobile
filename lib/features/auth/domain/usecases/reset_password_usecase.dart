import '../repositories/auth_repository.dart';

class ResetPasswordUseCase {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  Future<void> call({
    required String phone,
    required String otp,
    required String newPassword,
  }) async {
    return await repository.resetPassword(
      phone: phone,
      otp: otp,
      newPassword: newPassword,
    );
  }
}
