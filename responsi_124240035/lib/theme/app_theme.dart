import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color background = Color(0xFF090C13);
  static const Color surface = Color(0xFF0F131D);
  static const Color cardSurface = Color(0xFF131722);
  static const Color cardBorder = Color(0x1FFFFFFF);

  static const Color primaryPurple = Color(0xFFA855F7);
  static const Color primaryPurpleBright = Color(0xFFB55FE6);
  static const Color portalGreen = Color(0xFFA855F7);
  static const Color onPortalGreen = Colors.white;

  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF8E9AA8);
  static const Color statusDead = Color(0xFFEF4444);
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryPurple,
        onPrimary: Colors.white,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        outline: AppColors.cardBorder,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
      ),
    );
  }
}
