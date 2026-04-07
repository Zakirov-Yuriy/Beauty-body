class MarathonProgressEntity {
  final String userId;
  final int currentStage; // 1-4 этапа
  final int currentWeek; // 1-4 недели в этапе
  final int currentDay; // 1-7 дней в неделе
  final DateTime startDate; // дата начала марафона
  final DateTime lastUpdated;

  const MarathonProgressEntity({
    required this.userId,
    required this.currentStage,
    required this.currentWeek,
    required this.currentDay,
    required this.startDate,
    required this.lastUpdated,
  });

  /// Текущий день марафона (1-112)
  int get marathonDay {
    return (currentStage - 1) * 28 + (currentWeek - 1) * 7 + currentDay;
  }

  /// Процент завершения текущего этапа (0-100)
  double get stageProgress {
    final daysInStage = (currentWeek - 1) * 7 + currentDay;
    return (daysInStage / 28) * 100;
  }

  /// Процент завершения всего марафона (0-100)
  double get overallProgress {
    return (marathonDay / 112) * 100;
  }

  /// Истекшие дни с начала марафона
  int get elapsedDays {
    return DateTime.now().difference(startDate).inDays;
  }

  /// Осталось дней до конца марафона
  int get remainingDays {
    return 112 - marathonDay;
  }

  /// Название текущего этапа
  String get stageName {
    switch (currentStage) {
      case 1:
        return 'Адаптация';
      case 2:
        return 'Прогресс';
      case 3:
        return 'Интенсив';
      case 4:
        return 'Завершение';
      default:
        return 'Неизвестно';
    }
  }

  /// Полное название (Этап 1 · Неделя 2)
  String get stageLabel => 'Этап $currentStage · Неделя $currentWeek';

  /// Полное название дня (День 8)
  String get dayLabel => 'День ${marathonDay % 7 == 0 ? 7 : marathonDay % 7}';

  MarathonProgressEntity copyWith({
    String? userId,
    int? currentStage,
    int? currentWeek,
    int? currentDay,
    DateTime? startDate,
    DateTime? lastUpdated,
  }) {
    return MarathonProgressEntity(
      userId: userId ?? this.userId,
      currentStage: currentStage ?? this.currentStage,
      currentWeek: currentWeek ?? this.currentWeek,
      currentDay: currentDay ?? this.currentDay,
      startDate: startDate ?? this.startDate,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  String toString() {
    return 'MarathonProgressEntity(stage: $currentStage, week: $currentWeek, day: $currentDay, progress: ${overallProgress.toStringAsFixed(1)}%)';
  }
}
