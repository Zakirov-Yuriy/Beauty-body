import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:beauty_body/data/models/marathon_progress_model.dart';
import 'package:beauty_body/domain/entities/marathon_progress_entity.dart';

class FirebaseMarathonProgressDataSource {
  final FirebaseFirestore _firestore;

  FirebaseMarathonProgressDataSource(this._firestore);

  /// Путь к документу прогресса пользователя
  String _getUserProgressPath(String userId) {
    // Очистка и валидация
    final cleanUserId = userId.trim();
    if (cleanUserId.isEmpty || cleanUserId == 'null') {
      print('🚫 CRITICAL ERROR: Invalid userId passed to _getUserProgressPath: "$userId"');
      throw Exception('User ID is empty or invalid. User not authenticated. userId=$userId');
    }
    // Путь должен быть просто users/{uid}, а не users/{uid}/marathonProgress
    // marathonProgress это поле в документе, не подколлекция
    final path = 'users/$cleanUserId';
    print('✏️  Document path: $path');
    return path;
  }

  /// Получить текущий прогресс марафона
  Future<MarathonProgressEntity?> getMarathonProgress(String userId) async {
    try {
      final cleanUserId = userId.trim();
      print('🔍 getMarathonProgress called with userId: "$userId" (cleaned: "$cleanUserId")');
      
      if (cleanUserId.isEmpty || cleanUserId == 'null') {
        print('⚠️  User not authenticated (empty userId)');
        return null;
      }
      
      final docPath = _getUserProgressPath(cleanUserId);
      final doc = await _firestore.doc(docPath).get();
      
      if (!doc.exists) {
        print('⚠️  User document не найден для пользователя: $cleanUserId');
        return null;
      }
      
      // Проверяем есть ли поля марафона в документе
      final data = doc.data() as Map<String, dynamic>?;
      if (data == null) {
        print('⚠️  User document пуст для пользователя: $cleanUserId');
        return null;
      }
      
      // Если нет полей марафона, значит он не инициализирован
      if (!data.containsKey('currentStage')) {
        print('⚠️  Прогресс марафона не инициализирован для пользователя: $cleanUserId');
        return null;
      }
      
      final model = MarathonProgressModel.fromJson(data);
      print('✅ Прогресс марафона загружен: ${model.toEntity()}');
      return model.toEntity();
    } catch (e) {
      print('❌ Ошибка при загрузке прогресса марафона: $e');
      rethrow;
    }
  }

  /// Отслеживать прогресс в реальном времени
  Stream<MarathonProgressEntity?> watchMarathonProgress(String userId) {
    final cleanUserId = userId.trim();
    if (cleanUserId.isEmpty || cleanUserId == 'null') {
      print('⚠️  User not authenticated for watchMarathonProgress');
      return Stream.value(null);
    }
    return _firestore
        .doc(_getUserProgressPath(cleanUserId))
        .snapshots()
        .map((doc) {
      if (!doc.exists) {
        print('⚠️  User document не найден: $cleanUserId');
        return null;
      }
      
      final data = doc.data() as Map<String, dynamic>?;
      if (data == null || !data.containsKey('currentStage')) {
        print('⚠️  Прогресс марафона не инициализирован: $cleanUserId');
        return null;
      }
      
      final model = MarathonProgressModel.fromJson(data);
      return model.toEntity();
    }).handleError((e) {
      print('❌ Ошибка при отслеживании прогресса: $e');
      throw e;
    });
  }

