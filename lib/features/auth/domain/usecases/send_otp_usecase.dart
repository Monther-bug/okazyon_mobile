import '../repositories/auth_repository.dart';

class SendOtpUseCase {
  final AuthRepository repository;

  SendOtpUseCase(this.repository);

  Future<void> call({required String phone, required String purpose}) async {
    return await repository.sendOtp(phone: phone, purpose: purpose);
  }
}
