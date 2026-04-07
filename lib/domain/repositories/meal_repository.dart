import '../entities/meal_entity.dart';

abstract class MealRepository {
  /// Получить все доступные блюда
  Future<List<MealEntity>> getAllMeals();

  /// Получить блюдо по ID
  Future<MealEntity?> getMealById(String id);

  /// Получить блюда по типу (завтрак, обед и т.д.)
  Future<List<MealEntity>> getMealsByType(String type);

  /// Получить блюда на сегодня (из плана)
  Stream<List<MealEntity>> getTodayMeals();

  /// Получить блюда по дате
  Future<List<MealEntity>> getMealsByDate(DateTime date);

  /// Добавить новое блюдо
  Future<void> addMeal(MealEntity meal);

  /// Обновить storagePath для блюда (для изображений из Firebase Storage)
  Future<void> updateMealStoragePath({
    required String mealId,
    required String storagePath,
  });
}
