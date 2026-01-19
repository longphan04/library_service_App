import 'package:dio/dio.dart';
import '../../models/login_request_model.dart';
import '../../models/login_response_model.dart';
import '../../models/register_request_model.dart';
import '../../models/verify_email_otp_model.dart';

abstract class AuthRemoteDatasource {
  Future<LoginResponseModel> login(LoginRequestModel request);
  Future<void> register(RegisterRequestModel request);
  Future<void> verifyOtp(VerifyEmailOtpModel request);
  Future<void> logout();
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final Dio dio;

  AuthRemoteDatasourceImpl({required this.dio});

  @override
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: request.toJson(),
        options: Options(
          extra: const {'requiresAuth': false, 'skipRefresh': true},
        ),
      );

      if (response.statusCode! >= 400) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
      final model = LoginResponseModel.fromJson(response.data);
      return model;
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<void> register(RegisterRequestModel request) async {
    try {
      final response = await dio.post(
        '/auth/register-mobile',
        data: request.toJson(),
        options: Options(
          extra: const {'requiresAuth': false, 'skipRefresh': true},
        ),
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
  Future<void> verifyOtp(VerifyEmailOtpModel request) async {
    try {
      final response = await dio.post(
        '/auth/verify-email-otp',
        data: request.toJson(),
        options: Options(
          extra: const {'requiresAuth': false, 'skipRefresh': true},
        ),
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
  Future<void> logout() async {
    try {
      final response = await dio.post('/auth/logout');

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
