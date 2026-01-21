import 'package:latlong2/latlong.dart';

class Constants {
  // Бангкок bounds - отдельные константы
  static const double bangkokMinLat = 13.60; // Южная граница
  static const double bangkokMaxLat = 13.90; // Северная граница
  static const double bangkokMinLng = 100.30; // Западная граница
  static const double bangkokMaxLng = 100.70; // Восточная граница
  
  // Центр Бангкока
  static const double bangkokCenterLat = 13.75;
  static const double bangkokCenterLng = 100.50;
  
  // Трекинг параметры
  static const double minDistanceForTrackPoint = 10.0; // метров
  static const int minTimeForTrackPoint = 5; // секунд
  static const double maxAccuracy = 50.0; // метров
  
  // Активности
  static const int numberOfActivities = 50;
  static const double achievementRadius = 30.0; // метров
}
