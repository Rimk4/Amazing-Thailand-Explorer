import 'location_point.dart';

class TrackData {
  List<LocationPoint> points;
  double totalDistance;

  TrackData({
    required this.points,
    required this.totalDistance,
  });

  Map<String, dynamic> toJson() => {
    'points': points.map((p) => p.toJson()).toList(),
    'totalDistance': totalDistance,
  };

  String toJsonString() {
    return '''
    {
      "points": ${points.map((p) => p.toJson()).toList()},
      "totalDistance": $totalDistance
    }
    ''';
  }

  factory TrackData.fromJson(String jsonString) {
    // Простая реализация для MVP
    // В реальном приложении используйте json_serializable
    return TrackData(
      points: [],
      totalDistance: 0,
    );
  }
}
