// lib/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importar Firebase Auth
import 'widgets/styles.dart'; // Importar los estilos
import 'widgets/featured_court_card.dart'; // Importar los widgets
import 'widgets/recent_court_list_item.dart'; // Importar los widgets
import '../../data/dummy_data.dart'; // Importar datos de ejemplo (o tu modelo de datos)
import '../sport_filters/sports_filter_screen.dart'; // Importar SportsFilterScreen
import '../Reservas/reservas.dart';
import '../Perfil/perfil.dart';
import '../Mapa/mapa.dart'; // 👈 NUEVO: pantalla de Mapa

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user;
  int _selectedIndex = 0; // Para manejar el índice del BottomNavigationBar

  // Controlador de las páginas
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _checkAuthentication(); // Verificar si el usuario está autenticado al iniciar
  }

  // Verificación de autenticación en Firebase
  void _checkAuthentication() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Si el usuario no está autenticado, redirige a Login
      if (mounted) {
        Navigator.pushReplacementNamed(context, 'init'); // Ruta al login
      }
    } else {
      setState(() {
        this.user = user;
      });
    }
  }

  // Función para cambiar el índice del BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Actualizar el índice seleccionado
    });

    // Cambiar de página al tocar el ícono correspondiente
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          children: const [
            // 1) Página principal Home
            _HomePageContent(),

            // 2) NUEVA: Página del Mapa
            MapaScreen(),

            // 3) Página de filtros de deportes
            SportsFilterScreen(),

            // 4) Página de Reservas
            ReservasScreen(),

            // 5) Página de Perfil
            PerfilScreen(),
          ],
        ),
      ),
      // BottomNavigationBar con íconos y colores
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // BottomNavigationBar con íconos y color de selección
  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex, // Ítem seleccionado
      backgroundColor:
          Colors.white, // OJO: si no se ve bien, cambia a Colors.white
      selectedItemColor:
          Colors.green, // En fondo verde quizás prefieras Colors.white
      unselectedItemColor: Colors.grey,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.map_outlined), // 👈 Ícono de Mapa
          label: 'Mapa',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.sports_soccer), // Ícono de deportes
          label: 'Deportes',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark), // Ícono de Reservas
          label: 'Reservas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Perfil',
        ),
      ],
      onTap: _onItemTapped,
    );
  }
}

/// Contenido de la pestaña Home (tu contenido original), movido a un widget
/// separado para que el PageView pueda ser const y más eficiente.
class _HomePageContent extends StatelessWidget {
  const _HomePageContent();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Mostrar nombre del usuario logeado
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '¡BIENVENIDO!',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Text(
                      user?.displayName ??
                          'Usuario', // Mostrar nombre del usuario
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.notifications_none),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.bookmark_border),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Chips de filtro
            SizedBox(
              height: 35,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  _ChoiceChip(label: 'Recomendado', isSelected: true),
                  _ChoiceChip(label: 'Fútbol'),
                  _ChoiceChip(label: 'Tennis'),
                  _ChoiceChip(label: 'Natación'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Featured Courts Carousel
            SizedBox(
              height: 250,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: dummyCourts.length,
                itemBuilder: (context, index) {
                  return FeaturedCourtCard(court: dummyCourts[index]);
                },
              ),
            ),
            const SizedBox(height: 24),

            // Recent Views List
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Vistas recientes',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton(onPressed: () {}, child: const Text('Ver todo')),
              ],
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: dummyCourts.length,
              itemBuilder: (context, index) {
                return RecentCourtListItem(court: dummyCourts[index]);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ChoiceChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  const _ChoiceChip({required this.label, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) {},
        backgroundColor: Colors.white,
        selectedColor: Colors.green.shade100,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide.none,
      ),
    );
  }
}
