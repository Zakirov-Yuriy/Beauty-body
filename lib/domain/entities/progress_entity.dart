class ProgressEntity {
  final String id;
  final String userId;
  final DateTime date;
  final double weight;
  final Map<String, double> measurements; // талия, бёдра, грудь, живот
  final int mealsCompleted;
  final double waterIntake; // литры
  final DateTime createdAt;

  const ProgressEntity({
    required this.id,
    required this.userId,
    required this.date,
    required this.weight,
    this.measurements = const {},
    this.mealsCompleted = 0,
    this.waterIntake = 0.0,
    required this.createdAt,
  });

  ProgressEntity copyWith({
    String? id,
    String? userId,
    DateTime? date,
    double? weight,
    Map<String, double>? measurements,
    int? mealsCompleted,
    double? waterIntake,
    DateTime? createdAt,
  }) {
    return ProgressEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      weight: weight ?? this.weight,
      measurements: measurements ?? this.measurements,
      mealsCompleted: mealsCompleted ?? this.mealsCompleted,
      waterIntake: waterIntake ?? this.waterIntake,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'ProgressEntity(id: $id, weight: $weight, date: $date)';
  }
}
