import 'package:dio/dio.dart';

import '../../models/book_model.dart';
import '../../models/pagination_model.dart';

abstract class BookRemoteDatasource {
  Future<BooksListModel> getBooksById(List<String> ids);
  Future<BookModel> getBookDetails(int bookId);
  Future<BooksListModel> getAllBooks({
    String? query,
    String? categoryId,
    String? sort,
    int? page,
    int? limit,
  });
  Future<List<String>> getSuggestions(String query);
  Future<BooksListModel> getRecommendedBooks();
}

class BookRemoteDatasourceImpl implements BookRemoteDatasource {
  final Dio dio;

  BookRemoteDatasourceImpl({required this.dio});

  @override
  Future<BooksListModel> getBooksById(List<String> ids) async {
    try {
      final response = await dio.post('/book/identifier', data: {'ids': ids});

      if (response.statusCode! >= 400) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }

      // API /book/identifier không trả về pagination, tự tạo
      final List<dynamic> booksData = response.data['data'] ?? [];
      final List<BookModel> books = booksData
          .map((bookJson) => BookModel.fromJson(bookJson))
          .toList();

      final pagination = PaginationModel(
        totalPages: 1,
        totalItems: books.length,
        page: 1,
        limit: books.length,
        hasNext: false,
      );

      return BooksListModel(data: books, pagination: pagination);
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<BooksListModel> getRecommendedBooks() async {
    try {
      final response = await dio.get('/book/recommendation');

      if (response.statusCode! >= 400) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }

      final List<dynamic> booksData = response.data['books'];
      final List<BookModel> books = booksData
          .map((bookJson) => BookModel.fromJson(bookJson))
          .toList();

      final pagination = PaginationModel(
        totalPages: 1,
        totalItems: books.length,
        page: 1,
        limit: books.length,
        hasNext: false,
      );

      return BooksListModel(data: books, pagination: pagination);
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<BookModel> getBookDetails(int bookId) async {
    try {
      final response = await dio.get('/book/$bookId');

      if (response.statusCode! >= 400) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
      final model = BookModel.fromJson(response.data);
      return model;
    } on DioException {
      rethrow;
    }
  }

  @override
  // 1. Thêm các tham số tùy chọn (optional) vào hàm
  Future<BooksListModel> getAllBooks({
    String? query,
    String? categoryId,
    String? sort,
    int? page,
    int? limit,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {};

      if (query != null && query.isNotEmpty) {
        queryParams['q'] = query;
      }
      if (categoryId != null && categoryId.isNotEmpty) {
        queryParams['categoryId'] = categoryId;
      }
      if (sort != null && sort.isNotEmpty) {
        queryParams['sort'] = sort;
      }
      if (page != null) {
        queryParams['page'] = page;
      }
      if (limit != null) {
        queryParams['limit'] = limit;
      }

      final response = await dio.get('/book', queryParameters: queryParams);

      if (response.statusCode! >= 400) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
      final model = BooksListModel.fromJson(response.data);
      return model;
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<List<String>> getSuggestions(String query) async {
    try {
      final response = await dio.get(
        '/book/suggest',
        queryParameters: {'q': query},
      );

      if (response.statusCode! >= 400) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
      final List<dynamic> dataList = response.data['data'];
      return dataList.map((item) => item.toString()).toList();
    } on DioException {
      rethrow;
    }
  }
}
