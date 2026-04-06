import 'package:flutter/material.dart';
import '../theme.dart';
import 'package:google_fonts/google_fonts.dart';

// ─────────────────────────────────────────
// BOTTOM NAVIGATION BAR
// ─────────────────────────────────────────
class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.greenBorder, width: 0.5)),
        boxShadow: [BoxShadow(color: Color(0x10000000), blurRadius: 10, offset: Offset(0, -2))],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        elevation: 0,
        backgroundColor: Colors.transparent,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Главная'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month_rounded), label: 'Меню'),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart_rounded), label: 'Прогресс'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Профиль'),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// GREEN HEADER
// ─────────────────────────────────────────
class GreenHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Widget? bottom;

  const GreenHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.greenMid,
      padding: const EdgeInsets.fromLTRB(20, 52, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.rubik(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: GoogleFonts.rubik(
                          fontSize: 13,
                          color: Colors.white70,
                        ),
                      ),
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          if (bottom != null) ...[const SizedBox(height: 12), bottom!],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// MEAL CARD (small)
// ─────────────────────────────────────────
class MealCard extends StatelessWidget {
  final String emoji;
  final String type;
  final String name;
  final String portion;
  final Color emojiBackground;
  final bool isDone;
  final String? timeLabel;
  final VoidCallback? onTap;

  const MealCard({
    super.key,
    required this.emoji,
    required this.type,
    required this.name,
    required this.portion,
    required this.emojiBackground,
    this.isDone = false,
    this.timeLabel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.greenBorder, width: 0.5),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(color: emojiBackground, borderRadius: BorderRadius.circular(12)),
              child: Center(child: Text(emoji, style: const TextStyle(fontSize: 22))),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(type,
                      style: GoogleFonts.rubik(
                          fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 2),
                  Text(name,
                      style: GoogleFonts.rubik(
                          fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                  const SizedBox(height: 2),
                  Text(portion,
                      style: GoogleFonts.rubik(fontSize: 12, color: AppColors.textMuted)),
                ],
              ),
            ),
            if (isDone)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.greenCard,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('✓',
                    style: GoogleFonts.rubik(
                        fontSize: 12, color: AppColors.greenMid, fontWeight: FontWeight.w700)),
              )
            else if (timeLabel != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.orangeLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(timeLabel!,
                    style: GoogleFonts.rubik(
                        fontSize: 11, color: AppColors.orange, fontWeight: FontWeight.w600)),
              )
            else
              const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// STAT BOX
// ─────────────────────────────────────────
class StatBox extends StatelessWidget {
  final String value;
  final String label;

  const StatBox({super.key, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.greenSurface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(value,
                style: GoogleFonts.rubik(
                    fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.greenMid)),
            const SizedBox(height: 2),
            Text(label,
                style: GoogleFonts.rubik(fontSize: 11, color: AppColors.textMuted),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// SECTION TITLE
// ─────────────────────────────────────────
class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.rubik(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.greenDark,
      ),
    );
  }
}

// ─────────────────────────────────────────
// PILL / BADGE
// ─────────────────────────────────────────
class AppPill extends StatelessWidget {
  final String label;
  final Color bg;
  final Color textColor;

  const AppPill(this.label, {super.key, this.bg = AppColors.greenCard, this.textColor = AppColors.greenMid});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(label,
          style: GoogleFonts.rubik(fontSize: 11, fontWeight: FontWeight.w600, color: textColor)),
    );
  }
}

// ─────────────────────────────────────────
// PROGRESS BAR
// ─────────────────────────────────────────
class AppProgressBar extends StatelessWidget {
  final double value; // 0.0 – 1.0
  final Color? trackColor;
  final Color? fillColor;
  final double height;

  const AppProgressBar({
    super.key,
    required this.value,
    this.trackColor,
    this.fillColor,
    this.height = 6,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height),
      child: LinearProgressIndicator(
        value: value,
        minHeight: height,
        backgroundColor: trackColor ?? Colors.white24,
        valueColor: AlwaysStoppedAnimation<Color>(fillColor ?? AppColors.white),
      ),
    );
  }
}
