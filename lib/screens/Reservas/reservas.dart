// lib/screens/reservas/reservas_screen.dart
import 'package:flutter/material.dart';
import 'widgets/styles.dart'; // Importar los estilos
import 'widgets/reserva_card.dart'; // Importar la tarjeta de reserva

class Reserva {
  final String nombre;
  final String fecha;
  final String imagen;

  Reserva(this.nombre, this.fecha, this.imagen);
}

class ReservasScreen extends StatefulWidget {
  const ReservasScreen({super.key});

  @override
  _ReservasScreenState createState() => _ReservasScreenState();
}

class _ReservasScreenState extends State<ReservasScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Campo de búsqueda de reservas
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Búsqueda de reservas...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Reservas Disponibles',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              // Lista de reservas
              Expanded(
                child: ListView.builder(
                  itemCount: reservas.length, // Cantidad de reservas
                  itemBuilder: (context, index) {
                    return ReservaCard(
                      reserva: reservas[index],
                    ); // Pasamos cada instancia de reserva
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Datos de ejemplo de las reservas
List<Reserva> reservas = [
  Reserva(
    'Cancha de Fútbol',
    'Martes - 17/08 a las 09:30',
    'assets/soccer_field.png',
  ),
  Reserva(
    'Piscina para Natación',
    'Sábado - 19/09 a las 09:30',
    'assets/swimming_pool.png',
  ),
  Reserva('Gimnasia', 'Domingo - 21/03 a las 09:30', 'assets/gymnastics.png'),
  Reserva('Ring de Judo', 'Lunes - 21/08 a las 12:30', 'assets/judo.png'),
];
