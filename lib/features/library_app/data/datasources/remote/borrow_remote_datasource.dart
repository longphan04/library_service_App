import 'package:dio/dio.dart';
import '../../models/book_hold_model.dart';
import '../../models/borrow_ticket_model.dart';

abstract class BorrowRemoteDatasource {
  Future<List<BookHoldModel>> fetchBorrowBooks();
  Future<void> addBookHold(int holdId);
  Future<List<int>> removeBookHold(List<int> holdIds);
  Future<void> borrowNow(int bookId);
  Future<void> borrowFromHolds(List<int> holdIds);

  // history
  Future<TicketListModel> fetchBorrowTickets({
    int page = 1,
    int limit = 10,
    String? status,
  });
  Future<TicketModel> fetchBorrowTicketDetail(int ticketId);
  Future<void> cancelBorrowTicket(int ticketId);
  Future<void> renewBorrowTicket(int ticketId);
}

class BorrowRemoteDatasourceImpl implements BorrowRemoteDatasource {
  final Dio dio;

  BorrowRemoteDatasourceImpl({required this.dio});

  @override
  Future<void> cancelBorrowTicket(int ticketId) async {
    try {
      final response = await dio.put(
        '/borrow-ticket/$ticketId/member',
        data: {'action': 'cancel'},
      );

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

  @override
  Future<void> renewBorrowTicket(int ticketId) async {
    try {
      final response = await dio.put(
        '/borrow-ticket/$ticketId/member',
        data: {'action': 'renew'},
      );

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

  @override
  Future<List<int>> removeBookHold(List<int> holdIds) async {
    try {
      final response = await dio.delete(
        '/book-hold',
        data: {'hold_ids': holdIds},
      );

      if (response.statusCode! >= 400) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }

      final data = response.data;
      if (data is List) {
        return data
            .map((id) => int.tryParse(id.toString()))
            .whereType<int>()
            .toList();
      }

      return holdIds;
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<void> borrowNow(int bookId) async {
    try {
      final response = await dio.post(
        '/borrow-ticket',
        data: {'bookId': bookId},
      );

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

  @override
  Future<void> borrowFromHolds(List<int> holdIds) async {
    try {
      final response = await dio.post(
        '/borrow-ticket',
        data: {'hold_ids': holdIds},
      );

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

  @override
  Future<TicketListModel> fetchBorrowTickets({
    int page = 1,
    int limit = 10,
    String? status,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {'page': page, 'limit': limit};

      if (status != null && status.isNotEmpty) {
        queryParams['status'] = status;
      }

      final response = await dio.get(
        '/borrow-ticket/me',
        queryParameters: queryParams,
      );

      if (response.statusCode! >= 400) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }

      return TicketListModel.fromJson(response.data);
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<TicketModel> fetchBorrowTicketDetail(int ticketId) async {
    try {
      final response = await dio.get('/borrow-ticket/$ticketId');

      if (response.statusCode! >= 400) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }

      final responseModel = TicketDetailResponseModel.fromJson(response.data);
      return responseModel.data;
    } on DioException {
      rethrow;
    }
  }
}
