import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../widgets/widgets.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final List<double> _weights = [72.0, 71.5, 71.0, 70.3, 69.8, 69.2, 68.5];
  final List<String> _weekLabels = ['Нед 1', '', '', '', '', '', 'Сейчас'];

  bool _showMeasurements = true;

  @override
  Widget build(BuildContext context) {
    final maxW = _weights.reduce((a, b) => a > b ? a : b);
    final minW = _weights.reduce((a, b) => a < b ? a : b);
    final range = maxW - minW + 1.0;

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
                // Weight chart card
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Динамика веса (кг)',
                              style: GoogleFonts.rubik(
                                  fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.greenCard,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text('8 дней',
                                style: GoogleFonts.rubik(
                                    fontSize: 11, color: AppColors.greenMid, fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 120,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: _weights.asMap().entries.map((entry) {
                            final barH = ((entry.value - minW + 0.5) / range) * 100 + 20;
                            final isLast = entry.key == _weights.length - 1;
                            return Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 3),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
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
                                      duration: const Duration(milliseconds: 600),
                                      height: barH,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: isLast
                                              ? [AppColors.greenDark, AppColors.greenLight]
                                              : [AppColors.greenCard, AppColors.greenBorder],
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                        ),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _weekLabels[entry.key],
                                      style: GoogleFonts.rubik(
                                          fontSize: 9, color: AppColors.textMuted),
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
                ),
                const SizedBox(height: 12),

                // Weight entry
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.greenBorder, width: 0.5),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Внести вес сегодня',
                                style: GoogleFonts.rubik(
                                    fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                            Text('Последний: 68.5 кг',
                                style: GoogleFonts.rubik(fontSize: 12, color: AppColors.textMuted)),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => _showWeightDialog(context),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        ),
                        child: const Text('+ Добавить'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Measurements toggle
                GestureDetector(
                  onTap: () => setState(() => _showMeasurements = !_showMeasurements),
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
                                    fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textDark)),
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
                              onPressed: () {},
                              icon: const Icon(Icons.add, size: 16),
                              label: const Text('Обновить замеры'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.greenMid,
                                side: const BorderSide(color: AppColors.greenBorder),
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
                              fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textDark)),
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

  void _showWeightDialog(BuildContext context) {
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
                    fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textDark)),
            const SizedBox(height: 16),
            TextField(
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                  borderSide: const BorderSide(color: AppColors.greenMid),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
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
