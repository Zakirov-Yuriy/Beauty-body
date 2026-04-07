import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beauty_body/domain/repositories/meal_repository.dart';
import 'package:beauty_body/domain/repositories/progress_repository.dart';
import 'package:beauty_body/domain/repositories/meal_plan_repository.dart';
import 'package:beauty_body/domain/repositories/marathon_progress_repository.dart';
import 'package:beauty_body/data/datasources/remote/firebase_meal_data_source.dart';
import 'package:beauty_body/data/datasources/remote/firebase_progress_data_source.dart';
import 'package:beauty_body/data/datasources/remote/firebase_marathon_progress_data_source.dart';
import 'package:beauty_body/data/datasources/remote/mock_meal_plan_data_source.dart';
import 'package:beauty_body/data/repositories/meal_repository_impl.dart';
import 'package:beauty_body/data/repositories/progress_repository_impl.dart';
import 'package:beauty_body/data/repositories/meal_plan_repository_impl.dart';
import 'package:beauty_body/data/repositories/marathon_progress_repository_impl.dart';
import 'firebase_providers.dart';

// ============ Data Sources (Dependency Injection) ============

final mealDataSourceProvider = Provider((ref) {
  final firestore = ref.watch(firestoreProvider);
  return FirebaseMealDataSource(firestore);
});

final progressDataSourceProvider = Provider((ref) {
  final firestore = ref.watch(firestoreProvider);
  final auth = ref.watch(firebaseAuthProvider);
  return FirebaseProgressDataSource(firestore, auth);
});

final mealPlanDataSourceProvider = Provider((ref) {
  // Временно оставляем Mock пока UI не адаптирована к новой структуре
  // когда обновим MealPlanScreen и ProgressScreen, переходим на Firebase
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

// ============ Marathon Progress ============

final marathonProgressDataSourceProvider = Provider((ref) {
  final firestore = ref.watch(firestoreProvider);
  return FirebaseMarathonProgressDataSource(firestore);
});

final marathonProgressRepositoryProvider = Provider<MarathonProgressRepository>((ref) {
  return MarathonProgressRepositoryImpl(ref.watch(marathonProgressDataSourceProvider));
});
