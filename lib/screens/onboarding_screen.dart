import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import 'login_screen.dart';

class _OnboardPage {
  final String emoji;
  final String title;
  final String subtitle;
  final List<String> features;

  const _OnboardPage({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.features,
  });
}

class OnboardingScreen extends ConsumerStatefulWidget {
  final VoidCallback? onComplete;

  const OnboardingScreen({super.key, this.onComplete});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardPage> _pages = const [
    _OnboardPage(
      emoji: '🥗',
      title: 'Персональный\nплан питания',
      subtitle: 'Сбалансированное меню на каждый день, составленное специально для твоих целей',
      features: ['4 приёма пищи в день', 'Рецепты с КБЖУ', 'Список покупок'],
    ),
    _OnboardPage(
      emoji: '📈',
      title: 'Отслеживай\nпрогресс',
      subtitle: 'Фиксируй вес и замеры, наблюдай за изменениями и получай мотивацию каждый день',
      features: ['График снижения веса', 'Замеры тела', 'Достижения'],
    ),
    _OnboardPage(
      emoji: '💬',
      title: 'Сообщество\nучастниц',
      subtitle: 'Поддержка, вдохновение и живое общение с теми, кто идёт этим путём вместе с тобой',
      features: ['Чат марафона', 'Связь с куратором', 'Уведомления'],
    ),
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      // Onboarding завершен
      if (widget.onComplete != null) {
        widget.onComplete!();
      } else {
        // Fallback если нет callback
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () {
                  if (widget.onComplete != null) {
                    widget.onComplete!();
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  }
                },
                child: Text('Пропустить',
                    style: GoogleFonts.rubik(
                        fontSize: 14, color: AppColors.textMuted)),
              ),
            ),

            // Pages
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: _pages.length,
                itemBuilder: (_, i) => _OnboardPageView(page: _pages[i]),
              ),
            ),

            // Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pages.length, (i) {
                final isActive = i == _currentPage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isActive ? 20 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.greenMid : AppColors.greenBorder,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
            const SizedBox(height: 28),

            // Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _nextPage,
                  child: Text(
                    _currentPage < _pages.length - 1 ? 'Далее →' : 'Начать марафон',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _OnboardPageView extends StatelessWidget {
  final _OnboardPage page;
  const _OnboardPageView({required this.page});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 160,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE8F5D0), Color(0xFFC8E6A0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Center(child: Text(page.emoji, style: const TextStyle(fontSize: 72))),
          ),
          const SizedBox(height: 32),
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.rubik(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            page.subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.rubik(
              fontSize: 15,
              color: AppColors.textMuted,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24),
          ...page.features.map((f) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle_rounded, color: AppColors.greenLight, size: 18),
                    const SizedBox(width: 8),
                    Text(f,
                        style: GoogleFonts.rubik(
                            fontSize: 14, color: AppColors.textDark, fontWeight: FontWeight.w500)),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
