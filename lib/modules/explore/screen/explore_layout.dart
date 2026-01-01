import 'package:flutter/material.dart';
import '../widgets/search_widget/search_widget.dart';
import '../widgets/card_category_widget/card_categories_widget.dart';
import '../widgets/curated_collections_widget/curated_collections_widget.dart';

class ExploreLayout extends StatelessWidget {
  const ExploreLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Explore',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF202124),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Search Widget
                    const SearchWidget(),
                  ],
                ),
              ),
              
              // Browse by Category
              const CardCategoriesWidget(),
              
              const SizedBox(height: 24),
              
              // Curated Collections
              const CuratedCollectionsWidget(),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}