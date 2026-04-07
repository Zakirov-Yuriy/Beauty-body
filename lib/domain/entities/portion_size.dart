// Размеры порций с калориями и макронутриентами
class PortionSize {
  final String label; // "Маленькая", "Средняя", "Большая"
  final String grams; // "130g", "200g", "280g"
  final int calories;
  final int protein;
  final int carbs;
  final int fat;

  const PortionSize({
    required this.label,
    required this.grams,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  @override
  String toString() => '$label ($grams)';
}
