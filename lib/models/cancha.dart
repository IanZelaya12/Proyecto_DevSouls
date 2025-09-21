class Cancha {
  final String id;
  final String nombre;
  final String deporte;
  final double lat;
  final double lng;
  final bool disponible;

  const Cancha({
    required this.id,
    required this.nombre,
    required this.deporte,
    required this.lat,
    required this.lng,
    required this.disponible,
  });

  factory Cancha.fromMap(Map<String, dynamic> map, String id) => Cancha(
    id: id,
    nombre: map['nombre'] ?? '',
    deporte: map['deporte'] ?? '',
    lat: (map['lat'] ?? 0).toDouble(),
    lng: (map['lng'] ?? 0).toDouble(),
    disponible: map['disponible'] ?? true,
  );

  Map<String, dynamic> toMap() => {
    'nombre': nombre,
    'deporte': deporte,
    'lat': lat,
    'lng': lng,
    'disponible': disponible,
  };
}
