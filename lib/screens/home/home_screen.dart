import 'package:flutter/material.dart';
import '../../data/dummy_data.dart';
import '../data/dummy_data.dart';
import 'widgets/featured_court_card.dart';
import 'widgets/recent_court_list_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header, Search, and Filters...
                _buildHeader(),
                const SizedBox(height: 20),
                _buildSearchField(),
                const SizedBox(height: 20),
                _buildFilterChips(),
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
                _buildRecentViewsHeader(context),
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
        ),
      ),
    );
  }

  // Helper private widgets for cleaner build method
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '¡BIENVENIDO!',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Text(
              'Bessie Cooper',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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

  Widget _buildSearchField() {
    return const TextField(
      decoration: InputDecoration(
        hintText: 'Search',
        prefixIcon: Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

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

  Widget _buildRecentViewsHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Vistas recientes', style: Theme.of(context).textTheme.titleLarge),
        TextButton(onPressed: () {}, child: const Text('Ver todo')),
      ],
    );
  }
}
