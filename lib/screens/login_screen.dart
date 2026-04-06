import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLogin = true;
  bool _obscure = true;
  bool _isLoading = false;
  final _phoneController = TextEditingController();
  final _passController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final AuthService _authService = AuthService();
  String? _errorMessage;

  @override
  void dispose() {
    _phoneController.dispose();
    _passController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_validateForm()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      if (_isLogin) {
        // Логин
        final email = _emailController.text.trim();
        final password = _passController.text;

        await _authService.loginWithEmail(
          email: email,
          password: password,
        );

        if (mounted) {
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
      } else {
        // Регистрация
        final email = _emailController.text.trim();
        final password = _passController.text;
        final name = _nameController.text.trim();

        await _authService.registerWithEmail(
          email: email,
          password: password,
          name: name,
        );

        if (mounted) {
          // Показываем сообщение об успешной регистрации
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('✅ Аккаунт создан! Войдите в систему'),
              backgroundColor: Colors.green[600],
              duration: const Duration(seconds: 3),
            ),
          );

          // Очищаем форму
          _emailController.clear();
          _passController.clear();
          _nameController.clear();

          // Переключаемся на режим логина
          setState(() {
            _isLogin = true;
            _errorMessage = null;
          });
        }
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = _getErrorMessage(e.code);
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Произошла ошибка: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  bool _validateForm() {
    if (_isLogin) {
      if (_emailController.text.isEmpty || _passController.text.isEmpty) {
        setState(() => _errorMessage = 'Заполните все поля');
        return false;
      }
    } else {
      if (_nameController.text.isEmpty ||
          _emailController.text.isEmpty ||
          _passController.text.isEmpty) {
        setState(() => _errorMessage = 'Заполните все поля');
        return false;
      }
      if (_passController.text.length < 6) {
        setState(
            () => _errorMessage = 'Пароль должен быть не менее 6 символов');
        return false;
      }
    }
    return true;
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Пользователь не найден';
      case 'wrong-password':
        return 'Неверный пароль';
      case 'email-already-in-use':
        return 'Этот email уже используется';
      case 'weak-password':
        return 'Пароль слишком слабый';
      case 'invalid-email':
        return 'Неверный формат email';
      default:
        return 'Ошибка: $code';
    }
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
                      onTap: () {
                        setState(() {
                          _isLogin = true;
                          _errorMessage = null;
                        });
                      },
                    ),
                    _ToggleBtn(
                      label: 'Регистрация',
                      isActive: !_isLogin,
                      onTap: () {
                        setState(() {
                          _isLogin = false;
                          _errorMessage = null;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Error message
              if (_errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red[400]!, width: 1),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: GoogleFonts.rubik(
                            fontSize: 13,
                            color: Colors.red[900],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Fields
              if (!_isLogin) ...[
                _InputField(
                  controller: _nameController,
                  hint: 'Твоё имя',
                  icon: Icons.person_outline_rounded,
                  enabled: !_isLoading,
                ),
                const SizedBox(height: 12),
              ],
              _InputField(
                controller: _emailController,
                hint: 'Email',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                enabled: !_isLoading,
              ),
              const SizedBox(height: 12),
              _InputField(
                controller: _passController,
                hint: 'Пароль',
                icon: Icons.lock_outline_rounded,
                obscure: _obscure,
                enabled: !_isLoading,
                suffix: GestureDetector(
                  onTap: _isLoading ? null : () => setState(() => _obscure = !_obscure),
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
                    onPressed: _isLoading ? null : () {},
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
                  onPressed: _isLoading ? null : _submit,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(_isLogin ? 'Войти' : 'Создать аккаунт'),
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
                  onPressed: _isLoading ? null : () {},
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
  final bool enabled;
  final TextInputType? keyboardType;
  final Widget? suffix;

  const _InputField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.enabled = true,
    this.keyboardType,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      enabled: enabled,
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
