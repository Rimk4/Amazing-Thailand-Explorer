class LocationPoint {
  double latitude;
  double longitude;
  DateTime timestamp;
  double accuracy;

  LocationPoint({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    required this.accuracy,
  });

  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
    'timestamp': timestamp.toIso8601String(),
    'accuracy': accuracy,
  };

  factory LocationPoint.fromJson(Map<String, dynamic> json) => LocationPoint(
    latitude: json['latitude'],
    longitude: json['longitude'],
    timestamp: DateTime.parse(json['timestamp']),
    accuracy: json['accuracy'],
  );
}
