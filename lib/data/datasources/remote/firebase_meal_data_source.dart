import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:beauty_body/domain/entities/meal_entity.dart';
import '../../models/meal_model.dart';
import 'meal_data_source.dart';

class FirebaseMealDataSource implements MealDataSource {
  final FirebaseFirestore _firestore;

  FirebaseMealDataSource(this._firestore);

  @override
  Future<List<MealEntity>> getAllMeals() async {
    try {
      final snapshot = await _firestore.collection('meals').get();
      return snapshot.docs
          .map((doc) => MealModel.fromJson(doc.data()).toEntity())
          .toList();
    } catch (e) {
      print('❌ Ошибка getAllMeals: $e');
      return [];
    }
  }

  @override
  Future<MealEntity?> getMealById(String id) async {
    try {
      final doc = await _firestore.collection('meals').doc(id).get();
      if (doc.exists) {
        return MealModel.fromJson(doc.data() as Map<String, dynamic>).toEntity();
      }
      return null;
    } catch (e) {
      print('❌ Ошибка getMealById: $e');
      return null;
    }
  }

  @override
  Future<List<MealEntity>> getMealsByType(String type) async {
    try {
      final snapshot = await _firestore
          .collection('meals')
          .where('type', isEqualTo: type)
          .get();
      return snapshot.docs
          .map((doc) => MealModel.fromJson(doc.data()).toEntity())
          .toList();
    } catch (e) {
      print('❌ Ошибка getMealsByType: $e');
      return [];
    }
  }

  @override
  Stream<List<MealEntity>> getTodayMeals() {
    try {
      return _firestore.collection('meals').snapshots().map(
            (snapshot) {
              print('📥 Получено ${snapshot.docs.length} документов из Firestore');
              final meals = snapshot.docs
                  .map((doc) {
                    print('   📄 Doc ID: ${doc.id}');
                    try {
                      final entity = MealModel.fromJson(doc.data()).toEntity();
                      print('   ✅ Преобразовано: ${entity.name} (${entity.type})');
                      return entity;
                    } catch (e) {
                      print('   ❌ Ошибка парсинга: $e');
                      rethrow;
                    }
                  })
                  .toList();
              print('✅ Всего преобразовано ${meals.length} MealEntity');
              return meals;
            },
          );
    } catch (e) {
      print('❌ Ошибка getTodayMeals: $e');
      rethrow;
    }
  }

  @override
  Future<List<MealEntity>> getMealsByDate(DateTime date) async {
    try {
      final snapshot = await _firestore
          .collection('meals')
          .where('createdAt',
              isGreaterThanOrEqualTo: Timestamp.fromDate(
                DateTime(date.year, date.month, date.day),
              ))
          .where('createdAt',
              isLessThan: Timestamp.fromDate(
                DateTime(date.year, date.month, date.day + 1),
              ))
          .get();
      return snapshot.docs
          .map((doc) => MealModel.fromJson(doc.data()).toEntity())
          .toList();
    } catch (e) {
      print('❌ Ошибка getMealsByDate: $e');
      return [];
    }
  }

  @override
  Future<void> addMeal(MealEntity meal) async {
    try {
      final mealModel = MealModel.fromEntity(meal);
      final data = mealModel.toJson();
      
      print('🔍 Отправляю данные в Firestore:');
      print('   ID: ${meal.id}');
      print('   Название: ${meal.name}');
      print('   Тип: ${meal.type}');
      print('   PortionSizes: ${meal.portionSizes}');
      print('   PortionSizes length: ${meal.portionSizes.length}');
      print('   Data to save: $data');
      print('   Путь: meals/${meal.id}');
      
      await _firestore.collection('meals').doc(meal.id).set(data);
      
      print('✅ Успешно! Блюдо "${meal.name}" добавлено в Firebase');
    } catch (e) {
      print('❌ ОШИБКА addMeal: $e');
      print('   Stack: ${e.toString()}');
      rethrow; // Пробросим ошибку дальше для обработки в UI
    }
  }

  @override
  Future<void> updateMealStoragePath({
    required String mealId,
    required String storagePath,
  }) async {
    try {
      print('🔄 Обновляю imageAssetPath для meal_id: $mealId');
      
      await _firestore.collection('meals').doc(mealId).update({
        'imageAssetPath': storagePath,
      });
      
      print('✅ Успешно! imageAssetPath обновлен: $storagePath');
    } catch (e) {
      print('❌ ОШИБКА updateMealStoragePath: $e');
      rethrow;
    }
  }
}
