import 'package:proyecto_devsouls/models/sports_venue.dart';

class Court {
  final String name;
  final String sport;
  final String location;
  final double price;
  final String imagePath;
  final double rating;
  final int reviewCount;
  final String description;
  final List<String> facilities;

  Court({
    required this.name,
    required this.sport,
    required this.location,
    required this.price,
    required this.imagePath,
    required this.rating,
    required this.reviewCount,
    required this.description,
    required this.facilities,
  });

  // Método para convertir SportsVenue a Court
  factory Court.fromSportsVenue(SportsVenue venue) {
    return Court(
      name: venue.name,
      sport: venue.sport,
      location: venue.location,
      price: venue.pricePerHour, // Precio por hora de SportsVenue
      imagePath: venue.imageUrl, // Usamos la URL de la imagen
      rating: venue.rating,
      reviewCount: venue.reviewCount,
      description: venue.description,
      facilities: List<String>.from(
        venue.facilities,
      ), // Convertir la lista de facilidades
    );
  }
}
