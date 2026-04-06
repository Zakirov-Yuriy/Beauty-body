import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beauty_body/domain/entities/progress_entity.dart';
import 'package:beauty_body/domain/repositories/progress_repository.dart';
import 'repository_providers.dart';

// ============ Progress Providers ============

/// Поставщик полной истории прогресса
final progressHistoryProvider = FutureProvider<List<ProgressEntity>>((ref) async {
  final repository = ref.watch(progressRepositoryProvider);
  return await repository.getProgressHistory();
});

/// Поставщик прогресса за последние N дней
final progressLastDaysProvider = FutureProviderFamily<List<ProgressEntity>, int>((ref, days) async {
  final repository = ref.watch(progressRepositoryProvider);
  return await repository.getProgressLast(days);
});

/// Поставщик прогресса на сегодня (Stream для реальных обновлений)
final todayProgressProvider = StreamProvider<ProgressEntity?>((ref) {
  final repository = ref.watch(progressRepositoryProvider);
  return repository.getTodayProgress();
});

/// Поставщик текущего веса
final currentWeightProvider = FutureProvider<double>((ref) async {
  final repository = ref.watch(progressRepositoryProvider);
  return await repository.getCurrentWeight();
});

/// Поставщик для отслеживания прогресса в реальном времени
final watchProgressProvider = StreamProvider<ProgressEntity>((ref) {
  final repository = ref.watch(progressRepositoryProvider);
  return repository.watchProgress();
});

/// StateProvider для хранения временного веса (для добавления записи)
final tempWeightProvider = StateProvider<String>((ref) => '');

/// Notifier для добавления записей о весе
class WeightEntryNotifier extends StateNotifier<AsyncValue<void>> {
  final ProgressRepository _repository;

  WeightEntryNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> addWeight(double weight) async {
    state = const AsyncValue.loading();
    try {
      await _repository.addWeightEntry(weight);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final weightEntryProvider = StateNotifierProvider<WeightEntryNotifier, AsyncValue<void>>((ref) {
  return WeightEntryNotifier(ref.watch(progressRepositoryProvider));
});

/// Notifier для обновления замеров
class MeasurementsNotifier extends StateNotifier<AsyncValue<void>> {
  final ProgressRepository _repository;

  MeasurementsNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> updateMeasurements(Map<String, double> measurements) async {
    state = const AsyncValue.loading();
    try {
      await _repository.updateMeasurements(measurements);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final measurementsProvider = StateNotifierProvider<MeasurementsNotifier, AsyncValue<void>>((ref) {
  return MeasurementsNotifier(ref.watch(progressRepositoryProvider));
});
