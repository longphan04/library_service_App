import 'package:dio/dio.dart';
import '../../models/notification_model.dart';

abstract class MessageRemoteDataSource {
  Future<List<NotificationModel>> fetchNotifications();
  Future<int> fetchUnreadCount();
  Future<void> markAllAsRead();
}

class MessageRemoteDataSourceImpl implements MessageRemoteDataSource {
  final Dio dio;

  MessageRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<NotificationModel>> fetchNotifications() async {
    try {
      final response = await dio.get('/notification');

      if (response.statusCode! >= 400) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }

      final dynamic responseData = response.data;
      final List<dynamic> dataList;
      if (responseData is List) {
        dataList = responseData;
      } else if (responseData is Map<String, dynamic> &&
          responseData['data'] != null) {
        dataList = responseData['data'] as List<dynamic>;
      } else {
        dataList = [];
      }

      return dataList
          .map(
            (json) => NotificationModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<int> fetchUnreadCount() async {
    try {
      final response = await dio.get('/notification/unread-count');

      if (response.statusCode! >= 400) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }

      return response.data['data']['unread_count'] ?? 0;
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<void> markAllAsRead() async {
    try {
      final response = await dio.put('/notification/read-all');

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
