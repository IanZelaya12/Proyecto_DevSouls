// lib/screens/court_detail/court_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/court_model.dart';

class CourtDetailScreen extends StatelessWidget {
  final Court court;

  const CourtDetailScreen({required this.court});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(
          255,
          255,
          255,
          255,
        ), // Color similar to the design
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen de la cancha
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  court.imagePath,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),

              // Nombre de la cancha y ubicación
              Text(
                court.name,
                style: GoogleFonts.lato(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                court.location,
                style: GoogleFonts.lato(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 30),

              _buildSeparator(),

              // Descripción
              Text(
                "Descripción",
                style: GoogleFonts.lato(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(court.description, style: GoogleFonts.lato(fontSize: 16)),
              const SizedBox(height: 40),

              _buildSeparator(),

              // Facilidades
              Text(
                "Facilidades",
                style: GoogleFonts.lato(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Wrap(
                spacing: 10,
                children: [
                  _buildFacilityIcon(Icons.pool, 'Piscina'),
                  _buildFacilityIcon(Icons.wifi, 'Wi-Fi'),
                  _buildFacilityIcon(Icons.restaurant, 'Restaurante'),
                  _buildFacilityIcon(Icons.local_parking, 'Estacionamiento'),
                ],
              ),
              const SizedBox(height: 40),

              _buildSeparator(),

              // Galería de Fotos
              Text(
                "Galería de Fotos",
                style: GoogleFonts.lato(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildGalleryPhoto('assets/img/volleyball_court.jpg'),
                    _buildGalleryPhoto('assets/img/volleyball_court.jpg'),
                    _buildGalleryPhoto('assets/img/volleyball_court.jpg'),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              _buildSeparator(),

              // Mapa de la ubicación
              Text(
                "Ubicación",
                style: GoogleFonts.lato(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                height: 200,
                width: double.infinity,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(13.9671, -75.159),
                    zoom: 15,
                  ),
                  markers: {
                    Marker(
                      markerId: MarkerId(court.name),
                      position: LatLng(13.9671, -75.159),
                    ),
                  },
                ),
              ),
              const SizedBox(height: 30),

              _buildSeparator(),

              // Reseñas
              Text(
                "Reseñas",
                style: GoogleFonts.lato(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.yellow),
                  Text(
                    '${court.rating} (${court.reviewCount} opiniones)',
                    style: GoogleFonts.lato(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              _buildSeparator(),
              const SizedBox(height: 25),

              // Precio y botón de reserva
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'L ${court.price}/h',
                    style: GoogleFonts.lato(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Lógica para hacer una reserva
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 40,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                    child: Text(
                      'Reservar',
                      style: GoogleFonts.lato(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGalleryPhoto(String imagePath) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          imagePath,
          width: 120,
          height: 80,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildFacilityIcon(IconData icon, String label) {
    return Chip(
      avatar: Icon(icon, color: Colors.white),
      label: Text(label, style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.green,
    );
  }

  Widget _buildSeparator() {
    return Container(
      height: 1,
      color: Colors.grey.shade300, // Color de la línea
    );
  }
}
