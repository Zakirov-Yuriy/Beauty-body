import '../../models/user_model.dart';

/// Интерфейс для удаленного источника данных (Firebase)
abstract class RemoteAuthDataSource {
  /// Регистрация с email и паролем
  Future<UserModel> registerWithEmail({
    required String email,
    required String password,
    required String name,
  });

  /// Логин с email и паролем
  Future<UserModel> loginWithEmail({
    required String email,
    required String password,
  });

  /// Логин с Google
  Future<UserModel?> loginWithGoogle();

  /// Выход из аккаунта
  Future<void> logout();

  /// Сброс пароля
  Future<void> resetPassword({required String email});

  /// Получить текущего пользователя
  UserModel? getCurrentUser();

  /// Обновить профиль пользователя
  Future<void> updateUserProfile({
    String? displayName,
    String? photoUrl,
  });

  /// Получить поток изменения пользователя
  Stream<UserModel?> getAuthStateChanges();

  /// Создать профиль пользователя в Firestore
  Future<void> createUserProfile({
    required String uid,
    required String email,
    required String name,
  });

  /// Получить профиль пользователя из Firestore
  Future<UserModel> getUserProfile({required String uid});
}