  /// Обновить прогресс
  Future<void> updateProgress({
    required String userId,
    required int stage,
    required int week,
    required int day,
  }) async {
    try {
      final cleanUserId = userId.trim();
      print('🔍 updateProgress called with userId: "$userId" (cleaned: "$cleanUserId"), stage: $stage, week: $week, day: $day');
      
      if (cleanUserId.isEmpty || cleanUserId == 'null') {
        throw Exception('User not authenticated');
      }
      // Используем set с merge:true чтобы не ошибиться если документа нет
      final docPath = _getUserProgressPath(cleanUserId);
      print('📝 Updating document at path: $docPath');
      
      await _firestore.doc(docPath).set({
        'currentStage': stage,
        'currentWeek': week,
        'currentDay': day,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      print('✅ Прогресс обновлен: Этап $stage, Неделя $week, День $day');
    } catch (e) {
      print('❌ Ошибка при обновлении прогресса: $e');
      rethrow;
    }
  }

  /// Перейти на следующий день
  Future<void> nextDay(String userId) async {
    try {
      if (userId.isEmpty) {
        throw Exception('Пользователь не аутентифицирован');
      }
      final progress = await getMarathonProgress(userId);
      if (progress == null) throw Exception('Прогресс не найден');

      int newDay = progress.currentDay + 1;
      int newWeek = progress.currentWeek;
      int newStage = progress.currentStage;

      // Переход на следующую неделю
      if (newDay > 7) {
        newDay = 1;
        newWeek = newWeek + 1;
      }

      // Переход на следующий этап
      if (newWeek > 4) {
        newWeek = 1;
        newStage = newStage + 1;
      }

      // Проверка окончания марафона
      if (newStage > 4) {
        print('🎉 Марафон завершен!');
        newStage = 4;
        newWeek = 4;
        newDay = 7;
      }

      await updateProgress(
        userId: userId,
        stage: newStage,
        week: newWeek,
        day: newDay,
      );
    } catch (e) {
      print('❌ Ошибка при переходе на следующий день: $e');
      rethrow;
    }
  }

  /// Инициализировать прогресс марафона для нового пользователя
  Future<void> initializeMarathonProgress(String userId) async {
    try {
      final cleanUserId = userId.trim();
      if (cleanUserId.isEmpty || cleanUserId == 'null') {
        throw Exception('Пользователь не аутентифицирован');
      }
      final now = DateTime.now();
      final model = MarathonProgressModel(
        userId: cleanUserId,
        currentStage: 1,
        currentWeek: 1,
        currentDay: 1,
        startDate: now,
        lastUpdated: now,
      );

      // Используем merge:true чтобы не перезаписать другие поля пользователя
      await _firestore.doc(_getUserProgressPath(cleanUserId)).set(model.toJson(), SetOptions(merge: true));
      print('✅ Прогресс марафона инициализирован для: $cleanUserId');
    } catch (e) {
      print('❌ Ошибка при инициализации прогресса: $e');
      rethrow;
    }
  }

  /// Обновить прогресс на основе прошедшего времени с startDate
  /// Вызывается при открытии приложения для автоматического пересчета текущего дня/недели/этапа
  Future<void> updateProgressBasedOnElapsedDays(String userId) async {
    try {
      final cleanUserId = userId.trim();
      print('🔍 updateProgressBasedOnElapsedDays called with userId: "$userId" (cleaned: "$cleanUserId")');
      
      if (cleanUserId.isEmpty || cleanUserId == 'null') {
        print('⚠️  User not authenticated for updateProgressBasedOnElapsedDays');
        return;
      }
      
      final progress = await getMarathonProgress(cleanUserId);
      if (progress == null) {
        print('⚠️  Прогресс не найден для пересчета');
        return;
      }

      // Вычисляем количество дней с начала марафона
      final now = DateTime.now();
      final startDate = DateTime(
        progress.startDate.year,
        progress.startDate.month,
        progress.startDate.day,
      );
      final todayDate = DateTime(now.year, now.month, now.day);
      
      final elapsedDays = todayDate.difference(startDate).inDays;
      
      if (elapsedDays < 0) {
        print('⚠️  Дата начала в будущем, пропускаем обновление');
        return;
      }

      // День марафона = elapsedDays + 1 (потому что день 1 это день 0 с startDate)
      final marathonDay = elapsedDays + 1;
      
      // Если марафон завершен (больше 112 дней)
      if (marathonDay > 112) {
        print('🎉 Марафон уже завершен!');
        await updateProgress(userId: cleanUserId, stage: 4, week: 4, day: 7);
        return;
      }

      // Вычисляем текущий этап, неделю и день
      // День: 1-7 (день недели)
      int newDay = ((marathonDay - 1) % 7) + 1;
      
      // Неделя: 1-4 (неделя в этапе)
      final weekInMarathon = ((marathonDay - 1) / 7).floor() + 1;
      int newWeek = ((weekInMarathon - 1) % 4) + 1;
      
      // Этап: 1-4
      int newStage = ((marathonDay - 1) / 28).floor() + 1;
      if (newStage > 4) newStage = 4;

      print('📊 Пересчет прогресса: День марафона $marathonDay → Этап $newStage, Неделя $newWeek, День $newDay');

      // Обновляем только если значения изменились
      if (progress.currentStage != newStage || 
          progress.currentWeek != newWeek || 
          progress.currentDay != newDay) {
        await updateProgress(
          userId: cleanUserId,
          stage: newStage,
          week: newWeek,
          day: newDay,
        );
      } else {
        print('✅ Прогресс уже актуален');
      }
    } catch (e) {
      print('❌ Ошибка при пересчете прогресса по времени: $e');
      rethrow;
    }
  }

  /// Сбросить прогресс
  Future<void> resetMarathonProgress(String userId) async {
    try {
      if (userId.isEmpty) {
        throw Exception('Пользователь не аутентифицирован');
      }
      await initializeMarathonProgress(userId);
      print('🔄 Прогресс марафона сброшен для: $userId');
    } catch (e) {
      print('❌ Ошибка при сбросе прогресса: $e');
      rethrow;
    }
  }
}
