import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../widgets/map_widget.dart';
import '../widgets/stats_overlay.dart';
import '../services/location_service.dart';
import '../services/activity_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final LocationService _locationService = LocationService();
  final ActivityService _activityService = ActivityService();
  
  LatLng? _currentPosition;
  bool _isTracking = false;
  bool _isCentered = true;
  
  @override
  void initState() {
    super.initState();
    _initLocation();
    _activityService.loadActivities();
  }
  
  Future<void> _initLocation() async {
    try {
      await _locationService.initialize();
      
      _locationService.positionStream.listen((position) {
        if (mounted) {
          setState(() {
            _currentPosition = LatLng(position.latitude, position.longitude);
          });
          
          if (_locationService.isTracking) {
            _locationService.addTrackPoint(position);
            _activityService.checkAchievements(position);
          }
        }
      });
    } catch (e) {
      print('Error initializing location: $e');
    }
  }
  
  void _toggleTracking() {
    setState(() {
      _isTracking = !_isTracking;
    });
    
    if (_isTracking) {
      _locationService.startTracking();
    } else {
      _locationService.stopTracking();
    }
  }
  
  void _centerOnUser() {
    setState(() {
      _isCentered = true;
    });
  }
  
  @override
  void dispose() {
    _locationService.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MapWidget(
            currentPosition: _currentPosition,
            trackPoints: _locationService.trackPoints,
            activities: _activityService.activities,
            isCentered: _isCentered,
            onMapMoved: () {
              if (_isCentered) {
                setState(() {
                  _isCentered = false;
                });
              }
            },
          ),
          
          // Верхний оверлей со статистикой
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 10,
            right: 10,
            child: StatsOverlay(
              totalDistance: _locationService.totalDistance,
              unlockedCount: _activityService.unlockedCount,
              totalActivities: _activityService.totalActivities,
            ),
          ),
          
          // Кнопки управления
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 20,
            right: 20,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'center',
                  mini: true,
                  onPressed: _centerOnUser,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.my_location,
                    color: _isCentered ? Colors.blue : Colors.grey,
                  ),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: 'track',
                  onPressed: _toggleTracking,
                  backgroundColor: _isTracking ? Colors.red : Colors.green,
                  child: Icon(
                    _isTracking ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
