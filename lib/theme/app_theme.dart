import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// The app's Material Design 3 theme configuration.
class AppTheme {
  // ─── Color Palette ────────────────────────────────────────
  static const Color _primaryLight = Color(0xFF6C63FF);
  static const Color _primaryDark = Color(0xFF8B83FF);
  static const Color _surfaceLight = Color(0xFFF8F7FF);
  static const Color _surfaceDark = Color(0xFF1A1A2E);
  static const Color _cardLight = Colors.white;
  static const Color _cardDark = Color(0xFF16213E);
  static const Color _backgroundDark = Color(0xFF0F0F23);

  // ─── Light Theme ──────────────────────────────────────────
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorSchemeSeed: _primaryLight,
    scaffoldBackgroundColor: _surfaceLight,
    textTheme: GoogleFonts.poppinsTextTheme(),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF1A1A2E),
      ),
      iconTheme: const IconThemeData(color: Color(0xFF1A1A2E)),
    ),
    cardTheme: CardTheme(
      color: _cardLight,
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _primaryLight,
      foregroundColor: Colors.white,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: _primaryLight,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    iconTheme: const IconThemeData(color: Color(0xFF555555)),
  );

  // ─── Dark Theme ───────────────────────────────────────────
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorSchemeSeed: _primaryDark,
    scaffoldBackgroundColor: _backgroundDark,
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    cardTheme: CardTheme(
      color: _cardDark,
      elevation: 4,
      shadowColor: Colors.black38,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _primaryDark,
      foregroundColor: Colors.white,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: _surfaceDark,
      selectedItemColor: _primaryDark,
      unselectedItemColor: Colors.grey.shade600,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    iconTheme: const IconThemeData(color: Colors.white70),
  );

  // ─── Category Gradient Colors ─────────────────────────────
  /// Returns a gradient for category cards based on the category color.
  static LinearGradient categoryGradient(Color baseColor) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        baseColor.withOpacity(0.85),
        baseColor.withOpacity(0.65),
      ],
    );
  }
}
