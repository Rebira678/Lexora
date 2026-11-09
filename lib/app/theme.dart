import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App color scheme — calm, focused palette with one accent color.
/// High contrast, readable, game-like but not childish.
class AppColors {
  // Primary accent — a calm teal/cyan
  static const Color accent = Color(0xFF00BFA5);
  static const Color accentLight = Color(0xFF5DF2D6);
  static const Color accentDark = Color(0xFF008E76);

  // Semantic colors
  static const Color correct = Color(0xFF4CAF50);
  static const Color wrong = Color(0xFFEF5350);
  static const Color warning = Color(0xFFFFA726);
  static const Color combo = Color(0xFFFFD740);
  static const Color xp = Color(0xFF7C4DFF);
  static const Color streak = Color(0xFFFF6D00);

  // Light theme
  static const Color lightBg = Color(0xFFFAFAFA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightText = Color(0xFF212121);
  static const Color lightTextSecondary = Color(0xFF757575);

  // Dark theme
  static const Color darkBg = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkText = Color(0xFFE0E0E0);
  static const Color darkTextSecondary = Color(0xFF9E9E9E);
}

class AppTheme {
  static ThemeData light() {
    return _buildTheme(
      brightness: Brightness.light,
      background: AppColors.lightBg,
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightText,
      onSurfaceSecondary: AppColors.lightTextSecondary,
    );
  }

  static ThemeData dark() {
    return _buildTheme(
      brightness: Brightness.dark,
      background: AppColors.darkBg,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkText,
      onSurfaceSecondary: AppColors.darkTextSecondary,
    );
  }

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color background,
    required Color surface,
    required Color onSurface,
    required Color onSurfaceSecondary,
  }) {
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: AppColors.accent,
      onPrimary: Colors.white,
      primaryContainer: AppColors.accentLight,
      onPrimaryContainer: AppColors.accentDark,
      secondary: AppColors.xp,
      onSecondary: Colors.white,
      secondaryContainer: AppColors.xp.withAlpha(40),
      onSecondaryContainer: AppColors.xp,
      tertiary: AppColors.streak,
      onTertiary: Colors.white,
      error: AppColors.wrong,
      onError: Colors.white,
      surface: surface,
      onSurface: onSurface,
      onSurfaceVariant: onSurfaceSecondary,
      outline: onSurfaceSecondary.withAlpha(80),
    );

    final textTheme = GoogleFonts.interTextTheme(
      TextTheme(
        // Large readable fonts as per spec (minimum 16sp body text)
        displayLarge: TextStyle(fontSize: 36, fontWeight: FontWeight.w800, color: onSurface),
        displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: onSurface),
        displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: onSurface),
        headlineLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: onSurface),
        headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: onSurface),
        headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: onSurface),
        titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: onSurface),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: onSurface),
        titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: onSurface),
        bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: onSurface),
        bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: onSurface),
        bodySmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: onSurfaceSecondary),
        labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: onSurface),
        labelMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: onSurface),
        labelSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: onSurfaceSecondary),
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: background,
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: onSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56), // 48dp+ touch targets
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.accent,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          side: const BorderSide(color: AppColors.accent, width: 2),
          textStyle: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: onSurfaceSecondary.withAlpha(80)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.accent, width: 2),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: onSurfaceSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
