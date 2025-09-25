// lib/services/firebase_firestore.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proyecto_devsouls/models/sports_venue.dart';
import 'package:proyecto_devsouls/screens/Reservas/reservas.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Agregar sports venue
  Future<void> addSportsVenue(SportsVenue venue) async {
    try {
      CollectionReference venues = _firestore.collection('sports_venues');
      await venues.doc(venue.id).set({
        'name': venue.name,
        'sport': venue.sport,
        'location': venue.location,
        'description': venue.description,
        'pricePerHour': venue.pricePerHour,
        'rating': venue.rating,
        'reviewCount': venue.reviewCount,
        'imageUrl': venue.imageUrl,
        'facilities': venue.facilities,
        'galleryImages': venue.galleryImages,
      });
      print("Venue added successfully: ${venue.name}");
    } catch (e) {
      print("Error al agregar el lugar deportivo: $e");
      rethrow;
    }
  }

  // Obtener todos los SportsVenues
  Future<List<SportsVenue>> getSportsVenues() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('sports_venues')
          .get();
      return snapshot.docs
          .map((doc) => SportsVenue.fromFirestore(doc))
          .toList();
    } catch (e) {
      print("Error al obtener los lugares deportivos: $e");
      return [];
    }
  }

  // Obtener lugares deportivos por deporte (filtrado)
  Future<List<SportsVenue>> getSportsVenuesBySport(String sportName) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('sports_venues')
          .where('sport', isEqualTo: sportName)
          .get();

      return snapshot.docs
          .map((doc) => SportsVenue.fromFirestore(doc))
          .toList();
    } catch (e) {
      print("Error al obtener los lugares deportivos por deporte: $e");
      return [];
    }
  }

  // Agregar reserva (útil si la quieres crear desde UI sin pasar por checkout)
  Future<void> addReservation(Reserva reserva) async {
    try {
      final String userId = FirebaseAuth.instance.currentUser!.uid;
      CollectionReference reservations = _firestore.collection('reservations');

      final docRef = await reservations.add({
        'venueName': reserva.nombre,
        'nombre': reserva.nombre,
        'fechaHora': reserva.fechaHora,
        'hora': reserva.hora,
        'userId': userId,
        'imageUrl': reserva.imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'confirmed',
        'paymentStatus': 'paid',
      });

      // opcional: escribir el id dentro del doc
      await docRef.update({'reservationDocId': docRef.id});

      print("Reserva agregada con éxito: ${reserva.nombre} (id=${docRef.id})");
    } catch (e) {
      print("Error al agregar la reserva: $e");
      rethrow;
    }
  }

  // Obtener reservas del usuario (una vez) - 🔹 sin orderBy en la query
  Future<List<Reserva>> getUserReservations() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      QuerySnapshot snapshot = await _firestore
          .collection('reservations')
          .where('userId', isEqualTo: userId)
          .get(); // sin orderBy

      List<Reserva> reservas = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Reserva(
          id: doc.id,
          nombre: data['nombre'] ?? data['venueName'] ?? '',
          fechaHora: data['fechaHora'] ?? '',
          imageUrl: data['imageUrl'] ?? '',
          hora: data['hora'] ?? '',
          userId: data['userId'] ?? '',
        );
      }).toList();

      // 🔹 ordenar manualmente por createdAt descendente
      reservas.sort((a, b) {
        final aData =
            snapshot.docs.firstWhere((d) => d.id == a.id).data()
                as Map<String, dynamic>;
        final bData =
            snapshot.docs.firstWhere((d) => d.id == b.id).data()
                as Map<String, dynamic>;
        final aDate =
            aData['createdAt'] ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bDate =
            bData['createdAt'] ?? DateTime.fromMillisecondsSinceEpoch(0);

        final aDateTime = aDate is Timestamp
            ? aDate.toDate()
            : (aDate as DateTime);
        final bDateTime = bDate is Timestamp
            ? bDate.toDate()
            : (bDate as DateTime);

        return bDateTime.compareTo(aDateTime);
      });

      return reservas;
    } catch (e) {
      print("Error al obtener las reservas (sin índice): $e");
      return [];
    }
  }

  // Stream para escuchar reservas en tiempo real - 🔹 sin orderBy en la query
  Stream<List<Reserva>> streamUserReservations() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Stream.empty();

    return _firestore
        .collection('reservations')
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .map((snap) {
          List<Reserva> reservas = snap.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Reserva(
              id: doc.id,
              nombre: data['nombre'] ?? data['venueName'] ?? '',
              fechaHora: data['fechaHora'] ?? '',
              imageUrl: data['imageUrl'] ?? '',
              hora: data['hora'] ?? '',
              userId: data['userId'] ?? '',
            );
          }).toList();

          // 🔹 ordenar manualmente por createdAt descendente
          reservas.sort((a, b) {
            final aData =
                snap.docs.firstWhere((d) => d.id == a.id).data()
                    as Map<String, dynamic>;
            final bData =
                snap.docs.firstWhere((d) => d.id == b.id).data()
                    as Map<String, dynamic>;
            final aDate =
                aData['createdAt'] ?? DateTime.fromMillisecondsSinceEpoch(0);
            final bDate =
                bData['createdAt'] ?? DateTime.fromMillisecondsSinceEpoch(0);

            final aDateTime = aDate is Timestamp
                ? aDate.toDate()
                : (aDate as DateTime);
            final bDateTime = bDate is Timestamp
                ? bDate.toDate()
                : (bDate as DateTime);

            return bDateTime.compareTo(aDateTime);
          });

          return reservas;
        });
  }

  Future<void> cancelReservation(String reservaId) async {
    try {
      await _firestore.collection('reservations').doc(reservaId).delete();
      print("Reserva cancelada exitosamente");
    } catch (e) {
      print("Error al cancelar la reserva: $e");
      rethrow;
    }
  }
}
