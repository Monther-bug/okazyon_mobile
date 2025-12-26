import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<void> call({
    String? email,
    required String password,
    required String username,
    String? firstName,
    String? lastName,
    String? phone,
  }) async {
    return await repository.register(
      email: email,
      password: password,
      username: username,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
    );
  }
}
