import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proyecto_devsouls/models/sports_venue.dart'; // Importa el modelo SportsVenue
import 'package:proyecto_devsouls/screens/Reservas/reservas.dart'; // Importa el modelo de reservas

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Función para agregar un SportsVenue a Firestore
  Future<void> addSportsVenue(SportsVenue venue) async {
    try {
      CollectionReference venues = _firestore.collection('sports_venues');

      // Usar el id del lugar como el ID del documento en Firestore
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
    }
  }

  // Función para obtener todos los SportsVenues de Firestore
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

  // Función para obtener lugares deportivos por deporte
  Future<List<SportsVenue>> getSportsVenuesBySport(String sportName) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('sports_venues')
          .where('sport', isEqualTo: sportName) // Filtra por el deporte
          .get();

      return snapshot.docs
          .map((doc) => SportsVenue.fromFirestore(doc))
          .toList();
    } catch (e) {
      print("Error al obtener los lugares deportivos por deporte: $e");
      return [];
    }
  }

  // Función para agregar una reserva a Firestore
  Future<void> addReservation(Reserva reserva) async {
    try {
      final String userId = FirebaseAuth.instance.currentUser!.uid;

      // Referencia a la colección de reservas
      CollectionReference reservations = _firestore.collection('reservations');

      await reservations.add({
        'venueName': reserva.nombre,
        'fechaHora': reserva.fechaHora,
        'userId': userId,
        'imageUrl':
            reserva.imageUrl, // Almacena la URL de la imagen en la reserva
      });

      print("Reserva agregada con éxito: ${reserva.nombre}");
    } catch (e) {
      print("Error al agregar la reserva: $e");
    }
  }

  // Función para obtener las reservas del usuario autenticado
  Future<List<Reserva>> getUserReservations() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      QuerySnapshot snapshot = await _firestore
          .collection('reservations')
          .where('userId', isEqualTo: userId)
          .get();

      return snapshot.docs
          .map(
            (doc) => Reserva(
              id: doc.id,
              nombre: doc['venueName'],
              fechaHora: doc['fechaHora'],
              imageUrl: doc['imageUrl'],
              hora: doc['hora'],
              userId: doc['userId'],
            ),
          )
          .toList();
    } catch (e) {
      print("Error al obtener las reservas: $e");
      return [];
    }
  }

  // Función para cancelar una reserva en Firestore
  Future<void> cancelReservation(String reservaId) async {
    try {
      await _firestore.collection('reservations').doc(reservaId).delete();
      print("Reserva cancelada exitosamente");
    } catch (e) {
      print("Error al cancelar la reserva: $e");
    }
  }
}
