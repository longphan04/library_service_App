import 'package:dio/dio.dart';

import '../../domain/entities/login_request.dart';
import '../../domain/entities/login_response.dart';
import '../../domain/entities/register_request.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local/auth_local_datasource.dart';
import '../datasources/remote/auth_remote_datasource.dart';
import '../models/login_request_model.dart';
import '../models/register_request_model.dart';
import '../models/verify_email_otp_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;
  final AuthLocalDatasource localDatasource;

  AuthRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final requestModel = LoginRequestModel(
        email: request.email,
        password: request.password,
      );
      final response = await remoteDatasource.login(requestModel);
      await localDatasource.saveAccessToken(response.accessToken);
      await localDatasource.saveUserData(response.user);
      return response.toEntity();
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<void> register(RegisterRequest request) async {
    try {
      final requestModel = RegisterRequestModel(
        email: request.email,
        password: request.password,
        fullName: request.fullName,
      );
      await remoteDatasource.register(requestModel);
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<void> verifyOtp(String email, String otp) async {
    try {
      final requestModel = VerifyEmailOtpModel(email: email, otp: otp);
      await remoteDatasource.verifyOtp(requestModel);
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await remoteDatasource.logout();
    } on Exception catch (_) {
    } finally {
      await localDatasource.clearTokens();
      await localDatasource.clearUserData();
    }
  }

  @override
  Future<String?> getAccessToken() {
    return localDatasource.getAccessToken();
  }

  @override
  Future<bool> isLoggedIn() {
    return localDatasource.hasTokens();
  }

  @override
  Future<User> getUserData() async {
    final userModel = await localDatasource.getUserData();
    if (userModel != null) {
      return userModel.toEntity();
    } else {
      throw Exception('No user data found');
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await remoteDatasource.forgotPassword(email);
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<String> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      final newAccessToken = await remoteDatasource.changePassword(
        currentPassword,
        newPassword,
      );
      await localDatasource.saveAccessToken(newAccessToken);
      return newAccessToken;
    } on DioException {
      rethrow;
    }
  }
}
