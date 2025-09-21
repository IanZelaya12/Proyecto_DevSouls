// lib/screens/sport_filters/sport_filter_screen.dart
import 'package:flutter/material.dart';
import 'widgets/styles.dart'; // Importar los estilos
import 'widgets/sport_category_card.dart'; // Importar la tarjeta de deporte
import '../home/home_screen.dart'; // Importar la pantalla Home
import '../sport_filters/sports_filter_screen.dart'; // Importar la pantalla de búsqueda

class SportsFilterScreen extends StatefulWidget {
  const SportsFilterScreen({super.key});

  @override
  _SportsFilterScreenState createState() => _SportsFilterScreenState();
}

class _SportsFilterScreenState extends State<SportsFilterScreen> {
  int _selectedIndex =
      1; // Índice para el ítem seleccionado del BottomNavigationBar (Deportes)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          '4. Cerca de tu ubicación', // Título que puede ser dinámico según el contexto
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Campo de búsqueda (para filtrar deportes)
            TextField(
              decoration: InputDecoration(
                hintText: 'Buscar por nombre',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Deportes disponibles',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            // Usamos un GridView para mostrar los deportes
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Dos columnas
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 3 / 2, // Ajustamos la relación de aspecto
                ),
                itemCount: sportNames.length,
                itemBuilder: (context, index) {
                  final sport = sportNames[index];
                  return SportCategoryCard(
                    sportName: sport,
                    imageUrl:
                        'assets/images/placeholder.png', // Placeholder temporal
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // BottomNavigationBar con íconos y color de selección
}

// Lista de deportes (puedes cargar estos datos desde Firestore si lo deseas)
List<String> sportNames = [
  'Futbol',
  'Correr',
  'Yoga',
  'Fit Dance',
  'Natacion',
  'Volei',
  'Basketball',
  'Gimnasia',
  'Artes marciales',
  'Hip Hop',
  'Calistenia',
  'Ping-Pong',
];

// Lista de imágenes para los deportes (usa un ícono temporal mientras cargas las imágenes reales)
List<String> sportImages = [
  'assets/images/placeholder.png', // Este es el placeholder temporal
  'assets/images/placeholder.png',
  'assets/images/placeholder.png',
  'assets/images/placeholder.png',
  'assets/images/placeholder.png',
  'assets/images/placeholder.png',
  'assets/images/placeholder.png',
  'assets/images/placeholder.png',
  'assets/images/placeholder.png',
  'assets/images/placeholder.png',
  'assets/images/placeholder.png',
  'assets/images/placeholder.png',
];
