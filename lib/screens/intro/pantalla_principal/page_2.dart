// lib/screens/onboarding/page_two.dart
import 'package:flutter/material.dart';

class PageTwo extends StatelessWidget {
  const PageTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/img/voleibol_intro.png', // Ruta de la imagen
            width: 500, // Ajusta el tamaño de la imagen
            height: 500,
          ),
          const SizedBox(height: 20),
          const Text(
            'Pantalla de Pago',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'Confirma el resumen de tu reserva y completa el pago de forma segura.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
