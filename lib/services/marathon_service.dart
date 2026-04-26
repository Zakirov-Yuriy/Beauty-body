import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/marathon_progress.dart';

class MarathonService {
  static const String _marathonProgressKey = 'marathon_progress';
  final SharedPreferences _prefs;

  MarathonService(this._prefs);

  /// Сохранить прогресс марафона при первом запуске
  Future<void> initializeMarathon() async {
    final existingProgress = _getProgress();
    if (existingProgress == null) {
      final now = DateTime.now();
      final progress = MarathonProgress(
        startDate: now,
        startWeekday: now.weekday, // 1-7 (Пн-Вс)
        lastCheckedDate: now,
      );
      await _saveProgress(progress);
    }
  }

  /// Получить сохраненный прогресс
  MarathonProgress? _getProgress() {
    final jsonString = _prefs.getString(_marathonProgressKey);
    if (jsonString == null) return null;
    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return MarathonProgress.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  /// Сохранить прогресс
  Future<void> _saveProgress(MarathonProgress progress) async {
    final json = jsonEncode(progress.toJson());
    await _prefs.setString(_marathonProgressKey, json);
  }

  /// Обновить дату последней проверки
  Future<void> updateLastCheckedDate() async {
    final progress = _getProgress();
    if (progress != null) {
      final updatedProgress = progress.copyWith(lastCheckedDate: DateTime.now());
      await _saveProgress(updatedProgress);
    }
  }

  /// Получить текущий день марафона (1-based)
  int getCurrentMarathonDay() {
    final progress = _getProgress();
    if (progress == null) return 1;

    final now = DateTime.now();
    final startDate = progress.startDate;

    // Вычислить количество дней с момента старта
    final differenceInDays =
        now.difference(DateTime(startDate.year, startDate.month, startDate.day))
            .inDays;

    // День марафона 1-based (день 1 = день старта)
    return differenceInDays + 1;
  }

  /// Получить номер недели марафона
  int getCurrentMarathonWeek() {
    final marathonDay = getCurrentMarathonDay();
    // Неделя 1-based: дни 1-7 = неделя 1, дни 8-14 = неделя 2 и т.д.
    return ((marathonDay - 1) ~/ 7) + 1;
  }

  /// Получить день недели в текущей неделе марафона (1-7)
  /// Для первой недели: используется смещение
  /// Для остальных недель: понедельник = 1, воскресенье = 7
  int getCurrentDayOfWeek() {
    final progress = _getProgress();
    if (progress == null) return DateTime.now().weekday;

    final marathonWeek = getCurrentMarathonWeek();
    final now = DateTime.now();
    final currentWeekday = now.weekday; // 1-7 (Пн-Вс)
    final startWeekday = progress.startWeekday; // 1-7 (Пн-Вс)

    // Первая неделя: использовать смещение
    if (marathonWeek == 1) {
      // adjustedDay = (currentWeekday - startWeekday + 7) % 7
      final adjusted = (currentWeekday - startWeekday + 7) % 7;
      // Если результат 0, это значит мы еще в начальный день, вернем 1
      return adjusted == 0 ? 1 : adjusted;
    }

    // Остальные недели: стандартная неделя (понедельник = 1)
    return currentWeekday;
  }

  /// Получить день марафона для конкретной даты
  int getMarathonDayForDate(DateTime date) {
    final progress = _getProgress();
    if (progress == null) return 1;

    final startDate = progress.startDate;
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final normalizedStart =
        DateTime(startDate.year, startDate.month, startDate.day);

    final differenceInDays = normalizedDate.difference(normalizedStart).inDays;
    return (differenceInDays + 1).clamp(1, 1000); // Минимум день 1
  }

  /// Получить день недели марафона для конкретной даты
  int getDayOfWeekForDate(DateTime date) {
    final progress = _getProgress();
    if (progress == null) return date.weekday;

    final marathonDay = getMarathonDayForDate(date);
    final marathonWeek = ((marathonDay - 1) ~/ 7) + 1;
    final currentWeekday = date.weekday;
    final startWeekday = progress.startWeekday;

    // Первая неделя: использовать смещение
    if (marathonWeek == 1) {
      final adjusted = (currentWeekday - startWeekday + 7) % 7;
      return adjusted == 0 ? 1 : adjusted;
    }

    // Остальные недели: стандартная неделя
    return currentWeekday;
  }

  /// Получить дату старта марафона
  DateTime? getStartDate() {
    return _getProgress()?.startDate;
  }

  /// Сбросить прогресс марафона (для тестирования)
  Future<void> resetMarathon() async {
    await _prefs.remove(_marathonProgressKey);
  }

  /// Получить информацию о текущем дне марафона
  MarathonDayInfo getCurrentDayInfo() {
    final progress = _getProgress();
    final marathonDay = getCurrentMarathonDay();
    final marathonWeek = getCurrentMarathonWeek();
    final dayOfWeek = getCurrentDayOfWeek();

    return MarathonDayInfo(
      marathonDay: marathonDay,
      marathonWeek: marathonWeek,
      dayOfWeek: dayOfWeek,
      isFirstWeek: marathonWeek == 1,
      startDate: progress?.startDate ?? DateTime.now(),
    );
  }
}

/// Информация о текущем дне марафона
class MarathonDayInfo {
  final int marathonDay; // Общий день марафона (1, 2, 3, ...)
  final int marathonWeek; // Номер недели (1, 2, 3, ...)
  final int dayOfWeek; // День в текущей неделе (1-7)
  final bool isFirstWeek; // Это первая неделя со смещением?
  final DateTime startDate; // Дата начала марафона

  MarathonDayInfo({
    required this.marathonDay,
    required this.marathonWeek,
    required this.dayOfWeek,
    required this.isFirstWeek,
    required this.startDate,
  });

  @override
  String toString() =>
      'MarathonDayInfo(day=$marathonDay, week=$marathonWeek, dayOfWeek=$dayOfWeek, isFirstWeek=$isFirstWeek)';
}
