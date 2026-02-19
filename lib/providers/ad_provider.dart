import 'package:flutter/material.dart';
import '../services/ad_service.dart';
import '../services/preferences_service.dart';

/// Manages ad state: interaction counting and premium unlocks.
class AdProvider extends ChangeNotifier {
  final AdService _adService = AdService();
  final PreferencesService _prefsService = PreferencesService();
  Set<String> _unlockedCategories = {};

  AdService get adService => _adService;
  Set<String> get unlockedCategories => _unlockedCategories;

  /// Initialize ads SDK and load unlocked categories.
  Future<void> init() async {
    await _adService.initialize();
    _unlockedCategories = await _prefsService.getUnlockedPremium();
    notifyListeners();
  }

  /// Check if premium quotes are unlocked for a category.
  bool isPremiumUnlocked(String category) {
    return _unlockedCategories.contains(category);
  }

  /// Record a user interaction (copy/share). Shows interstitial every 5.
  void recordInteraction() {
    _adService.recordInteraction(onAdShown: () {
      // Ad was shown
    });
  }

  /// Show rewarded ad to unlock premium quotes for a category.
  void showRewardedAd(String category) {
    _adService.showRewardedAd(
      onRewarded: () async {
        _unlockedCategories.add(category);
        await _prefsService.unlockPremium(category);
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    _adService.dispose();
    super.dispose();
  }
}
