// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Amazing Thailand Explorer';

  @override
  String get map => 'Карта';

  @override
  String get statistics => 'Статистика';

  @override
  String get totalDistance => 'Всего пройдено';

  @override
  String get achievements => 'Ачивки';

  @override
  String get recentAchievements => 'Последние ачивки';

  @override
  String get noAchievementsYet => 'Ачивок пока нет';

  @override
  String get unlocked => 'Открыто';

  @override
  String get locked => 'Заблокировано';

  @override
  String get achievementUnlocked => 'Ачивка получена!';

  @override
  String get startTracking => 'Начать трекинг';

  @override
  String get stopTracking => 'Остановить трекинг';

  @override
  String get centerMap => 'Центрировать карту';
}
