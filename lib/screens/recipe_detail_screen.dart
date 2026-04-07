import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../theme.dart';
import '../presentation/providers/portion_provider.dart';
import '../presentation/providers/eaten_meals_provider.dart';
import '../presentation/providers/auth_provider.dart';
import '../core/utils/meal_translations.dart';

class RecipeDetailScreen extends ConsumerWidget {
  final dynamic meal; // Can be MealItem or MealEntity
  const RecipeDetailScreen({super.key, required this.meal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get common properties whether it's MealItem or MealEntity
    final mealId = (meal.id as String?) ?? 'unknown';
    final mealName = meal.name as String;
    final mealType = meal.type as String;
    final emoji = meal.emoji as String;
    final portion = meal.portion as String;
    final extra = meal.extra as String? ?? '';
    final imageAssetPath = (meal.imageAssetPath as String?) ?? '';
    final portionSizes = (meal.portionSizes as List?) ?? [];
    final ingredients = (meal.ingredients as List?) ?? [];
    final steps = (meal.steps as List?) ?? [];

    // Логируем данные для дебага
    print('🔍 RecipeDetailScreen - meal_1 debug:');
    print('   ID: $mealId');
    print('   Name: $mealName');
    print('   PortionSizes length: ${portionSizes.length}');
    print('   PortionSizes: $portionSizes');

    // Получить выбранный индекс размера порции
    final selectedPortionIndex = ref.watch(
      selectedPortionIndexProvider(mealId),
    );

    // Получить данные выбранного размера
    late int calories;
    late int protein;
    late int carbs;
    late int fat;
    late String displayPortion;

    if (portionSizes.isNotEmpty && selectedPortionIndex < portionSizes.length) {
      final selectedPortion =
          portionSizes[selectedPortionIndex] as Map<String, dynamic>;
      calories = selectedPortion['calories'] as int? ?? 0;
      protein = selectedPortion['protein'] as int? ?? 0;
      carbs = selectedPortion['carbs'] as int? ?? 0;
      fat = selectedPortion['fat'] as int? ?? 0;
      displayPortion = selectedPortion['grams'] as String? ?? portion;
    } else {
      calories = (meal.calories as int?) ?? 0;
      protein = (meal.protein as int?) ?? 0;
      carbs = (meal.carbs as int?) ?? 0;
      fat = (meal.fat as int?) ?? 0;
      displayPortion = portion;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Hero header
          SliverAppBar(
            expandedHeight: 210,
            pinned: true,
            backgroundColor: AppColors.greenMid,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  color: AppColors.white,
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.greenDark, AppColors.greenAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // const SizedBox(height: 5),
                    if (imageAssetPath.isNotEmpty)
                      Image.asset(
                        imageAssetPath,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Text(emoji, style: const TextStyle(fontSize: 72));
                        },
                      )
                    else
                      Text(emoji, style: const TextStyle(fontSize: 72)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        translateMealType(mealType),
                        style: GoogleFonts.rubik(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              title: Text(
                mealName,
                style: GoogleFonts.rubik(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
            ),
            
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Portion
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.greenSurface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.scale_rounded,
                          color: AppColors.greenAccent,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Порция: $displayPortion',
                                style: GoogleFonts.rubik(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.greenDark,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (extra.isNotEmpty) ...[
                                const SizedBox(height: 6),
                                Text(
                                  '+ $extra',
                                  style: GoogleFonts.rubik(
                                    fontSize: 12,
                                    color: AppColors.textMuted,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Portion size selector - если есть варианты
                  if (portionSizes.isNotEmpty) ...[
                    Text(
                      'Выберите размер порции:',
                      style: GoogleFonts.rubik(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: List.generate(portionSizes.length, (index) {
                        final portionData =
                            portionSizes[index] as Map<String, dynamic>;
                        final label = portionData['label'] as String? ?? '';
                        final grams = portionData['grams'] as String? ?? '';
                        final isSelected = selectedPortionIndex == index;

                        return Flexible(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: index < portionSizes.length - 1 ? 8 : 0,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                ref
                                        .read(
                                          selectedPortionIndexProvider(
                                            mealId,
                                          ).notifier,
                                        )
                                        .state =
                                    index;
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.greenMid
                                      : AppColors.greenSurface,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.greenDark
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      label,
                                      style: GoogleFonts.rubik(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: isSelected
                                            ? AppColors.white
                                            : AppColors.textDark,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      grams,
                                      style: GoogleFonts.rubik(
                                        fontSize: 11,
                                        color: isSelected
                                            ? AppColors.white
                                            : AppColors.textMuted,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // КБЖУ
                  if (calories > 0) ...[
                    _SectionHeader('Пищевая ценность'),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _NutrientBox(
                          '$calories',
                          'ккал',
                          AppColors.orangeLight,
                          AppColors.orange,
                        ),
                        const SizedBox(width: 8),
                        _NutrientBox(
                          '${protein}г',
                          'белки',
                          const Color(0xFFE8F0FF),
                          const Color(0xFF185FA5),
                        ),
                        const SizedBox(width: 8),
                        _NutrientBox(
                          '${carbs}г',
                          'углев.',
                          AppColors.breakfastBg,
                          const Color(0xFFB25000),
                        ),
                        const SizedBox(width: 8),
                        _NutrientBox(
                          '${fat}г',
                          'жиры',
                          const Color(0xFFE8F5D0),
                          AppColors.greenMid,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Ingredients
                  if (ingredients.isNotEmpty) ...[
                    _SectionHeader('Ингредиенты'),
                    const SizedBox(height: 10),
                    ...ingredients.asMap().entries.map((entry) {
                      final ing = entry.value;
                      final name = ing is String
                          ? ing
                          : (ing as dynamic).name ?? '';
                      final amount = ing is String
                          ? ''
                          : ((ing as dynamic).amount ?? '');
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: AppColors.greenSurface,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: AppColors.greenLight,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                name,
                                style: GoogleFonts.rubik(
                                  fontSize: 14,
                                  color: AppColors.textDark,
                                ),
                              ),
                            ),
                            if (amount.isNotEmpty)
                              Text(
                                amount,
                                style: GoogleFonts.rubik(
                                  fontSize: 13,
                                  color: AppColors.greenAccent,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 20),
                  ],

                  // Steps
                  if (steps.isNotEmpty) ...[
                    _SectionHeader('Приготовление'),
                    const SizedBox(height: 12),
                    ...steps.asMap().entries.map(
                      (entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: const BoxDecoration(
                                color: AppColors.greenMid,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${entry.key + 1}',
                                  style: GoogleFonts.rubik(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                entry.value as String,
                                style: GoogleFonts.rubik(
                                  fontSize: 14,
                                  color: AppColors.textDark,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        try {
                          // Добавляем блюдо в съеденные локально
                          final currentMeals = ref.read(eatenMealsProvider);
                          ref.read(eatenMealsProvider.notifier).state = {
                            ...currentMeals,
                            mealId: DateTime.now(),
                          };
                          
                          // Сохраняем в Firebase
                          final user = ref.read(authStateProvider).valueOrNull;
                          if (user != null) {
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(user.uid)
                                .collection('eatenMeals')
                                .doc(mealId)
                                .set({
                                  'mealId': mealId,
                                  'mealName': mealName,
                                  'completedAt': DateTime.now().toIso8601String(),
                                });
                            print('✅ Блюдо "$mealName" отмечено и сохранено в БД');
                          } else {
                            print('⚠️ User not authenticated');
                          }
                        } catch (e) {
                          print('❌ Ошибка при сохранении: $e');
                        }
                        
                        // Закрываем экран
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.check_rounded),
                      label: const Text('Отметить как выполнено'),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.rubik(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.greenDark,
      ),
    );
  }
}

class _NutrientBox extends StatelessWidget {
  final String value;
  final String label;
  final Color bg;
  final Color textColor;

  const _NutrientBox(this.value, this.label, this.bg, this.textColor);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.rubik(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.rubik(
                fontSize: 11,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
