import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:proyecto_devsouls/services/location_service.dart';

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
  String _query = '';
  Cancha? seleccionada;
  String? errorMessage;

  String get query => _query;

  final List<Cancha> _todas = [
    Cancha(
      id: '1',
      nombre: 'Cancha Central',
      direccion: 'Colonia Centro, Tegucigalpa',
      pos: const LatLng(14.072275, -87.192136),
      precioHora: 250,
      rating: 4.6,
    ),
    Cancha(
      id: '2',
      nombre: 'Campo Verde',
      direccion: 'Parque La Leona, Tegucigalpa',
      pos: const LatLng(14.0768, -87.1899),
      precioHora: 200,
      rating: 4.3,
    ),
    Cancha(
      id: '3',
      nombre: 'Polideportivo Sur',
      direccion: 'Boulevard Comunidad Económica Europea',
      pos: const LatLng(14.0703, -87.1975),
      precioHora: 180,
      rating: 4.0,
    ),
    Cancha(
      id: '4',
      nombre: 'Cancha Los Pinos',
      direccion: 'Colonia Los Pinos, Tegucigalpa',
      pos: const LatLng(14.0850, -87.1950),
      precioHora: 220,
      rating: 4.5,
    ),
    Cancha(
      id: '5',
      nombre: 'Estadio Municipal',
      direccion: 'Centro de Tegucigalpa',
      pos: const LatLng(14.0750, -87.1900),
      precioHora: 300,
      rating: 4.8,
    ),
    Cancha(
      id: '6',
      nombre: 'Campo San Miguel',
      direccion: 'Colonia San Miguel, Tegucigalpa',
      pos: const LatLng(14.0680, -87.2000),
      precioHora: 150,
      rating: 4.1,
    ),
  ];

  List<Cancha> get visibles {
    if (_query.trim().isEmpty) return _todas;
    
    final q = _query.toLowerCase().trim();
    return _todas.where((c) {
      final nombre = c.nombre.toLowerCase();
      final direccion = c.direccion.toLowerCase();
      
      return nombre.contains(q) || direccion.contains(q);
    }).toList();
  }

  Future<void> init() async {
    loading = true;
    errorMessage = null;
    notifyListeners();

    try {
      debugPrint('Iniciando MapaController...');
      
      // Solicitar permisos de ubicación
      hasLocationPermission = await _location.ensurePermission();
      debugPrint('Permisos de ubicación: $hasLocationPermission');
      
      if (hasLocationPermission) {
        // Intentar obtener posición actual
        final pos = await _location.getSafePosition();
        
        if (pos != null) {
          userCenter = LatLng(pos.latitude, pos.longitude);
          debugPrint('Ubicación del usuario establecida: ${userCenter.toString()}');
        } else {
          // Intentar obtener última posición conocida
          final lastPos = await _location.getLastKnownPosition();
          if (lastPos != null) {
            userCenter = LatLng(lastPos.latitude, lastPos.longitude);
            debugPrint('Usando última ubicación conocida: ${userCenter.toString()}');
          } else {
            // Fallback a ubicación por defecto (Centro de Tegucigalpa)
            userCenter = const LatLng(14.072275, -87.192136);
            debugPrint('Usando ubicación por defecto: ${userCenter.toString()}');
          }
        }
      } else {
        // Sin permisos, usar ubicación por defecto
        userCenter = const LatLng(14.072275, -87.192136);
        errorMessage = 'No se pudieron obtener los permisos de ubicación. Usando ubicación por defecto.';
        debugPrint('Sin permisos de ubicación, usando ubicación por defecto');
      }
      
    } catch (e) {
      debugPrint('Error durante la inicialización: $e');
      userCenter = const LatLng(14.072275, -87.192136);
      hasLocationPermission = false;
      errorMessage = 'Error al obtener ubicación: $e';
    } finally {
      loading = false;
      debugPrint('MapaController inicializado. Loading: $loading, UserCenter: $userCenter');
      notifyListeners();
    }
  }

  void setQuery(String value) {
    debugPrint('Estableciendo query: "$value"');
    if (_query != value) {
      _query = value;
      // Limpiar selección cuando se cambia la búsqueda
      if (seleccionada != null && !visibles.contains(seleccionada)) {
        seleccionada = null;
      }
      debugPrint('Query actualizado. Canchas visibles: ${visibles.length}');
      notifyListeners();
    }
  }

  void select(Cancha cancha) {
    debugPrint('Seleccionando cancha: ${cancha.nombre}');
    if (seleccionada?.id != cancha.id) {
      seleccionada = cancha;
      notifyListeners();
    }
  }

  void clearSelection() {
    if (seleccionada != null) {
      debugPrint('Limpiando selección');
      seleccionada = null;
      notifyListeners();
    }
  }

  // Método para actualizar ubicación manualmente
  Future<void> refreshLocation() async {
    if (!hasLocationPermission) {
      hasLocationPermission = await _location.ensurePermission();
    }
    
    if (hasLocationPermission) {
      final pos = await _location.getSafePosition();
      if (pos != null) {
        userCenter = LatLng(pos.latitude, pos.longitude);
        notifyListeners();
      }
    }
  }

  // Método para abrir configuración de permisos
  Future<void> openLocationSettings() async {
    await _location.openAppSettings();
  }

  // Método para buscar canchas por nombre o dirección
  List<Cancha> searchCanchas(String searchTerm) {
    if (searchTerm.trim().isEmpty) return _todas;
    
    final term = searchTerm.toLowerCase().trim();
    return _todas.where((cancha) {
      return cancha.nombre.toLowerCase().contains(term) ||
             cancha.direccion.toLowerCase().contains(term);
    }).toList();
  }

  // Método para obtener cancha por ID
  Cancha? getCanchaById(String id) {
    try {
      return _todas.firstWhere((cancha) => cancha.id == id);
    } catch (e) {
      return null;
    }
  }

  // Método para obtener todas las canchas
  List<Cancha> get todasLasCanchas => List.unmodifiable(_todas);
}