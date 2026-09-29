#!/usr/bin/env bash
set -e
command -v flutter >/dev/null || { echo 'Flutter is not installed/on PATH.'; exit 1; }
flutter pub get
flutter build apk --release
echo 'APK: build/app/outputs/flutter-apk/app-release.apk'
