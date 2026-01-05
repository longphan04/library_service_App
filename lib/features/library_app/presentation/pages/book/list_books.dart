import 'package:flutter/material.dart';
import 'book_card.dart';

class ListBooks extends StatelessWidget {
  const ListBooks({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.525,
        crossAxisSpacing: 20,
        mainAxisSpacing: 10,
      ),
      itemCount: 10,
      itemBuilder: (context, index) {
        return BookCard(
          title: 'Title Book',
          author: 'Author',
          category: 'Category',
          availableCount: 3,
        );
      },
    );
  }
}
