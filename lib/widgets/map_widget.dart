import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/activity.dart';

class MapWidget extends StatefulWidget {
  final LatLng? currentPosition;
  final List<LatLng> trackPoints;
  final List<Activity> activities;
  final bool isCentered;
  final VoidCallback onMapMoved;

  const MapWidget({
    super.key,
    required this.currentPosition,
    required this.trackPoints,
    required this.activities,
    required this.isCentered,
    required this.onMapMoved,
  });

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final MapController _mapController = MapController();
  LatLng? _lastCenter;

  @override
  void initState() {
    super.initState();
    _lastCenter = const LatLng(13.75, 100.50);
  }

  @override
  void didUpdateWidget(covariant MapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.isCentered && widget.currentPosition != null) {
      _mapController.move(widget.currentPosition!, _mapController.zoom);
      _lastCenter = widget.currentPosition;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        center: _lastCenter,
        zoom: 13.0,
        maxZoom: 18.0,
        minZoom: 10.0,
        interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
        onMapEvent: (mapEvent) {
          if (mapEvent is MapEventMoveStart) {
            widget.onMapMoved();
          }
        },
      ),
      children: [
        // OSM слой
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.amazing_thailand_explorer',
        ),
        
        // Трек
        PolylineLayer(
          polylines: [
            if (widget.trackPoints.length > 1)
              Polyline(
                points: widget.trackPoints,
                color: Colors.blue.withOpacity(0.7),
                strokeWidth: 4.0,
              ),
          ],
        ),
        
        // Маркеры активностей
        MarkerLayer(
          markers: widget.activities.map((activity) {
            return Marker(
              point: LatLng(activity.lat, activity.lng),
              width: 40,
              height: 40,
              child: Icon(
                activity.status == 'unlocked'
                    ? Icons.place
                    : Icons.location_on,
                color: activity.status == 'unlocked'
                    ? Colors.green
                    : Colors.red,
                size: 32,
              ),
            );
          }).toList(),
        ),
        
        // Маркер текущей позиции
        if (widget.currentPosition != null)
          MarkerLayer(
            markers: [
              Marker(
                point: widget.currentPosition!,
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
    );
  }
}
