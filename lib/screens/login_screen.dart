import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLogin = true;
  bool _obscure = true;
  final _phoneController = TextEditingController();
  final _passController = TextEditingController();
  final _nameController = TextEditingController();

  void _submit() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const HomeScreen(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              // Logo
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.greenCard,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(child: Text('🌿', style: TextStyle(fontSize: 36))),
              ),
              const SizedBox(height: 20),
              Text(
                _isLogin ? 'Добро пожаловать!' : 'Регистрация',
                style: GoogleFonts.rubik(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _isLogin ? 'Войди, чтобы продолжить марафон' : 'Создай аккаунт для доступа',
                style: GoogleFonts.rubik(fontSize: 14, color: AppColors.textMuted),
              ),
              const SizedBox(height: 36),

              // Toggle
              Container(
                decoration: BoxDecoration(
                  color: AppColors.greenSurface,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    _ToggleBtn(
                      label: 'Войти',
                      isActive: _isLogin,
                      onTap: () => setState(() => _isLogin = true),
                    ),
                    _ToggleBtn(
                      label: 'Регистрация',
                      isActive: !_isLogin,
                      onTap: () => setState(() => _isLogin = false),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Fields
              if (!_isLogin) ...[
                _InputField(
                  controller: _nameController,
                  hint: 'Твоё имя',
                  icon: Icons.person_outline_rounded,
                ),
                const SizedBox(height: 12),
              ],
              _InputField(
                controller: _phoneController,
                hint: 'Номер телефона',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              _InputField(
                controller: _passController,
                hint: 'Пароль',
                icon: Icons.lock_outline_rounded,
                obscure: _obscure,
                suffix: GestureDetector(
                  onTap: () => setState(() => _obscure = !_obscure),
                  child: Icon(
                    _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    color: AppColors.textMuted,
                    size: 20,
                  ),
                ),
              ),

              if (_isLogin) ...[
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text('Забыла пароль?',
                        style: GoogleFonts.rubik(
                            fontSize: 13, color: AppColors.greenAccent)),
                  ),
                ),
              ] else
                const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: Text(_isLogin ? 'Войти' : 'Создать аккаунт'),
                ),
              ),
              const SizedBox(height: 20),

              // Divider
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text('или',
                        style: GoogleFonts.rubik(
                            fontSize: 13, color: AppColors.textMuted)),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 16),

              // Telegram button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _submit,
                  icon: const Text('✈️', style: TextStyle(fontSize: 16)),
                  label: Text('Войти через Telegram',
                      style: GoogleFonts.rubik(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textDark)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.greenBorder),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _ToggleBtn extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _ToggleBtn({required this.label, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? AppColors.greenMid : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.rubik(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isActive ? AppColors.white : AppColors.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscure;
  final TextInputType? keyboardType;
  final Widget? suffix;

  const _InputField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.keyboardType,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: GoogleFonts.rubik(fontSize: 14, color: AppColors.textDark),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.rubik(fontSize: 14, color: AppColors.textMuted),
        prefixIcon: Icon(icon, color: AppColors.textMuted, size: 20),
        suffixIcon: suffix,
        filled: true,
        fillColor: AppColors.greenSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.greenBorder, width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.greenBorder, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.greenMid, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
