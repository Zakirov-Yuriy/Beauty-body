import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:beauty_body/domain/entities/marathon_progress_entity.dart';

class MarathonProgressModel {
  final String userId;
  final int currentStage;
  final int currentWeek;
  final int currentDay;
  final DateTime startDate;
  final DateTime lastUpdated;

  MarathonProgressModel({
    required this.userId,
    required this.currentStage,
    required this.currentWeek,
    required this.currentDay,
    required this.startDate,
    required this.lastUpdated,
  });

  /// Конвертирование в Entity
  MarathonProgressEntity toEntity() {
    return MarathonProgressEntity(
      userId: userId,
      currentStage: currentStage,
      currentWeek: currentWeek,
      currentDay: currentDay,
      startDate: startDate,
      lastUpdated: lastUpdated,
    );
  }

  /// Парсинг из JSON (Firestore)
  factory MarathonProgressModel.fromJson(Map<String, dynamic> json) {
    return MarathonProgressModel(
      userId: json['userId'] as String? ?? '',
      currentStage: json['currentStage'] as int? ?? 1,
      currentWeek: json['currentWeek'] as int? ?? 1,
      currentDay: json['currentDay'] as int? ?? 1,
      startDate: json['startDate'] is Timestamp
          ? (json['startDate'] as Timestamp).toDate()
          : DateTime.parse(json['startDate'] as String? ?? DateTime.now().toString()),
      lastUpdated: json['lastUpdated'] is Timestamp
          ? (json['lastUpdated'] as Timestamp).toDate()
          : DateTime.parse(json['lastUpdated'] as String? ?? DateTime.now().toString()),
    );
  }

  /// Конвертирование в JSON для Firestore
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'currentStage': currentStage,
      'currentWeek': currentWeek,
      'currentDay': currentDay,
      'startDate': Timestamp.fromDate(startDate),
      'lastUpdated': Timestamp.fromDate(lastUpdated),
    };
  }

  MarathonProgressModel copyWith({
    String? userId,
    int? currentStage,
    int? currentWeek,
    int? currentDay,
    DateTime? startDate,
    DateTime? lastUpdated,
  }) {
    return MarathonProgressModel(
      userId: userId ?? this.userId,
      currentStage: currentStage ?? this.currentStage,
      currentWeek: currentWeek ?? this.currentWeek,
      currentDay: currentDay ?? this.currentDay,
      startDate: startDate ?? this.startDate,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
