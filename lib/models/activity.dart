class Activity {
  String id;
  double lat;
  double lng;
  String titleRu;
  String titleEn;
  String status; // 'locked' or 'unlocked'
  DateTime? unlockedAt;
  
  Activity({
    required this.id,
    required this.lat,
    required this.lng,
    required this.titleRu,
    required this.titleEn,
    required this.status,
    this.unlockedAt,
  });
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'lat': lat,
    'lng': lng,
    'titleRu': titleRu,
    'titleEn': titleEn,
    'status': status,
    'unlockedAt': unlockedAt?.toIso8601String(),
  };
  
  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
    id: json['id'] as String,
    lat: json['lat'] as double,
    lng: json['lng'] as double,
    titleRu: json['titleRu'] as String,
    titleEn: json['titleEn'] as String,
    status: json['status'] as String,
    unlockedAt: json['unlockedAt'] != null
        ? DateTime.parse(json['unlockedAt'] as String)
        : null,
  );
}
