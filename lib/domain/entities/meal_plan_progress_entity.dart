/// Сущность для отслеживания прогресса в плане питания
class MealPlanProgressEntity {
  final String id;
  final String userId;
  final int currentStage; // Текущий этап (1, 2, 3...)
  final int currentWeek; // Текущая неделя в этапе (0, 1, 2)
  final DateTime startDate; // Дата начала текущего плана
  final DateTime? completedDate; // Дата завершения (null если активен)
  final bool isCompleted; // Завершён ли план?
  final bool isActive; // Активен ли план?

  const MealPlanProgressEntity({
    required this.id,
    required this.userId,
    required this.currentStage,
    required this.currentWeek,
    required this.startDate,
    this.completedDate,
    this.isCompleted = false,
    this.isActive = true,
  });

  /// Копирование с изменениями
  MealPlanProgressEntity copyWith({
    String? id,
    String? userId,
    int? currentStage,
    int? currentWeek,
    DateTime? startDate,
    DateTime? completedDate,
    bool? isCompleted,
    bool? isActive,
  }) {
    return MealPlanProgressEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      currentStage: currentStage ?? this.currentStage,
      currentWeek: currentWeek ?? this.currentWeek,
      startDate: startDate ?? this.startDate,
      completedDate: completedDate ?? this.completedDate,
      isCompleted: isCompleted ?? this.isCompleted,
      isActive: isActive ?? this.isActive,
    );
  }

  /// Переход на следующую неделю
  MealPlanProgressEntity nextWeek() {
    final newWeek = (currentWeek + 1) % 3; // 0, 1, 2 недели
    final newStage = currentStage + (currentWeek + 1) ~/ 3; // Переход на следующий этап после 3 недель
    
    return copyWith(
      currentWeek: newWeek,
      currentStage: newStage,
    );
  }

  @override
  String toString() {
    return 'MealPlanProgressEntity(stage: $currentStage, week: $currentWeek, active: $isActive)';
  }
}
