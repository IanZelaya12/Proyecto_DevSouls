// lib/screens/intro/intro_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // Si deseas usar Cupertino para un estilo iOS
import 'package:firebase_auth/firebase_auth.dart'; // Importar Firebase Auth para redirigir al login
import 'package:permission_handler/permission_handler.dart'; // Importar permission_handler

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      'title': 'Selecciona tu Cancha y Horario',
      'subtitle':
          'Selecciona una cancha y un horario disponibles en el calendario.',
      'image': 'assets/img/basketball_intro.png', // Ruta de la imagen
    },
    {
      'title': 'Pantalla de Pago',
      'subtitle':
          'Confirma el resumen de tu reserva y completa el pago de forma segura.',
      'image': 'assets/img/voleibol_intro.png', // Ruta de la imagen
    },
    {
      'title': 'Pantalla de Confirmación',
      'subtitle':
          'Tu reserva está lista! Recibirás los detalles y un código QR para entrar a la cancha.',
      'image': 'assets/img/futbol_intro.png', // Ruta de la imagen
    },
  ];

  @override
  void initState() {
    super.initState();
    _requestNotificationPermission(); // Solicitar permiso al iniciar la app
  }

  // Función para solicitar permisos de notificación
  Future<void> _requestNotificationPermission() async {
    // Solo para Android 13+
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      Navigator.pushReplacementNamed(context, 'init');
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: _pages.length,
              itemBuilder: (context, index) {
                return _buildPage(index);
              },
            ),
            Positioned(
              bottom: 30,
              left: MediaQuery.of(context).size.width / 2 - 40,
              child: Row(
                children: List.generate(
                  _pages.length,
                  (index) => Container(
                    margin: const EdgeInsets.only(right: 8.0),
                    height: 8.0,
                    width: 8.0,
                    decoration: BoxDecoration(
                      color: _currentPage == index ? Colors.green : Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 20,
              right: 20,
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, 'init');
                },
                child: const Text(
                  'Skip',
                  style: TextStyle(fontSize: 18, color: Colors.green),
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: ElevatedButton(
                onPressed: _nextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          _pages[index]['image']!, // Usamos la imagen de la lista
          width: 200, // Ajusta el tamaño si es necesario
          height: 200,
        ),
        const SizedBox(height: 20),
        Text(
          _pages[index]['title']!,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Text(
            _pages[index]['subtitle']!,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
