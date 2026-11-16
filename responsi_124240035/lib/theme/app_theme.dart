import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Canvas & Surface
  static const Color background = Color(0xFF151A20);
  static const Color surface = Color(0xFF151A20);
  static const Color surfaceLowest = Color(0xFF0A0F14);
  static const Color cardSurface = Color(0xFF222A32);
  static const Color cardBorder = Color(0x0FFFFFFF); // rgba(255, 255, 255, 0.06)
  static const Color inputSurface = Color(0xFF1B2026);

  // Accents
  static const Color portalGreen = Color(0xFF97CE4C); // Primary
  static const Color onPortalGreen = Color(0xFF151A20);
  static const Color rickBlue = Color(0xFF82CFEA); // Secondary (telemetry & episodes)
  static const Color mortyYellow = Color(0xFFF0E14A); // Tertiary (Favorites)

  // Typography
  static const Color textPrimary = Color(0xFFF4F4F0);
  static const Color textSecondary = Color(0xFFA7B0B8);

  // Status Signals
  static const Color statusAlive = Color(0xFF97CE4C);
  static const Color statusDead = Color(0xFFF16B6B);
  static const Color statusUnknown = Color(0xFFA7B0B8);
}

class AppTextStyles {
  // Space Grotesk for headlines, titles, and tactical labels
  static TextStyle display({Color color = AppColors.textPrimary}) =>
      GoogleFonts.spaceGrotesk(fontSize: 36, fontWeight: FontWeight.w700, color: color, letterSpacing: -0.72);

  static TextStyle headlineLg({Color color = AppColors.textPrimary}) =>
      GoogleFonts.spaceGrotesk(fontSize: 24, fontWeight: FontWeight.w700, color: color, letterSpacing: -0.24);

  static TextStyle headlineMd({Color color = AppColors.textPrimary}) =>
      GoogleFonts.spaceGrotesk(fontSize: 20, fontWeight: FontWeight.w600, color: color);

  static TextStyle headlineSm({Color color = AppColors.textPrimary}) =>
      GoogleFonts.spaceGrotesk(fontSize: 16, fontWeight: FontWeight.w600, color: color);

  static TextStyle labelLg({Color color = AppColors.textPrimary}) =>
      GoogleFonts.spaceGrotesk(fontSize: 14, fontWeight: FontWeight.w600, color: color, letterSpacing: 0.28);

  static TextStyle labelMd({Color color = AppColors.textPrimary}) =>
      GoogleFonts.spaceGrotesk(fontSize: 12, fontWeight: FontWeight.w600, color: color, letterSpacing: 0.48);

  static TextStyle labelSm({Color color = AppColors.textPrimary}) =>
      GoogleFonts.spaceGrotesk(fontSize: 10, fontWeight: FontWeight.w700, color: color, letterSpacing: 0.6);

  // DM Sans for readable descriptions and body copy
  static TextStyle bodyLg({Color color = AppColors.textPrimary}) =>
      GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.w400, color: color);

  static TextStyle bodyMd({Color color = AppColors.textSecondary}) =>
      GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w400, color: color);

  static TextStyle bodySm({Color color = AppColors.textSecondary}) =>
      GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w400, color: color);
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: GoogleFonts.dmSans().fontFamily,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.portalGreen,
        onPrimary: AppColors.onPortalGreen,
        secondary: AppColors.rickBlue,
        tertiary: AppColors.mortyYellow,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        outline: AppColors.cardBorder,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.spaceGrotesk(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.cardBorder, width: 1),
        ),
      ),
    );
  }
}