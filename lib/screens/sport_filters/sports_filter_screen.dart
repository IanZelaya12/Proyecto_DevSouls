import 'package:flutter/material.dart';
import '../../data/dummy_data.dart';
import './widgets/sport_category_card.dart';
import 'sport_category_card.dart' show SportCategoryCard;

class SportsFilterScreen extends StatelessWidget {
  const SportsFilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          '4. Cerca de tu ubicación',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 3 / 2,
                ),
                itemCount: dummySports.length,
                itemBuilder: (context, index) {
                  final sport = dummySports[index];
                  return SportCategoryCard(sport: sport);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
