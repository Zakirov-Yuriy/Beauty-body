import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beauty_body/domain/repositories/meal_repository.dart';
import 'package:beauty_body/domain/repositories/progress_repository.dart';
import 'package:beauty_body/domain/repositories/meal_plan_repository.dart';
import 'package:beauty_body/data/datasources/remote/mock_meal_data_source.dart';
import 'package:beauty_body/data/datasources/remote/mock_progress_data_source.dart';
import 'package:beauty_body/data/datasources/remote/mock_meal_plan_data_source.dart';
import 'package:beauty_body/data/repositories/meal_repository_impl.dart';
import 'package:beauty_body/data/repositories/progress_repository_impl.dart';
import 'package:beauty_body/data/repositories/meal_plan_repository_impl.dart';

// ============ Data Sources (Dependency Injection) ============

final mealDataSourceProvider = Provider((ref) {
  return MockMealDataSource();
});

final progressDataSourceProvider = Provider((ref) {
  return MockProgressDataSource();
});

final mealPlanDataSourceProvider = Provider((ref) {
  return MockMealPlanDataSource();
});

// ============ Repositories ============

final mealRepositoryProvider = Provider<MealRepository>((ref) {
  return MealRepositoryImpl(ref.watch(mealDataSourceProvider));
});

final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  return ProgressRepositoryImpl(ref.watch(progressDataSourceProvider));
});

final mealPlanRepositoryProvider = Provider<MealPlanRepository>((ref) {
  return MealPlanRepositoryImpl(ref.watch(mealPlanDataSourceProvider));
});
