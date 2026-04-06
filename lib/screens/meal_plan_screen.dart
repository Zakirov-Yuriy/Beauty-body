import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../presentation/providers/meal_plan_provider.dart';
import 'recipe_detail_screen.dart';

class MealPlanScreen extends ConsumerWidget {
  const MealPlanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the meal plan state for week/day selection
    final planState = ref.watch(mealPlanNotifierProvider);
    
    // Watch the selected meal plan with actual meals
    final selectedPlanAsync = ref.watch(selectedMealPlanProvider);

    const List<String> weekdays = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
    const List<String> weekdaysFull = [
      'Понедельник', 'Вторник', 'Среда', 'Четверг', 'Пятница', 'Суббота', 'Воскресенье'
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
                Text('📅  План питания',
                    style: GoogleFonts.rubik(
                        fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.white)),
                const SizedBox(height: 4),
                Text('Этап 1 · Неделя ${planState.selectedWeek + 1}',
                    style: GoogleFonts.rubik(fontSize: 13, color: Colors.white70)),
                const SizedBox(height: 14),

                // Week tabs
                Row(
                  children: List.generate(3, (i) {
                    final isActive = i == planState.selectedWeek;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          ref.read(mealPlanNotifierProvider.notifier).selectWeek(i);
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
                              color: isActive ? AppColors.greenMid : Colors.white70,
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

          // Days row
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (i) {
                final isDone = i < 2;
                final isToday = i == 2;
                final isSelected = i == planState.selectedDay;
                return GestureDetector(
                  onTap: () {
                    ref.read(mealPlanNotifierProvider.notifier).selectDay(i);
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
                              ? Border.all(color: AppColors.greenMid, width: 2)
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            weekdays[i],
                            style: GoogleFonts.rubik(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: isSelected || (isToday && !isSelected)
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
                        const Icon(Icons.check_rounded, size: 10, color: AppColors.greenLight),
                      ]
                    ],
                  ),
                );
              }),
            ),
          ),

          // Meals list - use .when() pattern for AsyncValue
          Expanded(
            child: selectedPlanAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.greenMid),
              ),
              error: (err, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline_rounded, color: AppColors.textMuted, size: 48),
                    const SizedBox(height: 16),
                    Text('Ошибка загрузки',
                        style: GoogleFonts.rubik(
                            fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                    const SizedBox(height: 8),
                    Text(err.toString(),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.rubik(fontSize: 12, color: AppColors.textMuted)),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        ref.invalidate(selectedMealPlanProvider);
                      },
                      child: const Text('Повторить'),
                    ),
                  ],
                ),
              ),
              data: (plan) {
                if (plan == null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.calendar_today_rounded,
                            color: AppColors.textMuted, size: 48),
                        const SizedBox(height: 16),
                        Text('План не найден',
                            style: GoogleFonts.rubik(
                                fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                      ],
                    ),
                  );
                }

                // Daily meals for the selected day
                final dailyMeals = plan.dailyMeals[planState.selectedDay] ?? [];

                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text(
                      '${weekdaysFull[planState.selectedDay]} · 5 апреля',
                      style: GoogleFonts.rubik(
                          fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.greenDark),
                    ),
                    const SizedBox(height: 12),
                    if (dailyMeals.isEmpty)
                      Center(
                        child: Text('Приемы пищи не добавлены',
                            style: GoogleFonts.rubik(
                                fontSize: 13, color: AppColors.textMuted)),
                      )
                    else
                      ...dailyMeals.asMap().entries.map((entry) {
                        final meal = entry.value;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => RecipeDetailScreen(meal: meal))),
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                    color: AppColors.greenBorder, width: 0.5),
                              ),
                              padding: const EdgeInsets.all(14),
                              child: Row(
                                children: [
                                  Container(
                                    width: 52,
                                    height: 52,
                                    decoration: BoxDecoration(
                                      color: mealColors[entry.key % 4],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                        child: Text(meal.emoji,
                                            style: const TextStyle(fontSize: 26))),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(meal.type,
                                            style: GoogleFonts.rubik(
                                                fontSize: 11,
                                                color: AppColors.textMuted,
                                                fontWeight: FontWeight.w500)),
                                        const SizedBox(height: 2),
                                        Text(meal.name,
                                            style: GoogleFonts.rubik(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.textDark)),
                                        const SizedBox(height: 3),
                                        Text('Порция: ${meal.portion}',
                                            style: GoogleFonts.rubik(
                                                fontSize: 12,
                                                color: AppColors.textMuted)),
                                        if (meal.extra.isNotEmpty) ...[
                                          const SizedBox(height: 4),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: AppColors.greenCard,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                                '+ ${meal.extra.replaceAll('\n', ', ')}',
                                                style: GoogleFonts.rubik(
                                                    fontSize: 10,
                                                    color: AppColors.greenMid,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.chevron_right_rounded,
                                      color: AppColors.textMuted),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
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
