import '../entities/auth_response.dart';
import '../repositories/auth_repository.dart';

class LoginWithGoogleUseCase {
  final AuthRepository _repository;

  LoginWithGoogleUseCase(this._repository);

  Future<AuthResponse> call() async {
    return await _repository.loginWithGoogle();
  }
}
