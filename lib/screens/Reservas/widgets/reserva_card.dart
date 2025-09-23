import 'package:flutter/material.dart';
import '../reservas.dart';

class ReservaCard extends StatelessWidget {
  final Reserva reserva;
  final VoidCallback? onTap; // Callback cuando la tarjeta es tocada
  final VoidCallback?
  onCancel; // Callback cuando el ícono de cancelación es tocado

  const ReservaCard({
    super.key,
    required this.reserva,
    this.onTap,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth * 0.045;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap, // Llama al callback al tocar la tarjeta
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 5,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: 160,
              child: Stack(
                children: [
                  // Fondo gris por defecto
                  Positioned.fill(
                    child: Container(
                      color: Colors.grey[400],
                      child: Icon(
                        Icons.sports,
                        size: screenWidth * 0.15,
                        color: Colors.white.withOpacity(0.6),
                      ),
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
                  // Ícono de cancelación
                  Positioned(
                    right: 8,
                    top: 8,
                    child: IconButton(
                      icon: const Icon(
                        Icons.cancel,
                        color: Colors.red,
                        size: 30,
                      ),
                      onPressed: onCancel, // Llama al callback de cancelación
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
