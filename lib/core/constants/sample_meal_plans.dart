import 'package:beauty_body/domain/entities/meal_plan_entity.dart';
import '../../../domain/entities/meal_entity.dart';
import 'sample_meals.dart';

/// 📅 Примеры планов питания на 3 недели
class SampleMealPlans {
  // Помощник для создания плана
  static MealPlanEntity _createPlan({
    required int weekNumber,
    required int stageNumber,
    required Map<int, List<MealEntity>> dailyMeals,
  }) {
    final now = DateTime.now();
    final startDate = now.add(Duration(days: (weekNumber - 1) * 7));
    final endDate = startDate.add(const Duration(days: 6));

    return MealPlanEntity(
      id: 'plan_${stageNumber}_week_$weekNumber',
      userId: 'user_1',
      weekNumber: weekNumber,
      stageNumber: stageNumber,
      dailyMeals: dailyMeals,
      dailyGoals: {'calories': 2000, 'protein': 150, 'carbs': 200, 'fat': 70},
      startDate: startDate,
      endDate: endDate,
      isActive: weekNumber == 1,
    );
  }

  /// Неделя 1 - Основная неделя с meal_1
  static final week1 = _createPlan(
    weekNumber: 1,
    stageNumber: 1,
    dailyMeals: {
      // Понедельник (0)
      0: [
        SampleMeals.cottageCheeseMeal,
        SampleMeals.pastaBologneseMeal,
        SampleMeals.summerSaladMeal,
        SampleMeals.fruitSaladMeal,
        SampleMeals.meatballsDinnerMeal,
        SampleMeals.greenSaladDinnerMeal,
      ],
      // Вторник (1)
      1: [
        SampleMeals.shakshukaMeal,
        SampleMeals.meatballsDinnerMeal,
        SampleMeals.greenSaladDinnerMeal,
        SampleMeals.layeredDessertMeal,
        SampleMeals.summerSaladDinnerMeal,
        SampleMeals.stuffedZucchiniDinnerMeal,
      ],
      // Среда (2)
      2: [
        SampleMeals.ppRollsMeal,
        SampleMeals.condensedMilkMeal,
        SampleMeals.confitureMeal,
        SampleMeals.stuffedZucchiniMeal,
        SampleMeals.summerSaladMeal,
        SampleMeals.lavashChipsMeal,
        SampleMeals.chickenBreastMeal,
        SampleMeals.bakedVeggiesMeal,
        SampleMeals.adjikaMeal,
      ],
      // Четверг (3)
      3: [
        SampleMeals.ppRollsMeal,
        SampleMeals.condensedMilkMeal,
        SampleMeals.confitureMeal,
        SampleMeals.chickenBreastLunchMeal,
        SampleMeals.bakedVeggiesMealLunch,
        SampleMeals.adjikaMealLunch,
        SampleMeals.glazedCurdSnack,
        SampleMeals.syrnikiMeal,
      ],
      // Пятница (4)
      4: [
        SampleMeals.syrnikiBreakfastMeal,
        SampleMeals.condensedMilkMeal,
        SampleMeals.confitureMeal,
        SampleMeals.beanBorschtMeal,
        SampleMeals.summerSaladMeal,
        SampleMeals.curdJellySnack,
        SampleMeals.georgianSaladMeal,
      ],
      // Суббота (5)
      5: [
        SampleMeals.dietBelyashiMeal,
        SampleMeals.fitSteakMeal,
        SampleMeals.detoxSaladMeal,
        SampleMeals.darkChocolateSnack,
        SampleMeals.chickpeaPilafMeal,
        SampleMeals.brushSaladMeal,
      ],
      // Воскресенье (6)
      6: [
        SampleMeals.cheesecakeMeal,
        SampleMeals.confitureMeal,
        SampleMeals.condensedMilkMeal,
        SampleMeals.chickenKebabMeal,
        SampleMeals.smokeSaladMeal,
        SampleMeals.appleSnackMeal,
        SampleMeals.proteinShakeMeal,
      ],
    },
  );

  /// Неделя 2
  static final week2 = _createPlan(
    weekNumber: 2,
    stageNumber: 1,
    dailyMeals: {0: [], 1: [], 2: [], 3: [], 4: [], 5: [], 6: []},
  );

  /// Неделя 3
  static final week3 = _createPlan(
    weekNumber: 3,
    stageNumber: 1,
    dailyMeals: {0: [], 1: [], 2: [], 3: [], 4: [], 5: [], 6: []},
  );

  /// Получить план по неделе
  static MealPlanEntity getPlan(int weekNumber) {
    switch (weekNumber) {
      case 0:
        return week1;
      case 1:
        return week2;
      case 2:
        return week3;
      default:
        return week1;
    }
  }
}
