import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beauty_body/domain/entities/user_entity.dart';
import 'package:beauty_body/domain/repositories/auth_repository.dart';
import 'firebase_providers.dart';

// ============ Auth State Provider ============

/// Провайдер текущего пользователя (Stream)
final authStateProvider = StreamProvider<UserEntity?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges;
});

/// Провайдер текущего пользователя (Simple)
final currentUserProvider = Provider<UserEntity?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.currentUser;
});

// ============ Auth State Notifier ============

/// Статусы для Auth операций
enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

/// Состояние автентификации
class AuthState {
  final AuthStatus status;
  final UserEntity? user;
  final String? errorMessage;

  AuthState({
    required this.status,
    this.user,
    this.errorMessage,
  });

  /// Начальное состояние
  factory AuthState.initial() => AuthState(status: AuthStatus.initial);

  /// Состояние загрузки
  factory AuthState.loading() => AuthState(status: AuthStatus.loading);

  /// Аутентифицирован
  factory AuthState.authenticated(UserEntity user) => AuthState(
    status: AuthStatus.authenticated,
    user: user,
  );

  /// Не аутентифицирован
  factory AuthState.unauthenticated() => AuthState(status: AuthStatus.unauthenticated);

  /// Ошибка
  factory AuthState.error(String message) => AuthState(
    status: AuthStatus.error,
    errorMessage: message,
  );

  /// Копирование с изменениями
  AuthState copyWith({
    AuthStatus? status,
    UserEntity? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// Notifier для управления Auth состоянием
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthNotifier(this._authRepository) : super(AuthState.initial());

  /// Регистрация с email и паролем
  Future<void> registerWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    state = AuthState.loading();
    try {
      final user = await _authRepository.registerWithEmail(
        email: email,
        password: password,
        name: name,
      );
      state = AuthState.authenticated(user);
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  /// Логин с email и паролем
  Future<void> loginWithEmail({
    required String email,
    required String password,
  }) async {
    state = AuthState.loading();
    try {
      final user = await _authRepository.loginWithEmail(
        email: email,
        password: password,
      );
      state = AuthState.authenticated(user);
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  /// Логин с Google
  Future<void> loginWithGoogle() async {
    state = AuthState.loading();
    try {
      final user = await _authRepository.loginWithGoogle();
      if (user != null) {
        state = AuthState.authenticated(user);
      } else {
        state = AuthState.error('Google login failed');
      }
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  /// Выход из аккаунта
  Future<void> logout() async {
    try {
      await _authRepository.logout();
      state = AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  /// Сброс пароля
  Future<void> resetPassword({required String email}) async {
    state = AuthState.loading();
    try {
      await _authRepository.resetPassword(email: email);
      state = AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  /// Обновить профиль пользователя
  Future<void> updateUserProfile({
    String? displayName,
    String? photoUrl,
  }) async {
    state = AuthState.loading();
    try {
      await _authRepository.updateUserProfile(
        displayName: displayName,
        photoUrl: photoUrl,
      );
      // Обновить состояние с новыми данными
      final user = state.user;
      if (user != null) {
        final updatedUser = user.copyWith(
          displayName: displayName ?? user.displayName,
          photoUrl: photoUrl ?? user.photoUrl,
        );
        state = AuthState.authenticated(updatedUser);
      }
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  /// Очистить ошибку
  void clearError() {
    if (state.status == AuthStatus.error) {
      state = state.copyWith(status: AuthStatus.unauthenticated);
    }
  }
}

/// StateNotifierProvider для управления Auth состоянием
final authStateNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});
