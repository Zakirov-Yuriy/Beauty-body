import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../presentation/providers/progress_provider.dart';

class ProgressScreen extends ConsumerStatefulWidget {
  const ProgressScreen({super.key});

  @override
  ConsumerState<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends ConsumerState<ProgressScreen> {
  bool _showMeasurements = true;

  @override
  Widget build(BuildContext context) {
    // Watch progress history for the weight chart
    final progressHistoryAsync = ref.watch(progressHistoryProvider);
    
    // Watch today's progress for the "last weight" display
    final todayProgressAsync = ref.watch(todayProgressProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Header
          Container(
            color: AppColors.greenMid,
            padding: const EdgeInsets.fromLTRB(20, 52, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('📈  Мой прогресс',
                    style: GoogleFonts.rubik(
                        fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.white)),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _HeaderStat('-3.5 кг', 'Результат'),
                    const SizedBox(width: 8),
                    _HeaderStat('8/30', 'Дней'),
                    const SizedBox(width: 8),
                    _HeaderStat('65%', 'Выполнено'),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Weight chart card - with .when() pattern
                progressHistoryAsync.when(
                  loading: () => Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.greenBorder, width: 0.5),
                    ),
                    child: const SizedBox(
                      height: 160,
                      child: Center(
                        child: CircularProgressIndicator(color: AppColors.greenMid),
                      ),
                    ),
                  ),
                  error: (err, stack) => Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.greenBorder, width: 0.5),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.error_outline_rounded,
                            color: AppColors.textMuted, size: 40),
                        const SizedBox(height: 12),
                        Text('Ошибка загрузки данных',
                            style: GoogleFonts.rubik(
                                fontSize: 13, color: AppColors.textDark)),
                        const SizedBox(height: 12),
                        OutlinedButton(
                          onPressed: () => ref.refresh(progressHistoryProvider),
                          child: const Text('Повторить'),
                        ),
                      ],
                    ),
                  ),
                  data: (progressList) {
                    if (progressList.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.greenBorder, width: 0.5),
                        ),
                        child: const SizedBox(
                          height: 160,
                          child: Center(
                            child: Text('Данные о весе отсутствуют'),
                          ),
                        ),
                      );
                    }

                    // Extract weights from ProgressEntity list
                    final weights = progressList.map((p) => p.weight).toList();
                    final weekLabels = <String>[
                      'Нед 1',
                      ...List<String>.filled(weights.length - 2, ''),
                      'Сейчас'
                    ];
                    
                    final maxW = weights.reduce((a, b) => a > b ? a : b);
                    final minW = weights.reduce((a, b) => a < b ? a : b);
                    final range = maxW - minW + 1.0;

                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.greenBorder, width: 0.5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Динамика веса (кг)',
                                  style: GoogleFonts.rubik(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textDark)),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.greenCard,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text('${weights.length} дней',
                                    style: GoogleFonts.rubik(
                                        fontSize: 11,
                                        color: AppColors.greenMid,
                                        fontWeight: FontWeight.w500)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 120,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: weights.asMap().entries.map((entry) {
                                final barH =
                                    ((entry.value - minW + 0.5) / range) * 100 + 20;
                                final isLast = entry.key == weights.length - 1;
                                return Expanded(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 3),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.end,
                                      children: [
                                        if (isLast)
                                          Text(
                                            '${entry.value}',
                                            style: GoogleFonts.rubik(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.greenMid),
                                          ),
                                        const SizedBox(height: 2),
                                        AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 600),
                                          height: barH,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: isLast
                                                  ? [
                                                      AppColors.greenDark,
                                                      AppColors.greenLight
                                                    ]
                                                  : [
                                                      AppColors.greenCard,
                                                      AppColors.greenBorder
                                                    ],
                                              begin: Alignment.bottomCenter,
                                              end: Alignment.topCenter,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          weekLabels[entry.key],
                                          style: GoogleFonts.rubik(
                                              fontSize: 9,
                                              color: AppColors.textMuted),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),

                // Weight entry
                todayProgressAsync.when(
                  loading: () => Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.greenBorder, width: 0.5),
                    ),
                    child: const SizedBox(height: 60),
                  ),
                  error: (err, stack) => Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.greenBorder, width: 0.5),
                    ),
                    child: Text('Ошибка загрузки',
                        style: GoogleFonts.rubik(color: AppColors.textMuted)),
                  ),
                  data: (progress) {
                    final lastWeight = progress?.weight ?? 68.5;
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border:
                            Border.all(color: AppColors.greenBorder, width: 0.5),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Внести вес сегодня',
                                    style: GoogleFonts.rubik(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textDark)),
                                Text('Последний: $lastWeight кг',
                                    style: GoogleFonts.rubik(
                                        fontSize: 12, color: AppColors.textMuted)),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => _showWeightDialog(context, ref),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                            ),
                            child: const Text('+ Добавить'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),

                // Measurements toggle
                GestureDetector(
                  onTap: () =>
                      setState(() => _showMeasurements = !_showMeasurements),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.greenBorder, width: 0.5),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Замеры тела (см)',
                                style: GoogleFonts.rubik(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textDark)),
                            Icon(
                              _showMeasurements
                                  ? Icons.keyboard_arrow_up_rounded
                                  : Icons.keyboard_arrow_down_rounded,
                              color: AppColors.textMuted,
                            ),
                          ],
                        ),
                        if (_showMeasurements) ...[
                          const SizedBox(height: 12),
                          _MeasurementRow('Талия', '72 см', '69.5 см', '-2.5'),
                          _MeasurementRow('Бёдра', '96 см', '94.5 см', '-1.5'),
                          _MeasurementRow('Грудь', '88 см', '87 см', '-1.0'),
                          _MeasurementRow('Живот', '84 см', '82 см', '-2.0'),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () => _showMeasurementsDialog(context, ref),
                              icon: const Icon(Icons.add, size: 16),
                              label: const Text('Обновить замеры'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.greenMid,
                                side: const BorderSide(
                                    color: AppColors.greenBorder),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Achievements
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.greenBorder, width: 0.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Достижения',
                          style: GoogleFonts.rubik(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _AchievementBadge('🌟', '8 дней\nподряд', true),
                          const SizedBox(width: 8),
                          _AchievementBadge('⚡', 'Минус\n3 кг', true),
                          const SizedBox(width: 8),
                          _AchievementBadge('🏆', 'Рекорд\nвеса', true),
                          const SizedBox(width: 8),
                          _AchievementBadge('🎯', '30 дней', false),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showWeightDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Внести вес',
                style: GoogleFonts.rubik(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark)),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: '68.5',
                suffixText: 'кг',
                filled: true,
                fillColor: AppColors.greenSurface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: AppColors.greenMid),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final weight = double.tryParse(controller.text);
                  if (weight != null) {
                    // Call the weight entry notifier
                    await ref
                        .read(weightEntryProvider.notifier)
                        .addWeight(weight);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Сохранить'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMeasurementsDialog(BuildContext context, WidgetRef ref) {
    final controllers = {
      'waist': TextEditingController(),
      'hips': TextEditingController(),
      'chest': TextEditingController(),
      'belly': TextEditingController(),
    };

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Обновить замеры',
                style: GoogleFonts.rubik(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark)),
            const SizedBox(height: 16),
            _MeasurementField(controllers['waist']!, 'Талия', 'см'),
            _MeasurementField(controllers['hips']!, 'Бёдра', 'см'),
            _MeasurementField(controllers['chest']!, 'Грудь', 'см'),
            _MeasurementField(controllers['belly']!, 'Живот', 'см'),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final measurements = {
                    'waist': double.tryParse(controllers['waist']!.text),
                    'hips': double.tryParse(controllers['hips']!.text),
                    'chest': double.tryParse(controllers['chest']!.text),
                    'belly': double.tryParse(controllers['belly']!.text),
                  };

                  if (measurements.values.every((v) => v != null)) {
                    ref
                        .read(measurementsProvider.notifier)
                        .updateMeasurements(measurements.cast<String, double>());
                    Navigator.pop(context);
                  }
                },
                child: const Text('Сохранить'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderStat extends StatelessWidget {
  final String value;
  final String label;
  const _HeaderStat(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(value,
                style: GoogleFonts.rubik(
                    fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.white)),
            Text(label,
                style: GoogleFonts.rubik(fontSize: 11, color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}

class _MeasurementRow extends StatelessWidget {
  final String name;
  final String start;
  final String current;
  final String diff;
  const _MeasurementRow(this.name, this.start, this.current, this.diff);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: Text(name,
                  style: GoogleFonts.rubik(fontSize: 13, color: AppColors.textDark))),
          Expanded(
              child: Text(start,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.rubik(fontSize: 12, color: AppColors.textMuted))),
          Expanded(
              child: Text(current,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.rubik(
                      fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFFFE0E0),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(diff,
                style: GoogleFonts.rubik(
                    fontSize: 12, fontWeight: FontWeight.w600, color: Colors.red.shade700)),
          ),
        ],
      ),
    );
  }
}

class _AchievementBadge extends StatelessWidget {
  final String emoji;
  final String label;
  final bool unlocked;
  const _AchievementBadge(this.emoji, this.label, this.unlocked);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: unlocked ? AppColors.greenCard : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: unlocked ? AppColors.greenBorder : Colors.transparent,
          ),
        ),
        child: Column(
          children: [
            Text(emoji,
                style: TextStyle(
                    fontSize: 22, color: unlocked ? null : const Color(0xFFCCCCCC))),
            const SizedBox(height: 4),
            Text(label,
                textAlign: TextAlign.center,
                style: GoogleFonts.rubik(
                    fontSize: 10,
                    color: unlocked ? AppColors.greenMid : AppColors.textMuted,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

class _MeasurementField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String suffix;

  const _MeasurementField(this.controller, this.label, this.suffix);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType:
            const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          suffixText: suffix,
          filled: true,
          fillColor: AppColors.greenSurface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.greenMid),
          ),
        ),
      ),
    );
  }
}
