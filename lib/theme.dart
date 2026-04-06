import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color greenDark = Color(0xFF2D5A1B);
  static const Color greenMid = Color(0xFF3A6B1A);
  static const Color greenAccent = Color(0xFF4A7C2E);
  static const Color greenLight = Color(0xFF5A9E30);
  static const Color greenSurface = Color(0xFFF0F5EB);
  static const Color greenCard = Color(0xFFE8F5D0);
  static const Color greenBorder = Color(0xFFD0E4B0);

  static const Color textDark = Color(0xFF1A2A0A);
  static const Color textMuted = Color(0xFF888888);
  static const Color background = Color(0xFFF5F9F0);
  static const Color white = Color(0xFFFFFFFF);

  static const Color orange = Color(0xFFE65100);
  static const Color orangeLight = Color(0xFFFFF3E0);

  // Meal type colors
  static const Color breakfastBg = Color(0xFFFFE4B0);
  static const Color lunchBg = Color(0xFFFFD0A0);
  static const Color snackBg = Color(0xFFFFE0F0);
  static const Color dinnerBg = Color(0xFFD0F0D0);
}

ThemeData get appTheme => ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.greenMid,
        primary: AppColors.greenMid,
        secondary: AppColors.greenAccent,
        surface: AppColors.white,
        background: AppColors.background,
      ),
      scaffoldBackgroundColor: const Color.fromARGB(255, 126, 219, 11),
      textTheme: GoogleFonts.rubikTextTheme().copyWith(
        displayLarge: GoogleFonts.rubik(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: AppColors.textDark,
        ),
        headlineMedium: GoogleFonts.rubik(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.textDark,
        ),
        titleLarge: GoogleFonts.rubik(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textDark,
        ),
        bodyLarge: GoogleFonts.rubik(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.textDark,
        ),
        bodyMedium: GoogleFonts.rubik(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: AppColors.textMuted,
        ),
        labelSmall: GoogleFonts.rubik(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: AppColors.textMuted,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.greenMid,
        foregroundColor: AppColors.white,
        elevation: 0,
        titleTextStyle: GoogleFonts.rubik(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.greenMid,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
          textStyle: GoogleFonts.rubik(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: AppColors.greenBorder, width: 0.5),
        ),
        margin: EdgeInsets.zero,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.greenMid,
        unselectedItemColor: AppColors.textMuted,
        selectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 11),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
