import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../theme.dart';
import '../widgets/widgets.dart';
import '../presentation/providers/auth_provider.dart';
import '../presentation/providers/marathon_progress_provider.dart';
import '../presentation/providers/progress_provider.dart';
import '../presentation/providers/profile_picture_provider.dart';
import 'shopping_list_screen.dart';
import 'notifications_screen.dart';
import 'community_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Получаем данные пользователя и прогресса
    final userAsync = ref.watch(authStateProvider);
    final marathonProgressAsync = ref.watch(marathonProgressProvider);
    final progressHistoryAsync = ref.watch(progressHistoryProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: userAsync.when(
        data: (user) {
          final displayName = user?.displayName ?? 'Пользователь';
          final nameParts = displayName.split(' ');
          final initials = nameParts.take(2).map((p) => p.isNotEmpty ? p[0] : '').join('').toUpperCase();
          
          return CustomScrollView(
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
                      _ProfilePictureWidget(initials: initials),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              displayName,
                              style: GoogleFonts.rubik(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => _showEditNameDialog(context, ref, displayName),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.edit_rounded,
                                color: AppColors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      marathonProgressAsync.when(
                        data: (progress) {
                          final stageName = progress?.stageName ?? 'Этап 1';
                          final week = progress?.currentWeek ?? 1;
                          final daysLeft = progress?.remainingDays ?? 0;
                          
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppPill(
                                stageName,
                                bg: const Color(0x33FFFFFF),
                                textColor: AppColors.white,
                              ),
                              const SizedBox(width: 6),
                              AppPill(
                                'Неделя $week',
                                bg: const Color(0x33FFFFFF),
                                textColor: AppColors.white,
                              ),
                              const SizedBox(width: 6),
                              AppPill(
                                '$daysLeft дней',
                                bg: const Color(0x33FFFFFF),
                                textColor: AppColors.white,
                              ),
                            ],
                          );
                        },
                        loading: () => const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                        error: (_, __) => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            AppPill(
                              'Этап -',
                              bg: Color(0x33FFFFFF),
                              textColor: AppColors.white,
                            ),
                            SizedBox(width: 6),
                            AppPill(
                              'Неделя -',
                              bg: Color(0x33FFFFFF),
                              textColor: AppColors.white,
                            ),
                            SizedBox(width: 6),
                            AppPill(
                              '- дней',
                              bg: Color(0x33FFFFFF),
                              textColor: AppColors.white,
                            ),
                          ],
                        ),
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
                  // Статистика веса
                  progressHistoryAsync.when(
                    data: (progressList) {
                      if (progressList.isEmpty) {
                        return Row(
                          children: const [
                            Expanded(child: StatBox(value: '-', label: 'Начальный вес')),
                            SizedBox(width: 8),
                            Expanded(child: StatBox(value: '-', label: 'Текущий вес')),
                            SizedBox(width: 8),
                            Expanded(child: StatBox(value: '-', label: 'Минус кг')),
                          ],
                        );
                      }

                      final firstWeight = progressList.first.weight;
                      final currentWeight = progressList.last.weight;
                      final weightLost = (firstWeight - currentWeight).abs();

                      return Row(
                        children: [
                          Expanded(child: StatBox(value: firstWeight.toStringAsFixed(1), label: 'Начальный вес')),
                          const SizedBox(width: 8),
                          Expanded(child: StatBox(value: currentWeight.toStringAsFixed(1), label: 'Текущий вес')),
                          const SizedBox(width: 8),
                          Expanded(child: StatBox(value: '-${weightLost.toStringAsFixed(1)}', label: 'Минус кг')),
                        ],
                      );
                    },
                    loading: () => Row(
                      children: const [
                        Expanded(child: StatBox(value: '...', label: 'Начальный вес')),
                        SizedBox(width: 8),
                        Expanded(child: StatBox(value: '...', label: 'Текущий вес')),
                        SizedBox(width: 8),
                        Expanded(child: StatBox(value: '...', label: 'Минус кг')),
                      ],
                    ),
                    error: (_, __) => Row(
                      children: const [
                        Expanded(child: StatBox(value: 'Ошибка', label: 'Начальный вес')),
                        SizedBox(width: 8),
                        Expanded(child: StatBox(value: 'Ошибка', label: 'Текущий вес')),
                        SizedBox(width: 8),
                        Expanded(child: StatBox(value: 'Ошибка', label: 'Минус кг')),
                      ],
                    ),
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
      );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Text('Ошибка загрузки профиля: $error'),
        ),
      ),
    );
  }

  /// Диалог для редактирования имени пользователя
  static Future<void> _showEditNameDialog(
    BuildContext context,
    WidgetRef ref,
    String currentName,
  ) async {
    final nameController = TextEditingController(text: currentName);
    
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Изменить имя'),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(
            hintText: 'Введите новое имя',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          maxLines: 1,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () async {
              final newName = nameController.text.trim();
              if (newName.isNotEmpty && newName != currentName) {
                try {
                  // Обновляем профиль пользователя
                  await ref.read(authStateNotifierProvider.notifier).updateUserProfile(
                    displayName: newName,
                  );
                  
                  if (context.mounted) {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Имя успешно обновлено'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Ошибка: $e'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                }
              } else {
                Navigator.pop(ctx);
              }
            },
            child: const Text(
              'Сохранить',
              style: TextStyle(color: AppColors.greenMid),
            ),
          ),
        ],
      ),
    );
    nameController.dispose();
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

