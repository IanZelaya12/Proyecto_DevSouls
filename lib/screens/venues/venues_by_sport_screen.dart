// lib/screens/venues/venues_by_sport_screen.dart
import 'package:flutter/material.dart';
import '../sport_filters/widgets/styles.dart';
import '../Reservas/reservation_screen.dart';

class VenuesBySportScreen extends StatefulWidget {
  final String sportName;
  final String sportImage;

  const VenuesBySportScreen({
    super.key,
    required this.sportName,
    required this.sportImage,
  });

  @override
  _VenuesBySportScreenState createState() => _VenuesBySportScreenState();
}

class _VenuesBySportScreenState extends State<VenuesBySportScreen> {
  List<VenueData> venues = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVenues();
  }

  void _loadVenues() {
    // Simulación de carga de datos - aquí conectarías con Firestore
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        venues = _getMockVenues();
        isLoading = false;
      });
    });
  }

  List<VenueData> _getMockVenues() {
    // Datos de ejemplo - reemplaza con datos reales de Firestore
    return [
      VenueData(
        name: 'Centro Deportivo Los Olivos',
        address: 'Av. Principal 123, Tegucigalpa',
        distance: '2.5 km',
        rating: 4.5,
        priceRange: 'L. 150-300',
        imageUrl: 'assets/img/fut1.jpg',
      ),
      VenueData(
        name: 'Complejo Deportivo El Salvador',
        address: 'Col. El Salvador, Comayagüela',
        distance: '4.2 km',
        rating: 4.2,
        priceRange: 'L. 200-400',
        imageUrl: 'assets/img/fut2.jpg',
      ),
      VenueData(
        name: 'Polideportivo San Rafael',
        address: 'Res. San Rafael, Tegucigalpa',
        distance: '6.1 km',
        rating: 4.0,
        priceRange: 'L. 100-250',
        imageUrl: 'assets/img/fut1.jpg',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          'Lugares para ${widget.sportName}',
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? _buildLoadingState()
          : venues.isEmpty
          ? _buildEmptyState()
          : _buildVenuesList(),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
          ),
          const SizedBox(height: 16),
          Text(
            'Buscando lugares para ${widget.sportName}...',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_off, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 24),
            Text(
              'No hay lugares disponibles',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'No se encontraron lugares para practicar ${widget.sportName} cerca de tu ubicación.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Volver',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVenuesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: venues.length,
      itemBuilder: (context, index) {
        final venue = venues[index];
        return _buildVenueCard(venue);
      },
    );
  }

  Widget _buildVenueCard(VenueData venue) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          _showVenueDetails(venue);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen del lugar
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[300],
                  child: Icon(
                    Icons.location_city,
                    size: 40,
                    color: Colors.grey[600],
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
                      venue.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            venue.address,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.directions_walk,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          venue.distance,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const Spacer(),
                        Icon(Icons.star, size: 16, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          venue.rating.toString(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      venue.priceRange,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showVenueDetails(VenueData venue) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              venue.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildDetailRow(Icons.location_on, 'Dirección', venue.address),
            _buildDetailRow(Icons.directions_walk, 'Distancia', venue.distance),
            _buildDetailRow(Icons.star, 'Calificación', '${venue.rating}/5'),
            _buildDetailRow(Icons.attach_money, 'Precio', venue.priceRange),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ReservationScreen(venueName: venue.name),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Reservar ahora',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}

class VenueData {
  final String name;
  final String address;
  final String distance;
  final double rating;
  final String priceRange;
  final String imageUrl;

  VenueData({
    required this.name,
    required this.address,
    required this.distance,
    required this.rating,
    required this.priceRange,
    required this.imageUrl,
  });
}
