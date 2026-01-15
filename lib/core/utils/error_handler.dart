import 'package:dio/dio.dart';
import 'dart:io';

/// Utility class for handling and converting API errors to user-friendly messages
class ErrorHandler {
  /// Get user-friendly error message from DioException
  static String getErrorMessage(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Hết thời gian kết nối. Vui lòng kiểm tra kết nối mạng.';
      case DioExceptionType.sendTimeout:
        return 'Hết thời gian gửi dữ liệu. Vui lòng thử lại.';
      case DioExceptionType.receiveTimeout:
        return 'Hết thời gian chờ phản hồi. Vui lòng thử lại.';
      case DioExceptionType.badResponse:
        return _handleBadResponse(error);
      case DioExceptionType.cancel:
        return 'Yêu cầu bị hủy.';
      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          return 'Lỗi kết nối mạng. Vui lòng kiểm tra kết nối.';
        }
        return 'Lỗi không xác định. Vui lòng thử lại.';
      case DioExceptionType.badCertificate:
        return 'Lỗi xác minh chứng chỉ SSL.';
      case DioExceptionType.connectionError:
        return 'Lỗi kết nối. Vui lòng kiểm tra kết nối mạng.';
    }
  }

  /// Handle bad response status codes
  static String _handleBadResponse(DioException error) {
    final statusCode = error.response?.statusCode ?? 0;
    final responseData = error.response?.data;

    // Try to extract message from response data
    String? extractedMessage;

    // If response data is a Map
    if (responseData is Map<String, dynamic>) {
      if (responseData.containsKey('message') &&
          responseData['message'] != null) {
        extractedMessage = responseData['message'].toString();
      } else if (responseData.containsKey('error') &&
          responseData['error'] != null) {
        extractedMessage = responseData['error'].toString();
      }
    }
    // If response data is a String
    else if (responseData is String && responseData.isNotEmpty) {
      extractedMessage = responseData;
    }

    // Return extracted message if available
    if (extractedMessage != null && extractedMessage.isNotEmpty) {
      return extractedMessage;
    }

    // Default messages by status code
    switch (statusCode) {
      case 400:
        return 'Yêu cầu không hợp lệ. Vui lòng kiểm tra lại thông tin.';
      case 401:
        return 'Thông tin đăng nhập không chính xác.';
      case 403:
        return 'Bạn không có quyền truy cập.';
      case 404:
        return 'Không tìm thấy dữ liệu.';
      case 500:
        return 'Lỗi máy chủ. Vui lòng thử lại sau.';
      case 502:
        return 'Máy chủ tạm thời không khả dụng.';
      case 503:
        return 'Dịch vụ hiện không khả dụng. Vui lòng thử lại sau.';
      default:
        return 'Có lỗi xảy ra. Vui lòng thử lại.';
    }
  }
}
