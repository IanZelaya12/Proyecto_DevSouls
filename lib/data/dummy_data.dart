import 'package:flutter/material.dart';
import '../models/court_model.dart';
import '../models/sport_model.dart';

// TODO: Reemplaza esto con los datos de tu base de datos o API
final List<Sport> dummySports = [
  Sport(
    name: 'Fútbol',
    imagePath: 'assets/img/futbol.png',
    color: Colors.green.shade100,
  ),
  Sport(
    name: 'Tennis',
    imagePath: 'assets/img/tennis.png',
    color: Colors.orange.shade100,
  ),
  Sport(
    name: 'Yoga',
    imagePath: 'assets/img/yoga.png',
    color: Colors.pink.shade100,
  ),
  Sport(
    name: 'Boxeo',
    imagePath: 'assets/img/boxeo.png',
    color: Colors.red.shade100,
  ),
  Sport(
    name: 'Natación',
    imagePath: 'assets/img/natacion.png',
    color: Colors.blue.shade100,
  ),
  Sport(
    name: 'Baloncesto',
    imagePath: 'assets/img/basket.png',
    color: Colors.orange.shade300,
  ),
];

final List<Court> dummyCourts = [
  Court(
    name: 'Cancha de Volleyball',
    sport: 'Volleyball',
    location: 'Blvd. Morazán, Tegucigalpa',
    price: 35.00,
    imagePath: 'assets/img/volleyball_court.jpg',
    rating: 4.8,
    reviewCount: 120,
    description:
        'Una cancha amplia para partidos de volleyball. Ideal para grupos grandes.',
    facilities: const [
      'Césped artificial',
      'Iluminación',
      'Gradas',
    ], // Lista constante
  ),
  Court(
    name: 'Estadio Atlético',
    sport: 'Fútbol',
    location: 'Villas del Sol, Tegucigalpa',
    price: 50.00,
    imagePath: 'assets/img/stadium.jpg',
    rating: 4.9,
    reviewCount: 250,
    description:
        'Estadio profesional para partidos de fútbol. Capacidad para 5000 personas.',
    facilities: const [
      'Césped natural',
      'Gradas',
      'Vestidores',
    ], // Lista constante
  ),
  Court(
    name: 'Piscina Olímpica',
    sport: 'Natacion',
    location: 'Colonia Kennedy, Tegucigalpa',
    price: 25.00,
    imagePath: 'assets/img/pool.jpg',
    rating: 4.7,
    reviewCount: 95,
    description: 'Piscina olímpica para entrenamientos y competencias.',
    facilities: const [
      'Piscina olímpica',
      'Gradas',
      'Sauna',
    ], // Lista constante
  ),
];
