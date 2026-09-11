# BetterMe — Android test build

## Requirements
- Flutter SDK (3.x)
- Android Studio / Android SDK
- Android SDK platform/build tools installed
- A physical Android phone or emulator

## Build
From this folder:

```bash
flutter doctor
flutter pub get
flutter build apk --release
```

The APK will be at:

`build/app/outputs/flutter-apk/app-release.apk`

## Install on phone
Enable installation from the source you use (if Android asks), then install the APK. For USB debugging:

```bash
adb install -r build/app/outputs/flutter-apk/app-release.apk
```

## Important
This is a test/prototype build. The release signing configuration currently uses the debug signing config so you can test it. Before Play Store release, create a real upload/release keystore, configure Play App Signing, and remove debug signing.

The app's real backend, encrypted persistence, native notifications, and native biometric integration are still production work. Do not put AI provider secrets in the APK.
