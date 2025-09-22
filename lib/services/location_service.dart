import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  /// Solicita permisos de ubicación al usuario
  Future<bool> ensurePermission() async {
    try {
      // Verificar si los servicios de ubicación están habilitados
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('Los servicios de ubicación están deshabilitados');
        return false;
      }

      // Verificar permisos actuales
      LocationPermission permission = await Geolocator.checkPermission();
      
      if (permission == LocationPermission.denied) {
        // Solicitar permiso si fue denegado
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint('Permisos de ubicación denegados');
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Los permisos están permanentemente denegados
        debugPrint('Permisos de ubicación permanentemente denegados');
        return false;
      }

      // Permisos concedidos
      return true;
    } catch (e) {
      debugPrint('Error al verificar permisos de ubicación: $e');
      return false;
    }
  }

  /// Obtiene la posición actual del usuario de forma segura
  Future<Position?> getSafePosition() async {
    try {
      // Verificar permisos primero
      bool hasPermission = await ensurePermission();
      if (!hasPermission) {
        return null;
      }

      // Obtener posición actual con timeout
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      debugPrint('Ubicación obtenida: ${position.latitude}, ${position.longitude}');
      return position;
    } catch (e) {
      debugPrint('Error al obtener ubicación: $e');
      return null;
    }
  }

  /// Obtiene la última posición conocida
  Future<Position?> getLastKnownPosition() async {
    try {
      bool hasPermission = await ensurePermission();
      if (!hasPermission) {
        return null;
      }

      Position? lastPosition = await Geolocator.getLastKnownPosition();
      if (lastPosition != null) {
        debugPrint('Última ubicación conocida: ${lastPosition.latitude}, ${lastPosition.longitude}');
      }
      return lastPosition;
    } catch (e) {
      debugPrint('Error al obtener última ubicación: $e');
      return null;
    }
  }

  /// Abre la configuración de la aplicación para habilitar permisos
  Future<void> openAppSettings() async {
    try {
      await Geolocator.openAppSettings();
    } catch (e) {
      debugPrint('Error al abrir configuración: $e');
    }
  }

  /// Abre la configuración de ubicación del dispositivo
  Future<void> openLocationSettings() async {
    try {
      await Geolocator.openLocationSettings();
    } catch (e) {
      debugPrint('Error al abrir configuración de ubicación: $e');
    }
  }
}