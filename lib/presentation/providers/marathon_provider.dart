import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/marathon_service.dart';

/// Провайдер для SharedPreferences
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  return SharedPreferences.getInstance();
});

/// Провайдер для MarathonService
final marathonServiceProvider = FutureProvider<MarathonService>((ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  final service = MarathonService(prefs);
  // Инициализировать марафон при первом запуске
  await service.initializeMarathon();
  return service;
});

/// Провайдер для получения текущего дня марафона
final currentMarathonDayProvider = FutureProvider<int>((ref) async {
  final service = await ref.watch(marathonServiceProvider.future);
  return service.getCurrentMarathonDay();
});

/// Провайдер для получения текущей недели марафона
final currentMarathonWeekProvider = FutureProvider<int>((ref) async {
  final service = await ref.watch(marathonServiceProvider.future);
  return service.getCurrentMarathonWeek();
});

/// Провайдер для получения дня недели в текущей неделе марафона
final currentDayOfWeekProvider = FutureProvider<int>((ref) async {
  final service = await ref.watch(marathonServiceProvider.future);
  return service.getCurrentDayOfWeek();
});

/// Провайдер для получения полной информации о текущем дне
final marathonDayInfoProvider = FutureProvider<MarathonDayInfo>((ref) async {
  final service = await ref.watch(marathonServiceProvider.future);
  return service.getCurrentDayInfo();
});

/// Провайдер для получения даты старта марафона
final marathonStartDateProvider = FutureProvider<DateTime?>((ref) async {
  final service = await ref.watch(marathonServiceProvider.future);
  return service.getStartDate();
});

/// Провайдер для получения дня марафона для конкретной даты
final marathonDayForDateProvider =
    FutureProvider.family<int, DateTime>((ref, date) async {
  final service = await ref.watch(marathonServiceProvider.future);
  return service.getMarathonDayForDate(date);
});

/// Провайдер для получения дня недели для конкретной даты
final dayOfWeekForDateProvider =
    FutureProvider.family<int, DateTime>((ref, date) async {
  final service = await ref.watch(marathonServiceProvider.future);
  return service.getDayOfWeekForDate(date);
});

// Утилиты для использования в UI

/// Получить названия дней недели
String getWeekdayName(int weekday, {bool short = false}) {
  const weekdayNames = {
    1: ('Понедельник', 'Пн'),
    2: ('Вторник', 'Вт'),
    3: ('Среда', 'Ср'),
    4: ('Четверг', 'Чт'),
    5: ('Пятница', 'Пт'),
    6: ('Суббота', 'Сб'),
    7: ('Воскресенье', 'Вс'),
  };

  final names = weekdayNames[weekday];
  if (names == null) return '';

  return short ? names.$2 : names.$1;
}

/// StateNotifier для управления обновлением марафона
class MarathonRefreshNotifier extends StateNotifier<void> {
  MarathonRefreshNotifier() : super(null);

  void refresh() {
    state = null; // Любое изменение триггерит перестроение
  }
}

/// Провайдер для обновления марафона (пересчета дней)
final marathonRefreshProvider =
    StateNotifierProvider<MarathonRefreshNotifier, void>((ref) {
  return MarathonRefreshNotifier();
});

// Вспомогательные функции для форматирования

/// Форматировать день марафона (например, "День 15")
String formatMarathonDay(int day) => 'День $day';

/// Форматировать неделю марафона (например, "Неделя 2")
String formatMarathonWeek(int week) => 'Неделя $week';
