# my_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

my_app/  
├── lib/
│   ├── main.dart
│   ├── app.dart
│   ├── models/
│   │   ├── track_point.dart
│   │   └── activity.dart
│   ├── services/
│   │   ├── storage_service.dart
│   │   ├── location_service.dart
│   │   └── activity_service.dart
│   ├── screens/
│   │   ├── splash_screen.dart
│   │   ├── main_menu_screen.dart
│   │   ├── map_screen.dart
│   │   ├── stats_screen.dart
│   │   ├── achievements_screen.dart
│   │   ├── settings_screen.dart
│   │   └── about_screen.dart
│   ├── widgets/
│   │   ├── menu_button.dart
│   │   ├── stat_item.dart
│   │   └── activity_item.dart
│   └── utils/
│       └── constants.dart  
├── android/           # Android-специфичные файлы  
├── ios/              # iOS-специфичные файлы  
├── pubspec.yaml      # Зависимости и настройки  
└── ...  

# Откройте основной файл в VS Code
code my_app/lib/main.dart

`flutter run`  


# 📝 Быстрые команды для редактирования:
### Открыть в VS Code
`code .`

### Открыть в Android Studio
`android-studio .`

### Открыть только основной файл в nano
`nano lib/main.dart`

### Просмотреть структуру проекта
`find . -type f -name "*.dart" | head -20`

