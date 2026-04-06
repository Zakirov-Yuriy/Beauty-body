import 'package:firebase_auth/firebase_auth.dart';
import 'user_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserService _userService = UserService();

  // Получить текущего пользователя
  User? get currentUser => _auth.currentUser;

  // Поток изменения состояния пользователя
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Регистрация с email и паролем
  Future<UserCredential> registerWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Обновить display name
      await userCredential.user?.updateDisplayName(name);
      await userCredential.user?.reload();
      
      // Создать профиль в Firestore
      if (userCredential.user != null) {
        await _userService.createUserProfile(
          uid: userCredential.user!.uid,
          email: email,
          name: name,
        );
      }
      
      // Выходим из аккаунта после регистрации
      // Пользователь должен заново войти
      await _auth.signOut();
      
      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  // Логин с email и паролем
  Future<UserCredential> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Выход из аккаунта
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  // Отправить письмо для восстановления пароля
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow;
    }
  }

  // Удалить аккаунт пользователя
  Future<void> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        // Удалить профиль из Firestore
        await _userService.deleteUserProfile(user.uid);
        // Удалить аккаунт из Firebase Auth
        await user.delete();
      }
    } catch (e) {
      rethrow;
    }
  }
}
