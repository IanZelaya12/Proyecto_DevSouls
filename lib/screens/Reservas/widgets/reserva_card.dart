import 'package:flutter/material.dart';
import '../reservas.dart';

class ReservaCard extends StatelessWidget {
  final Reserva reserva;

  const ReservaCard({super.key, required this.reserva});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth * 0.045; // Tamaño adaptativo de fuente

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 5,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 160,
          decoration: BoxDecoration(color: Colors.grey[300]),
          child: Stack(
            children: [
              // Imagen de fondo
              Positioned.fill(
                child: Image.asset(
                  reserva.imagen,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[400],
                      child: Icon(
                        Icons.sports,
                        size: screenWidth * 0.15,
                        color: Colors.white.withOpacity(0.6),
                      ),
                    );
                  },
                ),
              ),

              // Degradado oscuro para legibilidad
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.black.withOpacity(0.2),
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
              ),

              // Contenido textual
              Positioned(
                left: 16,
                bottom: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reserva.nombre,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      reserva.fecha,
                      style: TextStyle(
                        fontSize: fontSize * 0.8,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
