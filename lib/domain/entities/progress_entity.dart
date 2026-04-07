class ProgressEntity {
  final DateTime date;
  final double weight;
  final double targetWeight;
  final double progress;
  final int meals;
  final int calories;
  final int calorieGoal;
  final Map<String, double>? measurements; // талия, бёдра, грудь, живот (опционально)

  const ProgressEntity({
    required this.date,
    required this.weight,
    required this.targetWeight,
    required this.progress,
    required this.meals,
    required this.calories,
    required this.calorieGoal,
    this.measurements,
  });

  ProgressEntity copyWith({
    DateTime? date,
    double? weight,
    double? targetWeight,
    double? progress,
    int? meals,
    int? calories,
    int? calorieGoal,
    Map<String, double>? measurements,
  }) {
    return ProgressEntity(
      date: date ?? this.date,
      weight: weight ?? this.weight,
      targetWeight: targetWeight ?? this.targetWeight,
      progress: progress ?? this.progress,
      meals: meals ?? this.meals,
      calories: calories ?? this.calories,
      calorieGoal: calorieGoal ?? this.calorieGoal,
      measurements: measurements ?? this.measurements,
    );
  }

  @override
  String toString() {
    return 'ProgressEntity(date: $date, weight: $weight, progress: $progress)';
  }
}
