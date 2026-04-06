# ⚡ БЫСТРАЯ ИНСТРУКЦИЯ - Firestore Database

## ПРОБЛЕМА:
```
✅ Authentication работает
✅ Пользователь создается в Firebase
❌ В Firestore нет коллекции с данными
```

## РЕШЕНИЕ - 3 ШАГА:

---

## 1️⃣ ОТКРОЙТЕ FIRESTORE CONSOLE

```
https://console.firebase.google.com
  ↓
Проект: beauty-body
  ↓
Build → Firestore Database
  ↓
Вкладка: Rules
```

---

## 2️⃣ ЗАМЕНИТЕ ПРАВИЛА (скопируйте целиком):

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
    }
    match /public/{document=**} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```

---

## 3️⃣ НАЖМИТЕ "PUBLISH" (голубая кнопка)

✅ **ГОТОВО!**

---

## 🧪 ТЕСТИРУЕМ СЕЙЧАС:

```
1. flutter run

2. Нажмите "Регистрация"
   - Имя: Test User
   - Email: test4@mail.com
   - Пароль: 123456

3. Нажмите "Создать аккаунт"

4. Авторизуйтесь (введите эти же email и пароль)

5. Откройте Firestore Database → Data

6. ВЫ ДОЛЖНЫ УВИДЕТЬ КОЛЛЕКЦИЮ "users" ✅
```

---

## 📊 ЧТО ВЫ УВИДИТЕ:

**До Firestore Rules:**
```
⚠️ Ошибка: "Permission denied"
Коллекция: не создается
```

**После Firestore Rules:**
```
✅ Всё работает!

users/
├── uL123abc...
│   ├── uid: "uL123abc..."
│   ├── email: "test4@mail.com"
│   ├── name: "Test User"
│   ├── createdAt: 6 апр, 14:35
│   └── updatedAt: 6 апр, 14:35
```

---

## ⚠️ ЕСЛИ НЕ РАБОТАЕТ:

1. **Rules не опубликованы?**
   → Нажмите еще раз "Publish"

2. **Коллекция пуста?**
   → Зарегистрируйте нового пользователя в приложении
   → Коллекция создается автоматически

3. **Ошибка "Permission denied"?**
   → Проверьте что правила скопированы правильно
   → Убедитесь что Rules опубликованы (зеленая галочка)

4. **Всё еще не работает?**
   → Выполните `flutter clean && flutter pub get && flutter run`

---

## 📁 КОД УЖЕ ОБНОВЛЕН:

✅ `lib/models/user_profile.dart` - модель данных пользователя
✅ `lib/services/user_service.dart` - работа с Firestore
✅ `lib/services/auth_service.dart` - сохранение в Firestore при регистрации

**Вам больше ничего не нужно изменять!**

---

## 🎯 ИТОГО:

1. Откройте Firebase Console
2. Перейдите в Firestore Database → Rules
3. Вставьте правила
4. Нажмите Publish
5. Тестируйте! 🚀

**Вот и всё! Теперь работает!** ✨
