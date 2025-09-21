// lib/screens/intro/intro_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // Si deseas usar Cupertino para un estilo iOS
import 'package:firebase_auth/firebase_auth.dart'; // Importar Firebase Auth para redirigir al login

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  // Controlador para manejar la navegación por las páginas
  final PageController _pageController = PageController();
  int _currentPage = 0; // Índice de la página actual

  // Lista de títulos y descripciones
  final List<Map<String, String>> _pages = [
    {
      'title': 'Selecciona tu Cancha y Horario',
      'subtitle':
          'Selecciona una cancha y un horario disponibles en el calendario.',
    },
    {
      'title': 'Pantalla de Pago',
      'subtitle':
          'Confirma el resumen de tu reserva y completa el pago de forma segura.',
    },
    {
      'title': 'Pantalla de Confirmación',
      'subtitle':
          'Tu reserva está lista! Recibirás los detalles y un código QR para entrar a la cancha.',
    },
  ];

  // Cambiar de página
  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      // Cuando llega a la última página, redirige al login
      Navigator.pushReplacementNamed(context, 'init');
    }
  }

  // Cambiar de página al hacer swipe
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
            // PageView con las pantallas de introducción
            PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: _pages.length,
              itemBuilder: (context, index) {
                return _buildPage(index);
              },
            ),
            // Puntos de navegación abajo
            Positioned(
              bottom: 30,
              left:
                  MediaQuery.of(context).size.width / 2 -
                  40, // Centrado horizontalmente
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
            // Botón Skip en la esquina superior derecha
            Positioned(
              top: 20,
              right: 20,
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(
                    context,
                    'init',
                  ); // Redirigir al login
                },
                child: const Text(
                  'Skip',
                  style: TextStyle(fontSize: 18, color: Colors.green),
                ),
              ),
            ),
            // Botón Next en la esquina inferior derecha
            Positioned(
              bottom: 20,
              right: 20,
              child: ElevatedButton(
                onPressed: _nextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Color del botón
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

  // Método para construir cada página
  Widget _buildPage(int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Icono o ilustración de la página
        Icon(
          Icons
              .sports_soccer, // Esto es solo un ejemplo, puedes cambiarlo según la página
          size: 120,
          color: Colors.green,
        ),
        const SizedBox(height: 20),
        // Título de la página
        Text(
          _pages[index]['title']!,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        // Subtítulo de la página
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
