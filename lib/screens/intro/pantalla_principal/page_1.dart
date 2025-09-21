// lib/screens/intro/page_one.dart
import 'package:flutter/material.dart';

class PageOne extends StatelessWidget {
  const PageOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/img/basketball_intro.png', // Ruta de la imagen
            width: 500, // Ajusta el tamaño de la imagen
            height: 500,
          ),
          const SizedBox(height: 20),
          const Text(
            'Selecciona tu Cancha y Horario',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'Selecciona una cancha y un horario disponibles en el calendario.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
