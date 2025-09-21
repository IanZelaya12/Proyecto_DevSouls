// lib/screens/sport_filters/widgets/sport_category_card.dart
import 'package:flutter/material.dart';

class SportCategoryCard extends StatelessWidget {
  final String sportName;
  final String sportImage; // Imagen de fondo
  final Color backgroundColor;
  final VoidCallback? onTap;

  const SportCategoryCard({
    super.key,
    required this.sportName,
    required this.sportImage,
    required this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Adaptar tamaño de fuente según ancho de pantalla
    final fontSize = screenWidth * 0.045; // 4.5% del ancho de pantalla

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: backgroundColor,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Imagen de fondo
              Positioned.fill(
                child: Image.asset(
                  sportImage,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: backgroundColor,
                      child: Icon(
                        Icons.sports,
                        size: screenWidth * 0.15,
                        color: Colors.white.withOpacity(0.6),
                      ),
                    );
                  },
                ),
              ),

              // Degradado oscuro para que el texto resalte
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.black.withOpacity(0.2),
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
              ),

              // Texto del deporte
              Positioned(
                left: 16,
                bottom: 16,
                child: Text(
                  sportName,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.5),
                        offset: const Offset(1, 1),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
