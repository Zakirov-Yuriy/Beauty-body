import '../entities/user_entity.dart';

/// Абстрактный интерфейс для работы с аутентификацией
abstract class AuthRepository {
  /// Получить текущего пользователя
  UserEntity? get currentUser;

  /// Поток изменения состояния пользователя
  Stream<UserEntity?> get authStateChanges;

  /// Регистрация с email и паролем
  Future<UserEntity> registerWithEmail({
    required String email,
    required String password,
    required String name,
  });

  /// Логин с email и паролем
  Future<UserEntity> loginWithEmail({
    required String email,
    required String password,
  });

  /// Логин с Google
  Future<UserEntity?> loginWithGoogle();

  /// Выход из аккаунта
  Future<void> logout();

  /// Сброс пароля
  Future<void> resetPassword({required String email});

  /// Обновить профиль пользователя
  Future<void> updateUserProfile({
    String? displayName,
    String? photoUrl,
  });
}
