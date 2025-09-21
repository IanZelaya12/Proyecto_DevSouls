import '../../models/cancha.dart';
import '../mock/venues.dart';

class VenuesService {
  Future<List<Cancha>> fetchCanchas() async {
    // Avance 2: mock. En la siguiente fase: Firestore o API REST.
    await Future.delayed(const Duration(milliseconds: 350));
    return mockCanchas;
  }
}
