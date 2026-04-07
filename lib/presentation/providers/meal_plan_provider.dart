import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beauty_body/domain/entities/meal_plan_entity.dart';
import 'package:beauty_body/domain/entities/meal_entity.dart';
import 'package:beauty_body/domain/repositories/meal_plan_repository.dart';
import 'package:beauty_body/core/constants/sample_meal_plans.dart';
import 'package:beauty_body/presentation/providers/meal_plan_progress_provider.dart';
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
    this.selectedDay = -1, // -1 = не выбран день
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
  final Ref _ref;

  MealPlanNotifier(this._repository, this._ref) : super(
    // Инициализируем с текущим днём недели
    MealPlanState(
      selectedWeek: 0, // Первая неделя (неделя 1)
      selectedDay: DateTime.now().weekday - 1, // Текущий день (0=пн, 6=вс)
      stageNumber: 1,
      isLoading: false,
      errorMessage: null,
    ),
  ) {
    print('📅 Initialized meal plan: Week 1, Day ${DateTime.now().weekday - 1} (${_getDayName(DateTime.now().weekday - 1)})');
  }

  /// Получить название дня по индексу
  static String _getDayName(int dayIndex) {
    const days = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
    return days[dayIndex];
  }

  /// Выбрать неделю и сохранить в БД
  Future<void> selectWeek(int weekNumber) async {
    state = state.copyWith(selectedWeek: weekNumber, selectedDay: -1); // Сбрасываем день выбытия
    
    // Сохраняем выбор в БД
    try {
      await _ref.read(updateMealPlanProgressProvider(
        (stage: state.stageNumber, week: weekNumber),
      ).future);
    } catch (e) {
      print('⚠️ Error saving week selection: $e');
    }
  }

  /// Выбрать день
  void selectDay(int dayNumber) {
    state = state.copyWith(selectedDay: dayNumber);
  }

  /// Выбрать этап и сохранить в БД
  Future<void> selectStage(int stageNumber) async {
    state = state.copyWith(stageNumber: stageNumber);
    
    // Сохраняем выбор в БД
    try {
      await _ref.read(updateMealPlanProgressProvider(
        (stage: stageNumber, week: state.selectedWeek),
      ).future);
    } catch (e) {
      print('⚠️ Error saving stage selection: $e');
    }
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
  return MealPlanNotifier(ref.watch(mealPlanRepositoryProvider), ref);
});

/// Комбинированный поставщик для получения плана с текущим состоянием
/// Если есть прогресс в БД, используем его; иначе используем состояние UI
final selectedMealPlanProvider = FutureProvider<MealPlanEntity?>((ref) async {
  // Пытаемся получить прогресс из БД
  try {
    final progress = await ref.watch(mealPlanProgressProvider.future);
    
    if (progress != null && progress.isActive) {
      // Используем прогресс из БД
      print('📅 Using meal plan progress from DB: Stage ${progress.currentStage}, Week ${progress.currentWeek}');
      return SampleMealPlans.getPlan(progress.currentWeek);
    }
  } catch (e) {
    print('⚠️ Error loading meal plan progress: $e');
  }
  
  // Используем состояние UI (для когда пользователь вручную выбирает неделю)
  final state = ref.watch(mealPlanNotifierProvider);
  return SampleMealPlans.getPlan(state.selectedWeek);
});

/// Поставщик для получения меню и дня недели на сегодня
final todayMealPlanProvider = Provider<AsyncValue<({String dayName, List<MealEntity> meals})>>((ref) {
  final planAsync = ref.watch(selectedMealPlanProvider);
  
  return planAsync.whenData((mealPlan) {
    if (mealPlan == null || mealPlan.dailyMeals.isEmpty) {
      return (dayName: 'Понедельник', meals: <MealEntity>[]);
    }
    
    // Получаем текущий день недели (0=пн, 1=вт, ..., 6=вс)
    final todayDayIndex = DateTime.now().weekday - 1;
    
    // Список названий дней
    const dayNames = ['Понедельник', 'Вторник', 'Среда', 'Четверг', 'Пятница', 'Суббота', 'Воскресенье'];
    final dayName = dayNames[todayDayIndex];
    
    // Получаем меню на сегодня
    final todayMeals = mealPlan.dailyMeals[todayDayIndex] ?? [];
    
    print('📅 Today is $dayName (index: $todayDayIndex), meals count: ${todayMeals.length}');
    
    return (dayName: dayName, meals: todayMeals);
  });
});
