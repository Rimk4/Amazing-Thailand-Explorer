import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/activity.dart';
import '../models/location_point.dart';

class StorageService {
  static const String _trackKey = 'track_data';
  static const String _activitiesKey = 'activities';
  static const String _totalDistanceKey = 'total_distance';
  
  late SharedPreferences _prefs;
  
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  Future<void> saveTrackData(List<LocationPoint> points, double totalDistance) async {
    // Сохраняем точки
    final pointsJson = json.encode(points.map((p) => p.toJson()).toList());
    await _prefs.setString(_trackKey, pointsJson);
    
    // Сохраняем общую дистанцию
    await _prefs.setDouble(_totalDistanceKey, totalDistance);
  }
  
  (List<LocationPoint>, double) getTrackData() {
    final pointsJson = _prefs.getString(_trackKey);
    final totalDistance = _prefs.getDouble(_totalDistanceKey) ?? 0.0;
    
    List<LocationPoint> points = [];
    
    if (pointsJson != null) {
      try {
        final List<dynamic> jsonList = json.decode(pointsJson);
        points = jsonList.map((json) => LocationPoint.fromJson(json)).toList();
      } catch (e) {
        points = [];
      }
    }
    
    return (points, totalDistance);
  }
  
  Future<void> saveActivities(List<Activity> activities) async {
    final activitiesJson = json.encode(activities.map((a) => a.toJson()).toList());
    await _prefs.setString(_activitiesKey, activitiesJson);
  }
  
  List<Activity> getActivities() {
    final activitiesJson = _prefs.getString(_activitiesKey);
    
    if (activitiesJson != null) {
      try {
        final List<dynamic> jsonList = json.decode(activitiesJson);
        return jsonList.map((json) => Activity.fromJson(json)).toList();
      } catch (e) {
        return [];
      }
    }
    
    return [];
  }
}
