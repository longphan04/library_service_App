import 'package:dio/dio.dart';
import '../../models/ai_chat_response_model.dart';
import '../../models/notification_model.dart';

abstract class MessageRemoteDataSource {
  // Notifications
  Future<List<NotificationModel>> fetchNotifications();
  Future<int> fetchUnreadCount();
  Future<void> markAllAsRead();

  // AI Chat
  Future<AIChatResponseModel> sendMessage({
    required String message,
    String? sessionId,
    int topK = 5,
  });

  Future<void> clearChatHistory(String sessionId);
}

class MessageRemoteDataSourceImpl implements MessageRemoteDataSource {
  final Dio dio;
  final Dio aiDio;

  MessageRemoteDataSourceImpl({required this.dio, required this.aiDio});

  @override
  Future<AIChatResponseModel> sendMessage({
    required String message,
    String? sessionId,
    int topK = 5,
  }) async {
    try {
      final response = await aiDio.post(
        '/ai/chat',
        data: {
          'message': message,
          'top_k': topK,
          if (sessionId != null) 'session_id': sessionId,
        },
      );

      if (response.statusCode! >= 400) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }

      final responseData = response.data;
      if (responseData['status'] == 'success') {
        return AIChatResponseModel.fromJson(responseData);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          message: 'AI response failed',
        );
      }
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<void> clearChatHistory(String sessionId) async {
    try {
      final response = await aiDio.delete('/ai/chat/history/$sessionId');

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
