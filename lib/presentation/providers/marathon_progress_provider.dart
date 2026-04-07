import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beauty_body/presentation/providers/auth_provider.dart';
import 'package:beauty_body/presentation/providers/repository_providers.dart';
import 'package:beauty_body/domain/entities/marathon_progress_entity.dart';

/// Текущий прогресс марафона пользователя (в реальном времени)
final marathonProgressProvider = StreamProvider<MarathonProgressEntity?>((ref) {
  final authState = ref.watch(authStateProvider);
  
  return authState.maybeWhen(
    data: (user) {
      if (user == null) return Stream.value(null);
      final repository = ref.watch(marathonProgressRepositoryProvider);
      return repository.watchMarathonProgress(user.uid);
    },
    orElse: () => Stream.value(null),
  );
});

/// Инициализировать прогресс марафона автоматически при новом пользователе
final initializeMarathonProgressOnLoginProvider = FutureProvider<void>((ref) async {
  final authState = ref.watch(authStateProvider);
  
  await authState.maybeWhen(
    data: (user) async {
      if (user == null) return;
      
      final repository = ref.watch(marathonProgressRepositoryProvider);
      
      // Проверяем существует ли уже прогресс
      try {
        final existingProgress = await repository.getMarathonProgress(user.uid);
        if (existingProgress != null) {
          print('✅ Прогресс марафона уже существует для пользователя: ${user.uid}');
          return;
        }
      } catch (e) {
        print('⚠️  Не удалось получить прогресс: $e');
      }
      
      // Если прогресса нет, инициализируем
      try {
        await repository.initializeMarathonProgress(user.uid);
        print('✅ Прогресс марафона инициализирован для пользователя: ${user.uid}');
      } catch (e) {
        print('❌ Ошибка при инициализации прогресса: $e');
        rethrow;
      }
    },
    orElse: () {},
  );
});

/// Инициализировать прогресс марафона для нового пользователя
final initializeMarathonProgressProvider = FutureProvider.family<void, String>((ref, userId) async {
  final repository = ref.watch(marathonProgressRepositoryProvider);
  await repository.initializeMarathonProgress(userId);
});

/// Перейти на следующий день марафона
final nextDayProvider = FutureProvider.family<void, String>((ref, userId) async {
  final repository = ref.watch(marathonProgressRepositoryProvider);
  await repository.nextDay(userId);
});

/// Обновить прогресс марафона
final updateMarathonProgressProvider = FutureProvider.family<void, ({String userId, int stage, int week, int day})>((ref, params) async {
  final repository = ref.watch(marathonProgressRepositoryProvider);
  await repository.updateProgress(
    userId: params.userId,
    stage: params.stage,
    week: params.week,
    day: params.day,
  );
});

/// Сбросить прогресс марафона
final resetMarathonProgressProvider = FutureProvider.family<void, String>((ref, userId) async {
  final repository = ref.watch(marathonProgressRepositoryProvider);
  await repository.resetMarathonProgress(userId);
});
