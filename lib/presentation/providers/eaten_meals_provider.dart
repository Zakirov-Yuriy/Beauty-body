import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './auth_provider.dart';

/// Stream провайдер для съеденных блюд из Firebase в реальном времени
final eatenMealsStreamProvider = StreamProvider<Map<String, DateTime>>((ref) {
  // Получаем пользователя - если нет, возвращаем пустой поток
  final userState = ref.watch(authStateProvider);
  
  return userState.when(
    data: (user) {
      if (user == null) {
        print('⚠️ No user authenticated');
        return Stream.value({});
      }
      
      // Слушаем изменения съеденных блюд из Firebase
      return FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('eatenMeals')
          .snapshots()
          .map((snapshot) {
            final eatenMeals = <String, DateTime>{};
            for (var doc in snapshot.docs) {
              final data = doc.data();
              final mealId = data['mealId'] as String?;
              final completedAtStr = data['completedAt'] as String?;
              
              if (mealId != null && completedAtStr != null) {
                try {
                  eatenMeals[mealId] = DateTime.parse(completedAtStr);
                } catch (e) {
                  print('⚠️ Error parsing date for $mealId: $e');
                }
              }
            }
            
            if (eatenMeals.isNotEmpty) {
              print('📥 Loaded ${eatenMeals.length} eaten meals from Firebase');
            }
            return eatenMeals;
          });
    },
    loading: () => Stream.value({}),
    error: (err, stack) {
      print('❌ Error loading eaten meals: $err');
      return Stream.value({});
    },
  );
});

/// Провайдер для отслеживания съеденных блюд
/// Хранит Map<mealId, completedAt> для блюд, которые были отмечены как съеденные
final eatenMealsProvider = StateProvider<Map<String, DateTime>>((ref) {
  return {};
});

/// Инициализировать съеденные блюда из Firebase
final initEatenMealsProvider = FutureProvider<void>((ref) async {
  // Слушаем stream и обновляем state
  ref.listen(eatenMealsStreamProvider, (previous, next) {
    next.whenData((meals) {
      ref.read(eatenMealsProvider.notifier).state = meals;
    });
  });
  print('✅ Initialized eaten meals listener');
});

/// Получить список ID съеденных блюд (для обратной совместимости)
final eatenMealIdsProvider = Provider<Set<String>>((ref) {
  final eatenMeals = ref.watch(eatenMealsProvider);
  return eatenMeals.keys.toSet();
});

/// Добавляет блюдо в список съеденных
final addEatenMealProvider = FutureProvider.family<void, String>((ref, mealId) async {
  final currentMeals = ref.read(eatenMealsProvider);
  ref.read(eatenMealsProvider.notifier).state = {
    ...currentMeals,
    mealId: DateTime.now(),
  };
});

/// Проверяет, съедено ли блюдо СЕГОДНЯ (по дате)
final isMealEatenProvider = Provider.family<bool, String>((ref, mealId) {
  final eatenMeals = ref.watch(eatenMealsProvider);
  final completedAt = eatenMeals[mealId];
  
  if (completedAt == null) return false;
  
  // Проверяем, что блюдо отмечено именно СЕГОДНЯ
  final today = DateTime.now();
  final todayStart = DateTime(today.year, today.month, today.day);
  final todayEnd = DateTime(today.year, today.month, today.day, 23, 59, 59);
  
  return completedAt.isAfter(todayStart) && completedAt.isBefore(todayEnd);
});

/// Получить время отметки блюда
final getMealCompletedTimeProvider = Provider.family<DateTime?, String>((ref, mealId) {
  final eatenMeals = ref.watch(eatenMealsProvider);
  return eatenMeals[mealId];
});

/// Количество съеденных блюд сегодня
final todayCompletedMealsCountProvider = Provider<int>((ref) {
  final eatenMeals = ref.watch(eatenMealsProvider);
  final today = DateTime.now();
  final todayStart = DateTime(today.year, today.month, today.day);
  final todayEnd = DateTime(today.year, today.month, today.day, 23, 59, 59);

  return eatenMeals.values.where((completedAt) {
    return completedAt.isAfter(todayStart) && completedAt.isBefore(todayEnd);
  }).length;
});

/// Проверяет, съедено ли конкретное блюдо в конкретный день
/// Принимает mealId и DateTime для проверки
final isMealEatenOnDateProvider = 
    Provider.family<bool, ({String mealId, DateTime date})>((ref, params) {
  final eatenMeals = ref.watch(eatenMealsProvider);
  final completedAt = eatenMeals[params.mealId];
  
  if (completedAt == null) return false;
  
  // Проверяем, что блюдо отмечено в указанный день
  final targetDate = params.date;
  final dayStart = DateTime(targetDate.year, targetDate.month, targetDate.day);
  final dayEnd = DateTime(targetDate.year, targetDate.month, targetDate.day, 23, 59, 59);
  
  return completedAt.isAfter(dayStart) && completedAt.isBefore(dayEnd);
});

/// Получить все съеденные блюда за конкретный день
final completedMealsOnDateProvider = 
    Provider.family<Set<String>, DateTime>((ref, date) {
  final eatenMeals = ref.watch(eatenMealsProvider);
  
  final dayStart = DateTime(date.year, date.month, date.day);
  final dayEnd = DateTime(date.year, date.month, date.day, 23, 59, 59);
  
  // Фильтруем все блюда, которые съедены в этот день
  return eatenMeals.entries
      .where((entry) {
        final completedAt = entry.value;
        return completedAt.isAfter(dayStart) && completedAt.isBefore(dayEnd);
      })
      .map((entry) => entry.key)
      .toSet();
});

/// Количество съеденных блюд за конкретный день
final completedMealsCountOnDateProvider = 
    Provider.family<int, DateTime>((ref, date) {
  final completedMeals = ref.watch(completedMealsOnDateProvider(date));
  return completedMeals.length;
});
