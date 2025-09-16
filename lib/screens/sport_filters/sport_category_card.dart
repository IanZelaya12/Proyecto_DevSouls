import 'package:flutter/material.dart';
import '../../../models/sport_model.dart';

class SportCategoryCard extends StatelessWidget {
  final Sport sport;
  const SportCategoryCard({super.key, required this.sport});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: sport.color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: -20,
            right: -20,
            child: Image.asset(
              sport.imagePath,
              width: 100,
              height: 100,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.sports, size: 50, color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              sport.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
