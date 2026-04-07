import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme.dart';
import '../../presentation/providers/marathon_progress_provider.dart';
import '../../domain/entities/marathon_progress_entity.dart';

/// Компонент отображения прогресса марафона
class MarathonProgressCard extends ConsumerWidget {
  const MarathonProgressCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Инициализируем прогресс при первом запуске
    ref.watch(initializeMarathonProgressOnLoginProvider);
    
    // Отслеживаем текущий прогресс
    final marathonProgressAsync = ref.watch(marathonProgressProvider);

    return marathonProgressAsync.when(
      data: (progress) {
        if (progress == null) {
          return _buildLoadingState();
        }
        return _buildProgressCard(progress, context, ref);
      },
      loading: () => _buildLoadingState(),
      error: (error, stack) => _buildErrorState(error),
    );
  }

  /// Карточка с прогрессом марафона
  Widget _buildProgressCard(
    MarathonProgressEntity progress,
    BuildContext context,
    WidgetRef ref,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            AppColors.greenMid.withOpacity(0.9),
            AppColors.greenMid.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.greenMid.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок с этапом и неделей
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  progress.stageLabel,
                  style: GoogleFonts.rubik(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),
                // День марафона
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'День ${progress.marathonDay}',
                    style: GoogleFonts.rubik(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Имя этапа
            Text(
              progress.stageName,
              style: GoogleFonts.rubik(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 16),

            // Прогресс-бар этапа
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Прогресс этапа',
                  style: GoogleFonts.rubik(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 8),
                Stack(
                  children: [
                    // Фон прогресс-бара
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.white.withOpacity(0.2),
                      ),
                    ),
                    // Заполненная часть
                    Container(
                      height: 8,
                      width: (MediaQuery.of(context).size.width - 52) *
                          (progress.stageProgress / 100),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${progress.stageProgress.toStringAsFixed(1)}%',
                  style: GoogleFonts.rubik(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Общий прогресс марафона
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Общий прогресс',
                  style: GoogleFonts.rubik(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          // Фон
                          Container(
                            height: 6,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                          // Заполнение
                          Container(
                            height: 6,
                            width: (MediaQuery.of(context).size.width - 100) *
                                (progress.overallProgress / 100),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${progress.overallProgress.toStringAsFixed(1)}%',
                      style: GoogleFonts.rubik(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Дополнительная информация
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _InfoItem(
                  label: 'Осталось дней',
                  value: '${progress.remainingDays}',
                ),
                _InfoItem(
                  label: 'Прошло дней',
                  value: '${progress.marathonDay}/112',
                ),
                _InfoItem(
                  label: 'Неделя в этапе',
                  value: '${progress.currentWeek}/4',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Загружающееся состояние
  Widget _buildLoadingState() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.greenMid.withOpacity(0.2),
      ),
      padding: const EdgeInsets.all(20),
      child: Center(
        child: SizedBox(
          width: 30,
          height: 30,
          child: CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation(AppColors.greenMid.withOpacity(0.7)),
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }

  /// Состояние ошибки
  Widget _buildErrorState(Object error) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.red.withOpacity(0.1),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      padding: const EdgeInsets.all(20),
      child: Text(
        'Ошибка загрузки прогресса',
        style: GoogleFonts.rubik(
          fontSize: 14,
          color: Colors.red,
        ),
      ),
    );
  }
}

/// Элемент информации
class _InfoItem extends StatelessWidget {
  final String label;
  final String value;

  const _InfoItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: GoogleFonts.rubik(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.rubik(
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: Colors.white.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
