import '../../domain/entities/auth_response.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<AuthResponse> login({
    required String phone,
    required String password,
  }) async {
    final response = await remoteDataSource.login(
      phone: phone,
      password: password,
    );

    await localDataSource.cacheAuthToken(response.token);
    await localDataSource.cacheUserData(response.user);

    return response.toEntity();
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
    await remoteDataSource.register(
      email: email,
      password: password,
      username: username,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
    );

    // Note: Registration now returns void (OTP flow).
    // We do NOT cache token/user here because they are not provided yet.
  }

  @override
  Future<void> logout() async {
    await remoteDataSource.logout();
    await localDataSource.clearCache();
  }

  @override
  Future<void> resetPassword({
    required String phone,
    required String otp,
    required String newPassword,
  }) async {
    await remoteDataSource.resetPassword(
      phone: phone,
      otp: otp,
      newPassword: newPassword,
    );
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    await remoteDataSource.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );
  }

  @override
  Future<void> sendOtp({required String phone, required String purpose}) async {
    await remoteDataSource.sendOtp(phone: phone, purpose: purpose);
  }

  @override
  Future<bool> verifyOtp({required String phone, required String otp}) async {
    return await remoteDataSource.verifyOtp(phone: phone, otp: otp);
  }

  @override
  Future<AppUser> getProfile() async {
    final userModel = await remoteDataSource.getProfile();

    await localDataSource.cacheUserData(userModel);

    return userModel.toEntity();
  }

  @override
  Future<AppUser> updateProfile({
    String? username,
    String? firstName,
    String? lastName,
    String? phone,
  }) async {
    final userModel = await remoteDataSource.updateProfile(
      username: username,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
    );

    await localDataSource.cacheUserData(userModel);

    return userModel.toEntity();
  }

  @override
  Future<void> registerFcmToken({required String token}) async {
    await remoteDataSource.registerFcmToken(token: token);
  }

  @override
  Future<bool> isLoggedIn() async {
    return await localDataSource.isLoggedIn();
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    final userModel = await localDataSource.getCachedUserData();
    return userModel?.toEntity();
  }

  @override
  Future<String?> getAuthToken() async {
    return await localDataSource.getAuthToken();
  }
}
