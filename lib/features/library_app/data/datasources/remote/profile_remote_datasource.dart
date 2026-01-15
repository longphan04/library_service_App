import 'package:dio/dio.dart';

import '../../models/profile_model.dart';

abstract class ProfileRemoteDatasource {
  Future<ProfileModel> getProfile();
  Future<ProfileModel> updateProfile(UpdateProfileRequest profile);
}

class ProfileRemoteDatasourceImpl implements ProfileRemoteDatasource {
  final Dio dio;

  ProfileRemoteDatasourceImpl({required this.dio});

  @override
  Future<ProfileModel> getProfile() async {
    try {
      final response = await dio.get('/profile/me');

      if (response.statusCode! >= 400) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
      final model = ProfileResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
      return model.data;
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<ProfileModel> updateProfile(UpdateProfileRequest profile) async {
    try {
      final formData = await profile.toFormData();
      final response = await dio.put(
        '/profile/me',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      if (response.statusCode! >= 400) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
      final model = ProfileResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
      return model.data;
    } on DioException {
      rethrow;
    }
  }
}
