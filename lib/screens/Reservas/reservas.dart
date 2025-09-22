import 'package:flutter/material.dart';
import 'widgets/reserva_card.dart';

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
  List<Reserva> filteredReservas = reservas; // Inicialmente todas

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

              // Título
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Reservas Disponibles',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),

              // Lista filtrada
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
                          return ReservaCard(reserva: filteredReservas[index]);
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

// Datos de ejemplo
List<Reserva> reservas = [
  Reserva(
    'Cancha de Fútbol',
    'Martes - 17/08 a las 09:30',
    'assets/img/futbol.png',
  ),
  Reserva(
    'Piscina para Natación',
    'Sábado - 19/09 a las 09:30',
    'assets/img/natacion.png',
  ),
  Reserva('Gimnasia', 'Domingo - 21/03 a las 09:30', 'assets/img/gimnasia.png'),
  Reserva(
    'Ring de Judo',
    'Lunes - 21/08 a las 12:30',
    'assets/img/artes_marciales.png',
  ),
];
