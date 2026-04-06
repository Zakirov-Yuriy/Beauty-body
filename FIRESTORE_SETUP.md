# 💾 Firestore Database Setup - Полная Инструкция

## ✅ Что было сделано в коде:

1. **✅ Создана модель `UserProfile`** (`lib/models/user_profile.dart`)
   - Хранит данные пользователя
   - Методы для преобразования в/из JSON

2. **✅ Создан `UserService`** (`lib/services/user_service.dart`)
   - Управление коллекцией "users" в Firestore
   - Методы: создание, чтение, обновление, удаление

3. **✅ Обновлен `AuthService`**
   - При регистрации автоматически создает документ в Firestore
   - Сохраняет: uid, email, name, createdAt

---

## 📋 ЧТО НУЖНО СДЕЛАТЬ В FIREBASE CONSOLE:

### Шаг 1: Откройте Firestore Database

**Путь:**
```
1. https://console.firebase.google.com/
2. Проект: beauty-body
3. Build (левая панель) → Firestore Database
```

---

### Шаг 2: Установите Security Rules

**Нажмите вкладку "Rules"** (рядом с "Data")

**Замените текущие правила на:**

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Правило для коллекции users
    match /users/{userId} {
      // Пользователь может читать и изменять только свой документ
      allow read, write: if request.auth.uid == userId;
    }
    
    // Правило для публичных данных
    match /public/{document=**} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```

**Нажмите "Publish"** (голубая кнопка внизу)

---

### Шаг 3: Проверьте что коллекция пуста

После нажатия "Publish" вы должны увидеть:
- Вкладка "Data" → пусто (готово к данным)
- ✅ Rules опубликованы (зеленая галочка)

---

## 🧪 ТЕСТИРОВАНИЕ:

### Как это будет работать:

**До регистрации:**
```
Firestore Database → Data
┌─────────────────────┐
│ (пусто)             │
│ Start collection    │
└─────────────────────┘
```

**После регистрации нового пользователя:**
```
Firestore Database → Data
┌─────────────────────────────────────┐
│ 📁 users (коллекция)               │
│   📄 abc123def456... (документ)    │
│      - uid: abc123def456           │
│      - email: test@mail.com        │
│      - name: John Doe              │
│      - createdAt: 6 апр, 14:32     │
│      - updatedAt: 6 апр, 14:32     │
└─────────────────────────────────────┘
```

---

## 🚀 ТЕСТИРУЕМ ПРЯМО СЕЙЧАС:

1. **Откройте приложение** (flutter run)
2. **Нажмите "Регистрация"**
3. **Заполните форму:**
   - Имя: `Test User`
   - Email: `test3@example.com`
   - Пароль: `123456`
4. **Нажмите "Создать аккаунт"**
5. **Авторизуйтесь** (введите email и пароль еще раз)
6. **Откройте Firebase Console:**
   - Перейдите в Firestore Database
   - Нажмите вкладку "Data"
   - Вы должны увидеть коллекцию "users" с новым документом! ✅

---

## 📊 СТРУКТУРА В FIRESTORE:

```
firestore.db
└── users/ (коллекция)
    ├── uL123abc... (документ 1)
    │   ├── uid: "uL123abc..."
    │   ├── email: "user1@mail.com"
    │   ├── name: "John Doe"
    │   ├── photoUrl: null
    │   ├── createdAt: 2026-04-06 14:32:00
    │   └── updatedAt: 2026-04-06 14:32:00
    │
    └── uL456def... (документ 2)
        ├── uid: "uL456def..."
        ├── email: "user2@mail.com"
        ├── name: "Jane Smith"
        ├── photoUrl: null
        ├── createdAt: 2026-04-06 14:35:00
        └── updatedAt: 2026-04-06 14:35:00
```

---

## 💻 КАК ИСПОЛЬЗОВАТЬ В КОДЕ:

### Получить профиль текущего пользователя:
```dart
final userService = UserService();
final user = authService.currentUser;

if (user != null) {
  final profile = await userService.getUserProfile(user.uid);
  print('Имя: ${profile?.name}');
  print('Email: ${profile?.email}');
}
```

### Обновить профиль:
```dart
await authService.updateUserProfile(
  displayName: 'Новое имя',
  photoUrl: 'https://example.com/photo.jpg',
);
```

### Слушать изменения профиля в real-time:
```dart
userService.getUserProfileStream(userId).listen((profile) {
  print('Профиль обновлен: ${profile?.name}');
});
```

---

## 🔒 ЧТО ОЗНАЧАЮТ ПРАВИЛА:

```javascript
match /users/{userId} {
  allow read, write: if request.auth.uid == userId;
}
```

**Переводим:**
- `match /users/{userId}` = совпадает с путем `/users/123abc`
- `allow read` = позволить чтение документа
- `allow write` = позволить писать/обновлять документ
- `if request.auth.uid == userId` = только если пользователь авторизован И это его собственный документ

**На русском:** 
> "Каждый пользователь может читать и менять только свой документ в коллекции users"

---

## ⚠️ ЕСЛИ ОШИБКА:

### "Permission denied" в приложении?
1. Проверьте что Rules опубликованы ✅
2. Убедитесь что пользователь авторизован
3. Используйте правильный userId

### Коллекция "users" не создается?
- ✅ Это нормально! Firestore создает коллекцию автоматически на первый документ
- Просто зарегистрируйтесь в приложении - коллекция создастся сама

### Документ не появляется в Firestore?
1. Проверьте что приложение не упало (смотрите консоль)
2. Удалите старое приложение и установите заново
3. Убедитесь что Rules опубликованы

---

## 🎯 ГОТОВЫЕ ПРИМЕРЫ:

### 1. Сохранить дополнительные данные профиля:
```dart
// В AuthService:
await _userService.updateUserProfile(
  uid: user.uid,
  name: 'John Doe',
  photoUrl: 'https://example.com/photo.jpg',
);
```

### 2. Получить список всех пользователей (только администраторы):
```dart
// В UserService - добавить метод:
Future<List<UserProfile>> getAllUsers() async {
  try {
    final snapshot = await _firestore.collection(_usersCollection).get();
    return snapshot.docs
        .map((doc) => UserProfile.fromMap(doc.data()))
        .toList();
  } catch (e) {
    rethrow;
  }
}
```

### 3. Поиск пользователя по email:
```dart
Future<UserProfile?> getUserByEmail(String email) async {
  try {
    final snapshot = await _firestore
        .collection(_usersCollection)
        .where('email', isEqualTo: email)
        .limit(1)
        .get();
    
    if (snapshot.docs.isNotEmpty) {
      return UserProfile.fromMap(snapshot.docs.first.data());
    }
    return null;
  } catch (e) {
    rethrow;
  }
}
```

---

## 📱 СТРУКТУРА ФАЙЛОВ:

```
lib/
├── models/
│   └── user_profile.dart (новое - модель профиля)
├── services/
│   ├── auth_service.dart (обновлено - сохраняет в Firestore)
│   └── user_service.dart (новое - работа с Firestore)
└── screens/
    └── login_screen.dart (уже работает)
```

---

## ✨ ИТОГО:

✅ При регистрации создается:
- Пользователь в **Firebase Authentication**
- Документ в коллекции **users** в **Firestore Database**

✅ При логине:
- Пользователь авторизуется
- Можно получить данные из Firestore

✅ Полная безопасность:
- Каждый пользователь видит только свои данные
- Другие не могут читать/менять чужие профили

---

**Готово! Теперь у вас есть полная система с Authentication + Database!** 🎉
