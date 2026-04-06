import 'package:beauty_body/domain/entities/meal_entity.dart';
import 'meal_data_source.dart';

class MockMealDataSource implements MealDataSource {
  // Mock данные для демонстрации
  final List<MealEntity> mockMeals = [
    MealEntity(
      id: '1',
      name: 'Омлет с овощами',
      type: 'breakfast',
      portion: '180g',
      emoji: '🥚',
      calories: 250,
      protein: 15,
      carbs: 10,
      fat: 18,
      ingredients: ['Яйца (2 шт)', 'Помидор', 'Перец болгарский', 'Масло оливковое'],
      steps: ['Взбить яйца', 'Нарезать овощи', 'Жарить на сковороде 5-7 минут'],
      createdAt: DateTime.now(),
    ),
    MealEntity(
      id: '2',
      name: 'Куриный салат',
      type: 'lunch',
      portion: '200g',
      emoji: '🥗',
      calories: 320,
      protein: 28,
      carbs: 12,
      fat: 16,
      ingredients: ['Грудка курицы', 'Листья салата', 'Помидор', 'Огурец'],
      steps: ['Отварить курицу', 'Нарезать овощи', 'Смешать с дрессингом'],
      createdAt: DateTime.now(),
    ),
    MealEntity(
      id: '3',
      name: 'Творог с ягодами',
      type: 'snack',
      portion: '150g',
      emoji: '🫐',
      calories: 180,
      protein: 20,
      carbs: 15,
      fat: 5,
      ingredients: ['Творог', 'Черника', 'Малина', 'Мёд'],
      steps: ['Положить творог в чашку', 'Добавить ягоды', 'Полить мёдом'],
      createdAt: DateTime.now(),
    ),
    MealEntity(
      id: '4',
      name: 'Рыба с овощами',
      type: 'dinner',
      portion: '250g',
      emoji: '🐟',
      calories: 380,
      protein: 35,
      carbs: 18,
      fat: 15,
      ingredients: ['Филе окуня', 'Брокколи', 'Морковь', 'Лимон'],
      steps: ['Запечь рыбу в духовке', 'Отварить овощи', 'Сбрызнуть лимоном'],
      createdAt: DateTime.now(),
    ),
  ];

  @override
  Future<List<MealEntity>> getAllMeals() async {
    // Имитируем задержку сети
    await Future.delayed(const Duration(milliseconds: 500));
    return mockMeals;
  }

  @override
  Future<MealEntity?> getMealById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return mockMeals.firstWhere((meal) => meal.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<MealEntity>> getMealsByType(String type) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return mockMeals.where((meal) => meal.type == type).toList();
  }

  @override
  Stream<List<MealEntity>> getTodayMeals() async* {
    // Эмулируем поток данных с Firestore
    yield mockMeals;
    await Future.delayed(const Duration(seconds: 5));
    // Можно добавить обновления в реальном приложении
  }

  @override
  Future<List<MealEntity>> getMealsByDate(DateTime date) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // В реальном приложении запросим из Firestore по дате
    return mockMeals;
  }
}
