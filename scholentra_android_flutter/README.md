# Scholentra Mobile – Flutter Android Demo

Premium mobile-first Scholentra demo for **Sapphire School**.

## Demo login
- Email: `admin@demo.com`
- Password: `admin123`

## Included
- Branded login
- Light + dark mode
- Mobile dashboard
- Animated KPI cards and custom charts
- Students: search, filter, add, delete, avatars
- Attendance marking
- Fees & Finance using PKR
- More modules with interactive demo pages
- Floating Scholentra AI assistant
- Local/offline demo data
- Phone/tablet responsive Flutter UI

## Build an APK
You need Flutter + Android SDK installed.

```bash
flutter pub get
flutter build apk --release
```

APK output:
`build/app/outputs/flutter-apk/app-release.apk`

For an installable debug APK:
```bash
flutter build apk --debug
```

## Notes
This package intentionally has no non-Flutter runtime dependencies other than `cupertino_icons`, making it straightforward to build and later connect to your API.
