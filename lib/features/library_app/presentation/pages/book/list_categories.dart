import 'package:flutter/material.dart';

import '../../../domain/entities/category.dart';
import 'category_card.dart';
import 'search_page.dart';

class ListCategories extends StatelessWidget {
  final List<Category> categories;
  const ListCategories({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 20,
        mainAxisSpacing: 10,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return CategoryCard(
          categoryName: category.name,
          image: category.image,
          bookCount: category.bookCount,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchPage.fromCategory(
                  categoryId: category.categoryId,
                  categoryName: category.name,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
