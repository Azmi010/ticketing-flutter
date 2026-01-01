import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'card_category_widget.dart';
import 'bloc/card_category_bloc.dart';

class CardCategorySuccessWidget extends StatelessWidget {
  const CardCategorySuccessWidget({super.key});

  // Map category name ke image URL
  String _getCategoryImage(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'music':
        return 'https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3?w=400';
      case 'arts & theatre':
      case 'art & design':
        return 'https://images.unsplash.com/photo-1518998053901-5348d3961a04?w=400';
      case 'sports':
        return 'https://images.unsplash.com/photo-1461896836934-ffe607ba8211?w=400';
      case 'workshops':
      case 'business':
        return 'https://images.unsplash.com/photo-1552664730-d307ca884978?w=400';
      case 'tech':
        return 'https://images.unsplash.com/photo-1519389950473-47ba0277781c?w=400';
      default:
        return 'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=400';
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = context.watch<CardCategoryBloc>().state.categories;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Text(
            'Browse by Category',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF202124),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.5,
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return CardCategoryWidget(
                title: category.name,
                imageUrl: _getCategoryImage(category.name),
                onTap: () {},
              );
            },
          ),
        ),
      ],
    );
  }
}
