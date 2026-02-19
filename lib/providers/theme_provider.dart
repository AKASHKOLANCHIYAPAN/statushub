import 'package:flutter/material.dart';
import '../services/preferences_service.dart';

/// Manages theme mode (light/dark) with persistence.
class ThemeProvider extends ChangeNotifier {
  final PreferencesService _prefsService = PreferencesService();
  ThemeMode _themeMode = ThemeMode.light;
  bool _isDarkMode = false;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _isDarkMode;

  /// Load saved theme preference.
  Future<void> init() async {
    _isDarkMode = await _prefsService.getDarkMode();
    _themeMode = _isDarkMode ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  /// Toggle between light and dark mode.
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    _themeMode = _isDarkMode ? ThemeMode.dark : ThemeMode.light;
    await _prefsService.setDarkMode(_isDarkMode);
    notifyListeners();
  }
}
