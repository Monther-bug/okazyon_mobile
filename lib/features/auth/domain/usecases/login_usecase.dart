import '../entities/auth_response.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<AuthResponse> call({
    required String phone,
    required String password,
  }) async {
    return await repository.login(phone: phone, password: password);
  }
}
