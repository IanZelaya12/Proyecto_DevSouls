// home.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_devsouls/models/court_model.dart'; // Importamos el modelo Court
import 'package:proyecto_devsouls/models/sports_venue.dart';
import 'package:proyecto_devsouls/services/FirebaseFirestore.dart';
import 'widgets/styles.dart';
import 'widgets/featured_court_card.dart';
import 'widgets/recent_court_list_item.dart';
import '../sport_filters/sports_filter_screen.dart';
import '../Reservas/reservas.dart';
import '../Perfil/perfil.dart';
import '../Mapa/mapa.dart';
import 'courtdetalles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user;
  bool _isLoading = true;
  int _selectedIndex = 0;
  String selectedSport = '';
  String searchQuery = '';
  bool showRecentViews = false; // Para mostrar u ocultar las vistas recientes
  final PageController _pageController = PageController();

  List<Court> courts = [];

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
    _loadVenues(); // Cargar los datos desde Firestore
  }

  void _checkAuthentication() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, 'init');
      }
    } else {
      setState(() {
        this.user = user;
        _isLoading = false;
      });
    }
  }

  // Función para cargar los datos desde Firestore
  void _loadVenues() async {
    try {
      FirestoreService firestoreService = FirestoreService();
      List<SportsVenue> venues = await firestoreService
          .getSportsVenues(); // Obtener lugares deportivos de Firestore
      setState(() {
        courts = venues
            .map((venue) => Court.fromSportsVenue(venue))
            .toList(); // Convertir a Court
      });
    } catch (e) {
      print("Error al cargar los lugares deportivos: $e");
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  // Filtrar canchas según deporte seleccionado
  List<Court> _filterCourtsBySport(List<Court> courts) {
    if (selectedSport.isEmpty)
      return courts; // Si no hay filtro, mostrar todas las canchas
    return courts
        .where(
          (court) => court.sport.toLowerCase() == selectedSport.toLowerCase(),
        )
        .toList();
  }

  // Filtrar canchas por búsqueda
  List<Court> _searchCourts(List<Court> courts) {
    if (searchQuery.isEmpty)
      return courts; // Si no hay búsqueda, mostrar todas las canchas
    return courts
        .where(
          (court) =>
              court.name.toLowerCase().contains(searchQuery.toLowerCase()),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(color: Colors.green),
              ) // Pantalla de carga
            : PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                children: [
                  _HomePageContent(
                    onSportSelected: (sport) {
                      setState(() {
                        selectedSport = sport;
                      });
                    },
                    onSearch: (query) {
                      setState(() {
                        searchQuery = query;
                      });
                    },
                    onCourtSelected: () {
                      setState(() {
                        showRecentViews =
                            true; // Al seleccionar una cancha, mostramos las vistas recientes
                      });
                    },
                    showRecentViews: showRecentViews,
                    courts: _filterCourtsBySport(
                      _searchCourts(courts),
                    ), // Filtrar los courts antes de pasarlos
                  ),
                  MapaScreen(),
                  SportsFilterScreen(),
                  ReservasScreen(),
                  PerfilScreen(),
                ],
              ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      backgroundColor: Colors.white,
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: 'Mapa'),
        BottomNavigationBarItem(
          icon: Icon(Icons.sports_soccer),
          label: 'Deportes',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Reservas'),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Perfil',
        ),
      ],
      onTap: _onItemTapped,
    );
  }
}

class _HomePageContent extends StatelessWidget {
  final Function(String) onSportSelected;
  final Function(String) onSearch;
  final Function() onCourtSelected;
  final bool showRecentViews;
  final List<Court> courts; // Lista de canchas filtradas

  const _HomePageContent({
    required this.onSportSelected,
    required this.onSearch,
    required this.onCourtSelected,
    required this.showRecentViews,
    required this.courts, // Recibimos la lista de canchas
  });

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Avatar y Nombre de usuario
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    user?.photoURL ??
                        'https://www.example.com/default_avatar.png',
                  ),
                  radius: 30,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '¡Bienvenido!',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Text(
                      user?.displayName ?? 'Usuario',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.notifications),
                  onPressed: () {
                    // Acciones de notificaciones
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Botón de búsqueda
            TextField(
              decoration: InputDecoration(
                hintText: 'Buscar canchas o deportes...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: onSearch,
            ),
            const SizedBox(height: 20),

            // Chips de filtro
            _buildFilterChips(),

            const SizedBox(height: 20),

            // Carrusel de canchas destacadas
            SizedBox(
              height: 250,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: courts.length, // Usamos courts en vez de dummyCourts
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      onCourtSelected(); // Muestra las vistas recientes al seleccionar una cancha
                    },
                    child: FeaturedCourtCard(
                      court: courts[index],
                    ), // Usamos court en vez de dummyCourts
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Mostrar vistas recientes si ya se seleccionó una cancha
            if (showRecentViews) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Vistas recientes',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Mostrar vistas recientes
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: courts.length, // Usamos courts en vez de dummyCourts
                itemBuilder: (context, index) {
                  return RecentCourtListItem(
                    court: courts[index],
                  ); // Usamos court en vez de dummyCourts
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Filtros de deportes interactivos
  Widget _buildFilterChips() {
    return SizedBox(
      height: 35,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ChoiceChip(
            label: Text('Recomendado'),
            selected: false,
            onSelected: (selected) {
              // Mostrar canchas recomendadas al seleccionar "Recomendado"
              onSportSelected('');
            },
            backgroundColor: Colors.white,
            selectedColor: Colors.green.shade100,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          ChoiceChip(
            label: Text('Fútbol'),
            selected: false,
            onSelected: (selected) {
              onSportSelected('fútbol');
            },
            backgroundColor: Colors.white,
            selectedColor: Colors.green.shade100,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          ChoiceChip(
            label: Text('Tenis'),
            selected: false,
            onSelected: (selected) {
              onSportSelected('tenis');
            },
            backgroundColor: Colors.white,
            selectedColor: Colors.green.shade100,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          ChoiceChip(
            label: Text('Yoga'),
            selected: false,
            onSelected: (selected) {
              onSportSelected('yoga');
            },
            backgroundColor: Colors.white,
            selectedColor: Colors.green.shade100,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          ChoiceChip(
            label: Text('Hip Hop'),
            selected: false,
            onSelected: (selected) {
              onSportSelected('hip hop');
            },
            backgroundColor: Colors.white,
            selectedColor: Colors.green.shade100,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          ChoiceChip(
            label: Text('Natación'),
            selected: false,
            onSelected: (selected) {
              onSportSelected('natación');
            },
            backgroundColor: Colors.white,
            selectedColor: Colors.green.shade100,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          ChoiceChip(
            label: Text('Basketball'),
            selected: false,
            onSelected: (selected) {
              onSportSelected('basketball');
            },
            backgroundColor: Colors.white,
            selectedColor: Colors.green.shade100,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          ChoiceChip(
            label: Text('Calistenia'),
            selected: false,
            onSelected: (selected) {
              onSportSelected('calistenia');
            },
            backgroundColor: Colors.white,
            selectedColor: Colors.green.shade100,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          ChoiceChip(
            label: Text('Gimnasia'),
            selected: false,
            onSelected: (selected) {
              onSportSelected('gimnasia');
            },
            backgroundColor: Colors.white,
            selectedColor: Colors.green.shade100,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          ChoiceChip(
            label: Text('Voleibol'),
            selected: false,
            onSelected: (selected) {
              onSportSelected('voleibol');
            },
            backgroundColor: Colors.white,
            selectedColor: Colors.green.shade100,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ],
      ),
    );
  }
}
