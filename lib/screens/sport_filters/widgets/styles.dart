// lib/screens/search/widgets/styles.dart
import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(
    0xFF4CAF50,
  ); // Color principal (verde)
  static const Color backgroundColor = Color(0xFFF5F5F5); // Color de fondo

  // Colores para las tarjetas de los deportes
  static const Map<String, Color> sportCardColors = {
    'Futbol': Color(0xFF4CAF50), // Verde
    'Correr': Color(0xFFF44336), // Rojo
    'Yoga': Color(0xFFE91E63), // Rosa
    'Fit Dance': Color(0xFF9C27B0), // Morado
    'Natacion': Color(0xFF2196F3), // Azul
    'Volei': Color(0xFFFFC107), // Amarillo
    'Basketball': Color(0xFFFF9800), // Naranja
    'Gimnasia': Color(0xFF9E9E9E), // Gris
    'Artes marciales': Color(0xFF9C27B0), // Morado
    'Hip Hop': Color(0xFF607D8B), // Azul oscuro
    'Calistenia': Color(0xFF3F51B5), // Azul claro
    'Ping-Pong': Color(0xFF795548), // Marrón
  };
}
