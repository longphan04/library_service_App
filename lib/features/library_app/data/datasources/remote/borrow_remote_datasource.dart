import 'package:dio/dio.dart';
import '../../models/book_hold_model.dart';

abstract class BorrowRemoteDatasource {
  Future<List<BookHoldModel>> fetchBorrowBooks();
  Future<void> addBookHold(int holdId);
}

class BorrowRemoteDatasourceImpl implements BorrowRemoteDatasource {
  final Dio dio;

  BorrowRemoteDatasourceImpl({required this.dio});

  @override
  Future<List<BookHoldModel>> fetchBorrowBooks() async {
    try {
      final response = await dio.get('/book-hold/me');

      if (response.statusCode! >= 400) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }

      final List<dynamic> dataList = response.data;
      return dataList.map((json) => BookHoldModel.fromJson(json)).toList();
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<void> addBookHold(int holdId) async {
    try {
      final response = await dio.post('/book-hold', data: {'book_id': holdId});

      if (response.statusCode! >= 400) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException {
      rethrow;
    }
  }
}
