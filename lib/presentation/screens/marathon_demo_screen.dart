import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/providers/marathon_provider.dart';
import '../../presentation/widgets/marathon_info_widgets.dart';

/// Экран для демонстрации всех возможностей системы марафона
class MarathonDemoScreen extends ConsumerWidget {
  const MarathonDemoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Информация о марафоне'),
      ),
      body: ListView(
        children: [
          // Основная панель информации
          const MarathonInfoPanel(),

          // Текущий день и неделя
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Текущее состояние',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _CurrentDayCard(ref),
              ],
            ),
          ),

          // Демонстрация для разных дат
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Примеры для разных дат',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ...List.generate(
                  5,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: MarathonDayDetailsWidget(
                      date: DateTime.now().add(Duration(days: index)),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Кнопка для сброса (для тестирования)
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () => _resetMarathon(context, ref),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text(
                'Сбросить прогресс (для тестирования)',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _resetMarathon(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Сброс прогресса'),
        content: const Text('Вы уверены? Это удалит все данные марафона.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () async {
              final service = await ref.read(marathonServiceProvider.future);
              await service.resetMarathon();
              ref.invalidate(marathonDayInfoProvider);
              ref.invalidate(marathonStartDateProvider);
              ref.invalidate(currentMarathonDayProvider);
              ref.invalidate(currentMarathonWeekProvider);
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Прогресс сброшен')),
                );
              }
            },
            child: const Text(
              'Сбросить',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

/// Карточка с текущим днем
class _CurrentDayCard extends ConsumerWidget {
  final WidgetRef ref;

  const _CurrentDayCard(this.ref);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dayAsync = ref.watch(currentMarathonDayProvider);
    final weekAsync = ref.watch(currentMarathonWeekProvider);

    return dayAsync.when(
      data: (day) {
        return weekAsync.when(
          data: (week) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text(
                          'День марафона',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$day',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const VerticalDivider(),
                    Column(
                      children: [
                        const Text(
                          'Неделя',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$week',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
          loading: () => const CircularProgressIndicator(),
          error: (error, stack) => Text('Ошибка: $error'),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Text('Ошибка: $error'),
    );
  }
}
