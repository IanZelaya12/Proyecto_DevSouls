import 'package:flutter/material.dart';
import 'package:proyecto_devsouls/services/FirebaseFirestore.dart'; // Importa el servicio Firestore

// Clase Reserva movida aquí directamente desde reserva_model.dart
class Reserva {
  final String id;
  final String nombre;
  final String fechaHora;
  final String imageUrl; // Asegúrate de tener este campo
  final String hora;
  final String userId;

  Reserva({
    required this.id,
    required this.nombre,
    required this.fechaHora,
    required this.imageUrl, // Asegúrate de incluir la URL de la imagen aquí
    required this.hora,
    required this.userId,
  });
}

class ReservasScreen extends StatefulWidget {
  const ReservasScreen({super.key});

  @override
  _ReservasScreenState createState() => _ReservasScreenState();
}

class _ReservasScreenState extends State<ReservasScreen> {
  List<Reserva> filteredReservas = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReservas();
  }

  // Función para cargar las reservas desde Firestore
  Future<void> _loadReservas() async {
    try {
      // Obtener las reservas del usuario desde Firestore
      List<Reserva> reservas = await FirestoreService().getUserReservations();

      setState(() {
        filteredReservas = reservas;
        isLoading = false;
      });
    } catch (e) {
      print("Error al cargar las reservas: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  // Función para cancelar una reserva
  void _cancelReserva(String reservaId) {
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
              onPressed: () async {
                // Cancelar la reserva en Firestore
                await FirestoreService().cancelReservation(reservaId);
                setState(() {
                  filteredReservas.removeWhere(
                    (reserva) => reserva.id == reservaId,
                  );
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Campo de búsqueda
              TextField(
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

              // Mostrar estado de carga o lista de reservas
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredReservas.isEmpty
                  ? const Center(child: Text('No se encontraron reservas'))
                  : Expanded(
                      child: ListView.builder(
                        itemCount: filteredReservas.length,
                        itemBuilder: (context, index) {
                          final reserva = filteredReservas[index];
                          return ReservaCard(
                            reserva: reserva,
                            onCancel: () {
                              // Llamar al método de cancelación al tocar el ícono de cancelación
                              _cancelReserva(reserva.id);
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

class ReservaCard extends StatelessWidget {
  final Reserva reserva;
  final Function() onCancel;

  const ReservaCard({super.key, required this.reserva, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen del lugar (imagen URL)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[300],
                  child: reserva.imageUrl.isEmpty
                      ? Icon(
                          Icons.image_not_supported,
                          size: 40,
                          color: Colors.grey[600],
                        )
                      : Image.network(
                          reserva.imageUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return Center(
                                child: CircularProgressIndicator(
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                            (loadingProgress
                                                    .expectedTotalBytes ??
                                                1)
                                      : null,
                                ),
                              );
                            }
                          },
                        ),
                ),
              ),
              const SizedBox(width: 16),
              // Información de la reserva
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reserva.nombre,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      reserva.fechaHora,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          reserva.hora,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(icon: const Icon(Icons.delete), onPressed: onCancel),
            ],
          ),
        ),
      ),
    );
  }
}
