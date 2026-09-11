#!/usr/bin/env bash
set -euo pipefail
flutter pub get
flutter build apk --release
echo "APK: build/app/outputs/flutter-apk/app-release.apk"
