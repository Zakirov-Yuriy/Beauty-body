import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/providers/marathon_provider.dart';

/// Виджет для отображения текущей информации о дне марафона
class MarathonDayDisplay extends ConsumerWidget {
  const MarathonDayDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dayInfoAsync = ref.watch(marathonDayInfoProvider);

    return dayInfoAsync.when(
      data: (dayInfo) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // День марафона
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${formatMarathonDay(dayInfo.marathonDay)} (Неделя ${dayInfo.marathonWeek})',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // День недели
            Text(
              'День недели: ${getWeekdayName(dayInfo.dayOfWeek)}',
              style: const TextStyle(fontSize: 16),
            ),

            // Информация о первой неделе
            if (dayInfo.isFirstWeek)
              Container(
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange),
                ),
                child: const Text(
                  '📌 Первая неделя со смещением',
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Text('Ошибка: $error'),
    );
  }
}

/// Виджет для отображения дня недели по модулю 7
class WeekdayBadge extends ConsumerWidget {
  const WeekdayBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dayOfWeekAsync = ref.watch(currentDayOfWeekProvider);

    return dayOfWeekAsync.when(
      data: (dayOfWeek) {
        return Chip(
          label: Text(getWeekdayName(dayOfWeek, short: true)),
          backgroundColor: Colors.lightBlue,
          labelStyle: const TextStyle(color: Colors.white),
        );
      },
      loading: () => const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      error: (error, stack) => const Text('Ошибка'),
    );
  }
}

/// Полная информационная панель о марафоне
class MarathonInfoPanel extends ConsumerWidget {
  final Function(int)? onDayTap; // Callback для взаимодействия с днем

  const MarathonInfoPanel({
    super.key,
    this.onDayTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dayInfoAsync = ref.watch(marathonDayInfoProvider);
    final startDateAsync = ref.watch(marathonStartDateProvider);

    return dayInfoAsync.when(
      data: (dayInfo) {
        return startDateAsync.when(
          data: (startDate) {
            return Card(
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Заголовок
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Прогресс марафона',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Chip(
                          label: Text('День ${dayInfo.marathonDay}'),
                          backgroundColor: Colors.blue,
                          labelStyle: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    const Divider(height: 24),

                    // Основная информация
                    _InfoRow(
                      label: 'Текущий день:',
                      value: '${dayInfo.marathonDay} из 42',
                    ),
                    const SizedBox(height: 12),
                    _InfoRow(
                      label: 'Неделя:',
                      value: '${dayInfo.marathonWeek} неделя',
                    ),
                    const SizedBox(height: 12),
                    _InfoRow(
                      label: 'День недели:',
                      value: getWeekdayName(dayInfo.dayOfWeek),
                    ),
                    const SizedBox(height: 12),
                    _InfoRow(
                      label: 'Дата старта:',
                      value: startDate != null
                          ? '${startDate.day}.${startDate.month}.${startDate.year}'
                          : 'Не указана',
                    ),

                    // Статус первой недели
                    if (dayInfo.isFirstWeek) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.orange,
                            width: 1.5,
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.info, color: Colors.orange),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Используется смещение первой недели',
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // Прогресс бар
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: dayInfo.marathonDay / 42,
                        minHeight: 8,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          dayInfo.marathonDay <= 7
                              ? Colors.orange
                              : Colors.blue,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${((dayInfo.marathonDay / 42) * 100).toStringAsFixed(1)}% завершено',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Ошибка: $error')),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Ошибка: $error')),
    );
  }
}

/// Вспомогательный виджет для отображения информационной строки
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

/// Виджет для отображения информации о конкретном дне
class MarathonDayDetailsWidget extends ConsumerWidget {
  final DateTime date;

  const MarathonDayDetailsWidget({
    required this.date,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marathonDayAsync = ref.watch(marathonDayForDateProvider(date));
    final dayOfWeekAsync = ref.watch(dayOfWeekForDateProvider(date));

    return marathonDayAsync.when(
      data: (marathonDay) {
        return dayOfWeekAsync.when(
          data: (dayOfWeek) {
            return ListTile(
              title: Text('День $marathonDay'),
              subtitle: Text(getWeekdayName(dayOfWeek)),
              leading: const Icon(Icons.calendar_today),
            );
          },
          loading: () => const ListTile(
            title: CircularProgressIndicator(),
          ),
          error: (error, stack) => ListTile(
            title: Text('Ошибка: $error'),
          ),
        );
      },
      loading: () => const ListTile(
        title: CircularProgressIndicator(),
      ),
      error: (error, stack) => ListTile(
        title: Text('Ошибка: $error'),
      ),
    );
  }
}
