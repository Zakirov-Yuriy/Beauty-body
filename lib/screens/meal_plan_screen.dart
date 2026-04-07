import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../presentation/providers/meal_plan_provider.dart';
import '../presentation/providers/eaten_meals_provider.dart';
import '../core/utils/meal_translations.dart';
import 'recipe_detail_screen.dart';

class MealPlanScreen extends ConsumerWidget {
  const MealPlanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the meal plan state for week/day selection
    final planState = ref.watch(mealPlanNotifierProvider);

    // Watch the selected meal plan with actual meals
    final selectedPlanAsync = ref.watch(selectedMealPlanProvider);

    // Инициализируем съеденные блюда из Firebase
    ref.watch(initEatenMealsProvider);

    // Получаем ID съеденных блюд
    final eatenMealIds = ref.watch(eatenMealIdsProvider);

    const List<String> weekdays = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
    const List<String> weekdaysFull = [
      'Понедельник',
      'Вторник',
      'Среда',
      'Четверг',
      'Пятница',
      'Суббота',
      'Воскресенье',
    ];

    const List<Color> mealColors = [
      AppColors.breakfastBg,
      AppColors.lunchBg,
      AppColors.snackBg,
      AppColors.dinnerBg,
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Header
          Container(
            color: AppColors.greenMid,
            padding: const EdgeInsets.fromLTRB(20, 52, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '📅  План питания',
                  style: GoogleFonts.rubik(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Этап 1 · Неделя ${planState.selectedWeek + 1}',
                  style: GoogleFonts.rubik(fontSize: 13, color: Colors.white70),
                ),
                const SizedBox(height: 14),

                // Week tabs
                Row(
                  children: List.generate(3, (i) {
                    final isActive = i == planState.selectedWeek;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          await ref
                              .read(mealPlanNotifierProvider.notifier)
                              .selectWeek(i);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: EdgeInsets.only(right: i < 2 ? 6 : 0),
                          padding: const EdgeInsets.symmetric(vertical: 7),
                          decoration: BoxDecoration(
                            color: isActive ? AppColors.white : Colors.white24,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Нед ${i + 1}',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.rubik(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isActive
                                  ? AppColors.greenMid
                                  : Colors.white70,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),

          // Days row - will be populated dynamically based on meal plan
          Expanded(
            child: selectedPlanAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.greenMid),
              ),
              error: (err, stack) => Center(
                child: Text(
                  'Ошибка: $err',
                  style: GoogleFonts.rubik(color: AppColors.textMuted),
                ),
              ),
              data: (plan) {
                return Column(
                  children: [
                    // Days row с проверкой съеденных блюд
                    Container(
                      color: AppColors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(7, (i) {
                          // Определяем какой день сегодня
                          final now = DateTime.now();
                          final todayWeekday =
                              now.weekday - 1; // 0=пн, 1=вт, ..., 6=вс
                          final isToday = i == todayWeekday;

                          // Проверяем, все ли блюда за этот день съедены
                          final dailyMealsForDay = plan?.dailyMeals[i] ?? [];
                          final isDone =
                              dailyMealsForDay.isNotEmpty &&
                              dailyMealsForDay.every(
                                (meal) => eatenMealIds.contains(meal.id),
                              );
                          final isSelected = i == planState.selectedDay;

                          return GestureDetector(
                            onTap: () {
                              ref
                                  .read(mealPlanNotifierProvider.notifier)
                                  .selectDay(i);
                            },
                            child: Column(
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSelected
                                        ? AppColors.greenMid
                                        : isDone
                                        ? AppColors.greenCard
                                        : isToday
                                        ? AppColors.greenLight
                                        : AppColors.greenSurface,
                                    border: isToday && !isSelected
                                        ? Border.all(
                                            color: AppColors.greenMid,
                                            width: 2,
                                          )
                                        : null,
                                  ),
                                  child: Center(
                                    child: Text(
                                      weekdays[i],
                                      style: GoogleFonts.rubik(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color:
                                            isSelected ||
                                                (isToday && !isSelected)
                                            ? AppColors.white
                                            : isDone
                                            ? AppColors.greenMid
                                            : AppColors.textMuted,
                                      ),
                                    ),
                                  ),
                                ),
                                if (isDone) ...[
                                  const SizedBox(height: 3),
                                  const Icon(
                                    Icons.check_rounded,
                                    size: 10,
                                    color: AppColors.greenLight,
                                  ),
                                ],
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                    // Daily meals list - показываем ТОЛЬКО если выбран день
                    Expanded(
                      child: plan == null
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.calendar_today_rounded,
                                    color: AppColors.textMuted,
                                    size: 48,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'План не найден',
                                    style: GoogleFonts.rubik(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : planState.selectedDay ==
                                -1 // Если день не выбран
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.touch_app_rounded,
                                    color: AppColors.greenLight,
                                    size: 48,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Выберите день недели',
                                    style: GoogleFonts.rubik(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView(
                              padding: const EdgeInsets.all(16),
                              children: [
                                ...(() {
                                  // Рассчитываем дату на основе выбранной недели и дня
                                  final now = DateTime.now();

                                  // Находим понедельник текущей недели
                                  // weekday: 1=пн, 2=вт, ..., 7=вс
                                  final daysToMonday = now.weekday - 1;
                                  final mondayOfThisWeek = now.subtract(
                                    Duration(days: daysToMonday),
                                  );

                                  // Рассчитываем итоговую дату
                                  final weekOffset =
                                      (planState.selectedWeek) * 7;
                                  final dayOffset = planState.selectedDay;
                                  final selectedDate = mondayOfThisWeek.add(
                                    Duration(days: weekOffset + dayOffset),
                                  );

                                  // Месяцы на русском
                                  const monthsRu = [
                                    'января',
                                    'февраля',
                                    'марта',
                                    'апреля',
                                    'мая',
                                    'июня',
                                    'июля',
                                    'августа',
                                    'сентября',
                                    'октября',
                                    'ноября',
                                    'декабря',
                                  ];

                                  final dateStr =
                                      '${selectedDate.day} ${monthsRu[selectedDate.month - 1]} ${selectedDate.year}';

                                  return [
                                    Text(
                                      '${weekdaysFull[planState.selectedDay]} · $dateStr',
                                      style: GoogleFonts.rubik(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.greenDark,
                                      ),
                                    ),
                                  ];
                                }()),
                                const SizedBox(height: 12),
                                ...(() {
                                  final dailyMeals =
                                      plan.dailyMeals[planState.selectedDay] ??
                                      [];
                                  if (dailyMeals.isEmpty) {
                                    return [
                                      Center(
                                        child: Text(
                                          'Приемы пищи не добавлены',
                                          style: GoogleFonts.rubik(
                                            fontSize: 13,
                                            color: AppColors.textMuted,
                                          ),
                                        ),
                                      ),
                                    ];
                                  }
                                  return dailyMeals.asMap().entries.map((
                                    entry,
                                  ) {
                                    final meal = entry.value;
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 10,
                                      ),
                                      child: GestureDetector(
                                        onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                RecipeDetailScreen(meal: meal),
                                          ),
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.white,
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                            border: Border.all(
                                              color: AppColors.greenBorder,
                                              width: 0.5,
                                            ),
                                          ),
                                          padding: const EdgeInsets.all(14),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 52,
                                                height: 52,
                                                decoration: BoxDecoration(
                                                  color:
                                                      mealColors[entry.key % 4],
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  child:
                                                      meal
                                                          .imageAssetPath
                                                          .isEmpty
                                                      ? Center(
                                                          child: Text(
                                                            meal.emoji,
                                                            style:
                                                                const TextStyle(
                                                                  fontSize: 26,
                                                                ),
                                                          ),
                                                        )
                                                      : Image.asset(
                                                          meal.imageAssetPath,
                                                          fit: BoxFit.cover,
                                                          errorBuilder:
                                                              (
                                                                context,
                                                                error,
                                                                stackTrace,
                                                              ) {
                                                                return Center(
                                                                  child: Text(
                                                                    meal.emoji,
                                                                    style: const TextStyle(
                                                                      fontSize:
                                                                          26,
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                        ),
                                                ),
                                              ),
                                              const SizedBox(width: 14),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      translateMealType(
                                                        meal.type,
                                                      ),
                                                      style: GoogleFonts.rubik(
                                                        fontSize: 11,
                                                        color:
                                                            AppColors.textMuted,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 2),
                                                    Text(
                                                      meal.name,
                                                      style: GoogleFonts.rubik(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            AppColors.textDark,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 3),
                                                    Text(
                                                      'Порция: ${meal.portion}',
                                                      style: GoogleFonts.rubik(
                                                        fontSize: 12,
                                                        color:
                                                            AppColors.textMuted,
                                                      ),
                                                    ),
                                                    if (meal
                                                        .extra
                                                        .isNotEmpty) ...[
                                                      const SizedBox(height: 4),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 8,
                                                              vertical: 3,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color: AppColors
                                                              .greenCard,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                6,
                                                              ),
                                                        ),
                                                        child: Text(
                                                          '+ ${meal.extra.replaceAll('\n', ', ')}',
                                                          style:
                                                              GoogleFonts.rubik(
                                                                fontSize: 10,
                                                                color: AppColors
                                                                    .greenMid,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                        ),
                                                      ),
                                                    ],
                                                  ],
                                                ),
                                              ),
                                              const Icon(
                                                Icons.chevron_right_rounded,
                                                color: AppColors.textMuted,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList();
                                }()),
                              ],
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
