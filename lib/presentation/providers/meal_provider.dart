import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beauty_body/domain/entities/meal_entity.dart';
import 'repository_providers.dart';

// ============ Meal Providers ============

/// Прова йдер со всеми доступными блюдами
final allMealsProvider = FutureProvider<List<MealEntity>>((ref) async {
  final repository = ref.watch(mealRepositoryProvider);
  return await repository.getAllMeals();
});

/// Поставщик блюд на сегодня (с использованием Stream)
final todayMealsProvider = StreamProvider<List<MealEntity>>((ref) {
  final repository = ref.watch(mealRepositoryProvider);
  return repository.getTodayMeals();
});

/// Фильтр для получения блюд по типу
final mealTypeProvider = StateProvider<String?>((ref) => null);

final mealsByTypeProvider = FutureProvider<List<MealEntity>>((ref) async {
  final type = ref.watch(mealTypeProvider);
  final repository = ref.watch(mealRepositoryProvider);

  if (type == null) {
    return [];
  }

  return await repository.getMealsByType(type);
});

/// Поставщик отдельного блюда по ID
final mealByIdProvider = FutureProviderFamily<MealEntity?, String>((ref, id) async {
  final repository = ref.watch(mealRepositoryProvider);
  return await repository.getMealById(id);
});

/// Поставщик блюд на конкретную дату
final mealsByDateProvider = FutureProviderFamily<List<MealEntity>, DateTime>((ref, date) async {
  final repository = ref.watch(mealRepositoryProvider);
  return await repository.getMealsByDate(date);
});
