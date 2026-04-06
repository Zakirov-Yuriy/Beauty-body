import 'package:beauty_body/domain/entities/progress_entity.dart';
import 'progress_data_source.dart';

class MockProgressDataSource implements ProgressDataSource {
  // Mock данные для демонстрации
  final List<ProgressEntity> mockProgress = [
    ProgressEntity(
      id: '1',
      userId: 'user1',
      date: DateTime.now().subtract(const Duration(days: 6)),
      weight: 72.0,
      measurements: {'талия': 72, 'бёдра': 96, 'грудь': 88, 'живот': 84},
      mealsCompleted: 4,
      waterIntake: 2.0,
      createdAt: DateTime.now().subtract(const Duration(days: 6)),
    ),
    ProgressEntity(
      id: '2',
      userId: 'user1',
      date: DateTime.now().subtract(const Duration(days: 5)),
      weight: 71.5,
      measurements: {'талия': 71.5, 'бёдра': 95.5, 'грудь': 87.5, 'живот': 83},
      mealsCompleted: 4,
      waterIntake: 2.2,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    ProgressEntity(
      id: '3',
      userId: 'user1',
      date: DateTime.now().subtract(const Duration(days: 4)),
      weight: 71.0,
      measurements: {'талия': 71, 'бёдра': 95, 'грудь': 87, 'живот': 82.5},
      mealsCompleted: 4,
      waterIntake: 2.1,
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
    ProgressEntity(
      id: '4',
      userId: 'user1',
      date: DateTime.now().subtract(const Duration(days: 3)),
      weight: 70.3,
      measurements: {'талия': 70.5, 'бёдра': 94.5, 'грудь': 86.5, 'живот': 82},
      mealsCompleted: 4,
      waterIntake: 2.3,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    ProgressEntity(
      id: '5',
      userId: 'user1',
      date: DateTime.now().subtract(const Duration(days: 2)),
      weight: 69.8,
      measurements: {'талия': 70, 'бёдра': 94, 'грудь': 86, 'живот': 81.5},
      mealsCompleted: 4,
      waterIntake: 2.2,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    ProgressEntity(
      id: '6',
      userId: 'user1',
      date: DateTime.now().subtract(const Duration(days: 1)),
      weight: 69.2,
      measurements: {'талия': 69.5, 'бёдра': 93.5, 'грудь': 85.5, 'живот': 81},
      mealsCompleted: 4,
      waterIntake: 2.4,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    ProgressEntity(
      id: '7',
      userId: 'user1',
      date: DateTime.now(),
      weight: 68.5,
      measurements: {'талия': 69, 'бёдра': 93, 'грудь': 85, 'живот': 80.5},
      mealsCompleted: 3,
      waterIntake: 1.8,
      createdAt: DateTime.now(),
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
