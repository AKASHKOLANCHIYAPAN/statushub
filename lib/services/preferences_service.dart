import 'package:shared_preferences/shared_preferences.dart';

/// Manages app preferences (dark mode, unlocked premium categories).
class PreferencesService {
  static const String _darkModeKey = 'dark_mode';
  static const String _unlockedPremiumKey = 'unlocked_premium';

  /// Get the saved dark mode preference.
  Future<bool> getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_darkModeKey) ?? false;
  }

  /// Save the dark mode preference.
  Future<void> setDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, value);
  }

  /// Get set of unlocked premium categories.
  Future<Set<String>> getUnlockedPremium() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> unlocked =
        prefs.getStringList(_unlockedPremiumKey) ?? [];
    return unlocked.toSet();
  }

  /// Unlock premium quotes for a category.
  Future<void> unlockPremium(String category) async {
    final prefs = await SharedPreferences.getInstance();
    final Set<String> unlocked = await getUnlockedPremium();
    unlocked.add(category);
    await prefs.setStringList(_unlockedPremiumKey, unlocked.toList());
  }
}
