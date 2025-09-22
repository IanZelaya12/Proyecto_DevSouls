import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../services/location_service.dart';

class Cancha {
  final String id;
  final String nombre;
  final String direccion;
  final LatLng pos;
  final double precioHora;
  final double rating;
  Cancha({
    required this.id,
    required this.nombre,
    required this.direccion,
    required this.pos,
    required this.precioHora,
    required this.rating,
  });
}

class MapaController extends ChangeNotifier {
  final LocationService _location = LocationService();

  LatLng? userCenter;
  bool loading = true;
  bool hasLocationPermission = false;
  String query = '';
  Cancha? seleccionada;

  final List<Cancha> _todas = [
    Cancha(
      id: '1',
      nombre: 'Cancha Central',
      direccion: 'Col. Centro',
      pos: LatLng(14.072275, -87.192136),
      precioHora: 250,
      rating: 4.6,
    ),
    Cancha(
      id: '2',
      nombre: 'Campo Verde',
      direccion: 'Parque La Leona',
      pos: LatLng(14.0768, -87.1899),
      precioHora: 200,
      rating: 4.3,
    ),
    Cancha(
      id: '3',
      nombre: 'Polideportivo Sur',
      direccion: 'Bv. Comunidad',
      pos: LatLng(14.0703, -87.1975),
      precioHora: 180,
      rating: 4.0,
    ),
  ];

  List<Cancha> get visibles {
    if (query.trim().isEmpty) return _todas;
    final q = query.toLowerCase();
    return _todas
        .where(
          (c) =>
              c.nombre.toLowerCase().contains(q) ||
              c.direccion.toLowerCase().contains(q),
        )
        .toList();
  }

  Future<void> init() async {
    try {
      hasLocationPermission = await _location.ensurePermission();
      final pos = await _location.getSafePosition();
      if (pos != null) {
        userCenter = LatLng(pos.latitude, pos.longitude);
      } else {
        userCenter = _todas.first.pos; // fallback seguro
      }
    } catch (_) {
      userCenter = _todas.first.pos;
      hasLocationPermission = false;
    }
    loading = false;
    notifyListeners();
  }

  void setQuery(String v) {
    query = v;
    notifyListeners();
  }

  void select(Cancha c) {
    seleccionada = c;
    notifyListeners();
  }

  void clearSelection() {
    seleccionada = null;
    notifyListeners();
  }
}
