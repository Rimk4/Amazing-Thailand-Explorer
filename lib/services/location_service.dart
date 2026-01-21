import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../models/track_point.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';

class LocationService {
  final StorageService _storageService = StorageService();
  
  List<LatLng> trackPoints = [];
  List<TrackPoint> _rawTrackPoints = [];
  double totalDistance = 0.0;
  
  Position? _lastPosition;
  DateTime? _lastPositionTime;
  bool _isTracking = false;
  StreamSubscription<Position>? _positionSubscription;
  
  bool get isTracking => _isTracking;
  
  Future<void> initialize() async {
    await _storageService.init();
    _loadTrack();
  }
  
  Future<bool> checkAndRequestPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }
    
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    
    return true;
  }
  
  void startLocationUpdates(Function(Position) onPositionUpdate) {
    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 0,
      ),
    ).listen((position) {
      if (position.accuracy <= AppConstants.maxAccuracy) {
        onPositionUpdate(position);
      }
    });
  }
  
  void addTrackPoint(Position position) {
    final now = DateTime.now();
    
    bool shouldAdd = false;
    
    if (_lastPosition == null) {
      shouldAdd = true;
    } else {
      final distance = Geolocator.distanceBetween(
        _lastPosition!.latitude,
        _lastPosition!.longitude,
        position.latitude,
        position.longitude,
      );
      
      final timeDiff = now.difference(_lastPositionTime!).inSeconds;
      
      if (distance >= AppConstants.minDistanceForTrackPoint ||
          timeDiff >= AppConstants.minTimeForTrackPoint) {
        shouldAdd = true;
      }
    }
    
    if (shouldAdd) {
      trackPoints.add(LatLng(position.latitude, position.longitude));
      
      _rawTrackPoints.add(TrackPoint(
        lat: position.latitude,
        lng: position.longitude,
        time: now,
        accuracy: position.accuracy,
      ));
      
      if (_lastPosition != null) {
        final segmentDistance = Geolocator.distanceBetween(
          _lastPosition!.latitude,
          _lastPosition!.longitude,
          position.latitude,
          position.longitude,
        );
        totalDistance += segmentDistance;
      }
      
      _lastPosition = position;
      _lastPositionTime = now;
      
      // Сохраняем каждые 10 точек
      if (_rawTrackPoints.length % 10 == 0) {
        _saveTrack();
      }
    }
  }
  
  void startTracking() {
    _isTracking = true;
  }
  
  void stopTracking() {
    _isTracking = false;
    _saveTrack();
  }
  
  void clearTrack() {
    trackPoints.clear();
    _rawTrackPoints.clear();
    totalDistance = 0.0;
    _lastPosition = null;
    _lastPositionTime = null;
    _saveTrack();
  }
  
  void _loadTrack() {
    final (savedPoints, savedDistance) = _storageService.loadTrack();
    
    _rawTrackPoints.clear();
    trackPoints.clear();
    
    _rawTrackPoints.addAll(savedPoints);
    trackPoints.addAll(savedPoints.map((p) => LatLng(p.lat, p.lng)));
    
    totalDistance = savedDistance;
    
    if (_rawTrackPoints.isNotEmpty) {
      final last = _rawTrackPoints.last;
      _lastPosition = Position(
        latitude: last.lat,
        longitude: last.lng,
        timestamp: last.time,
        accuracy: last.accuracy,
        altitude: 0,
        altitudeAccuracy: 0,
        heading: 0,
        headingAccuracy: 0,
        speed: 0,
        speedAccuracy: 0,
      );
      _lastPositionTime = last.time;
    }
  }
  
  Future<void> _saveTrack() async {
    await _storageService.saveTrack(_rawTrackPoints, totalDistance);
  }
  
  void dispose() {
    _positionSubscription?.cancel();
    _saveTrack();
  }
}
