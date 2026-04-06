import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beauty_body/domain/entities/meal_plan_entity.dart';
import 'package:beauty_body/domain/repositories/meal_plan_repository.dart';
import 'repository_providers.dart';

// ============ Meal Plan Providers ============

/// Поставщик текущего плана питания
final currentMealPlanProvider = FutureProvider<MealPlanEntity?>((ref) async {
  final repository = ref.watch(mealPlanRepositoryProvider);
  return await repository.getCurrentPlan();
});

/// Поставщик плана по неделе и этапу
final mealPlanByWeekProvider = FutureProviderFamily<MealPlanEntity?, ({int week, int stage})>((ref, params) async {
  final repository = ref.watch(mealPlanRepositoryProvider);
  return await repository.getPlanByWeek(params.week, params.stage);
});

/// Поставщик всех доступных планов
final allMealPlansProvider = FutureProvider<List<MealPlanEntity>>((ref) async {
  final repository = ref.watch(mealPlanRepositoryProvider);
  return await repository.getAllPlans();
});

/// Поставщик плана на конкретную дату
final mealPlanForDateProvider = FutureProviderFamily<MealPlanEntity?, DateTime>((ref, date) async {
  final repository = ref.watch(mealPlanRepositoryProvider);
  return await repository.getPlanForDate(date);
});

/// Поставщик для отслеживания текущего плана в реальном времени
final watchMealPlanProvider = StreamProvider<MealPlanEntity>((ref) {
  final repository = ref.watch(mealPlanRepositoryProvider);
  return repository.watchCurrentPlan();
});

// ============ Meal Plan State Management ============

/// Состояние управления планом питания
class MealPlanState {
  final int selectedWeek;
  final int selectedDay;
  final int stageNumber;
  final bool isLoading;
  final String? errorMessage;

  const MealPlanState({
    this.selectedWeek = 1,
    this.selectedDay = 2, // Среда (сегодня)
    this.stageNumber = 1,
    this.isLoading = false,
    this.errorMessage,
  });

  MealPlanState copyWith({
    int? selectedWeek,
    int? selectedDay,
    int? stageNumber,
    bool? isLoading,
    String? errorMessage,
  }) {
    return MealPlanState(
      selectedWeek: selectedWeek ?? this.selectedWeek,
      selectedDay: selectedDay ?? this.selectedDay,
      stageNumber: stageNumber ?? this.stageNumber,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// Notifier для управления состоянием плана питания
class MealPlanNotifier extends StateNotifier<MealPlanState> {
  final MealPlanRepository _repository;

  MealPlanNotifier(this._repository) : super(const MealPlanState());

  /// Выбрать неделю
  void selectWeek(int weekNumber) {
    state = state.copyWith(selectedWeek: weekNumber);
  }

  /// Выбрать день
  void selectDay(int dayNumber) {
    state = state.copyWith(selectedDay: dayNumber);
  }

  /// Выбрать этап
  void selectStage(int stageNumber) {
    state = state.copyWith(stageNumber: stageNumber);
  }

  /// Загрузить план для выбранной недели и этапа
  Future<void> loadPlan() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _repository.getPlanByWeek(
        state.selectedWeek,
        state.stageNumber,
      );
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Сбросить к начальному состоянию
  void reset() {
    state = const MealPlanState();
  }
}

/// StateNotifierProvider для управления состоянием плана питания
final mealPlanNotifierProvider = StateNotifierProvider<MealPlanNotifier, MealPlanState>((ref) {
  return MealPlanNotifier(ref.watch(mealPlanRepositoryProvider));
});

/// Комбинированный поставщик для получения плана с текущим состоянием
final selectedMealPlanProvider = FutureProvider<MealPlanEntity?>((ref) async {
  final state = ref.watch(mealPlanNotifierProvider);
  final repository = ref.watch(mealPlanRepositoryProvider);
  
  return await repository.getPlanByWeek(state.selectedWeek, state.stageNumber);
});
