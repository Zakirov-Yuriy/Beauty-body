import 'package:beauty_body/domain/entities/meal_plan_entity.dart';
import 'package:beauty_body/domain/repositories/meal_plan_repository.dart';
import '../datasources/remote/meal_plan_data_source.dart';

class MealPlanRepositoryImpl implements MealPlanRepository {
  final MealPlanDataSource _dataSource;

  MealPlanRepositoryImpl(this._dataSource);

  @override
  Future<MealPlanEntity?> getCurrentPlan() => _dataSource.getCurrentPlan();

  @override
  Future<MealPlanEntity?> getPlanByWeek(int weekNumber, int stageNumber) =>
      _dataSource.getPlanByWeek(weekNumber, stageNumber);

  @override
  Future<List<MealPlanEntity>> getAllPlans() => _dataSource.getAllPlans();

  @override
  Future<MealPlanEntity?> getPlanForDate(DateTime date) =>
      _dataSource.getPlanForDate(date);

  @override
  Stream<MealPlanEntity> watchCurrentPlan() => _dataSource.watchCurrentPlan();
}
