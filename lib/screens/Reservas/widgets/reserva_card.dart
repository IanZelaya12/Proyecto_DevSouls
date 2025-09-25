import 'package:flutter/material.dart';

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
    required this.imageUrl, // Asegúrate de incluir la URL aquí
    required this.hora,
    required this.userId,
  });
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
              // Información del lugar
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
