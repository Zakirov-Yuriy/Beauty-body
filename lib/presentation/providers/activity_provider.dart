import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './auth_provider.dart';
import './marathon_progress_provider.dart';
import './repository_providers.dart';

/// Провайдер для отслеживания последней активности пользователя
final userActivityProvider = FutureProvider<DateTime?>((ref) async {
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null || user.uid.isEmpty) {
    print('⚠️  User not authenticated for userActivityProvider');
    return null;
  }

  try {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    
    if (!doc.exists) {
      print('⚠️  User document does not exist: ${user.uid}');
      return null;
    }
    
    final lastActiveStr = doc.data()?['lastActiveDate'] as String?;
    if (lastActiveStr != null) {
      return DateTime.parse(lastActiveStr);
    }
    return null;
  } catch (e) {
    print('❌ Error getting user activity: $e');
    return null;
  }
});

/// Провайдер для проверки прошла ли 1 день без активности
final isUserInactiveProvider = FutureProvider<bool>((ref) async {
  final user = ref.watch(authStateProvider).valueOrNull;
  print('🔍 isUserInactiveProvider - user: $user, uid: ${user?.uid}');
  
  if (user == null) {
    print('❌ User is null in isUserInactiveProvider');
    return false;
  }

  try {
    final lastActiveAsync = await ref.watch(userActivityProvider.future);
    
    if (lastActiveAsync == null) {
      // Первый раз в приложении - обновляем дату активности
      print('📅 First time in app, updating activity date for uid: ${user.uid}');
      await _updateLastActivityDate(user.uid);
      return false;
    }
    
    // Проверяем сколько дней без активности
    final today = DateTime.now();
    final lastActiveDate = DateTime(lastActiveAsync.year, lastActiveAsync.month, lastActiveAsync.day);
    final todayDate = DateTime(today.year, today.month, today.day);
    
    final daysDifference = todayDate.difference(lastActiveDate).inDays;
    
    print('📅 Days inactive: $daysDifference (last active: $lastActiveDate, today: $todayDate)');
    
    if (daysDifference > 1) {
      print('! User inactive for $daysDifference days - resetting progress!');
      return true;
    }
    
    // Обновляем дату активности на сегодня
    if (daysDifference >= 1) {
      await _updateLastActivityDate(user.uid);
    }
    
    return false;
  } catch (e) {
    print('❌ Error checking inactivity: $e');
    return false;
  }
});

/// Провайдер для сброса прогресса при неактивности
final resetProgressOnInactivityProvider = FutureProvider<void>((ref) async {
  final user = ref.watch(authStateProvider).valueOrNull;
  print('🔍 resetProgressOnInactivityProvider - user: $user, uid: ${user?.uid}');
  
  if (user == null) {
    print('⚠️  User is null in resetProgressOnInactivityProvider');
    return;
  }
  
  if (user.uid.isEmpty) {
    print('⚠️  user.uid is empty in resetProgressOnInactivityProvider');
    return;
  }

  final isInactive = await ref.watch(isUserInactiveProvider.future);
  
  if (isInactive) {
    print('🔄 Resetting user progress due to inactivity...');
    
    try {
      // Сбрасываем прогресс в Firestore
      // Используем set с merge:true чтобы не ошибиться если документа нет
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
            'dayStreak': 0,
            'currentDay': 1,
            'currentWeek': 1,
            'currentStage': 1,
            'marathonStartDate': DateTime.now().toIso8601String(),
            'lastResetDate': DateTime.now().toIso8601String(),
            'wasInactiveReset': true,
          }, SetOptions(merge: true));
      
      print('✅ Progress reset successfully');
      
      // Инвалидируем провайдеры чтобы обновить UI
      ref.invalidate(marathonProgressProvider);
      ref.invalidate(userActivityProvider);
    } catch (e) {
      print('❌ Error resetting progress: $e');
      rethrow;
    }
  }
});

/// Обновляет дату последней активности
Future<void> _updateLastActivityDate(String uid) async {
  // Валидация входного параметра
  if (uid.isEmpty) {
    print('❌ Cannot update activity: uid is empty');
    return;
  }
  
  final today = DateTime.now();
  final todayDate = DateTime(today.year, today.month, today.day);
  
  try {
    // Используем set с merge:true чтобы не ошибиться если документа нет
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set({
          'lastActiveDate': todayDate.toIso8601String(),
        }, SetOptions(merge: true));
    
    print('✅ Updated last active date to $todayDate');
  } catch (e) {
    print('❌ Error updating last active date: $e');
  }
}

/// Провайдер для ручного обновления активности когда пользователь открывает приложение
final updateActivityProvider = FutureProvider<void>((ref) async {
  final user = ref.watch(authStateProvider).valueOrNull;
  print('🔍 updateActivityProvider - user: $user, uid: ${user?.uid}');
  
  if (user == null) {
    print('❌ User is null in updateActivityProvider');
    return;
  }
  
  if (user.uid.isEmpty) {
    print('❌ User uid is empty in updateActivityProvider');
    return;
  }

  try {
    // Валидация uid перед использованием
    final cleanUid = user.uid.trim();
    if (cleanUid.isEmpty || cleanUid == 'null') {
      print('❌ CRITICAL: Invalid uid detected in updateActivityProvider: "${user.uid}"');
      return;
    }
    
    print('✅ Starting activity update for uid: $cleanUid');
    
    // Сначала проверяем надо ли сбрасывать прогресс при неактивности
    await ref.watch(resetProgressOnInactivityProvider.future);
    
    // Затем пересчитываем текущий день/неделю/этап на основе прошедшего времени
    final repository = ref.watch(marathonProgressRepositoryProvider);
    print('📍 Calling updateProgressBasedOnElapsedDays with uid: $cleanUid');
    await repository.updateProgressBasedOnElapsedDays(cleanUid);
    
    print('✅ Activity updated and progress recalculated');
  } catch (e) {
    print('❌ Error updating activity: $e');
  }
});
