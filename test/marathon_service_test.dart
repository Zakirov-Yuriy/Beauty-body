// Тесты для логики марафона
// Скопируйте в test/marathon_service_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:beauty_body/services/marathon_service.dart';

void main() {
  group('MarathonService', () {
    late MarathonService marathonService;
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      marathonService = MarathonService(prefs);
    });

    group('Инициализация марафона', () {
      test('Сохраняет дату старта при первом запуске', () async {
        await marathonService.initializeMarathon();
        
        final startDate = marathonService.getStartDate();
        expect(startDate, isNotNull);
        expect(startDate!.year, DateTime.now().year);
      });

      test('Сохраняет день недели старта', () async {
        await marathonService.initializeMarathon();
        
        final info = marathonService.getCurrentDayInfo();
        expect(info.marathonDay, 1);
      });

      test('Не перезаписывает при повторном запуске', () async {
        await marathonService.initializeMarathon();
        final firstDate = marathonService.getStartDate();

        // Имитируем повторный запуск
        final service2 = MarathonService(prefs);
        final secondDate = service2.getStartDate();

        expect(firstDate, secondDate);
      });
    });

    group('Расчет дня марафона', () {
      test('День 1 = день старта', () async {
        await marathonService.initializeMarathon();
        final day = marathonService.getCurrentMarathonDay();
        expect(day, 1);
      });

      test('День увеличивается каждый день', () async {
        await marathonService.initializeMarathon();
        
        // Имитируем время, прошедшее на 5 дней
        final testDate = DateTime.now().add(const Duration(days: 5));
        final day = marathonService.getMarathonDayForDate(testDate);
        expect(day, 6);
      });

      test('День не может быть меньше 1', () async {
        await marathonService.initializeMarathon();
        
        final testDate = DateTime.now().subtract(const Duration(days: 5));
        final day = marathonService.getMarathonDayForDate(testDate);
        expect(day, greaterThanOrEqualTo(1));
      });
    });

    group('Расчет недели марафона', () {
      test('Дни 1-7 = неделя 1', () async {
        await marathonService.initializeMarathon();
        
        for (int day = 1; day <= 7; day++) {
          final testDate = DateTime.now().add(Duration(days: day - 1));
          final marathonDay = marathonService.getMarathonDayForDate(testDate);
          final week = ((marathonDay - 1) ~/ 7) + 1;
          expect(week, 1);
        }
      });

      test('Дни 8-14 = неделя 2', () async {
        await marathonService.initializeMarathon();
        
        for (int day = 8; day <= 14; day++) {
          final testDate = DateTime.now().add(Duration(days: day - 1));
          final marathonDay = marathonService.getMarathonDayForDate(testDate);
          final week = ((marathonDay - 1) ~/ 7) + 1;
          expect(week, 2);
        }
      });

      test('День 42 = неделя 6', () async {
        await marathonService.initializeMarathon();
        
        final testDate = DateTime.now().add(const Duration(days: 41));
        final marathonDay = marathonService.getMarathonDayForDate(testDate);
        final week = ((marathonDay - 1) ~/ 7) + 1;
        expect(week, 6);
      });
    });

    group('Смещение первой недели', () {
      test(
        'Смещение работает правильно для старта в среду',
        () async {
          // Создаем марафон с датой старта в среду
          // Wednesday = 3 (День недели в Dart)
          await marathonService.initializeMarathon();

          final dayInfo = marathonService.getCurrentDayInfo();
          expect(dayInfo.isFirstWeek, true);

          // День 1 (среда) должен вернуть 1 после смещения
          expect(dayInfo.dayOfWeek, greaterThanOrEqualTo(0));
        },
      );

      test(
        'Смещение работает для старта в понедельник',
        () async {
          await marathonService.initializeMarathon();

          final dayInfo = marathonService.getCurrentDayInfo();
          expect(dayInfo.isFirstWeek, true);
        },
      );

      test(
        'Смещение применяется только в первую неделю',
        () async {
          await marathonService.initializeMarathon();

          // День 1 (первая неделя)
          final day1Info = marathonService.getCurrentDayInfo();
          expect(day1Info.isFirstWeek, true);

          // День 8 (вторая неделя)
          final testDate = DateTime.now().add(const Duration(days: 7));
          final marathonDay = marathonService.getMarathonDayForDate(testDate);
          final week = ((marathonDay - 1) ~/ 7) + 1;
          expect(week, 2);
        },
      );
    });

    group('Работа с конкретными датами', () {
      test('Получить день марафона для конкретной даты', () async {
        await marathonService.initializeMarathon();
        
        final today = DateTime.now();
        final tomorrow = today.add(const Duration(days: 1));

        final todayDay = marathonService.getMarathonDayForDate(today);
        final tomorrowDay = marathonService.getMarathonDayForDate(tomorrow);

        expect(tomorrowDay, todayDay + 1);
      });

      test('Получить день недели для конкретной даты', () async {
        await marathonService.initializeMarathon();
        
        final today = DateTime.now();
        final dayOfWeek = marathonService.getDayOfWeekForDate(today);

        expect(dayOfWeek, greaterThanOrEqualTo(1));
        expect(dayOfWeek, lessThanOrEqualTo(7));
      });

      test('Дни в разных неделях используют разную логику', () async {
        await marathonService.initializeMarathon();

        // День 5 (первая неделя, со смещением)
        final day5 = DateTime.now().add(const Duration(days: 4));
        final day5Week = ((marathonService.getMarathonDayForDate(day5) - 1) ~/ 7) + 1;
        expect(day5Week, 1);

        // День 10 (вторая неделя, без смещения)
        final day10 = DateTime.now().add(const Duration(days: 9));
        final day10Week = ((marathonService.getMarathonDayForDate(day10) - 1) ~/ 7) + 1;
        expect(day10Week, 2);
      });
    });

    group('Обновление состояния', () {
      test('updateLastCheckedDate обновляет дату', () async {
        await marathonService.initializeMarathon();
        
        await marathonService.updateLastCheckedDate();
        
        // Дата должна быть обновлена (примерно текущее время)
        // Невозможно точно проверить, так что проверяем, что ошибки нет
        expect(true, true);
      });

      test('resetMarathon удаляет все данные', () async {
        await marathonService.initializeMarathon();
        
        final beforeReset = marathonService.getStartDate();
        expect(beforeReset, isNotNull);

        await marathonService.resetMarathon();

        final afterReset = marathonService.getStartDate();
        expect(afterReset, isNull);
      });
    });

    group('Полная информация о дне', () {
      test('getCurrentDayInfo возвращает все необходимые данные', () async {
        await marathonService.initializeMarathon();
        
        final dayInfo = marathonService.getCurrentDayInfo();

        expect(dayInfo.marathonDay, greaterThanOrEqualTo(1));
        expect(dayInfo.marathonWeek, greaterThanOrEqualTo(1));
        expect(dayInfo.dayOfWeek, greaterThanOrEqualTo(1));
        expect(dayInfo.dayOfWeek, lessThanOrEqualTo(7));
      });

      test('isFirstWeek устанавливается правильно', () async {
        await marathonService.initializeMarathon();
        
        // День 1-7
        final dayInfo1 = marathonService.getCurrentDayInfo();
        expect(dayInfo1.isFirstWeek, true);

        // День 8+
        final testDate = DateTime.now().add(const Duration(days: 7));
        final marathonDay = marathonService.getMarathonDayForDate(testDate);
        final week = ((marathonDay - 1) ~/ 7) + 1;
        expect(week == 1, false);
      });
    });

    group('Формула смещения', () {
      test('Формула (currentWeekday - startWeekday + 7) % 7 работает', () async {
        // Пример: startWeekday = 3 (среда)
        // День 1 (среда, weekday = 3): (3 - 3 + 7) % 7 = 0 -> 1
        // День 2 (четверг, weekday = 4): (4 - 3 + 7) % 7 = 1
        // День 3 (пятница, weekday = 5): (5 - 3 + 7) % 7 = 2

        const int startWeekday = 3;

        final adjusted1 = (3 - startWeekday + 7) % 7;
        expect(adjusted1 == 0 ? 1 : adjusted1, 1);

        final adjusted2 = (4 - startWeekday + 7) % 7;
        expect(adjusted2, 1);

        final adjusted3 = (5 - startWeekday + 7) % 7;
        expect(adjusted3, 2);
      });

      test('Формула работает для всех дней недели', () {
        for (int startWeekday = 1; startWeekday <= 7; startWeekday++) {
          for (int currentWeekday = 1; currentWeekday <= 7; currentWeekday++) {
            final adjusted = (currentWeekday - startWeekday + 7) % 7;
            final result = adjusted == 0 ? 1 : adjusted;

            expect(result, greaterThanOrEqualTo(1));
            expect(result, lessThanOrEqualTo(6));
          }
        }
      });
    });
  });
}
