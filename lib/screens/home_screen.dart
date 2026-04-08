import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../models/data.dart';
import '../widgets/widgets.dart';
import '../presentation/providers/auth_provider.dart';
import '../presentation/providers/meal_provider.dart';
import '../presentation/providers/progress_provider.dart';
import '../presentation/providers/marathon_progress_provider.dart';
import '../presentation/providers/meal_plan_provider.dart';
import '../presentation/providers/storage_provider.dart';
import '../presentation/providers/repository_providers.dart';
import '../presentation/providers/eaten_meals_provider.dart';
import '../core/constants/sample_meals.dart';
import 'meal_plan_screen.dart';
import 'progress_screen.dart';
import 'profile_screen.dart';
import 'recipe_detail_screen.dart';

/// Провайдер для управления текущим индексом навигации
final navIndexProvider = StateProvider<int>((ref) => 0);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navIndex = ref.watch(navIndexProvider);

    final screens = const [
      _HomeTab(),
      MealPlanScreen(),
      ProgressScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: navIndex, children: screens),
      bottomNavigationBar: AppBottomNav(
        currentIndex: navIndex,
        onTap: (i) => ref.read(navIndexProvider.notifier).state = i,
      ),
    );
  }
}

class _HomeTab extends ConsumerWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final todayMealsAsync = ref.watch(todayMealsProvider);
    final watchProgressAsync = ref.watch(watchProgressProvider);
    final marathonProgressAsync = ref.watch(marathonProgressProvider);
    final todayMealPlanAsync = ref.watch(todayMealPlanProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Header with Marathon Progress
          marathonProgressAsync.when(
            data: (marathon) {
              final stageLabel = marathon?.stageLabel ?? 'Этап 1 · Неделя 1';
              final dayLabel = marathon != null 
                  ? 'День ${marathon.marathonDay}'
                  : 'День 1';
              final progressPercent = marathon?.overallProgress ?? 0;
              
              return Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.greenDark, AppColors.greenMid],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 52, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              authState.when(
                                data: (user) {
                                  final displayName = user?.displayName ?? 'пользователь';
                                  return Text(
                                    'Привет, $displayName! 👋',
                                    style: GoogleFonts.rubik(
                                      fontSize: 13,
                                      color: Colors.white70,
                                    ),
                                  );
                                },
                                loading: () => Text(
                                  'Привет! 👋',
                                  style: GoogleFonts.rubik(
                                    fontSize: 13,
                                    color: Colors.white70,
                                  ),
                                ),
                                error: (err, stack) => Text(
                                  'Привет, пользователь! 👋',
                                  style: GoogleFonts.rubik(
                                    fontSize: 13,
                                    color: Colors.white70,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                stageLabel,
                                style: GoogleFonts.rubik(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            dayLabel,
                            style: GoogleFonts.rubik(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Прогресс марафона',
                          style: GoogleFonts.rubik(fontSize: 12, color: Colors.white70),
                        ),
                        Text(
                          '${progressPercent.toStringAsFixed(1)}%',
                          style: GoogleFonts.rubik(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    AppProgressBar(value: (progressPercent / 100).clamp(0, 1)),
                  ],
                ),
              );
            },
            loading: () => Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.greenDark, AppColors.greenMid],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.fromLTRB(20, 52, 20, 20),
              child: const SizedBox(
                height: 100,
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
            error: (err, stack) => Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.greenDark, AppColors.greenMid],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.only(top: 52, bottom: 20),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: authState.when(
                      data: (user) {
                        final displayName = user?.displayName ?? 'пользователь';
                        return Text(
                          'Привет, $displayName! 👋',
                          style: GoogleFonts.rubik(
                            fontSize: 13,
                            color: Colors.white70,
                          ),
                        );
                      },
                      loading: () => Text(
                        'Привет! 👋',
                        style: GoogleFonts.rubik(
                          fontSize: 13,
                          color: Colors.white70,
                        ),
                      ),
                      error: (err, stack) => Text(
                        'Привет, пользователь! 👋',
                        style: GoogleFonts.rubik(
                          fontSize: 13,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Этап 1 · Неделя 1',
                      style: GoogleFonts.rubik(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Today card - dynamic meal count
                todayMealsAsync.when(
                  loading: () => Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.greenMid, AppColors.greenLight],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: const SizedBox(
                      height: 100,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                  error: (err, stack) {
                    return todayMealPlanAsync.when(
                      data: (todayData) {
                        final dayName = todayData.dayName;
                        final planMeals = todayData.meals;
                        final mealCount = planMeals.isNotEmpty ? planMeals.length : 4;
                        
                        return Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.greenMid, AppColors.greenLight],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text('🔥', style: TextStyle(fontSize: 18)),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Сегодня: $dayName',
                                    style: GoogleFonts.rubik(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '$mealCount приёма пищи запланировано',
                                style: GoogleFonts.rubik(fontSize: 13, color: Colors.white70),
                              ),
                            ],
                          ),
                        );
                      },
                      loading: () => Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.greenMid, AppColors.greenLight],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: const SizedBox(height: 60, child: CircularProgressIndicator(color: AppColors.white)),
                      ),
                      error: (_, __) => Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.greenMid, AppColors.greenLight],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text('🔥', style: TextStyle(fontSize: 18)),
                                const SizedBox(width: 8),
                                Text(
                                  'Сегодня: Понедельник',
                                  style: GoogleFonts.rubik(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '4 приёма пищи запланировано',
                              style: GoogleFonts.rubik(fontSize: 13, color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  data: (meals) {
                    return todayMealPlanAsync.when(
                      data: (todayData) {
                        final dayName = todayData.dayName;
                        final planMeals = todayData.meals;
                        final mealCount = planMeals.isNotEmpty ? planMeals.length : meals.length;
                        final completedCount = ref.watch(todayCompletedMealsCountProvider);
                        final progressValue = mealCount > 0 
                          ? (completedCount / mealCount).clamp(0.0, 1.0) 
                          : 0.0;
                        
                        return Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.greenMid, AppColors.greenLight],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text('🔥', style: TextStyle(fontSize: 18)),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Сегодня: $dayName',
                                    style: GoogleFonts.rubik(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '$mealCount приёмов пищи запланировано',
                                style: GoogleFonts.rubik(
                                  fontSize: 13,
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 10),
                              AppProgressBar(value: progressValue),
                              const SizedBox(height: 4),
                              Text(
                                '$completedCount из $mealCount выполнено',
                                style: GoogleFonts.rubik(
                                  fontSize: 11,
                                  color: Colors.white60,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      loading: () => Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.greenMid, AppColors.greenLight],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: const SizedBox(
                          height: 100,
                          child: Center(
                            child: CircularProgressIndicator(color: AppColors.white),
                          ),
                        ),
                      ),
                      error: (_, __) => Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.greenMid, AppColors.greenLight],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text('🔥', style: TextStyle(fontSize: 18)),
                                const SizedBox(width: 8),
                                Text(
                                  'Сегодня: Понедельник',
                                  style: GoogleFonts.rubik(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${meals.length} приёмов пищи запланировано',
                              style: GoogleFonts.rubik(
                                fontSize: 13,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),

                // Stats - from watchProgressProvider
                watchProgressAsync.when(
                  loading: () => Row(
                    children: [
                      StatBox(value: '--', label: 'Результат'),
                      const SizedBox(width: 8),
                      StatBox(value: '--', label: 'Дней'),
                      const SizedBox(width: 8),
                      StatBox(value: '--', label: 'Текущий вес'),
                    ],
                  ),
                  error: (err, stack) => Row(
                    children: [
                      StatBox(value: '-3.5 кг', label: 'Результат'),
                      const SizedBox(width: 8),
                      StatBox(value: '8/30', label: 'Дней'),
                      const SizedBox(width: 8),
                      StatBox(value: '68.5', label: 'Текущий вес'),
                    ],
                  ),
                  data: (progress) {
                    final weight = progress.weight;
                    return Row(
                      children: [
                        StatBox(value: '-3.5 кг', label: 'Результат'),
                        const SizedBox(width: 8),
                        StatBox(value: '8/30', label: 'Дней'),
                        const SizedBox(width: 8),
                        StatBox(value: '$weight', label: 'Текущий вес'),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20),

                // Meals today - from todayMealPlanProvider (правильный день)
                const SectionTitle('Питание сегодня'),
                const SizedBox(height: 10),
                todayMealPlanAsync.when(
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: CircularProgressIndicator(color: AppColors.greenMid),
                    ),
                  ),
                  error: (err, stack) => Column(
                    children: [
                      MealCard(
                        mealId: 'test_1',
                        emoji: '🥯',
                        type: 'Завтрак',
                        name: 'Творожный бейгл',
                        portion: '150 г',
                        emojiBackground: AppColors.breakfastBg,
                        isDone: true,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RecipeDetailScreen(meal: AppData.mondayMeals[0]),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      MealCard(
                        mealId: 'test_2',
                        emoji: '🍲',
                        type: 'Обед',
                        name: 'Плов из булгура',
                        portion: '180 г',
                        emojiBackground: AppColors.lunchBg,
                        timeLabel: '12:00',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RecipeDetailScreen(meal: AppData.mondayMeals[1]),
                          ),
                        ),
                      ),
                    ],
                  ),
                  data: (todayData) {
                    final meals = todayData.meals;
                    if (meals.isEmpty) {
                      return Center(
                        child: Text(
                          'Приёмы пищи на сегодня не добавлены',
                          style: GoogleFonts.rubik(color: AppColors.textMuted),
                        ),
                      );
                    }
                    return Column(
                      children: meals.asMap().entries.map((entry) {
                        final meal = entry.value;
                        final mealColors = [
                          AppColors.breakfastBg,
                          AppColors.lunchBg,
                          AppColors.snackBg,
                          AppColors.dinnerBg,
                        ];
                        return Padding(
                          padding: EdgeInsets.only(bottom: entry.key < meals.length - 1 ? 8 : 0),
                          child: MealCard(
                            mealId: meal.id,
                            emoji: meal.emoji,
                            type: meal.type,
                            name: meal.name,
                            portion: meal.portion,
                            emojiBackground: mealColors[entry.key % 4],
                            imageAssetPath: meal.imageAssetPath,
                            portionSizes: meal.portionSizes,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RecipeDetailScreen(meal: meal),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
                const SizedBox(height: 20),

                // Tip of the day
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.greenCard,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.greenBorder, width: 0.5),
                  ),
                  child: Row(
                    children: [
                      const Text('💡', style: TextStyle(fontSize: 24)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Совет дня',
                              style: GoogleFonts.rubik(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.greenDark,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Пей воду за 20 минут до еды — это снижает аппетит на 15–20%',
                              style: GoogleFonts.rubik(
                                fontSize: 12,
                                color: AppColors.greenAccent,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 🧪 TEST BUTTON - Добавить тестовое блюдо
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber[50],
                    border: Border.all(color: Colors.amber[300]!, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.bug_report, color: Colors.amber, size: 16),
                          SizedBox(width: 8),
                          Text(
                            'Режим тестирования',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.amber,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Перед использованием проверьте правила Firestore в docs/firebase/FIRESTORE_RULES.md',
                        style: GoogleFonts.rubik(
                          fontSize: 11,
                          color: Colors.orange[700],
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            // Одна кнопка для инициализации всех блюд с картинками
                            try {
                              print('🚀 Инициализирую основное меню...');
                              
                              // Добавляем meal_1 (завтрак)
                              await ref.read(addMealProvider(SampleMeals.cottageCheeseMeal).future);
                              print('✅ meal_1 добавлена');
                              
                              // Обновляем meal_1 с картинкой
                              await ref.read(mealRepositoryProvider).updateMealStoragePath(
                                mealId: 'meal_1',
                                storagePath: 'assets/meals/stage_1/week_1/day_1/breakfast_1.png',
                              );
                              print('✅ meal_1 с картинкой активирована');
                              
                              // Добавляем meal_7 (завтрак - Shakshuka для вторника)
                              await ref.read(addMealProvider(SampleMeals.shakshukaMeal).future);
                              print('✅ meal_7 добавлена');
                              
                              // Обновляем meal_7 с картинкой
                              await ref.read(mealRepositoryProvider).updateMealStoragePath(
                                mealId: 'meal_7',
                                storagePath: 'assets/meals/stage_1/week_1/day_2/breakfast_1.png',
                              );
                              print('✅ meal_7 с картинкой активирована');
                              
                              // Добавляем meal_2 (обед - паста)
                              await ref.read(addMealProvider(SampleMeals.pastaBologneseMeal).future);
                              print('✅ meal_2 добавлена');
                              
                              // Обновляем meal_2 с картинкой
                              await ref.read(mealRepositoryProvider).updateMealStoragePath(
                                mealId: 'meal_2',
                                storagePath: 'assets/meals/stage_1/week_1/day_1/lunch_1.png',
                              );
                              print('✅ meal_2 с картинкой активирована');
                              
                              // Добавляем meal_3 (летний салат)
                              await ref.read(addMealProvider(SampleMeals.summerSaladMeal).future);
                              print('✅ meal_3 добавлена');
                              
                              // Обновляем meal_3 с картинкой
                              await ref.read(mealRepositoryProvider).updateMealStoragePath(
                                mealId: 'meal_3',
                                storagePath: 'assets/meals/stage_1/week_1/day_1/lunch_2.png',
                              );
                              print('✅ meal_3 с картинкой активирована');
                              
                              // Добавляем meal_4 (фруктовый салат - перекус)
                              await ref.read(addMealProvider(SampleMeals.fruitSaladMeal).future);
                              print('✅ meal_4 добавлена');
                              
                              // Обновляем meal_4 с картинкой
                              await ref.read(mealRepositoryProvider).updateMealStoragePath(
                                mealId: 'meal_4',
                                storagePath: 'assets/meals/stage_1/week_1/day_1/snack_1.png',
                              );
                              print('✅ meal_4 с картинкой активирована');
                              
                              // Добавляем meal_5 (тефтели - ужин)
                              await ref.read(addMealProvider(SampleMeals.meatballsDinnerMeal).future);
                              print('✅ meal_5 добавлена');
                              
                              // Обновляем meal_5 с картинкой
                              await ref.read(mealRepositoryProvider).updateMealStoragePath(
                                mealId: 'meal_5',
                                storagePath: 'assets/meals/stage_1/week_1/day_1/dinner_1.png',
                              );
                              print('✅ meal_5 с картинкой активирована');
                              
                              // Добавляем meal_6 (зелёный салат - ужин)
                              await ref.read(addMealProvider(SampleMeals.greenSaladDinnerMeal).future);
                              print('✅ meal_6 добавлена');
                              
                              // Обновляем meal_6 с картинкой
                              await ref.read(mealRepositoryProvider).updateMealStoragePath(
                                mealId: 'meal_6',
                                storagePath: 'assets/meals/stage_1/week_1/day_1/dinner_2.png',
                              );
                              print('✅ meal_6 с картинкой активирована');
                              
                              // Добавляем meal_8 (слоёный десерт - перекус для вторника)
                              await ref.read(addMealProvider(SampleMeals.layeredDessertMeal).future);
                              print('✅ meal_8 добавлена');
                              
                              // Обновляем meal_8 с картинкой
                              await ref.read(mealRepositoryProvider).updateMealStoragePath(
                                mealId: 'meal_8',
                                storagePath: 'assets/meals/stage_1/week_1/day_2/snack_1.png',
                              );
                              print('✅ meal_8 с картинкой активирована');
                              
                              // Добавляем meal_9 (фаршированные кабачки - второй ужин для вторника)
                              await ref.read(addMealProvider(SampleMeals.stuffedZucchiniMeal).future);
                              print('✅ meal_9 добавлена');
                              
                              // Обновляем meal_9 с картинкой
                              await ref.read(mealRepositoryProvider).updateMealStoragePath(
                                mealId: 'meal_9',
                                storagePath: 'assets/meals/stage_1/week_1/day_2/dinner_2.png',
                              );
                              print('✅ meal_9 с картинкой активирована');
                              
                              // ========== ДЕНЬ 3 (СРЕДА) ==========
                              
                              // Добавляем meal_10 (чипсы из лаваша - перекус)
                              await ref.read(addMealProvider(SampleMeals.lavashChipsMeal).future);
                              print('✅ meal_10 добавлена');
                              
                              // Обновляем meal_10 с картинкой
                              await ref.read(mealRepositoryProvider).updateMealStoragePath(
                                mealId: 'meal_10',
                                storagePath: 'assets/meals/stage_1/week_1/day_3/snack_1.png',
                              );
                              print('✅ meal_10 с картинкой активирована');
                              
                              // Добавляем meal_11 (ПП аджика)
                              await ref.read(addMealProvider(SampleMeals.adjikaMeal).future);
                              print('✅ meal_11 добавлена');
                              
                              // Обновляем meal_11 с картинкой
                              await ref.read(mealRepositoryProvider).updateMealStoragePath(
                                mealId: 'meal_11',
                                storagePath: 'assets/meals/stage_1/week_1/day_3/snack_2.png',
                              );
                              print('✅ meal_11 с картинкой активирована');
                              
                              // Добавляем meal_12 (ПП вареная сгущенка)
                              await ref.read(addMealProvider(SampleMeals.condensedMilkMeal).future);
                              print('✅ meal_12 добавлена');
                              
                              // Обновляем meal_12 с картинкой
                              await ref.read(mealRepositoryProvider).updateMealStoragePath(
                                mealId: 'meal_12',
                                storagePath: 'assets/meals/stage_1/week_1/day_3/snack_3.png',
                              );
                              print('✅ meal_12 с картинкой активирована');
                              
                              // Добавляем meal_13 (ПП конфитюр)
                              await ref.read(addMealProvider(SampleMeals.confitureMeal).future);
                              print('✅ meal_13 добавлена');
                              
                              // Обновляем meal_13 с картинкой
                              await ref.read(mealRepositoryProvider).updateMealStoragePath(
                                mealId: 'meal_13',
                                storagePath: 'assets/meals/stage_1/week_1/day_3/snack_4.png',
                              );
                              print('✅ meal_13 с картинкой активирована');
                              
                              // Добавляем meal_14 (ПП рулетики - завтрак)
                              await ref.read(addMealProvider(SampleMeals.ppRollsMeal).future);
                              print('✅ meal_14 добавлена');
                              
                              // Обновляем meal_14 с картинкой
                              await ref.read(mealRepositoryProvider).updateMealStoragePath(
                                mealId: 'meal_14',
                                storagePath: 'assets/meals/stage_1/week_1/day_3/breakfast_1.png',
                              );
                              print('✅ meal_14 с картинкой активирована');
                              
                              // Добавляем meal_15 (куриная грудка - ужин)
                              await ref.read(addMealProvider(SampleMeals.chickenBreastMeal).future);
                              print('✅ meal_15 добавлена');
                              
                              // Обновляем meal_15 с картинкой
                              await ref.read(mealRepositoryProvider).updateMealStoragePath(
                                mealId: 'meal_15',
                                storagePath: 'assets/meals/stage_1/week_1/day_3/dinner_1.png',
                              );
                              print('✅ meal_15 с картинкой активирована');
                              
                              // Добавляем meal_16 (запечённые овощи - ужин)
                              await ref.read(addMealProvider(SampleMeals.bakedVeggiesMeal).future);
                              print('✅ meal_16 добавлена');
                              
                              // Обновляем meal_16 с картинкой
                              await ref.read(mealRepositoryProvider).updateMealStoragePath(
                                mealId: 'meal_16',
                                storagePath: 'assets/meals/stage_1/week_1/day_3/dinner_2.png',
                              );
                              print('✅ meal_16 с картинкой активирована');
                              
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('✅ Меню День 1, 2 и 3 инициализировано! 🎉'),
                                    backgroundColor: Colors.green,
                                    duration: Duration(seconds: 5),
                                  ),
                                );
                              }
                            } catch (e) {
                              print('❌ Ошибка инициализации: $e');
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('❌ Ошибка: $e'),
                                    backgroundColor: Colors.red,
                                    duration: const Duration(seconds: 5),
                                  ),
                                );
                              }
                            }
                          },
                          icon: const Icon(Icons.fastfood),
                          label: const Text('Инициализировать меню 🎯'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[700],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
