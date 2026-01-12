import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../book/list_categories.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Danh mục',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.titleText,
              ),
            ),
          ),
          const ListCategories(),
        ],
      ),
    );
  }
}
