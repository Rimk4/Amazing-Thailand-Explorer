class TrackPoint {
  final double lat;
  final double lng;
  final DateTime time;
  final double accuracy;

  TrackPoint({
    required this.lat,
    required this.lng,
    required this.time,
    required this.accuracy,
  });

  Map<String, dynamic> toJson() => {
    'lat': lat,
    'lng': lng,
    'time': time.toIso8601String(),
    'accuracy': accuracy,
  };

  factory TrackPoint.fromJson(Map<String, dynamic> json) => TrackPoint(
    lat: json['lat'] as double,
    lng: json['lng'] as double,
    time: DateTime.parse(json['time'] as String),
    accuracy: json['accuracy'] as double,
  );
}
