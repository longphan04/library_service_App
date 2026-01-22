import '../entities/category.dart';
import '../repositories/category_repository.dart';

class GetCategoriesUseCase {
  final CategoryRepository repository;

  GetCategoriesUseCase(this.repository);

  Future<List<Category>> call() async {
    return await repository.getCategories();
  }
}

class GetPopularCategoriesUseCase {
  final CategoryRepository repository;

  GetPopularCategoriesUseCase(this.repository);

  Future<List<Category>> call() async {
    return await repository.getPopularCategories();
  }
}
