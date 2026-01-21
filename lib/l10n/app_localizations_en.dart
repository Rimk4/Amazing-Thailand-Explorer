// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Amazing Thailand Explorer';

  @override
  String get map => 'Map';

  @override
  String get statistics => 'Statistics';

  @override
  String get totalDistance => 'Total Distance';

  @override
  String get achievements => 'Achievements';

  @override
  String get recentAchievements => 'Recent Achievements';

  @override
  String get noAchievementsYet => 'No achievements yet';

  @override
  String get unlocked => 'Unlocked';

  @override
  String get locked => 'Locked';

  @override
  String get achievementUnlocked => 'Achievement Unlocked!';

  @override
  String get startTracking => 'Start Tracking';

  @override
  String get stopTracking => 'Stop Tracking';

  @override
  String get centerMap => 'Center Map';
}
