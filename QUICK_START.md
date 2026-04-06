# 🚀 БЫСТРАЯ ШПАРГАЛКА - Firebase Authentication

## ЗАДАЧА: Включить Email/Password в Firebase

### ⚡ 5 Кликов - Готово!

```
1️⃣ https://console.firebase.google.com
   ↓
2️⃣ Выберите проект: "beauty-body"
   ↓
3️⃣ Левая панель: Build → Authentication
   ↓
4️⃣ Вкладка "Sign-in method" → Email/Password
   ↓
5️⃣ Кнопка Toggle "Enable" → Синяя! → Save
   ✅ ГОТОВО!
```

---

## СТРУКТУРА FIREBASE CONSOLE

```
🔥 Firebase
┣ 📊 Overview (главная панель)
┗ 🏗️ Build
  ┣ 🔐 Authentication ← ВЫ ЗДЕСЬ
  ┃ ┣ Get started (начало)
  ┃ ┣ Sign-in method (ВЫ ЗДЕСЬ)
  ┃ ┗ Users (список пользователей)
  ┣ 📁 Firestore Database
  ┣ 📦 Realtime Database
  ┣ 💾 Storage
  ┗ ...
```

---

## ГДЕ НАЖИМАТЬ В SIGN-IN METHOD

```
┌─────────────────────────────────────────┐
│ Sign-in method                          │
├─────────────────────────────────────────┤
│                                         │
│ ☑️  Email/Password      [Toggle ← нажми]
│ ☐  Phone Number                        │
│ ☐  Google                              │
│ ☐  Facebook                            │
│ ☐  Apple                               │
│ ☐  Anonymous                           │
│                                         │
│          [Save] ← потом нажми           │
└─────────────────────────────────────────┘
```

---

## ПРОВЕРКА: Users Tab

После регистрации пользователя через приложение вы увидите:

```
┌─────────────────────────────────────────┐
│ Users (список пользователей)            │
├─────────────────────────────────────────┤
│                                         │
│ UID: abc123def456...                   │
│ Email: user@example.com                │
│ Created: 6 апр 2026, 14:32             │
│ Last sign-in: 6 апр 2026, 14:35        │
│                                         │
└─────────────────────────────────────────┘
```

---

## КОД ЭКРАНА (что изменилось)

### ДО (старый код):
```dart
void _submit() {
  // просто переезжаем на HomeScreen
  Navigator.pushReplacement(...);
}
```

### ПОСЛЕ (с Firebase):
```dart
Future<void> _submit() async {
  try {
    if (_isLogin) {
      // Логин с Firebase
      await authService.loginWithEmail(
        email: email,
        password: password,
      );
    } else {
      // Регистрация в Firebase
      await authService.registerWithEmail(
        email: email,
        password: password,
        name: name,
      );
    }
    // Переходим на HomeScreen
    Navigator.pushReplacement(...);
  } catch (e) {
    // Показываем ошибку
    setState(() => _errorMessage = e);
  }
}
```

---

## ОШИБКИ И РЕШЕНИЯ

| Ошибка | Решение |
|--------|---------|
| "Email/Password не включен" | Откройте Firebase Console → Authentication → Sign-in method → включите Email/Password |
| "user-not-found" | Пользователь не существует - зарегистрируйтесь сначала |
| "wrong-password" | Неверный пароль |
| "email-already-in-use" | Этот email уже используется - используйте другой |
| "weak-password" | Пароль должен быть минимум 6 символов |

---

## ТЕСТОВЫЕ АККАУНТЫ

Используйте для тестирования:

```
Email: test@example.com
Password: 123456

Email: demo@beautyapp.com
Password: password123

Email: yourname@gmail.com
Password: qwerty1
```

---

## ФАЙЛЫ КОТОРЫЕ ИЗМЕНИЛИСЬ

```
✅ lib/screens/login_screen.dart
   ├─ Добавлен Firebase Auth
   ├─ Добавлена валидация
   └─ Добавлена обработка ошибок

✅ lib/services/auth_service.dart
   └─ Новый файл с AuthService классом

✅ firebase_options.dart
   └─ Конфигурация Firebase (уже готова)

✅ main.dart
   └─ Инициализация Firebase (уже готова)
```

---

## ПОЛЕЗНЫЕ КОМАНДЫ

```bash
# Перезагрузить приложение
flutter run

# Очистить кэш и пересобрать
flutter clean
flutter pub get
flutter run

# Смотреть логи Firebase
flutter logs | grep -i firebase
```

---

## ГОТОВЫЕ ПРИМЕРЫ ИСПОЛЬЗОВАНИЯ

### Проверить, авторизован ли пользователь:
```dart
final user = authService.currentUser;
if (user != null) {
  print('Пользователь авторизован: ${user.email}');
} else {
  print('Пользователь не авторизован');
}
```

### Слушать изменения состояния:
```dart
authService.authStateChanges.listen((User? user) {
  if (user == null) {
    // Вышел из системы
    Navigator.pushReplacement(..., LoginScreen());
  } else {
    // Вошел в систему
    Navigator.pushReplacement(..., HomeScreen());
  }
});
```

### Восстановить пароль:
```dart
await authService.sendPasswordResetEmail('user@example.com');
```

---

## SECURITY RULES (Firestore, если нужна БД)

Firebase Console → Firestore Database → Rules

Скопируйте эти правила:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
    }
  }
}
```

Нажмите **Publish** ✅

---

## ✨ ВЫ ГОТОВЫ!

- ✅ Firebase подключена
- ✅ Экран авторизации работает
- ✅ Регистрация работает
- ✅ Логин работает
- ✅ Обработка ошибок работает

**Начните работать!** 🚀
