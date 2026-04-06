import '../entities/meal_plan_entity.dart';

abstract class MealPlanRepository {
  /// Получить текущий план питания
  Future<MealPlanEntity?> getCurrentPlan();

  /// Получить план по неделе и этапу
  Future<MealPlanEntity?> getPlanByWeek(int weekNumber, int stageNumber);

  /// Получить все доступные планы
  Future<List<MealPlanEntity>> getAllPlans();

  /// Получить план на конкретную дату
  Future<MealPlanEntity?> getPlanForDate(DateTime date);

  /// Обновления плана питания в реальном времени
  Stream<MealPlanEntity> watchCurrentPlan();
}
