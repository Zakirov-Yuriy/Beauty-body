class MealEntity {
  final String id;
  final String name;
  final String type; // breakfast, lunch, snack, dinner
  final String portion;
  final String emoji;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final String extra;
  final List<String> ingredients;
  final List<String> steps;
  final String description;
  final DateTime createdAt;

  const MealEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.portion,
    required this.emoji,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.extra = '',
    this.ingredients = const [],
    this.steps = const [],
    this.description = '',
    required this.createdAt,
  });

  MealEntity copyWith({
    String? id,
    String? name,
    String? type,
    String? portion,
    String? emoji,
    int? calories,
    int? protein,
    int? carbs,
    int? fat,
    String? extra,
    List<String>? ingredients,
    List<String>? steps,
    String? description,
    DateTime? createdAt,
  }) {
    return MealEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      portion: portion ?? this.portion,
      emoji: emoji ?? this.emoji,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      extra: extra ?? this.extra,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'MealEntity(id: $id, name: $name, type: $type, calories: $calories)';
  }
}

