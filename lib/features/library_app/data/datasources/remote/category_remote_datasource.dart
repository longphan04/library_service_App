import 'package:dio/dio.dart';

import '../../models/category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
  Future<List<CategoryModel>> getPopularCategories();
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final Dio dio;

  CategoryRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<CategoryModel>> getPopularCategories() async {
    try {
      final response = await dio.get('/category/hot');
      if (response.statusCode! >= 400) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
      // Handle both formats: direct list or { "data": [...] }
      final dynamic data = response.data;
      final List<dynamic> categoriesList;
      if (data is List) {
        categoriesList = data;
      } else if (data is Map<String, dynamic> && data['data'] != null) {
        categoriesList = data['data'] as List<dynamic>;
      } else {
        categoriesList = [];
      }
      final categories = categoriesList
          .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return categories;
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await dio.get('/category');

      if (response.statusCode! >= 400) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
      final categories = (response.data as List)
          .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return categories;
    } on DioException {
      rethrow;
    }
  }
}
