import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../models/data.dart';
import '../widgets/widgets.dart';
import '../presentation/providers/auth_provider.dart';
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

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Header
          Container(
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
                            'Этап 1 · Неделя 2',
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
                        'День 8',
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
                      '65%',
                      style: GoogleFonts.rubik(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const AppProgressBar(value: 0.65),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Today card
                Container(
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
                          const Text(
                            '🔥',
                            style: TextStyle(fontSize: 18),
                          ),
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
                      const SizedBox(height: 10),
                      const AppProgressBar(value: 0.25),
                      const SizedBox(height: 4),
                      Text(
                        '1 из 4 выполнено',
                        style: GoogleFonts.rubik(fontSize: 11, color: Colors.white60),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Stats
                Row(
                  children: [
                    StatBox(value: '-3.5 кг', label: 'Результат'),
                    const SizedBox(width: 8),
                    StatBox(value: '8/30', label: 'Дней'),
                    const SizedBox(width: 8),
                    StatBox(value: '68.5', label: 'Текущий вес'),
                  ],
                ),
                const SizedBox(height: 20),

                // Meals today
                const SectionTitle('Питание сегодня'),
                const SizedBox(height: 10),
                MealCard(
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
                const SizedBox(height: 8),
                MealCard(
                  emoji: '🍓',
                  type: 'Перекус',
                  name: 'Творожный мусс',
                  portion: '150 г',
                  emojiBackground: AppColors.snackBg,
                  timeLabel: '15:30',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RecipeDetailScreen(meal: AppData.mondayMeals[2]),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                MealCard(
                  emoji: '🥗',
                  type: 'Ужин',
                  name: 'Нутовый салат',
                  portion: '160 г',
                  emojiBackground: AppColors.dinnerBg,
                  timeLabel: '18:30',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RecipeDetailScreen(meal: AppData.mondayMeals[3]),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Tip of the day
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.greenCard,
                    borderRadius: BorderRadius.circular(14),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
