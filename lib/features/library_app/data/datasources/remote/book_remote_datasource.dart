import 'package:dio/dio.dart';

import '../../models/book_model.dart';

abstract class BookRemoteDatasource {
  Future<BookModel> getBookDetails(int bookId);
  Future<BooksListModel> getAllBooks();
}

class BookRemoteDatasourceImpl implements BookRemoteDatasource {
  final Dio dio;

  BookRemoteDatasourceImpl({required this.dio});

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
  Future<BooksListModel> getAllBooks() async {
    try {
      final response = await dio.get('/book');

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
}
