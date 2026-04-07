import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/progress_entity.dart';

/// Модель прогресса для Firestore
class ProgressModel extends ProgressEntity {
  const ProgressModel({
    required super.date,
    required super.weight,
    required super.targetWeight,
    required super.progress,
    required super.meals,
    required super.calories,
    required super.calorieGoal,
    super.measurements,
  });

  /// Создание модели из Entity
  factory ProgressModel.fromEntity(ProgressEntity entity) {
    return ProgressModel(
      date: entity.date,
      weight: entity.weight,
      targetWeight: entity.targetWeight,
      progress: entity.progress,
      meals: entity.meals,
      calories: entity.calories,
      calorieGoal: entity.calorieGoal,
      measurements: entity.measurements,
    );
  }

  /// Создание модели из JSON (из Firestore)
  factory ProgressModel.fromJson(Map<String, dynamic> json) {
    return ProgressModel(
      date: _parseDate(json['date']),
      weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
      targetWeight: (json['targetWeight'] as num?)?.toDouble() ?? 70.0,
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      meals: json['meals'] as int? ?? 0,
      calories: json['calories'] as int? ?? 0,
      calorieGoal: json['calorieGoal'] as int? ?? 2000,
      measurements: _parseMeasurements(json['measurements']),
    );
  }

  /// Преобразование в Map для Firestore
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'weight': weight,
      'targetWeight': targetWeight,
      'progress': progress,
      'meals': meals,
      'calories': calories,
      'calorieGoal': calorieGoal,
      if (measurements != null) 'measurements': measurements,
    };
  }

  /// Вспомогательная функция для парсинга дат
  static DateTime _parseDate(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    } else if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    } else if (value is DateTime) {
      return value;
    }
    return DateTime.now();
  }

  /// Вспомогательная функция для парсинга измерений
  static Map<String, double>? _parseMeasurements(dynamic value) {
    if (value is Map) {
      return value.map((key, val) {
        return MapEntry(
          key.toString(),
          (val as num?)?.toDouble() ?? 0.0,
        );
      });
    }
    return null;
  }

  /// Преобразование в Entity
  ProgressEntity toEntity() {
    return ProgressEntity(
      date: date,
      weight: weight,
      targetWeight: targetWeight,
      progress: progress,
      meals: meals,
      calories: calories,
      calorieGoal: calorieGoal,
      measurements: measurements,
    );
  }
}
