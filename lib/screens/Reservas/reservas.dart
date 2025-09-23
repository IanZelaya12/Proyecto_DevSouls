import 'package:flutter/material.dart';
import 'package:proyecto_devsouls/screens/Reservas/reservation_screen.dart';
import 'widgets/reserva_card.dart';

// Modelo de reserva
class Reserva {
  final String nombre;
  final String fecha;

  Reserva(this.nombre, this.fecha);
}

class ReservasScreen extends StatefulWidget {
  const ReservasScreen({super.key});

  @override
  _ReservasScreenState createState() => _ReservasScreenState();
}

class _ReservasScreenState extends State<ReservasScreen> {
  TextEditingController searchController = TextEditingController();
  List<Reserva> filteredReservas = reservas; // Lista de reservas

  @override
  void initState() {
    super.initState();
    searchController.addListener(_filterReservas);
  }

  void _filterReservas() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredReservas = reservas.where((reserva) {
        return reserva.nombre.toLowerCase().contains(query) ||
            reserva.fecha.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _cancelReserva(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cancelar Reserva'),
          content: const Text(
            '¿Estás seguro de que deseas cancelar esta reserva?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cierra el diálogo sin hacer nada
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  reservas.removeAt(index); // Elimina la reserva de la lista
                  filteredReservas = reservas; // Actualiza la lista filtrada
                });
                Navigator.pop(context); // Cierra el diálogo después de cancelar
              },
              child: const Text('Sí'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Campo de búsqueda
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar reservas...',
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

              // Lista filtrada de reservas
              Expanded(
                child: filteredReservas.isEmpty
                    ? Center(
                        child: Text(
                          "No se encontraron reservas",
                          style: TextStyle(
                            fontSize: screenHeight * 0.02,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredReservas.length,
                        itemBuilder: (context, index) {
                          final r = filteredReservas[index];
                          return ReservaCard(
                            reserva: r,
                            onTap: () {
                              // Al tocar, navega a la pantalla de Reservar
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ReservationScreen(venueName: r.nombre),
                                ),
                              );
                            },
                            onCancel: () {
                              // Llamar al método de cancelación al tocar el ícono de cancelación
                              _cancelReserva(index);
                            },
                          );
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

// Lista vacía de reservas
List<Reserva> reservas = [];
