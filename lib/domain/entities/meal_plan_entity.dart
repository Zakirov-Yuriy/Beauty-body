import 'meal_entity.dart';

class MealPlanEntity {
  final String id;
  final String userId;
  final int weekNumber;
  final int stageNumber;
  final Map<int, List<MealEntity>> dailyMeals; // день недели -> список блюд
  final Map<String, dynamic> dailyGoals; // калории, белки, углеводы, жиры
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;

  const MealPlanEntity({
    required this.id,
    required this.userId,
    required this.weekNumber,
    required this.stageNumber,
    required this.dailyMeals,
    required this.dailyGoals,
    required this.startDate,
    required this.endDate,
    this.isActive = true,
  });

  MealPlanEntity copyWith({
    String? id,
    String? userId,
    int? weekNumber,
    int? stageNumber,
    Map<int, List<MealEntity>>? dailyMeals,
    Map<String, dynamic>? dailyGoals,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
  }) {
    return MealPlanEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      weekNumber: weekNumber ?? this.weekNumber,
      stageNumber: stageNumber ?? this.stageNumber,
      dailyMeals: dailyMeals ?? this.dailyMeals,
      dailyGoals: dailyGoals ?? this.dailyGoals,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  String toString() {
    return 'MealPlanEntity(id: $id, weekNumber: $weekNumber, stageNumber: $stageNumber)';
  }
}
