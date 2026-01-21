import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/track_point.dart';
import '../models/activity.dart';

class StorageService {
  static const String _trackKey = 'track';
  static const String _activitiesKey = 'activities';
  
  late SharedPreferences _prefs;
  
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  Future<void> saveTrack(List<TrackPoint> points, double totalDistance) async {
    final json = jsonEncode({
      'points': points.map((p) => p.toJson()).toList(),
      'totalDistance': totalDistance,
    });
    await _prefs.setString(_trackKey, json);
  }
  
  (List<TrackPoint>, double) loadTrack() {
    final jsonStr = _prefs.getString(_trackKey);
    
    List<TrackPoint> points = [];
    double distance = 0.0;
    
    if (jsonStr != null) {
      try {
        final Map<String, dynamic> json = jsonDecode(jsonStr);
        final List<dynamic> pointsJson = json['points'] as List;
        points = pointsJson.map((p) => TrackPoint.fromJson(p)).toList();
        distance = json['totalDistance'] as double;
      } catch (e) {
        print('Ошибка загрузки трека: $e');
      }
    }
    
    return (points, distance);
  }
  
  Future<void> saveActivities(List<Activity> activities) async {
    final json = jsonEncode(activities.map((a) => a.toJson()).toList());
    await _prefs.setString(_activitiesKey, json);
  }
  
  List<Activity> loadActivities() {
    final jsonStr = _prefs.getString(_activitiesKey);
    
    if (jsonStr != null) {
      try {
        final List<dynamic> jsonList = jsonDecode(jsonStr);
        return jsonList.map((a) => Activity.fromJson(a)).toList();
      } catch (e) {
        print('Ошибка загрузки активностей: $e');
      }
    }
    
    return [];
  }
  
  Future<void> clearAllData() async {
    await _prefs.remove(_trackKey);
    await _prefs.remove(_activitiesKey);
  }
}
