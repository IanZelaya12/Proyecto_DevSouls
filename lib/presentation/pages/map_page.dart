import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as ll;
import 'package:geolocator/geolocator.dart';
import '../../../data/services/venues_service.dart';
import '../../../models/cancha.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final _map = MapController();
  final _venues = VenuesService();

  final List<Marker> _placeMarkers = [];
  Marker? _userMarker;
  bool _loading = false;
  String? _error;

  static final ll.LatLng _center = ll.LatLng(14.0723, -87.1921); // TGU aprox

  @override
  void initState() {
    super.initState();
    _loadCanchas();
  }

  Future<void> _loadCanchas() async {
    setState(() {
      _loading = true;
      _error = null;
      _placeMarkers.clear();
    });
    try {
      final canchas = await _venues.fetchCanchas();
      if (!mounted) return;

      final markers = canchas.map(_toMarker).toList();
      setState(() => _placeMarkers.addAll(markers));

      if (markers.isNotEmpty) {
        _fitBounds(markers.map((m) => m.point).toList());
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = 'No se pudieron cargar las canchas.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Marker _toMarker(Cancha c) {
    final color = c.disponible ? Colors.green : Colors.red;
    return Marker(
      point: ll.LatLng(c.lat, c.lng),
      width: 44,
      height: 44,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              c.nombre,
              style: const TextStyle(color: Colors.white, fontSize: 10),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Icon(Icons.location_on, size: 28, color: color),
        ],
      ),
    );
  }

  void _fitBounds(List<ll.LatLng> pts) {
    if (pts.isEmpty) return;
    double minLat = pts.first.latitude, maxLat = pts.first.latitude;
    double minLng = pts.first.longitude, maxLng = pts.first.longitude;
    for (final p in pts) {
      if (p.latitude < minLat) minLat = p.latitude;
      if (p.latitude > maxLat) maxLat = p.latitude;
      if (p.longitude < minLng) minLng = p.longitude;
      if (p.longitude > maxLng) maxLng = p.longitude;
    }
    final bounds = LatLngBounds(
      ll.LatLng(minLat, minLng),
      ll.LatLng(maxLat, maxLng),
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      try {
        _map.fitCamera(
          CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(60)),
        );
      } catch (_) {}
    });
  }

  Future<void> _centerOnUser() async {
    var p = await Geolocator.checkPermission();
    if (p == LocationPermission.denied) {
      p = await Geolocator.requestPermission();
    }
    if (p == LocationPermission.denied ||
        p == LocationPermission.deniedForever) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permiso de ubicación denegado')),
      );
      return;
    }

    try {
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      if (!mounted) return;

      final me = ll.LatLng(pos.latitude, pos.longitude);
      setState(() {
        _userMarker = Marker(
          point: me,
          width: 36,
          height: 36,
          child: const Icon(Icons.my_location, color: Colors.blue, size: 28),
        );
      });
      _map.move(me, 15);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo obtener tu ubicación')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final markers = [..._placeMarkers, if (_userMarker != null) _userMarker!];

    return Scaffold(
      appBar: AppBar(title: const Text('Mapa de canchas (gratis)')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_error!),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: _loadCanchas,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            )
          : FlutterMap(
              mapController: _map,

              options: MapOptions(initialCenter: _center, initialZoom: 13),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c'],
                ),
                MarkerLayer(markers: markers),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _centerOnUser,
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
