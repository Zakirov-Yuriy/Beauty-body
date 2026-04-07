import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:beauty_body/data/models/marathon_progress_model.dart';
import 'package:beauty_body/domain/entities/marathon_progress_entity.dart';

class FirebaseMarathonProgressDataSource {
  final FirebaseFirestore _firestore;

  FirebaseMarathonProgressDataSource(this._firestore);

  /// Путь к документу прогресса пользователя
  String _getUserProgressPath(String userId) => 'users/$userId/marathonProgress';

  /// Получить текущий прогресс марафона
  Future<MarathonProgressEntity?> getMarathonProgress(String userId) async {
    try {
      final doc = await _firestore.doc(_getUserProgressPath(userId)).get();
      if (!doc.exists) {
        print('⚠️  Прогресс марафона не найден для пользователя: $userId');
        return null;
      }
      final model = MarathonProgressModel.fromJson(doc.data() as Map<String, dynamic>);
      print('✅ Прогресс марафона загружен: ${model.toEntity()}');
      return model.toEntity();
    } catch (e) {
      print('❌ Ошибка при загрузке прогресса марафона: $e');
      rethrow;
    }
  }

  /// Отслеживать прогресс в реальном времени
  Stream<MarathonProgressEntity?> watchMarathonProgress(String userId) {
    return _firestore
        .doc(_getUserProgressPath(userId))
        .snapshots()
        .map((doc) {
      if (!doc.exists) {
        print('⚠️  Прогресс марафона не найден: $userId');
        return null;
      }
      final model = MarathonProgressModel.fromJson(doc.data() as Map<String, dynamic>);
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
      await _firestore.doc(_getUserProgressPath(userId)).update({
        'currentStage': stage,
        'currentWeek': week,
        'currentDay': day,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
      print('✅ Прогресс обновлен: Этап $stage, Неделя $week, День $day');
    } catch (e) {
      print('❌ Ошибка при обновлении прогресса: $e');
      rethrow;
    }
  }

  /// Перейти на следующий день
  Future<void> nextDay(String userId) async {
    try {
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
      final now = DateTime.now();
      final model = MarathonProgressModel(
        userId: userId,
        currentStage: 1,
        currentWeek: 1,
        currentDay: 1,
        startDate: now,
        lastUpdated: now,
      );

      await _firestore.doc(_getUserProgressPath(userId)).set(model.toJson());
      print('✅ Прогресс марафона инициализирован для: $userId');
    } catch (e) {
      print('❌ Ошибка при инициализации прогресса: $e');
      rethrow;
    }
  }

  /// Сбросить прогресс
  Future<void> resetMarathonProgress(String userId) async {
    try {
      await initializeMarathonProgress(userId);
      print('🔄 Прогресс марафона сброшен для: $userId');
    } catch (e) {
      print('❌ Ошибка при сбросе прогресса: $e');
      rethrow;
    }
  }
}
