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
  const Court(
    name: 'Cancha de Volleyball',
    location: 'Blvd. Morazán, Tegucigalpa',
    price: 35.00,
    imagePath: 'assets/img/volleyball_court.jpg',
    rating: 4.8,
    reviewCount: 120,
  ),
  const Court(
    name: 'Estadio Atlético',
    location: 'Villas del Sol, Tegucigalpa',
    price: 50.00,
    imagePath: 'assets/img/stadium.jpg',
    rating: 4.9,
    reviewCount: 250,
  ),
  const Court(
    name: 'Piscina Olímpica',
    location: 'Colonia Kennedy, Tegucigalpa',
    price: 25.00,
    imagePath: 'assets/img/pool.jpg',
    rating: 4.7,
    reviewCount: 95,
  ),
];
