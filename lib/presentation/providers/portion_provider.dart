import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Провайдер для отслеживания выбранного индекса размера порции для конкретного блюда
/// Ключ: meal_id
final selectedPortionIndexProvider = StateProvider.family<int, String>((ref, mealId) {
  return 0; // По умолчанию маленькая порция (индекс 0)
});
