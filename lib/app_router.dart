import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/user_service.dart';
import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'widgets/splash_screen_widget.dart';

class AppRouter extends StatelessWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreenWidget();
        }

        // ❌ Пользователь НЕ авторизован → OnboardingScreen
        if (!snapshot.hasData || snapshot.data == null) {
          return const OnboardingScreen();
        }

        // ✅ Пользователь авторизован → проверяем профиль
        final userId = snapshot.data!.uid;
        return FutureBuilder<bool>(
          future: _profileExists(userId),
          builder: (context, profileSnapshot) {
            // Пока проверяем профиль - показываем красивый splash
            if (!profileSnapshot.hasData) {
              return const SplashScreenWidget();
            }

            // Профиль существует → HomeScreen
            if (profileSnapshot.data == true) {
              return const HomeScreen();
            }

            // Профиля нет → LoginScreen (регистрация)
            return const LoginScreen();
          },
        );
      },
    );
  }

  // Проверяем наличие профиля в Firestore
  static Future<bool> _profileExists(String uid) async {
    try {
      final userService = UserService();
      return await userService.profileExists(uid);
    } catch (e) {
      return false;
    }
  }
}
