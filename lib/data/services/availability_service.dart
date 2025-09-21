class AvailabilityService {
  // Simula GET /disponibilidad?canchaId=...&fecha=YYYY-MM-DD
  Future<List<String>> fetchSlots({
    required String canchaId,
    required DateTime fecha,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Slots demo; en prod traer de Firestore/API y filtrar ocupados
    return ['08:00', '10:00', '12:00', '14:00', '16:00', '18:00'];
  }

  // Simula POST /reservas
  Future<bool> reservar({
    required String canchaId,
    required DateTime fecha,
    required String hora,
    required String usuarioId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return true; // mock OK
  }
}
