import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../widgets/widgets.dart';
import '../presentation/providers/auth_provider.dart';
import 'shopping_list_screen.dart';
import 'notifications_screen.dart';
import 'community_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.greenMid,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.greenDark, AppColors.greenMid],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: AppColors.greenCard,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.white, width: 3),
                        ),
                        child: Center(
                          child: Text(
                            'АН',
                            style: GoogleFonts.rubik(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: AppColors.greenDark,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Анна Новикова',
                        style: GoogleFonts.rubik(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          AppPill(
                            'Этап 1',
                            bg: Color(0x33FFFFFF),
                            textColor: AppColors.white,
                          ),
                          SizedBox(width: 6),
                          AppPill(
                            'Неделя 2',
                            bg: Color(0x33FFFFFF),
                            textColor: AppColors.white,
                          ),
                          SizedBox(width: 6),
                          AppPill(
                            '8 дней',
                            bg: Color(0x33FFFFFF),
                            textColor: AppColors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: const [
                      StatBox(value: '72.0', label: 'Начальный вес'),
                      SizedBox(width: 8),
                      StatBox(value: '68.5', label: 'Текущий вес'),
                      SizedBox(width: 8),
                      StatBox(value: '-3.5', label: 'Минус кг'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _ProfileSettingsSection(ref: ref, context: context),
                  const SizedBox(height: 32),
                  Text(
                    'Марафон похудения v1.0.0',
                    style: GoogleFonts.rubik(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileSettingsSection extends StatelessWidget {
  final WidgetRef ref;
  final BuildContext context;

  const _ProfileSettingsSection({
    required this.ref,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SettingsCard(
          children: [
            _SettingsTile(
              icon: '⚡',
              iconBg: AppColors.greenCard,
              title: 'Мой уровень питания',
              trailing: Text(
                '180 г',
                style: GoogleFonts.rubik(
                  fontSize: 13,
                  color: AppColors.greenMid,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () {},
            ),
          ],
        ),
        const SizedBox(height: 10),
        _SettingsCard(
          label: 'БЫСТРЫЕ ДЕЙСТВИЯ',
          children: [
            _SettingsTile(
              icon: '🛒',
              iconBg: const Color(0xFFFFF3E0),
              title: 'Список покупок',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ShoppingListScreen()),
              ),
            ),
            _SettingsTile(
              icon: '💬',
              iconBg: const Color(0xFFE8F0FF),
              title: 'Сообщество марафона',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CommunityScreen()),
              ),
            ),
            _SettingsTile(
              icon: '🔔',
              iconBg: const Color(0xFFFCE4EC),
              title: 'Уведомления',
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.greenCard,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '3 новых',
                  style: GoogleFonts.rubik(
                    fontSize: 11,
                    color: AppColors.greenMid,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _SettingsCard(
          label: 'НАСТРОЙКИ',
          children: const [
            _SettingsTile(
              icon: '📏',
              iconBg: Color(0xFFFCE4EC),
              title: 'Мои замеры',
              onTap: null,
            ),
            _ProfileSwitch(
              icon: '🔔',
              iconBg: Color(0xFFE8F5D0),
              title: 'Push-уведомления',
              initialValue: true,
            ),
            _ProfileSwitch(
              icon: '💧',
              iconBg: Color(0xFFE8F0FF),
              title: 'Напоминания о воде',
              initialValue: true,
            ),
          ],
        ),
        const SizedBox(height: 10),
        _SettingsCard(
          children: [
            _SettingsTile(
              icon: '📞',
              iconBg: const Color(0xFFE8F0FF),
              title: 'Связь с куратором',
              subtitle: 'Написать в Telegram',
              onTap: () {},
            ),
            _SettingsTile(
              icon: '⭐',
              iconBg: const Color(0xFFFFF3E0),
              title: 'Оценить приложение',
              onTap: () {},
            ),
          ],
        ),
        const SizedBox(height: 10),
        _SettingsCard(
          children: [
            _SettingsTile(
              icon: '🚪',
              iconBg: const Color(0xFFFFE8E8),
              title: 'Выйти из аккаунта',
              titleColor: Colors.red,
              onTap: () => _showLogoutDialog(context),
              showChevron: false,
            ),
            _SettingsTile(
              icon: '🗑️',
              iconBg: const Color(0xFFFFE8E8),
              title: 'Удалить аккаунт',
              titleColor: Colors.red,
              onTap: () => _showDeleteDialog(context),
              showChevron: false,
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Выйти из аккаунта?'),
        content: const Text('Вы уверены, что хотите выйти из системы?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Выйти', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (shouldLogout == true && context.mounted) {
      await ref.read(authStateNotifierProvider.notifier).logout();
    }
  }

  Future<void> _showDeleteDialog(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Удалить аккаунт?'),
        content: const Text(
          'Это действие необратимо. Все ваши данные будут удалены.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Удалить', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (shouldDelete == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Функция удаления аккаунта скоро будет доступна'),
        ),
      );
    }
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  final String? label;

  const _SettingsCard({
    required this.children,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 6),
            child: Text(
              label!,
              style: GoogleFonts.rubik(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.textMuted,
                letterSpacing: 0.05,
              ),
            ),
          ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.greenBorder, width: 0.5),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String icon;
  final Color iconBg;
  final String title;
  final String? subtitle;
  final Color? titleColor;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showChevron;

  const _SettingsTile({
    required this.icon,
    required this.iconBg,
    required this.title,
    this.subtitle,
    this.titleColor,
    this.trailing,
    this.onTap,
    this.showChevron = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.greenSurface, width: 0.5)),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(icon, style: const TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.rubik(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: titleColor ?? AppColors.textDark,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: GoogleFonts.rubik(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                ],
              ),
            ),
            ...(trailing != null ? [trailing!] : []),
            if (trailing == null && showChevron)
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textMuted,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}

class _ProfileSwitch extends StatefulWidget {
  final String icon;
  final Color iconBg;
  final String title;
  final bool initialValue;

  const _ProfileSwitch({
    required this.icon,
    required this.iconBg,
    required this.title,
    required this.initialValue,
  });

  @override
  State<_ProfileSwitch> createState() => _ProfileSwitchState();
}

class _ProfileSwitchState extends State<_ProfileSwitch> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.greenSurface, width: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: widget.iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(widget.icon, style: const TextStyle(fontSize: 18)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.title,
              style: GoogleFonts.rubik(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textDark,
              ),
            ),
          ),
          Switch(
            value: _value,
            onChanged: (v) => setState(() => _value = v),
            activeThumbColor: AppColors.greenMid,
          ),
        ],
      ),
    );
  }
}
