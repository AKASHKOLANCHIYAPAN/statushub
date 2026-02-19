# StatusHub – Quotes & Caption Generator

A lightweight, fast Android app providing categorized WhatsApp, Instagram, and social media statuses and captions in English and Tamil. Built with Flutter and Material Design 3.

## Features

- **10 Categories**: Love, Sad, Attitude, Motivation, Funny, Good Morning, Birthday, Festival Wishes, Tamil Love, Tamil Motivation
- **150+ Static Quotes** with premium exclusive quotes
- **Copy & Share** quotes with one tap
- **Favorites** saved locally (offline)
- **Search** across all categories with instant filtering
- **Dark Mode** toggle with persistent preference
- **AdMob Integration**: Banner, Interstitial (every 5 actions), Rewarded (premium unlock)
- **Offline-first** – no internet required for quotes
- **Optimized** for low-end Android devices

## Project Structure

```
lib/
├── main.dart                      # App entry point
├── models/
│   ├── quote.dart                 # Quote data model
│   └── category.dart              # Category data model
├── services/
│   ├── quote_service.dart         # JSON loading, search, favorites
│   ├── ad_service.dart            # AdMob lifecycle management
│   └── preferences_service.dart   # Dark mode & premium persistence
├── providers/
│   ├── quote_provider.dart        # Quote state management
│   ├── theme_provider.dart        # Theme state management
│   └── ad_provider.dart           # Ad state management
├── theme/
│   └── app_theme.dart             # Material Design 3 themes
├── screens/
│   ├── splash_screen.dart         # Animated splash (2s)
│   ├── home_screen.dart           # Category grid + settings
│   ├── quotes_list_screen.dart    # Quote cards + banner ad
│   ├── favorites_screen.dart      # Saved quotes
│   └── search_screen.dart         # Cross-category search
└── widgets/
    ├── category_card.dart         # Gradient category tile
    ├── quote_card.dart            # Quote with actions
    └── banner_ad_widget.dart      # AdMob banner wrapper
```

## Setup & Run

### Prerequisites
- Flutter SDK (3.2.0 or later)
- Android Studio or VS Code with Flutter extension
- Android device/emulator (API 21+)

### Steps

```bash
# 1. Clone/navigate to the project
cd "d:\caption generator"

# 2. Get dependencies
flutter pub get

# 3. Run on a connected device
flutter run
```

## Replace AdMob Test IDs with Real IDs

The app currently uses **Google's official test ad unit IDs** for development. Before publishing:

### Step 1: App-level AdMob ID

Open `android/app/src/main/AndroidManifest.xml` and replace:
```xml
<!-- REPLACE this test App ID with your real AdMob App ID -->
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="ca-app-pub-3940256099942544~3347511713"/>
```

### Step 2: Ad Unit IDs

Open `lib/services/ad_service.dart` and replace the test IDs in these methods:
- `bannerAdUnitId` → Your banner ad unit ID
- `interstitialAdUnitId` → Your interstitial ad unit ID
- `rewardedAdUnitId` → Your rewarded ad unit ID

Search for `REPLACE_WITH_REAL_ID` in the file to find all locations.

## Generate Signed APK

### Step 1: Create a Keystore

```bash
keytool -genkey -v -keystore ~/statushub-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias statushub
```

### Step 2: Create `android/key.properties`

```properties
storePassword=<your-store-password>
keyPassword=<your-key-password>
keyAlias=statushub
storeFile=<path-to-your-keystore>/statushub-key.jks
```

### Step 3: Update `android/app/build.gradle`

Add before the `android {}` block:
```groovy
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}
```

Update `buildTypes.release`:
```groovy
release {
    signingConfig signingConfigs.create("release") {
        keyAlias keystoreProperties['keyAlias']
        keyPassword keystoreProperties['keyPassword']
        storeFile file(keystoreProperties['storeFile'])
        storePassword keystoreProperties['storePassword']
    }
}
```

### Step 4: Build the APK

```bash
# App Bundle (recommended for Play Store)
flutter build appbundle --release

# Or APK
flutter build apk --release --split-per-abi
```

## Play Store Publishing Checklist

- [ ] Replace all AdMob test IDs with real IDs
- [ ] Update `version` in `pubspec.yaml` (e.g., `1.0.0+1`)
- [ ] Set app icon (use `flutter_launcher_icons` package)
- [ ] Create splash screen native assets (use `flutter_native_splash`)
- [ ] Generate signed App Bundle (`.aab`)
- [ ] Prepare Play Store listing:
  - App title: "StatusHub – Quotes & Caption Generator"
  - Short description (80 chars)
  - Full description (4000 chars)
  - Feature graphic (1024x500)
  - Screenshots (at least 2, phone + tablet)
  - App icon (512x512)
- [ ] Privacy Policy URL (required for AdMob apps)
- [ ] Content rating questionnaire
- [ ] Set target audience and content
- [ ] Ads declaration: "Yes, my app contains ads"
- [ ] Enable app signing by Google Play
- [ ] Test on multiple devices before release

## Adding Firebase Later

This app is designed to be Firebase-ready. To add Firebase:

1. Run `flutterfire configure` to register the app
2. Add `firebase_core` to `pubspec.yaml`
3. Initialize Firebase in `main.dart` before `runApp()`
4. Use Firebase Remote Config for dynamic quotes
5. Use Firebase Analytics for usage tracking
6. Use Cloud Firestore for user-synced favorites

## License

This project is proprietary. All rights reserved.
