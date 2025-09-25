import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Importamos Firestore
import '../../models/sports_venue.dart'; // Importamos el modelo SportsVenue

class CourtDetailScreen extends StatefulWidget {
  final String courtId; // Recibimos el ID de la cancha

  const CourtDetailScreen({required this.courtId});

  @override
  _CourtDetailScreenState createState() => _CourtDetailScreenState();
}

class _CourtDetailScreenState extends State<CourtDetailScreen> {
  late SportsVenue
  venue; // Creamos una variable para almacenar los detalles del SportsVenue

  // Cargar los detalles de la cancha desde Firestore
  Future<void> _loadCourtDetails() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('sports_venues') // Colección de canchas en Firestore
          .doc(widget.courtId) // Usamos el ID de la cancha
          .get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        setState(() {
          // Creamos el objeto SportsVenue usando los datos de Firestore
          venue = SportsVenue(
            id: doc.id,
            name: data['name'] ?? '',
            sport: data['sport'] ?? '',
            location: data['location'] ?? '',
            pricePerHour:
                data['pricePerHour']?.toDouble() ??
                0.0, // Asegúrate de convertirlo a double
            imageUrl: data['imageUrl'] ?? '',
            rating:
                data['rating']?.toDouble() ??
                0.0, // Asegúrate de convertirlo a double
            reviewCount: data['reviewCount'] ?? 0,
            description: data['description'] ?? '',
            facilities: List<String>.from(data['facilities'] ?? []),
            galleryImages: List<String>.from(data['galleryImages'] ?? []),
          );
        });
      }
    } catch (e) {
      print("Error al cargar los detalles de la cancha: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _loadCourtDetails(); // Llamamos a la función para cargar los datos de la cancha
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: const Color.fromARGB(255, 255, 255, 255)),
      body: venue == null
          ? Center(child: CircularProgressIndicator()) // Pantalla de carga
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Imagen de la cancha
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        venue.imageUrl, // Usamos la URL de la cancha
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Nombre de la cancha y ubicación
                    Text(
                      venue.name,
                      style: GoogleFonts.lato(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      venue.location,
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
                    Text(
                      venue.description,
                      style: GoogleFonts.lato(fontSize: 16),
                    ),
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
                      children: venue.facilities.map((facility) {
                        return _buildFacilityIcon(Icons.check_circle, facility);
                      }).toList(),
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
                        children: venue.galleryImages.map((imageUrl) {
                          return _buildGalleryPhoto(
                            imageUrl,
                          ); // Asegúrate de usar la URL de Firestore
                        }).toList(),
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
                          target: LatLng(
                            13.9671,
                            -75.159,
                          ), // Ubicación predeterminada
                          zoom: 15,
                        ),
                        markers: {
                          Marker(
                            markerId: MarkerId(venue.name),
                            position: LatLng(
                              13.9671,
                              -75.159,
                            ), // Ubicación predeterminada
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
                          '${venue.rating} (${venue.reviewCount} opiniones)',
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
                          'L ${venue.pricePerHour}/h',
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

  Widget _buildGalleryPhoto(String imageUrl) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          imageUrl, // Aquí usamos la URL de la galería desde Firestore
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