/// Виджет для отображения и редактирования профильной картинки
class _ProfilePictureWidget extends ConsumerWidget {
  final String initials;

  const _ProfilePictureWidget({required this.initials});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profilePictureAsync = ref.watch(profilePictureProvider);

    return GestureDetector(
      onTap: () => _showPictureOptionsDialog(context, ref),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.greenCard,
              shape: BoxShape.circle,
              // border: Border.all(color: AppColors.white, width: 3),
            ),
            child: profilePictureAsync.when(
              data: (pictureFile) {
                if (pictureFile != null) {
                  // Показываем загруженную картинку
                  return ClipOval(
                    child: Image.file(
                      pictureFile,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Center(
                        child: Text(
                          initials,
                          style: GoogleFonts.rubik(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.greenDark,
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  // Показываем инициалы
                  return Center(
                    child: Text(
                      initials,
                      style: GoogleFonts.rubik(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.greenDark,
                      ),
                    ),
                  );
                }
              },
              loading: () => Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor:
                        AlwaysStoppedAnimation(AppColors.greenDark),
                  ),
                ),
              ),
              error: (_, __) => Center(
                child: Text(
                  initials,
                  style: GoogleFonts.rubik(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.greenDark,
                  ),
                ),
              ),
            ),
          ),
          // Иконка камеры
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: AppColors.greenMid,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                )
              ],
            ),
            child: const Icon(
              Icons.camera_alt_rounded,
              color: AppColors.white,
              size: 12,
            ),
          ),
        ],
      ),
    );
  }

  void _showPictureOptionsDialog(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Загрузить фото'),
        content: const Text('Выберите источник фотографии'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _pickAndUploadImage(context, ref, ImageSource.camera);
            },
            child: const Text('📷 Камера'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _pickAndUploadImage(context, ref, ImageSource.gallery);
            },
            child: const Text('🖼️ Галерея'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Отмена'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickAndUploadImage(
    BuildContext context,
    WidgetRef ref,
    ImageSource source,
  ) async {
    try {
      // Выбираем картинку
      final imageAsync = await ref
          .read(pickProfilePictureProvider(source).future);
      
      if (imageAsync == null) return;

      // Показываем индикатор загрузки
      if (!context.mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⏳ Сохранение фото...'),
          duration: Duration(seconds: 2),
        ),
      );

      // Сохраняем локально
      await ref
          .read(saveProfilePictureProvider(imageAsync).future);

      if (!context.mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Фото успешно сохранено'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Ошибка: $e'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}
