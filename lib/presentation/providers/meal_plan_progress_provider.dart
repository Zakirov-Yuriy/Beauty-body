import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/meal_plan_progress_model.dart';
import '../../domain/entities/meal_plan_progress_entity.dart';
import 'repository_providers.dart';
import 'firebase_providers.dart';
import 'auth_provider.dart';

/// Получить текущий прогресс плана питания пользователя
final mealPlanProgressProvider = FutureProvider<MealPlanProgressEntity?>((ref) async {
  // Получаем текущего пользователя
  final userAsync = await ref.watch(authStateProvider.future);
  
  if (userAsync == null) {
    print('⚠️ No user authenticated');
    return null;
  }
  
  final snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(userAsync.uid)
      .collection('mealPlanProgress')
      .where('isActive', isEqualTo: true)
      .get();
  
  if (snapshot.docs.isEmpty) {
    print('⚠️ No meal plan progress found for user');
    return null;
  }
  
  final doc = snapshot.docs.first;
  final model = MealPlanProgressModel.fromJson(doc.data());
  print('📋 Loaded meal plan progress: Stage ${model.currentStage}, Week ${model.currentWeek}');
  return model.toEntity();
});

/// Создать или обновить прогресс плана питания
final updateMealPlanProgressProvider = FutureProvider.family<void, ({int stage, int week})>((ref, params) async {
  final userAsync = await ref.watch(authStateProvider.future);
  
  if (userAsync == null) throw Exception('User not authenticated');
  
  final progressDoc = FirebaseFirestore.instance
      .collection('users')
      .doc(userAsync.uid)
      .collection('mealPlanProgress')
      .doc('current');
  
  final model = MealPlanProgressModel(
    id: 'current',
    userId: userAsync.uid,
    currentStage: params.stage,
    currentWeek: params.week,
    startDate: DateTime.now(),
    isActive: true,
  );
  
  await progressDoc.set(model.toJson(), SetOptions(merge: true));
  
  // Инвалидируем провайдер чтобы обновить данные
  ref.invalidate(mealPlanProgressProvider);
  
  print('✅ Updated meal plan progress: Stage ${params.stage}, Week ${params.week}');
});

/// Инициализировать прогресс (при первом запуске)
final initializeMealPlanProgressProvider = FutureProvider<void>((ref) async {
  final userAsync = await ref.watch(authStateProvider.future);
  
  if (userAsync == null) throw Exception('User not authenticated');
  
  final progressRef = FirebaseFirestore.instance
      .collection('users')
      .doc(userAsync.uid)
      .collection('mealPlanProgress')
      .doc('current');
  
  final doc = await progressRef.get();
  
  // Если еще нет прогресса, создаем нулевой
  if (!doc.exists) {
    final model = MealPlanProgressModel(
      id: 'current',
      userId: userAsync.uid,
      currentStage: 1,
      currentWeek: 0,
      startDate: DateTime.now(),
      isActive: true,
    );
    
    await progressRef.set(model.toJson());
    print('🎯 Initialized meal plan progress for user');
  }
});
