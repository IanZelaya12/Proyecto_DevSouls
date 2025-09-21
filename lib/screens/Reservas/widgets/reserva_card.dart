// lib/screens/reservas/widgets/reserva_card.dart
import 'package:flutter/material.dart';
import '../reservas.dart';
import 'styles.dart'; // Importar estilos

class ReservaCard extends StatelessWidget {
  final Reserva
  reserva; // Aquí declaramos correctamente el parámetro de tipo Reserva

  // Constructor correcto
  const ReservaCard({super.key, required this.reserva});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          height: 150,
          color: Colors.green.shade300,
          child: Row(
            children: [
              Image.asset(
                reserva.imagen,
                width: 120,
                fit: BoxFit.cover,
              ), // Usamos reserva.imagen aquí
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reserva
                            .nombre, // Aquí accedemos al nombre de la reserva
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        reserva.fecha, // Y aquí a la fecha
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
