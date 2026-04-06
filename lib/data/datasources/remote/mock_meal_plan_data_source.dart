import 'package:beauty_body/domain/entities/meal_entity.dart';
import 'package:beauty_body/domain/entities/meal_plan_entity.dart';
import 'mock_meal_data_source.dart';
import 'meal_plan_data_source.dart';

class MockMealPlanDataSource implements MealPlanDataSource {
  final _mealDataSource = MockMealDataSource();

  final List<MealPlanEntity> mockPlans = [];

  MockMealPlanDataSource() {
    _initializeMockPlans();
  }

  void _initializeMockPlans() {
    final meals = _mealDataSource.mockMeals;
    
    // Создаём план на неделю с 7 дневными комбинациями
    final dailyMeals = <int, List<MealEntity>>{
      0: [meals[0], meals[1], meals[2], meals[3]], // Пн
      1: [meals[0], meals[1], meals[2], meals[3]], // Вт
      2: [meals[0], meals[1], meals[2], meals[3]], // Ср (сегодня)
      3: [meals[0], meals[1], meals[2], meals[3]], // Чт
      4: [meals[0], meals[1], meals[2], meals[3]], // Пт
      5: [meals[0], meals[1], meals[2], meals[3]], // Сб
      6: [meals[0], meals[1], meals[2], meals[3]], // Вс
    };

    mockPlans.add(
      MealPlanEntity(
        id: 'plan_1',
        userId: 'user1',
        weekNumber: 2,
        stageNumber: 1,
        dailyMeals: dailyMeals,
        dailyGoals: {
          'calories': 2000,
          'protein': 120,
          'carbs': 200,
          'fat': 70,
        },
        startDate: DateTime.now().subtract(const Duration(days: 2)),
        endDate: DateTime.now().add(const Duration(days: 5)),
        isActive: true,
      ),
    );
  }

  @override
  Future<MealPlanEntity?> getCurrentPlan() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return mockPlans.isNotEmpty ? mockPlans.first : null;
  }

  @override
  Future<MealPlanEntity?> getPlanByWeek(int weekNumber, int stageNumber) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return mockPlans.firstWhere(
        (plan) =>
            plan.weekNumber == weekNumber && plan.stageNumber == stageNumber,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<MealPlanEntity>> getAllPlans() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return mockPlans;
  }

  @override
  Future<MealPlanEntity?> getPlanForDate(DateTime date) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return mockPlans.firstWhere(
        (plan) =>
            plan.startDate.isBefore(date) && plan.endDate.isAfter(date),
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Stream<MealPlanEntity> watchCurrentPlan() async* {
    if (mockPlans.isNotEmpty) {
      yield mockPlans.first;
      await Future.delayed(const Duration(seconds: 5));
      // В реальном приложении слушать Firestore для обновлений
    }
  }
}
