import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Premium, senior-level 2-color design system:
/// - Base Canvas & Surfaces: Deep Obsidian (Dark) / Clean Studio Paper (Light)
/// - Single Primary Brand Accent: Modern Electric Indigo (#6366F1 / #4F46E5)
/// - Single Subtle Functional Accent: Clean Emerald (#10B981) for success confirmation
/// Strict typographic hierarchy, zero cartoon colors, zero visual clutter.
class AppColors {
  // Brand Color 1: Electric Indigo (Single signature accent)
  static const Color accent = Color(0xFF6366F1);
  static const Color accentLight = Color(0xFF818CF8);
  static const Color accentDark = Color(0xFF4F46E5);

  // Functional Semantic Accents (Used sparingly & strictly for feedback)
  static const Color correct = Color(0xFF10B981);
  static const Color wrong = Color(0xFFEF4444);

  // Brand unified accent (Replaces rainbow colors with consistent brand palette)
  static const Color combo = Color(0xFF6366F1);
  static const Color xp = Color(0xFF6366F1);
  static const Color streak = Color(0xFF6366F1);
  static const Color warning = Color(0xFFF59E0B);

  // Dark theme surfaces (Deep Obsidian & Slate Hairlines)
  static const Color darkBg = Color(0xFF0A0C10);
  static const Color darkSurface = Color(0xFF12151E);
  static const Color darkSurfaceElevated = Color(0xFF181C28);
  static const Color darkBorder = Color(0xFF222838);
  static const Color darkText = Color(0xFFF3F4F6);
  static const Color darkTextSecondary = Color(0xFF9CA3AF);

  // Light theme surfaces (Clean Paper & Subtle Borders)
  static const Color lightBg = Color(0xFFF8F9FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceElevated = Color(0xFFF3F4F6);
  static const Color lightBorder = Color(0xFFE5E7EB);
  static const Color lightText = Color(0xFF111827);
  static const Color lightTextSecondary = Color(0xFF6B7280);
}

class AppTheme {
  static ThemeData light() {
    return _buildTheme(
      brightness: Brightness.light,
      background: AppColors.lightBg,
      surface: AppColors.lightSurface,
      border: AppColors.lightBorder,
      onSurface: AppColors.lightText,
      onSurfaceSecondary: AppColors.lightTextSecondary,
      primaryAccent: AppColors.accentDark,
    );
  }

  static ThemeData dark() {
    return _buildTheme(
      brightness: Brightness.dark,
      background: AppColors.darkBg,
      surface: AppColors.darkSurface,
      border: AppColors.darkBorder,
      onSurface: AppColors.darkText,
      onSurfaceSecondary: AppColors.darkTextSecondary,
      primaryAccent: AppColors.accent,
    );
  }

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color background,
    required Color surface,
    required Color border,
    required Color onSurface,
    required Color onSurfaceSecondary,
    required Color primaryAccent,
  }) {
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: primaryAccent,
      onPrimary: Colors.white,
      primaryContainer: primaryAccent.withAlpha(30),
      onPrimaryContainer: primaryAccent,
      secondary: primaryAccent,
      onSecondary: Colors.white,
      secondaryContainer: primaryAccent.withAlpha(25),
      onSecondaryContainer: primaryAccent,
      tertiary: onSurface,
      onTertiary: background,
      error: AppColors.wrong,
      onError: Colors.white,
      surface: surface,
      onSurface: onSurface,
      onSurfaceVariant: onSurfaceSecondary,
      outline: border,
      outlineVariant: border,
    );

    // Highly consistent, mathematical typographic hierarchy via GoogleFonts.inter
    final textTheme = GoogleFonts.interTextTheme(
      TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, letterSpacing: -0.8, color: onSurface),
        displayMedium: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, letterSpacing: -0.6, color: onSurface),
        displaySmall: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, letterSpacing: -0.4, color: onSurface),
        headlineLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, letterSpacing: -0.3, color: onSurface),
        headlineMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: -0.2, color: onSurface),
        headlineSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: -0.2, color: onSurface),
        titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: onSurface),
        titleMedium: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: onSurface),
        titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: onSurface),
        bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, height: 1.5, color: onSurface),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, height: 1.45, color: onSurface),
        bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, height: 1.4, color: onSurfaceSecondary),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.1, color: onSurface),
        labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.2, color: onSurface),
        labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.5, color: onSurfaceSecondary),
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: background,
      dividerTheme: DividerThemeData(color: border, thickness: 1),
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
          color: onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: border, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: primaryAccent,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          elevation: 0,
          foregroundColor: onSurface,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          side: BorderSide(color: border, width: 1),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: border, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryAccent, width: 1.5),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primaryAccent,
        unselectedItemColor: onSurfaceSecondary,
        selectedLabelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
