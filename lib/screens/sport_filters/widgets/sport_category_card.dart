// lib/screens/search/widgets/sport_category_card.dart
import 'package:flutter/material.dart';

class SportCategoryCard extends StatelessWidget {
  final String sportName;
  final String imageUrl;

  const SportCategoryCard({
    super.key,
    required this.sportName,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen del deporte
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imageUrl,
              width: double.infinity,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          // Nombre del deporte
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              sportName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
