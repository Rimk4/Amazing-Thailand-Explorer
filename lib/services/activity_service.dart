import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';
import '../models/activity.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';

class ActivityService {
  final List<Activity> activities = [];
  final StorageService _storageService = StorageService();
  final Uuid _uuid = const Uuid();
  
  int get unlockedCount => activities.where((a) => a.status == 'unlocked').length;
  int get totalActivities => activities.length;
  
  Future<void> loadActivities() async {
    final saved = await _storageService.getActivities();
    
    if (saved.isEmpty) {
      await _generateActivities();
    } else {
      activities.addAll(saved);
    }
  }
  
  Future<void> _generateActivities() async {
    final random = Random();
    
    for (int i = 0; i < Constants.numberOfActivities; i++) {
      // Используем обычные константы
      final lat = Constants.bangkokMinLat +
          random.nextDouble() * (Constants.bangkokMaxLat - Constants.bangkokMinLat);
      
      final lng = Constants.bangkokMinLng +
          random.nextDouble() * (Constants.bangkokMaxLng - Constants.bangkokMinLng);
      
      final activity = Activity(
        id: _uuid.v4(),
        lat: lat,
        lng: lng,
        titleRu: 'Достопримечательность ${i + 1}',
        titleEn: 'Attraction ${i + 1}',
        status: 'locked',
        unlockedAt: null,
      );
      
      activities.add(activity);
    }
    
    await _saveActivities();
  }

  void checkAchievements(Position position) {
    for (final activity in activities) {
      if (activity.status == 'locked') {
        final distance = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          activity.lat,
          activity.lng,
        );
        
        if (distance <= Constants.achievementRadius) {
          _unlockActivity(activity);
        }
      }
    }
  }
  
  Future<void> _unlockActivity(Activity activity) async {
    activity.status = 'unlocked';
    activity.unlockedAt = DateTime.now();
    
    await _saveActivities();
    
    // Здесь можно показать уведомление
    // Для MVP просто сохраняем
  }
  
  Future<void> _saveActivities() async {
    await _storageService.saveActivities(activities);
  }
}
