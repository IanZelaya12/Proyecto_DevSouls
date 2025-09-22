import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<bool> ensurePermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }
    if (permission == LocationPermission.deniedForever) return false;
    return true;
  }

  Future<Position?> getSafePosition() async {
    try {
      final ok = await ensurePermission();
      if (!ok) return await Geolocator.getLastKnownPosition();

      // Intenta rápido con precisión balanceada (consume menos)
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy
            .bestForNavigation, // puedes bajar a LocationAccuracy.high
        timeLimit: const Duration(seconds: 8),
      );
      return pos;
    } catch (_) {
      // Fallback a la última conocida
      try {
        return await Geolocator.getLastKnownPosition();
      } catch (_) {
        return null;
      }
    }
  }
}
