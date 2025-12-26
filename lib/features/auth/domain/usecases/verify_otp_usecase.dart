import '../repositories/auth_repository.dart';

class VerifyOtpUseCase {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  Future<bool> call({required String phone, required String otp}) async {
    return await repository.verifyOtp(phone: phone, otp: otp);
  }
}
