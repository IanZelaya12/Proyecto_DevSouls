class Reserva {
  final String id; // generado por backend
  final String canchaId;
  final DateTime fecha; // solo fecha (yyyy-MM-dd) en backend
  final String hora; // HH:mm
  final String usuarioId;

  const Reserva({
    required this.id,
    required this.canchaId,
    required this.fecha,
    required this.hora,
    required this.usuarioId,
  });

  Map<String, dynamic> toMap() => {
    'canchaId': canchaId,
    'fecha': fecha.toIso8601String(),
    'hora': hora,
    'usuarioId': usuarioId,
  };
}
