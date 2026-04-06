import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../models/data.dart';
import '../widgets/widgets.dart';
import 'recipe_detail_screen.dart';

class MealPlanScreen extends StatefulWidget {
  const MealPlanScreen({super.key});

  @override
  State<MealPlanScreen> createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen> {
  int _selectedWeek = 1; // 0-indexed
  int _selectedDay = 2;  // 0=Пн, 2=Ср (today)

  final List<String> _weekdays = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
  final List<String> _weekdaysFull = [
    'Понедельник', 'Вторник', 'Среда', 'Четверг', 'Пятница', 'Суббота', 'Воскресенье'
  ];

  final List<Color> _mealColors = [
    AppColors.breakfastBg,
    AppColors.lunchBg,
    AppColors.snackBg,
    AppColors.dinnerBg,
  ];
  final List<String> _mealEmojis = ['🥯', '🍲', '🍓', '🥗'];

  @override
  Widget build(BuildContext context) {
    final meals = AppData.weekPlan[_selectedDay];

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
                Text('Этап 1 · Неделя ${_selectedWeek + 1}',
                    style: GoogleFonts.rubik(fontSize: 13, color: Colors.white70)),
                const SizedBox(height: 14),

                // Week tabs
                Row(
                  children: List.generate(3, (i) {
                    final isActive = i == _selectedWeek;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedWeek = i),
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
                final isSelected = i == _selectedDay;
                return GestureDetector(
                  onTap: () => setState(() => _selectedDay = i),
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
                            _weekdays[i],
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

          // Meals list
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  '${_weekdaysFull[_selectedDay]} · 5 апреля',
                  style: GoogleFonts.rubik(
                      fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.greenDark),
                ),
                const SizedBox(height: 12),
                ...meals.asMap().entries.map((entry) {
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
                          border: Border.all(color: AppColors.greenBorder, width: 0.5),
                        ),
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: _mealColors[entry.key % 4],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                  child: Text(meal.emoji,
                                      style: const TextStyle(fontSize: 26))),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                          fontSize: 12, color: AppColors.textMuted)),
                                  if (meal.extra.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: AppColors.greenCard,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text('+ ${meal.extra.replaceAll('\n', ', ')}',
                                          style: GoogleFonts.rubik(
                                              fontSize: 10,
                                              color: AppColors.greenMid,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
