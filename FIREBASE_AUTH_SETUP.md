# 🔐 Firebase Authentication Setup - Полная Инструкция

## Что было сделано в коде:
- ✅ Создан `AuthService` для управления авторизацией
- ✅ Обновлен `LoginScreen` с интеграцией Firebase
- ✅ Добавлена валидация формы и обработка ошибок
- ✅ Добавлена индикация загрузки во время запроса

---

## 📋 ЧТО НУЖНО СДЕЛАТЬ В FIREBASE CONSOLE:

### Шаг 1️⃣: Откройте Firebase Console
1. Откройте [Firebase Console](https://console.firebase.google.com/)
2. Выберите проект **beauty-body**

### Шаг 2️⃣: Включите Email/Password Authentication

**Путь в Firebase Console:**
```
Build (Слева) → Authentication → Sign-in method → Email/Password
```

**Действия:**
1. Нажмите на **Authentication** в левой панели
2. Перейдите на вкладку **Sign-in method**
3. Найдите **Email/Password** провайдер
4. Нажмите на нее (она должна быть серой)
5. Переключите **Enable** (кнопка должна стать голубой)
6. Нажмите **Save**

**Результат:** Email/Password провайдер станет активным (зеленый статус ✅)

---

### Шаг 3️⃣: Правила безопасности Firestore (если планируете упоминать БД)

**Путь:**
```
Build → Firestore Database → Rules
```

**Замените текущие правила на:**

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Любой авторизованный пользователь может читать и писать свои документы
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
    }
    
    // Общественные данные может читать любой
    match /public/{document=**} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```

**Сохраните:** Нажмите **Publish**

---

### Шаг 4️⃣: Правила безопасности Firebase Storage (если планируете загрузку файлов)

**Путь:**
```
Build → Storage → Rules
```

**Замените на:**

```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Пользователи могут загружать файлы в свою папку
    match /users/{userId}/{allPaths=**} {
      allow read, write: if request.auth.uid == userId;
    }
    
    // Администраторы могут делать всё
    match /{allPaths=**} {
      allow read, write: if request.auth.token.admin == true;
    }
  }
}
```

**Сохраните:** Нажмите **Publish**

---

## 🧪 ТЕСТИРОВАНИЕ

### Способ 1: Напрямую в Firebase Console

1. Перейдите **Authentication → Sign-in method**
2. Нажмите вкладку **Users**
3. Нажмите кнопку **Add user**
4. Введите:
   - Email: `test@example.com`
   - Password: `123456`
5. Нажмите **Create**

Пользователь создан! ✅

### Способ 2: Тестировать в приложении

1. Откройте приложение на эмуляторе
2. Нажмите **Регистрация**
3. Введите:
   - Имя: `Тест Маза`
   - Email: `test002@example.com`
   - Пароль: `123456`
4. Нажмите **Создать аккаунт**

Если в консоли появится новый пользователь - всё работает! ✅

---

## 📱 КА ИСПОЛЬЗОВАТЬ В КОДЕ:

### Регистрация новогопользователя:
```dart
final authService = AuthService();

try {
  await authService.registerWithEmail(
    email: 'user@example.com',
    password: 'password123',
    name: 'John Doe',
  );
  // Успешно!
} on FirebaseAuthException catch (e) {
  print('Ошибка: ${e.message}');
}
```

### Логин пользователя:
```dart
try {
  await authService.loginWithEmail(
    email: 'user@example.com',
    password: 'password123',
  );
  // Вошли в систему!
} on FirebaseAuthException catch (e) {
  print('Ошибка входа: ${e.message}');
}
```

### Получить текущего пользователя:
```dart
final user = authService.currentUser;
print('Пользователь: ${user?.email}');
print('Имя: ${user?.displayName}');
```

### Выйти из аккаунта:
```dart
await authService.signOut();
```

### Отслеживать изменения состояния:
```dart
authService.authStateChanges.listen((user) {
  if (user == null) {
    // Пользователь вышел или не авторизован
    print('Пользователь вышел');
  } else {
    // Пользователь авторизован
    print('Пользователь вошел: ${user.email}');
  }
});
```

---

## ⚙️ НАСТРОЙКИ ДЛЯ ПРОДАКШЕНА:

### 1. Включить Email Confirmation
```
Authentication → Sign-in method → Email/Password
Переключите: "Email link (passwordless sign-in)" если нужно
```

### 2. Установить ограничение по странам (для безопасности)
```
Authentication → Sign-in method → Block Sign-ups (внизу страницы)
```

### 3. Двухфакторная аутентификация (2FA)
```
Authentication → Sign-in method → Multi-factor Auth (MFA)
```

---

## 🔍 КОДЫ ОШИБОК И РЕШЕНИЯ:

| Код Ошибки | Значение | Решение |
|-----------|---------|--------|
| `user-not-found` | Пользователь не существует | Проверьте email и убедитесь, что он зарегистрирован |
| `wrong-password` | Неверный пароль | Попросите пользователя восстановить пароль |
| `email-already-in-use` | Email уже используется | Используйте другой email |
| `weak-password` | Пароль слишком слабый | Минимум 6 символов |
| `invalid-email` | Неверный формат email | Проверьте формат: user@example.com |
| `too-many-requests` | Слишком много попыток | Подождите несколько минут |

---

## 📊 ГДЕ СМОТРЕТЬ АКТИВНОСТЬ ПОЛЬЗОВАТЕЛЕЙ:

**Путь:** Authentication → Users

Там вы увидите:
- Email каждого пользователя
- Дата создания аккаунта
- Дата последнего входа
- Статус 2FA
- UID (уникальный ID пользователя)

---

## ✅ ПРОВЕРКА РАБОТОСПОСОБНОСТИ:

1. ✅ Приложение запускается без ошибок
2. ✅ Экран авторизации отображается
3. ✅ Можно создать новый аккаунт
4. ✅ Можно войти существующим аккаунтом
5. ✅ Новые пользователи видны в Firebase Console
6. ✅ Неверный пароль показывает ошибку
7. ✅ Email-адрес в формате email проверяется

---

## 🚀 СЛЕДУЮЩИЕ ШАГИ:

1. **Email Verification** - отправлять проверочное письмо
2. **Password Reset** - функция восстановления пароля
3. **Social Auth** - авторизация через Google, Facebook
4. **User Profile** - сохранение профиля в Firestore
5. **Phone Auth** - авторизация по номеру телефона

---

**Все готово! Ваша система авторизации работает с Firebase!** 🎉
