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
      Navigator.pushReplacementNamed(context, 'init'); // Ruta al login
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
          children: [
            // Página principal Home
            _buildHomePage(),
            // Página de filtros de deportes
            SportsFilterScreen(),
            // Página de Reservas
            const ReservasScreen(), // Agregar la pantalla de reservas aquí
            // Puedes agregar más pantallas como Perfil si lo deseas
            const PerfilScreen(), //Perfil
          ],
        ),
      ),
      // BottomNavigationBar con íconos y colores
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // Página de inicio (Home)
  Widget _buildHomePage() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Mostrar nombre del usuario logeado
            _buildHeader(),
            const SizedBox(height: 20),
            _buildFilterChips(),
            const SizedBox(height: 24),

            // Featured Courts Carousel
            SizedBox(
              height: 250,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: dummyCourts
                    .length, // Asegúrate de que dummyCourts tenga los datos
                itemBuilder: (context, index) {
                  return FeaturedCourtCard(court: dummyCourts[index]);
                },
              ),
            ),
            const SizedBox(height: 24),

            // Recent Views List
            _buildRecentViewsHeader(context),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: dummyCourts
                  .length, // Asegúrate de que dummyCourts tenga los datos
              itemBuilder: (context, index) {
                return RecentCourtListItem(court: dummyCourts[index]);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Header: Mostrar el nombre del usuario logeado
  Widget _buildHeader() {
    return Row(
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
              user?.displayName ?? 'Usuario', // Mostrar nombre del usuario
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
    );
  }

  // Chips de filtro (como Recomendado, Fútbol, etc.)
  Widget _buildFilterChips() {
    return SizedBox(
      height: 35,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildChoiceChip('Recomendado', isSelected: true),
          _buildChoiceChip('Fútbol'),
          _buildChoiceChip('Tennis'),
          _buildChoiceChip('Natación'),
        ],
      ),
    );
  }

  Widget _buildChoiceChip(String label, {bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {},
        backgroundColor: Colors.white,
        selectedColor: Colors.green.shade100,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide.none,
      ),
    );
  }

  // Recent Views Header
  Widget _buildRecentViewsHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Vistas recientes', style: Theme.of(context).textTheme.titleLarge),
        TextButton(onPressed: () {}, child: const Text('Ver todo')),
      ],
    );
  }

  // BottomNavigationBar con íconos y color de selección
  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex, // Indicar el ítem seleccionado
      backgroundColor: Colors.green, // Color de fondo del menú inferior
      selectedItemColor: Colors.green, // Color del ítem seleccionado
      unselectedItemColor: Colors.grey, // Color de los ítems no seleccionados
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.sports_soccer), // Ícono de deporte
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
      onTap: _onItemTapped, // Llama la función para manejar el cambio de índice
    );
  }
}
