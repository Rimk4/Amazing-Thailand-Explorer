import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart';
import '../services/activity_service.dart';
import '../utils/constants.dart';
import 'main_menu_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final LocationService _locationService = LocationService();
  final ActivityService _activityService = ActivityService();
  final MapController _mapController = MapController();
  
  LatLng? _currentPosition;
  bool _isCentered = true;
  
  @override
  void initState() {
    super.initState();
    _initApp();
  }
  
  Future<void> _initApp() async {
    await _locationService.initialize();
    await _activityService.loadActivities();
    _startLocationTracking();
  }
  
  Future<void> _startLocationTracking() async {
    final hasPermission = await _locationService.checkAndRequestPermissions();
    if (!hasPermission) return;
    
    _locationService.startLocationUpdates(_onPositionUpdate);
  }
  
  void _onPositionUpdate(Position position) {
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
    
    if (_locationService.isTracking) {
      _locationService.addTrackPoint(position);
      _activityService.checkAchievements(position);
    }
  }
  
  void _toggleTracking() {
    setState(() {
      if (_locationService.isTracking) {
        _locationService.stopTracking();
      } else {
        _locationService.startTracking();
      }
    });
  }
  
  void _centerOnUser() {
    if (_currentPosition != null) {
      _mapController.move(_currentPosition!, _mapController.zoom);
      setState(() {
        _isCentered = true;
      });
    }
  }
  
  void _goToMenu() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainMenuScreen()),
    );
  }
  
  void _clearTrack() {
    setState(() {
      _locationService.clearTrack();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Трек очищен')),
    );
  }
  
  @override
  void dispose() {
    _locationService.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Карта Бангкока'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: _goToMenu,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _clearTrack,
            tooltip: 'Очистить трек',
          ),
        ],
      ),
      body: Stack(
        children: [
          // Карта
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: LatLng(
                AppConstants.bangkokCenterLat,
                AppConstants.bangkokCenterLng,
              ),
              zoom: 13.0,
              onMapEvent: (event) {
                if (event is MapEventMoveStart) {
                  setState(() {
                    _isCentered = false;
                  });
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.thailand_explorer',
              ),
              
              PolylineLayer(
                polylines: [
                  if (_locationService.trackPoints.length > 1)
                    Polyline(
                      points: _locationService.trackPoints,
                      color: Colors.blue.withOpacity(0.7),
                      strokeWidth: 4.0,
                    ),
                ],
              ),
              
              MarkerLayer(
                markers: _activityService.activities.map((activity) {
                  return Marker(
                    point: LatLng(activity.lat, activity.lng),
                    width: 30,
                    height: 30,
                    child: Icon(
                      activity.status == 'unlocked' ? Icons.place : Icons.location_on,
                      color: activity.status == 'unlocked' ? Colors.green : Colors.red,
                      size: 24,
                    ),
                  );
                }).toList(),
              ),
              
              if (_currentPosition != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _currentPosition!,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.person_pin_circle,
                        color: Colors.blue,
                        size: 40,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          
          // Статистика
          Positioned(
            top: MediaQuery.of(context).padding.top + 70,
            left: 10,
            right: 10,
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${(_locationService.totalDistance / 1000).toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const Text(
                          'км',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${_activityService.unlockedCount}/${_activityService.totalActivities}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const Text(
                          'ачивки',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _locationService.isTracking ? Icons.play_arrow : Icons.pause,
                          color: _locationService.isTracking ? Colors.green : Colors.red,
                        ),
                        Text(
                          _locationService.isTracking ? 'Идет запись' : 'Пауза',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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
                  backgroundColor: _locationService.isTracking ? Colors.red : Colors.green,
                  child: Icon(
                    _locationService.isTracking ? Icons.pause : Icons.play_arrow,
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
