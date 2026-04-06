# Firebase Setup для Beauty Body

## Статус: ✅ Подключено для Android

### Что было настроено:

1. **Firebase SDK** добавлены в pubspec.yaml:
   - firebase_core
   - firebase_auth
   - cloud_firestore
   - firebase_messaging

2. **Android конфигурация**:
   - ✅ google-services.json скопирован в `android/app/`
   - ✅ google-services плагин добавлен в build.gradle.kts
   - ✅ firebase_options.dart создан с данными Android

3. **Инициализация Firebase**:
   - ✅ Firebase инициализация добавлена в main.dart

### Данные проекта:
- **Project ID**: beauty-body-86d4e
- **API Key**: AIzaSyCXQI8lZ8eN02dpPaqb5pqyl_lLHM5ct_w
- **App ID**: 1:583737317649:android:b516be2456ced308e594b0
- **Storage Bucket**: beauty-body-86d4e.firebasestorage.app

### Готово для использования:

#### 1. Firebase Authentication
```dart
import 'package:firebase_auth/firebase_auth.dart';

final auth = FirebaseAuth.instance;

// Регистрация
await auth.createUserWithEmailAndPassword(email: email, password: password);

// Логин
await auth.signInWithEmailAndPassword(email: email, password: password);

// Выход
await auth.signOut();
```

#### 2. Firestore Database
```dart
import 'package:cloud_firestore/cloud_firestore.dart';

final firestore = FirebaseFirestore.instance;

// Добавить документ
await firestore.collection('users').doc(userId).set({
  'name': 'John',
  'email': 'john@example.com',
});

// Получить документ
final doc = await firestore.collection('users').doc(userId).get();

// Получить коллекцию
final query = await firestore.collection('users').get();
```

#### 3. Push Notifications
```dart
import 'package:firebase_messaging/firebase_messaging.dart';

final messaging = FirebaseMessaging.instance;

// Получить token
final token = await messaging.getToken();

// Обработать входящие сообщения
FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  print('Message: ${message.notification?.title}');
});
```

### Следующие шаги:

1. Добавить нужные правила безопасности в Firebase Console
2. Настроить динамические ссылки (если нужны)
3. Запустить на Android-устройстве: `flutter run`

### Команды для сборки:

```bash
# Debug сборка
flutter run

# Release сборка
flutter build apk --release

# Проверка зависимостей
flutter pub get

# Очистка кеша
flutter clean
```

---
**Дата подготовки**: 6 апреля 2026
