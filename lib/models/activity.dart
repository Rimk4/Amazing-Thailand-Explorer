class Activity {
  final String id;
  final double lat;
  final double lng;
  final String title;
  String status; // 'locked' или 'unlocked'
  DateTime? unlockedAt;

  Activity({
    required this.id,
    required this.lat,
    required this.lng,
    required this.title,
    required this.status,
    this.unlockedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'lat': lat,
    'lng': lng,
    'title': title,
    'status': status,
    'unlockedAt': unlockedAt?.toIso8601String(),
  };

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
    id: json['id'] as String,
    lat: json['lat'] as double,
    lng: json['lng'] as double,
    title: json['title'] as String,
    status: json['status'] as String,
    unlockedAt: json['unlockedAt'] != null
        ? DateTime.parse(json['unlockedAt'] as String)
        : null,
  );
}
