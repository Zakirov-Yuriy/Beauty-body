import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/remote_auth_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final RemoteAuthDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  UserEntity? get currentUser => _remoteDataSource.getCurrentUser();

  @override
  Stream<UserEntity?> get authStateChanges => _remoteDataSource.getAuthStateChanges();

  @override
  Future<UserEntity> registerWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    return await _remoteDataSource.registerWithEmail(
      email: email,
      password: password,
      name: name,
    );
  }

  @override
  Future<UserEntity> loginWithEmail({
    required String email,
    required String password,
  }) async {
    return await _remoteDataSource.loginWithEmail(
      email: email,
      password: password,
    );
  }

  @override
  Future<UserEntity?> loginWithGoogle() async {
    return await _remoteDataSource.loginWithGoogle();
  }

  @override
  Future<void> logout() async {
    await _remoteDataSource.logout();
  }

  @override
  Future<void> resetPassword({required String email}) async {
    await _remoteDataSource.resetPassword(email: email);
  }

  @override
  Future<void> updateUserProfile({
    String? displayName,
    String? photoUrl,
  }) async {
    await _remoteDataSource.updateUserProfile(
      displayName: displayName,
      photoUrl: photoUrl,
    );
  }
}
