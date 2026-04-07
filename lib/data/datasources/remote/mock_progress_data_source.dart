import 'package:beauty_body/domain/entities/progress_entity.dart';
import 'progress_data_source.dart';

class MockProgressDataSource implements ProgressDataSource {
  // Mock данные для демонстрации
  final List<ProgressEntity> mockProgress = [
    ProgressEntity(
      date: DateTime.now().subtract(const Duration(days: 7)),
      weight: 76.5,
      targetWeight: 70,
      progress: 6.5,
      meals: 4,
      calories: 1750,
      calorieGoal: 2000,
      measurements: {'талия': 72, 'бёдра': 96, 'грудь': 88, 'живот': 84},
    ),
    ProgressEntity(
      date: DateTime.now().subtract(const Duration(days: 6)),
      weight: 76.2,
      targetWeight: 70,
      progress: 6.2,
      meals: 4,
      calories: 1800,
      calorieGoal: 2000,
    ),
    ProgressEntity(
      date: DateTime.now().subtract(const Duration(days: 5)),
      weight: 75.8,
      targetWeight: 70,
      progress: 5.8,
      meals: 4,
      calories: 1850,
      calorieGoal: 2000,
    ),
    ProgressEntity(
      date: DateTime.now().subtract(const Duration(days: 4)),
      weight: 75.5,
      targetWeight: 70,
      progress: 5.5,
      meals: 4,
      calories: 1900,
      calorieGoal: 2000,
    ),
    ProgressEntity(
      date: DateTime.now().subtract(const Duration(days: 3)),
      weight: 75.2,
      targetWeight: 70,
      progress: 5.2,
      meals: 4,
      calories: 1800,
      calorieGoal: 2000,
    ),
    ProgressEntity(
      date: DateTime.now().subtract(const Duration(days: 2)),
      weight: 74.9,
      targetWeight: 70,
      progress: 4.9,
      meals: 4,
      calories: 1950,
      calorieGoal: 2000,
    ),
    ProgressEntity(
      date: DateTime.now().subtract(const Duration(days: 1)),
      weight: 74.7,
      targetWeight: 70,
      progress: 4.7,
      meals: 4,
      calories: 1850,
      calorieGoal: 2000,
    ),
    ProgressEntity(
      date: DateTime.now(),
      weight: 74.5,
      targetWeight: 70,
      progress: 4.5,
      meals: 4,
      calories: 1800,
      calorieGoal: 2000,
    ),
  ];

  @override
  Future<List<ProgressEntity>> getProgressHistory() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return mockProgress;
  }

  @override
  Future<List<ProgressEntity>> getProgressLast(int days) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final cutoffDate = DateTime.now().subtract(Duration(days: days));
    return mockProgress.where((p) => p.date.isAfter(cutoffDate)).toList();
  }

  @override
  Stream<ProgressEntity?> getTodayProgress() async* {
    await Future.delayed(const Duration(milliseconds: 300));
    final today = mockProgress.where((p) => 
      p.date.day == DateTime.now().day &&
      p.date.month == DateTime.now().month &&
      p.date.year == DateTime.now().year
    ).firstOrNull;
    yield today;
  }

  @override
  Future<double> getCurrentWeight() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return mockProgress.last.weight;
  }

  @override
  Future<void> addWeightEntry(double weight) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // В реальном приложении сохранить в Firestore
  }

  @override
  Future<void> updateMeasurements(Map<String, double> measurements) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // В реальном приложении сохранить в Firestore
  }

  @override
  Stream<ProgressEntity> watchProgress() async* {
    // Эмулируем поток обновлений
    yield mockProgress.last;
    await Future.delayed(const Duration(seconds: 5));
    // В реальном приложении слушать Firestore
  }
}
