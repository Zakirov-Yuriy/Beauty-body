import 'package:beauty_body/domain/entities/marathon_progress_entity.dart';

abstract class MarathonProgressRepository {
  /// Получить текущий прогресс марафона пользователя
  Future<MarathonProgressEntity?> getMarathonProgress(String userId);

  /// Отслеживать прогресс в реальном времени
  Stream<MarathonProgressEntity?> watchMarathonProgress(String userId);

  /// Обновить прогресс (этап, неделя, день)
  Future<void> updateProgress({
    required String userId,
    required int stage,
    required int week,
    required int day,
  });

  /// Перейти на следующий день
  Future<void> nextDay(String userId);

  /// Инициализировать прогресс марафона для нового пользователя
  Future<void> initializeMarathonProgress(String userId);

  /// Сбросить прогресс (начать с нуля)
  Future<void> resetMarathonProgress(String userId);
}
