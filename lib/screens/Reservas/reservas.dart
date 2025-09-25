// lib/screens/Reservas/reservas.dart
import 'package:flutter/material.dart';
import 'package:proyecto_devsouls/services/firebase_firestore.dart';

class Reserva {
  final String id;
  final String nombre;
  final String fechaHora;
  final String imageUrl;
  final String hora;
  final String userId;

  Reserva({
    required this.id,
    required this.nombre,
    required this.fechaHora,
    required this.imageUrl,
    required this.hora,
    required this.userId,
  });
}

class ReservasScreen extends StatelessWidget {
  const ReservasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = FirestoreService();

    return Scaffold(
      appBar: AppBar(title: const Text('Mis Reservas')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Campo de búsqueda (sin lógica de filtrado por simplicidad)
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
              Expanded(
                child: StreamBuilder<List<Reserva>>(
                  stream: service.streamUserReservations(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    final reservas = snapshot.data ?? [];
                    if (reservas.isEmpty) {
                      return const Center(
                        child: Text('No se encontraron reservas'),
                      );
                    }
                    return ListView.builder(
                      itemCount: reservas.length,
                      itemBuilder: (context, index) {
                        final r = reservas[index];
                        return ReservaCard(
                          reserva: r,
                          onCancel: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Cancelar Reserva'),
                                content: const Text(
                                  '¿Estás seguro de cancelar esta reserva?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(ctx).pop(false),
                                    child: const Text('No'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(ctx).pop(true),
                                    child: const Text('Sí'),
                                  ),
                                ],
                              ),
                            );
                            if (confirm == true) {
                              await FirestoreService().cancelReservation(r.id);
                            }
                          },
                        );
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                      : Image.network(reserva.imageUrl, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 16),
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
