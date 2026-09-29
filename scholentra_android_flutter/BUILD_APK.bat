@echo off
where flutter >nul 2>nul
if errorlevel 1 (
  echo Flutter is not installed or not on PATH.
  echo Install Flutter and Android Studio, then run this file again.
  pause
  exit /b 1
)
flutter pub get
flutter build apk --release
if errorlevel 1 exit /b 1
echo.
echo APK created at: build\app\outputs\flutter-apk\app-release.apk
pause
