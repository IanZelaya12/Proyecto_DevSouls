import 'package:flutter/material.dart';
import '../models/court_model.dart';
import '../models/sport_model.dart';

// TODO: Reemplaza esto con los datos de tu base de datos o API
final List<Sport> dummySports = [
  Sport(
    name: 'Fútbol',
    imagePath: 'assets/images/futbol.png',
    color: Colors.green.shade100,
  ),
  Sport(
    name: 'Tennis',
    imagePath: 'assets/images/tennis.png',
    color: Colors.orange.shade100,
  ),
  Sport(
    name: 'Yoga',
    imagePath: 'assets/images/yoga.png',
    color: Colors.pink.shade100,
  ),
  Sport(
    name: 'Boxeo',
    imagePath: 'assets/images/boxeo.png',
    color: Colors.red.shade100,
  ),
  Sport(
    name: 'Natación',
    imagePath: 'assets/images/natacion.png',
    color: Colors.blue.shade100,
  ),
  Sport(
    name: 'Baloncesto',
    imagePath: 'assets/images/basket.png',
    color: Colors.orange.shade300,
  ),
];

final List<Court> dummyCourts = [
  const Court(
    name: 'Cancha de Volleyball',
    location: 'Blvd. Morazán, Tegucigalpa',
    price: 35.00,
    imagePath: 'assets/images/volleyball_court.jpg',
    rating: 4.8,
    reviewCount: 120,
  ),
  const Court(
    name: 'Estadio Atlético',
    location: 'Villas del Sol, Tegucigalpa',
    price: 50.00,
    imagePath: 'assets/images/stadium.jpg',
    rating: 4.9,
    reviewCount: 250,
  ),
  const Court(
    name: 'Piscina Olímpica',
    location: 'Colonia Kennedy, Tegucigalpa',
    price: 25.00,
    imagePath: 'assets/images/pool.jpg',
    rating: 4.7,
    reviewCount: 95,
  ),
];
