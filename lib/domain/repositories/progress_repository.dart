import '../entities/progress_entity.dart';

abstract class ProgressRepository {
  /// Получить весь прогресс пользователя
  Future<List<ProgressEntity>> getProgressHistory();

  /// Получить прогресс за последние N дней
  Future<List<ProgressEntity>> getProgressLast(int days);

  /// Получить прогресс на сегодня
  Stream<ProgressEntity?> getTodayProgress();

  /// Получить текущий вес
  Future<double> getCurrentWeight();

  /// Добавить запись о весе
  Future<void> addWeightEntry(double weight);

  /// Обновить замеры

  Future<void> updateMeasurements(Map<String, double> measurements);

  /// Получить обновления прогресса в реальном времени
  Stream<ProgressEntity> watchProgress();
}
