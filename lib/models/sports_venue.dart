import 'package:cloud_firestore/cloud_firestore.dart';

class SportsVenue {
  final String id;
  final String name;
  final String sport;
  final String location;
  final String description;
  final double pricePerHour;
  final double rating;
  final int reviewCount;
  final String imageUrl;
  final List<String> facilities;
  final List<String> galleryImages;

  SportsVenue({
    required this.id,
    required this.name,
    required this.sport,
    required this.location,
    required this.description,
    required this.pricePerHour,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
    required this.facilities,
    required this.galleryImages,
  });

  // Método para crear un objeto SportsVenue desde Firestore
  factory SportsVenue.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return SportsVenue(
      id: doc.id,
      name: data['name'] ?? '',
      sport: data['sport'] ?? '',
      location: data['location'] ?? '',
      description: data['description'] ?? '',
      pricePerHour:
          data['pricePerHour']?.toDouble() ??
          0.0, // Asegúrate de convertirlo a double
      rating:
          data['rating']?.toDouble() ??
          0.0, // Asegúrate de convertirlo a double
      reviewCount: data['reviewCount'] ?? 0,
      imageUrl: data['imageUrl'] ?? '',
      facilities: List<String>.from(data['facilities'] ?? []),
      galleryImages: List<String>.from(data['galleryImages'] ?? []),
    );
  }
}
