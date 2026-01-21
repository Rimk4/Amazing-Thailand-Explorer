import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../models/location_point.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';

class LocationService {
  final List<LatLng> trackPoints = [];
  final List<LocationPoint> _rawTrackPoints = [];
  final StorageService _storageService = StorageService();
  
  Position? _lastAddedPosition;
  DateTime? _lastAddedTime;
  double totalDistance = 0.0;
  
  bool _isTracking = false;
  
  Future<void> initialize() async {
    // Проверяем разрешения
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }
    
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }
    
    // Загружаем сохраненный трек
    await _loadTrack();
  }
  
  Stream<Position> get positionStream {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 0, // Мы сами фильтруем
      ),
    ).where((position) {
      // Фильтруем плохие точки
      return position.accuracy <= Constants.maxAccuracy;
    });
  }
  
  void startTracking() {
    _isTracking = true;
  }
  
  void stopTracking() {
    _isTracking = false;
    _saveTrack();
  }
  
  bool get isTracking => _isTracking;
  
  void addTrackPoint(Position position) {
    final now = DateTime.now();
    final point = LocationPoint(
      latitude: position.latitude,
      longitude: position.longitude,
      timestamp: now,
      accuracy: position.accuracy,
    );
    
    // Проверяем условия добавления точки
    bool shouldAdd = false;
    
    if (_lastAddedPosition == null) {
      shouldAdd = true;
    } else {
      final distance = Geolocator.distanceBetween(
        _lastAddedPosition!.latitude,
        _lastAddedPosition!.longitude,
        position.latitude,
        position.longitude,
      );
      
      final timeDiff = now.difference(_lastAddedTime!).inSeconds;
      
      if (distance >= Constants.minDistanceForTrackPoint ||
          timeDiff >= Constants.minTimeForTrackPoint) {
        shouldAdd = true;
      }
    }
    
    if (shouldAdd) {
      _rawTrackPoints.add(point);
      trackPoints.add(LatLng(position.latitude, position.longitude));
      
      // Обновляем общую дистанцию
      if (_lastAddedPosition != null) {
        final segmentDistance = Geolocator.distanceBetween(
          _lastAddedPosition!.latitude,
          _lastAddedPosition!.longitude,
          position.latitude,
          position.longitude,
        );
        totalDistance += segmentDistance;
      }
      
      _lastAddedPosition = position;
      _lastAddedTime = now;
      
      // Периодически сохраняем
      if (_rawTrackPoints.length % 10 == 0) {
        _saveTrack();
      }
    }
  }
  
  Future<void> _loadTrack() async {
    final (savedPoints, savedDistance) = _storageService.getTrackData();
    
    _rawTrackPoints.clear();
    trackPoints.clear();
    
    _rawTrackPoints.addAll(savedPoints);
    trackPoints.addAll(savedPoints.map(
      (p) => LatLng(p.latitude, p.longitude),
    ));
    
    totalDistance = savedDistance;
    
    if (_rawTrackPoints.isNotEmpty) {
      final last = _rawTrackPoints.last;
      _lastAddedPosition = Position(
        latitude: last.latitude,
        longitude: last.longitude,
        timestamp: last.timestamp,
        accuracy: last.accuracy,
        altitude: 0,
        altitudeAccuracy: 0,
        heading: 0,
        headingAccuracy: 0,
        speed: 0,
        speedAccuracy: 0,
      );
      _lastAddedTime = last.timestamp;
    }
  }
  
  Future<void> _saveTrack() async {
    await _storageService.saveTrackData(_rawTrackPoints, totalDistance);
  }
  
  void dispose() {
    _saveTrack();
  }
}
