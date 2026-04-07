import '../../domain/entities/meal_plan_progress_entity.dart';

class MealPlanProgressModel {
  final String id;
  final String userId;
  final int currentStage;
  final int currentWeek;
  final DateTime startDate;
  final DateTime? completedDate;
  final bool isCompleted;
  final bool isActive;

  const MealPlanProgressModel({
    required this.id,
    required this.userId,
    required this.currentStage,
    required this.currentWeek,
    required this.startDate,
    this.completedDate,
    this.isCompleted = false,
    this.isActive = true,
  });

  /// Конвертирование из JSON (Firestore)
  factory MealPlanProgressModel.fromJson(Map<String, dynamic> json) {
    return MealPlanProgressModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      currentStage: json['currentStage'] as int? ?? 1,
      currentWeek: json['currentWeek'] as int? ?? 0,
      startDate: _parseDate(json['startDate']),
      completedDate: _parseDate(json['completedDate']),
      isCompleted: json['isCompleted'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  /// Конвертирование в JSON (для Firestore)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'currentStage': currentStage,
      'currentWeek': currentWeek,
      'startDate': startDate.toIso8601String(),
      'completedDate': completedDate?.toIso8601String(),
      'isCompleted': isCompleted,
      'isActive': isActive,
    };
  }

  /// Конвертирование в Entity
  MealPlanProgressEntity toEntity() {
    return MealPlanProgressEntity(
      id: id,
      userId: userId,
      currentStage: currentStage,
      currentWeek: currentWeek,
      startDate: startDate,
      completedDate: completedDate,
      isCompleted: isCompleted,
      isActive: isActive,
    );
  }

  /// Копирование с изменениями
  MealPlanProgressModel copyWith({
    String? id,
    String? userId,
    int? currentStage,
    int? currentWeek,
    DateTime? startDate,
    DateTime? completedDate,
    bool? isCompleted,
    bool? isActive,
  }) {
    return MealPlanProgressModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      currentStage: currentStage ?? this.currentStage,
      currentWeek: currentWeek ?? this.currentWeek,
      startDate: startDate ?? this.startDate,
      completedDate: completedDate ?? this.completedDate,
      isCompleted: isCompleted ?? this.isCompleted,
      isActive: isActive ?? this.isActive,
    );
  }

  static DateTime _parseDate(dynamic date) {
    if (date == null) return DateTime.now();
    if (date is DateTime) return date;
    if (date is String) return DateTime.parse(date);
    return DateTime.now();
  }
}
