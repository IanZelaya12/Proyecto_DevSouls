// FirebaseFirestore.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proyecto_devsouls/models/sports_venue.dart'; // Importa el modelo SportsVenue

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
}
