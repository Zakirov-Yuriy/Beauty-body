import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './auth_provider.dart';

/// Stream провайдер для съеденных блюд из Firebase в реальном времени
final eatenMealsStreamProvider = StreamProvider<Map<String, DateTime>>((ref) {
  final userState = ref.watch(authStateProvider);
  
  // Если пользователь не загружен, возвращаем пустой stream
  if (!userState.hasValue || userState.value == null) {
    print('⚠️ No user authenticated');
    return Stream.value({});
  }
  
  final user = userState.value;
  if (user == null) {
    return Stream.value({});
  }

  return FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('eatenMeals')
      .snapshots()
      .map((snapshot) {
        print('📡 Stream snapshot received: ${snapshot.docs.length} documents');
        final eatenMeals = <String, DateTime>{};
        for (var doc in snapshot.docs) {
          final data = doc.data();
          final mealId = data['mealId'] as String?;
          final completedAtStr = data['completedAt'] as String?;
          
          print('   Doc ${doc.id}: mealId=$mealId, completedAt=$completedAtStr');
          
          if (mealId != null && completedAtStr != null) {
            try {
              final completedAt = DateTime.parse(completedAtStr);
              
              // Если это mealId уже есть, берём БОЛЕЕ НОВУЮ дату
              if (eatenMeals.containsKey(mealId)) {
                final existingDate = eatenMeals[mealId]!;
                if (completedAt.isAfter(existingDate)) {
                  print('   ⬆️ Replacing $mealId with newer date: $completedAt > $existingDate');
                  eatenMeals[mealId] = completedAt;
                }
              } else {
                eatenMeals[mealId] = completedAt;
              }
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
});


/// Notifier для управления съеденными блюдами
class EatenMealsNotifier extends StateNotifier<Map<String, DateTime>> {
  EatenMealsNotifier() : super({});

  void addMeal(String mealId) {
    final newState = {...state, mealId: DateTime.now()};
    state = newState;
  }

  void setMeals(Map<String, DateTime> meals) {
    state = meals;
  }

  void removeMeal(String mealId) {
    final newState = Map<String, DateTime>.from(state);
    newState.remove(mealId);
    state = newState;
  }

  void clear() {
    state = {};
  }
}

/// Провайдер для отслеживания съеденных блюд
final eatenMealsProvider = StateNotifierProvider<EatenMealsNotifier, Map<String, DateTime>>((ref) {
  final notifier = EatenMealsNotifier();
  
  // Слушаем Firebase изменения
  ref.listen(eatenMealsStreamProvider, (previous, next) {
    next.whenData((meals) {
      notifier.setMeals(meals);
    });
  });
  
  return notifier;
});

/// Получить список ID съеденных блюд
final eatenMealIdsProvider = Provider<Set<String>>((ref) {
  final eatenMeals = ref.watch(eatenMealsProvider);
  return eatenMeals.keys.toSet();
});

/// Добавляет блюдо в список съеденных
final addEatenMealProvider = FutureProvider.family<void, String>((ref, mealId) async {
  ref.read(eatenMealsProvider.notifier).addMeal(mealId);
  
  final user = ref.read(authStateProvider).valueOrNull;
  if (user != null) {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('eatenMeals')
        .doc(mealId)
        .set({
          'mealId': mealId,
          'completedAt': DateTime.now().toIso8601String(),
        });
  }
});

/// Проверяет, съедено ли блюдо СЕГОДНЯ
final isMealEatenProvider = Provider.family<bool, String>((ref, mealId) {
  final eatenMeals = ref.watch(eatenMealsProvider);
  final completedAt = eatenMeals[mealId];
  
  if (completedAt == null) {
    return false;
  }
  
  final today = DateTime.now();
  final todayStart = DateTime(today.year, today.month, today.day);
  final todayEnd = DateTime(today.year, today.month, today.day, 23, 59, 59, 999, 999);
  
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

/// Проверяет, съедено ли блюдо в конкретный день
final isMealEatenOnDateProvider = 
    Provider.family<bool, ({String mealId, DateTime date})>((ref, params) {
  final eatenMeals = ref.watch(eatenMealsProvider);
  final completedAt = eatenMeals[params.mealId];
  
  if (completedAt == null) return false;
  
  final targetDate = params.date;
  final dayStart = DateTime(targetDate.year, targetDate.month, targetDate.day);
  final dayEnd = DateTime(targetDate.year, targetDate.month, targetDate.day, 23, 59, 59);
  
  return completedAt.isAfter(dayStart) && completedAt.isBefore(dayEnd);
});

/// Получить съеденные блюда за конкретный день
final completedMealsOnDateProvider = 
    Provider.family<Set<String>, DateTime>((ref, date) {
  final eatenMeals = ref.watch(eatenMealsProvider);
  
  final dayStart = DateTime(date.year, date.month, date.day);
  final dayEnd = DateTime(date.year, date.month, date.day, 23, 59, 59);
  
  return eatenMeals.entries
      .where((entry) {
        final completedAt = entry.value;
        return completedAt.isAfter(dayStart) && completedAt.isBefore(dayEnd);
      })
      .map((entry) => entry.key)
      .toSet();
});

/// Количество съеденных блюд за конкретный день
final completedMealsCountOnDateProvider = Provider.family<int, DateTime>((ref, date) {
  final completedMeals = ref.watch(completedMealsOnDateProvider(date));
  return completedMeals.length;
});
