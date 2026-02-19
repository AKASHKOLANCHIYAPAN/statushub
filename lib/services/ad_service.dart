import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io';

/// Manages all AdMob ad units: banner, interstitial, and rewarded.
///
/// ╔══════════════════════════════════════════════════════════╗
/// ║  IMPORTANT: Replace test IDs with your real AdMob IDs   ║
/// ║  before publishing to the Play Store.                   ║
/// ║  Search for "REPLACE_WITH_REAL_ID" in this file.        ║
/// ╚══════════════════════════════════════════════════════════╝
class AdService {
  // ─── Test Ad Unit IDs (Google-provided) ───────────────────
  // REPLACE_WITH_REAL_ID: Replace these with your actual AdMob unit IDs.

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111'; // Android test banner
    }
    return 'ca-app-pub-3940256099942544/2934735716'; // iOS test banner
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712'; // Android test interstitial
    }
    return 'ca-app-pub-3940256099942544/4411468910'; // iOS test interstitial
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/5224354917'; // Android test rewarded
    }
    return 'ca-app-pub-3940256099942544/1712485313'; // iOS test rewarded
  }

  // ─── Interaction counter for interstitial ads ─────────────
  int _interactionCount = 0;
  static const int _interstitialThreshold = 5;

  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  bool _isInterstitialLoaded = false;
  bool _isRewardedLoaded = false;

  bool get isRewardedAdLoaded => _isRewardedLoaded;

  /// Initializes the Mobile Ads SDK.
  Future<void> initialize() async {
    await MobileAds.instance.initialize();
    _loadInterstitialAd();
    _loadRewardedAd();
  }

  /// Call this after each user interaction (copy/share).
  /// Shows interstitial ad every [_interstitialThreshold] interactions.
  void recordInteraction({required Function onAdShown}) {
    _interactionCount++;
    if (_interactionCount >= _interstitialThreshold) {
      _interactionCount = 0;
      showInterstitialAd(onAdShown: onAdShown);
    }
  }

  // ─── Banner Ad ────────────────────────────────────────────

  /// Creates a BannerAd instance. Use in a widget.
  BannerAd createBannerAd({
    required Function onAdLoaded,
    required Function onAdFailed,
  }) {
    return BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) => onAdLoaded(),
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          onAdFailed();
        },
      ),
    );
  }

  // ─── Interstitial Ad ─────────────────────────────────────

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialLoaded = true;
        },
        onAdFailedToLoad: (error) {
          _isInterstitialLoaded = false;
        },
      ),
    );
  }

  void showInterstitialAd({required Function onAdShown}) {
    if (_isInterstitialLoaded && _interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _isInterstitialLoaded = false;
          _loadInterstitialAd(); // Pre-load the next one
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _isInterstitialLoaded = false;
          _loadInterstitialAd();
        },
      );
      _interstitialAd!.show();
      onAdShown();
    } else {
      _loadInterstitialAd();
    }
  }

  // ─── Rewarded Ad ──────────────────────────────────────────

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isRewardedLoaded = true;
        },
        onAdFailedToLoad: (error) {
          _isRewardedLoaded = false;
        },
      ),
    );
  }

  /// Shows a rewarded ad. Calls [onRewarded] when the user earns the reward.
  void showRewardedAd({required Function onRewarded}) {
    if (_isRewardedLoaded && _rewardedAd != null) {
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _isRewardedLoaded = false;
          _loadRewardedAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _isRewardedLoaded = false;
          _loadRewardedAd();
        },
      );
      _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) {
          onRewarded();
        },
      );
    } else {
      _loadRewardedAd();
    }
  }

  /// Dispose all loaded ads.
  void dispose() {
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
  }
}
