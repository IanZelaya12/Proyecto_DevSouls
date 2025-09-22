import '../models/sports_venue.dart';

final mockVenues = <SportsVenue>[
  SportsVenue(
    id: 'v1',
    name: 'Centro Deportivo Los Olivos',
    sport: 'Fútbol',
    location: 'Av. Principal 123, Tegucigalpa',
    description:
        'Cancha techada con césped sintético, baños y estacionamiento.',
    pricePerHour: 250.0,
    rating: 4.5,
    reviewCount: 132,
    imageUrl: 'assets/img/venue1.png', // o una URL
    facilities: ['Estacionamiento', 'Baños', 'Iluminación', 'Vestidores'],
    galleryImages: [
      'assets/img/venue1.png',
      'assets/img/venue2.png',
      'assets/img/venue3.png',
    ],
  ),
  SportsVenue(
    id: 'v2',
    name: 'Complejo Deportivo El Salvador',
    sport: 'Natación',
    location: 'Col. El Salvador, Comayagüela',
    description: 'Piscina semi-olímpica con carriles y salvavidas.',
    pricePerHour: 300.0,
    rating: 4.2,
    reviewCount: 98,
    imageUrl: 'assets/img/venue2.png',
    facilities: ['Duchas', 'Locker', 'Iluminación', 'Cafetería'],
    galleryImages: [
      'assets/img/venue2.png',
      'assets/img/venue1.png',
      'assets/img/venue3.png',
    ],
  ),
  SportsVenue(
    id: 'v3',
    name: 'Polideportivo San Rafael',
    sport: 'Básquetbol',
    location: 'Res. San Rafael, Tegucigalpa',
    description: 'Gimnasio con cancha de madera y tableros profesionales.',
    pricePerHour: 180.0,
    rating: 4.0,
    reviewCount: 61,
    imageUrl: 'assets/img/venue3.png',
    facilities: ['Graderías', 'Aireado', 'Iluminación', 'Parqueo'],
    galleryImages: [
      'assets/img/venue3.png',
      'assets/img/venue2.png',
      'assets/img/venue1.png',
    ],
  ),
];
