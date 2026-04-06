import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../models/data.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  Color _hexColor(String hex) {
    return Color(int.parse('FF$hex', radix: 16));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('🔔  Уведомления'),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text('Прочитать все',
                style: GoogleFonts.rubik(fontSize: 13, color: Colors.white70)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _GroupLabel('СЕГОДНЯ'),
          const SizedBox(height: 6),
          ...AppData.notifications.take(3).map((n) => _NotifCard(
                n: n,
                bgColor: _hexColor(n.bgColorHex),
              )),
          const SizedBox(height: 16),
          _GroupLabel('ВЧЕРА'),
          const SizedBox(height: 6),
          ...AppData.notifications.skip(3).map((n) => _NotifCard(
                n: n,
                bgColor: _hexColor(n.bgColorHex),
                isRead: true,
              )),
        ],
      ),
    );
  }
}

class _GroupLabel extends StatelessWidget {
  final String text;
  const _GroupLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.rubik(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppColors.textMuted,
        letterSpacing: 0.08,
      ),
    );
  }
}

class _NotifCard extends StatelessWidget {
  final NotificationItem n;
  final Color bgColor;
  final bool isRead;

  const _NotifCard({required this.n, required this.bgColor, this.isRead = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isRead ? AppColors.white : AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isRead ? AppColors.greenBorder : AppColors.greenAccent.withOpacity(0.3),
          width: isRead ? 0.5 : 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
            child: Center(child: Text(n.emoji, style: const TextStyle(fontSize: 22))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(n.title,
                          style: GoogleFonts.rubik(
                            fontSize: 14,
                            fontWeight: isRead ? FontWeight.w500 : FontWeight.w600,
                            color: AppColors.textDark,
                          )),
                    ),
                    if (!isRead)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.greenLight,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(n.subtitle,
                    style: GoogleFonts.rubik(fontSize: 12, color: AppColors.textMuted, height: 1.4)),
                const SizedBox(height: 4),
                Text(n.time,
                    style: GoogleFonts.rubik(fontSize: 11, color: AppColors.textMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
