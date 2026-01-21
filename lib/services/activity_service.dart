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
    await _storageService.init();
    final saved = _storageService.loadActivities();
    
    if (saved.isEmpty) {
      await _generateActivities();
    } else {
      activities.addAll(saved);
    }
  }
  
  Future<void> _generateActivities() async {
    final random = Random();
    activities.clear();
    
    for (int i = 0; i < AppConstants.numberOfActivities; i++) {
      final lat = AppConstants.bangkokMinLat +
          random.nextDouble() * (AppConstants.bangkokMaxLat - AppConstants.bangkokMinLat);
      
      final lng = AppConstants.bangkokMinLng +
          random.nextDouble() * (AppConstants.bangkokMaxLng - AppConstants.bangkokMinLng);
      
      activities.add(Activity(
        id: _uuid.v4(),
        lat: lat,
        lng: lng,
        title: _getActivityTitle(i),
        status: 'locked',
      ));
    }
    
    await _saveActivities();
  }
  
  String _getActivityTitle(int index) {
    final titles = [
      'Храм Ват Арун',
      'Королевский дворец',
      'Храм Изумрудного Будды',
      'Храм Лежащего Будды',
      'Рынок Чатучак',
      'Парк Лумпхини',
      'Небоскреб Байок Скай',
      'Китайский квартал',
      'Район Каосан',
      'Музей Сиама',
      'Монумент Демократии',
      'Храм Золотой Горы',
      'Памятник королю Раме V',
      'Сад Змей',
      'Музей королевских лодок',
      'Парк Бенчакитти',
      'Торговый центр Сиам Парагон',
      'Аквапарк Сиам',
      'Сады Суан Паккад',
      'Музей Эраван',
      'Статуя короля Таксина',
      'Храм Суваннарам',
      'Парк Рот Фай',
      'Национальный музей',
      'Дом Джима Томпсона',
      'Рынок Талинг Чан',
      'Канал Сансаб',
      'Храм Кхалаянмит',
      'Парк Чатучак',
      'Музей королевских слонов',
    ];
    
    return index < titles.length ? titles[index] : 'Достопримечательность ${index + 1}';
  }
  
  void checkAchievements(Position position) {
    bool updated = false;
    
    for (final activity in activities) {
      if (activity.status == 'locked') {
        final distance = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          activity.lat,
          activity.lng,
        );
        
        if (distance <= AppConstants.achievementRadius) {
          activity.status = 'unlocked';
          activity.unlockedAt = DateTime.now();
          updated = true;
        }
      }
    }
    
    if (updated) {
      _saveActivities();
    }
  }
  
  Future<void> _saveActivities() async {
    await _storageService.saveActivities(activities);
  }
  
  Future<void> resetActivities() async {
    activities.clear();
    await _generateActivities();
  }
}
