import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/meal_entity.dart';

/// Модель блюда для Firestore (с методами сериализации)
class MealModel extends MealEntity {
  const MealModel({
    required super.id,
    required super.name,
    required super.type,
    required super.portion,
    required super.emoji,
    required super.calories,
    required super.protein,
    required super.carbs,
    required super.fat,
    super.extra,
    super.ingredients,
    super.steps,
    super.description,
    super.imageAssetPath,
    super.portionSizes,
    required super.createdAt,
  });

  /// Создание модели из MealEntity
  factory MealModel.fromEntity(MealEntity entity) {
    return MealModel(
      id: entity.id,
      name: entity.name,
      type: entity.type,
      portion: entity.portion,
      emoji: entity.emoji,
      calories: entity.calories,
      protein: entity.protein,
      carbs: entity.carbs,
      fat: entity.fat,
      extra: entity.extra,
      ingredients: entity.ingredients,
      steps: entity.steps,
      description: entity.description,
      imageAssetPath: entity.imageAssetPath,
      portionSizes: entity.portionSizes,
      createdAt: entity.createdAt,
    );
  }

  /// Преобразование в Map для Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'portion': portion,
      'emoji': emoji,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'extra': extra,
      'ingredients': ingredients,
      'steps': steps,
      'description': description,
      'imageAssetPath': imageAssetPath,
      'portionSizes': portionSizes,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  /// Создание из Map (Firestore)
  factory MealModel.fromJson(Map<String, dynamic> json) {
    print('🔍 MealModel.fromJson for ID: ${json['id']}');
    print('   Available keys: ${json.keys.toList()}');
    print('   portionSizes value: ${json['portionSizes']} (type: ${json['portionSizes'].runtimeType})');
    
    // Маппинг для совместимости с Firestore полями
    final type = json['type'] ?? json['category'] ?? '';
    final portion = json['portion'] ?? 'N/A';
    
    // Парсим ingredients (может быть массив объектов или строк)
    final ingredientsList = <String>[];
    if (json['ingredients'] is List) {
      for (var item in json['ingredients']) {
        if (item is String) {
          ingredientsList.add(item);
        } else if (item is Map) {
          final name = item['name'] ?? '';
          final amount = item['amount'] ?? '';
          ingredientsList.add('$name${amount.isNotEmpty ? ' ($amount)' : ''}');
        }
      }
    }

    // Парсим steps (массив строк)
    final stepsList = <String>[];
    if (json['steps'] is List) {
      for (var step in json['steps']) {
        if (step is String && step.isNotEmpty) {
          stepsList.add(step);
        }
      }
    }

    return MealModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      type: type,
      portion: portion,
      emoji: _getMealEmoji(type),
      calories: json['calories'] as int? ?? 0,
      protein: json['protein'] as int? ?? 0,
      carbs: json['carbs'] as int? ?? 0,
      fat: json['fat'] as int? ?? 0,
      extra: json['extra'] as String? ?? '',
      ingredients: ingredientsList,
      steps: stepsList,
      description: json['description'] as String? ?? '',
      imageAssetPath: json['imageAssetPath'] as String? ?? '',
      portionSizes: _parsePortionSizes(json['portionSizes']),
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Вспомогательная функция для получения emoji по типу
  static String _getMealEmoji(String type) {
    switch (type.toLowerCase()) {
      case 'breakfast':
        return '🥯';
      case 'lunch':
        return '🍲';
      case 'snack':
        return '🍎';
      case 'dinner':
        return '🍗';
      default:
        return '🍽️';
    }
  }

  /// Парсинг размеров порций из JSON
  static List<Map<String, dynamic>> _parsePortionSizes(dynamic portionSizesData) {
    print('🔍 _parsePortionSizes - input: $portionSizesData (type: ${portionSizesData.runtimeType})');
    
    if (portionSizesData == null) {
      print('⚠️  portionSizesData is null, returning empty list');
      return [];
    }
    
    if (portionSizesData is! List) {
      print('⚠️  portionSizesData is not List (is ${portionSizesData.runtimeType}), returning empty list');
      return [];
    }
    
    try {
      final result = List<Map<String, dynamic>>.from(
        portionSizesData.map((item) => Map<String, dynamic>.from(item as Map))
      );
      print('✅ Successfully parsed ${result.length} portion sizes');
      return result;
    } catch (e) {
      print('❌ Error parsing portionSizes: $e');
      return [];
    }
  }

  /// Преобразование модели в Entity
  MealEntity toEntity() {
    return MealEntity(
      id: id,
      name: name,
      type: type,
      portion: portion,
      emoji: emoji,
      calories: calories,
      protein: protein,
      carbs: carbs,
      fat: fat,
      extra: extra,
      ingredients: ingredients,
      steps: steps,
      description: description,
      imageAssetPath: imageAssetPath,
      portionSizes: portionSizes,
      createdAt: createdAt,
    );
  }

  /// Копирование с изменениями
  MealModel copyWith({
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
    String? imageAssetPath,
    List<Map<String, dynamic>>? portionSizes,
    DateTime? createdAt,
  }) {
    return MealModel(
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
      imageAssetPath: imageAssetPath ?? this.imageAssetPath,
      portionSizes: portionSizes ?? this.portionSizes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
