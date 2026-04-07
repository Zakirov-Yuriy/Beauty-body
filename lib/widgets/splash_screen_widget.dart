import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../theme.dart';

class SplashScreenWidget extends StatefulWidget {
  const SplashScreenWidget({super.key});

  @override
  State<SplashScreenWidget> createState() => _SplashScreenWidgetState();
}

class _SplashScreenWidgetState extends State<SplashScreenWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0xFFECEAD7),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Color(0xFFECEAD7),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Логотип или иконка приложения
                  Padding(
                    padding: const EdgeInsets.only(top: 180),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: SizedBox(
                        width: 200,
                        height: 200,
                        child: Image.asset(
                          'assets/splash_screen_widget.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  // Название приложения
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [
                        AppColors.greenMid,
                        AppColors.greenLight,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds),
                    blendMode: BlendMode.srcIn,
                    child: Text(
                      'Beauty Body',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  // Loading индикатор
                  LoadingAnimationWidget.inkDrop(
                    color: AppColors.greenMid,
                    size: 60,
                  ),
                  const SizedBox(height: 20),
                  // Текст загрузки
                  // Text(
                  //   'Загрузка...',
                  //   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  //         color: AppColors.white.withOpacity(0.8),
                  //       ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
