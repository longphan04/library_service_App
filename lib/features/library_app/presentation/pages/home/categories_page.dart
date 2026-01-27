import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../bloc/category/category_bloc.dart';
import '../book/list_categories.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async {
            context.read<CategoryBloc>().add(RefreshCategoriesEvent());
            await Future.delayed(const Duration(milliseconds: 500));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
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
                if (state is CategoryLoaded) ...[
                  ListCategories(categories: state.categories),
                ] else if (state is CategoryLoading) ...[
                  const Center(child: CircularProgressIndicator()),
                ] else if (state is CategoryFailure) ...[
                  Center(
                    child: Text(
                      'Lỗi: ${state.message}',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
