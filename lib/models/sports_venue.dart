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

  factory SportsVenue.fromJson(Map<String, dynamic> json) {
    return SportsVenue(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      sport: json['sport'] ?? '',
      location: json['location'] ?? '',
      description: json['description'] ?? '',
      pricePerHour: (json['pricePerHour'] ?? 0).toDouble(),
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      imageUrl: json['imageUrl'] ?? '',
      facilities: List<String>.from(json['facilities'] ?? []),
      galleryImages: List<String>.from(json['galleryImages'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sport': sport,
      'location': location,
      'description': description,
      'pricePerHour': pricePerHour,
      'rating': rating,
      'reviewCount': reviewCount,
      'imageUrl': imageUrl,
      'facilities': facilities,
      'galleryImages': galleryImages,
    };
  }
}
