// lib/screens/onboarding/page_three.dart
import 'package:flutter/material.dart';

class PageThree extends StatelessWidget {
  const PageThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/img/futbol_intro.png', // Ruta de la imagen
            width: 500, // Ajusta el tamaño de la imagen
            height: 500,
          ),
          const SizedBox(height: 20),
          const Text(
            'Pantalla de Confirmación',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'Tu reserva está lista! Recibirás los detalles y un código QR para entrar a la cancha.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
