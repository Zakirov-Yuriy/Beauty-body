import 'package:beauty_body/domain/entities/meal_plan_entity.dart';

abstract class MealPlanDataSource {
  Future<MealPlanEntity?> getCurrentPlan();
  Future<MealPlanEntity?> getPlanByWeek(int weekNumber, int stageNumber);
  Future<List<MealPlanEntity>> getAllPlans();
  Future<MealPlanEntity?> getPlanForDate(DateTime date);
  Stream<MealPlanEntity> watchCurrentPlan();
}
