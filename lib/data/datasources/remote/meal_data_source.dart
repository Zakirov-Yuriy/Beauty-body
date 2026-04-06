import 'package:beauty_body/domain/entities/meal_entity.dart';

abstract class MealDataSource {
  Future<List<MealEntity>> getAllMeals();
  Future<MealEntity?> getMealById(String id);
  Future<List<MealEntity>> getMealsByType(String type);
  Stream<List<MealEntity>> getTodayMeals();
  Future<List<MealEntity>> getMealsByDate(DateTime date);
}
