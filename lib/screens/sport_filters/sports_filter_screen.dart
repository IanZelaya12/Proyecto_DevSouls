// lib/screens/sport_filters/sport_filter_screen.dart
import 'package:flutter/material.dart';
import 'widgets/styles.dart';
import 'widgets/sport_category_card.dart';
import '../venues/venues_by_sport_screen.dart'; // Pantalla que mostrarás después

class SportsFilterScreen extends StatefulWidget {
  const SportsFilterScreen({super.key});

  @override
  _SportsFilterScreenState createState() => _SportsFilterScreenState();
}

class _SportsFilterScreenState extends State<SportsFilterScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<SportData> _filteredSports = [];
  List<SportData> _allSports = [];

  @override
  void initState() {
    super.initState();
    _initializeSports();
    _filteredSports = _allSports;
  }

  void _initializeSports() {
    _allSports = [
      SportData('Fútbol', 'assets/img/futbol.png', Colors.green),
      SportData('Correr', 'assets/img/correr.png', Colors.red),
      SportData('Yoga', 'assets/img/yoga.png', Colors.pinkAccent),
      SportData('Fit Dance', 'assets/img/fit_dance.png', Colors.pink),
      SportData('Natación', 'assets/img/natacion.png', Colors.blueGrey),
      SportData('Voleibol', 'assets/img/volei.png', Colors.orange),
      SportData('Basketball', 'assets/img/basketball.png', Colors.deepOrange),
      SportData('Gimnasia', 'assets/img/gimnasia.png', Colors.teal),
      SportData(
        'Artes marciales',
        'assets/img/artes_marciales.png',
        Colors.red.shade900,
      ),
      SportData('Hip Hop', 'assets/img/hiphop.png', Colors.grey),
      SportData('Calistenia', 'assets/img/calistenia.png', Colors.black87),
      SportData('Ping-Pong', 'assets/img/pingpong.png', Colors.cyan),
    ];
  }

  void _filterSports(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredSports = _allSports;
      } else {
        _filteredSports = _allSports
            .where(
              (sport) => sport.name.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  void _onSportSelected(SportData sport) {
    // Navegar a la pantalla de lugares disponibles para ese deporte
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VenuesBySportScreen(
          sportName: sport.name,
          sportImage: sport.imagePath,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        title: const Text(
          'Deportes disponibles',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Campo de búsqueda
              TextField(
                controller: _searchController,
                onChanged: _filterSports,
                decoration: InputDecoration(
                  hintText: 'Buscar deporte por nombre...',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                            _filterSports('');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColors.primaryColor,
                      width: 2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Contador de resultados
              Text(
                'Encontrados: ${_filteredSports.length} deportes',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 16),

              // Grid de deportes
              Expanded(
                child: _filteredSports.isEmpty
                    ? _buildEmptyState()
                    : GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: screenWidth > 600 ? 3 : 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 2, // cards horizontales
                        ),
                        itemCount: _filteredSports.length,
                        itemBuilder: (context, index) {
                          final sport = _filteredSports[index];
                          return SportCategoryCard(
                            sportName: sport.name,
                            sportImage: sport.imagePath,
                            backgroundColor: sport.backgroundColor,
                            onTap: () => _onSportSelected(sport),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No se encontraron deportes',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Intenta con otro término de búsqueda',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

// Clase de datos para cada deporte
class SportData {
  final String name;
  final String imagePath;
  final Color backgroundColor;

  SportData(this.name, this.imagePath, this.backgroundColor);
}
