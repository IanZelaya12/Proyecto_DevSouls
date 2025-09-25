import 'package:cloud_firestore/cloud_firestore.dart'; // Importamos Firestore
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_devsouls/models/court_model.dart'; // Importamos el modelo Court
import 'package:proyecto_devsouls/models/sports_venue.dart';
import 'package:proyecto_devsouls/services/firebase_firestore.dart';
import 'widgets/styles.dart';
import 'widgets/featured_court_card.dart';
import 'widgets/recent_court_list_item.dart';
import '../sport_filters/sports_filter_screen.dart';
import '../Reservas/reservas.dart';
import '../Perfil/perfil.dart';
import '../Mapa/mapa.dart';
import 'courtdetalles.dart'; // Importamos la pantalla de detalles de cancha

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
  final PageController _pageController = PageController();

  List<Court> courts = [];
  List<Court> recentCourts =
      []; // Lista para almacenar las canchas vistas recientemente

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
    _loadVenues(); // Cargar los datos desde Firestore
    _loadRecentCourts(); // Cargar vistas recientes
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
      _loadRecentCourts(); // Cargar vistas recientes del usuario
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

  // Cargar vistas recientes desde Firestore
  Future<void> _loadRecentCourts() async {
    if (user == null) return; // Asegúrate de que el usuario está autenticado
    final userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid);
    final snapshot = await userRef.get();
    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;
      if (data['recentViews'] != null) {
        List<String> recentCourtIds = List<String>.from(data['recentViews']);
        setState(() {
          recentCourts = recentCourtIds
              .map((id) => courts.firstWhere((court) => court.id == id))
              .toList();
        });
      }
    }
  }

  // Función para manejar la selección de una cancha y agregarla a las vistas recientes
  Future<void> _onCourtSelected(Court court) async {
    if (user == null) return; // Asegúrate de que el usuario está autenticado
    setState(() {
      if (!recentCourts.contains(court)) {
        recentCourts.add(
          court,
        ); // Agregar la cancha seleccionada a las vistas recientes
      }
    });

    // Guardar la cancha en Firestore
    final userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid);
    List<String> recentCourtIds = recentCourts
        .map((court) => court.id)
        .toList();
    userRef.update({
      'recentViews':
          recentCourtIds, // Guardamos el campo recentViews con los IDs
    });
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
                    onCourtSelected: (court) {
                      _onCourtSelected(
                        court,
                      ); // Llamada para agregar la cancha a vistas recientes
                    },
                    courts: _filterCourtsBySport(
                      _searchCourts(courts),
                    ), // Filtrar los courts antes de pasarlos
                    recentCourts: recentCourts, // Pasamos las canchas recientes
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
  final Function(Court)
  onCourtSelected; // Ahora recibimos la función para manejar la selección de cancha
  final List<Court> courts; // Lista de canchas filtradas
  final List<Court> recentCourts; // Lista de vistas recientes

  const _HomePageContent({
    required this.onSportSelected,
    required this.onSearch,
    required this.onCourtSelected,
    required this.courts,
    required this.recentCourts, // Recibimos las vistas recientes
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
              height: 300, // Altura mayor para imágenes más grandes
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: courts.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Navegar a la pantalla de detalles de la cancha
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CourtDetailScreen(courtId: courts[index].id),
                        ),
                      ).then((_) {
                        // Cuando regresa, agregamos la cancha a las vistas recientes
                        onCourtSelected(courts[index]);
                      });
                    },
                    child: FeaturedCourtCard(court: courts[index]),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Sección de Vistas Recientes
            if (recentCourts.isNotEmpty) ...[
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
                itemCount: recentCourts.length, // Usamos recentCourts aquí
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Navegar a la pantalla de detalles de la cancha
                      // En HomeScreen, modifica el código donde navegas a CourtDetailScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CourtDetailScreen(
                            courtId: courts[index].id,
                          ), // Solo pasamos el ID de la cancha
                        ),
                      );
                    },
                    child: RecentCourtListItem(
                      court:
                          recentCourts[index], // Usamos la cancha de las vistas recientes
                    ),
                  );
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
          // Más ChoiceChips según tus deportes...
        ],
      ),
    );
  }
}
