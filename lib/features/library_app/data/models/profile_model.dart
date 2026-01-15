import 'dart:io';

import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../../core/config/dio_config.dart';
import '../../domain/entities/profile.dart';
import 'user_model.dart';

part 'profile_model.g.dart';

/// Profile model for API deserialization
@JsonSerializable()
class ProfileModel {
  @JsonKey(name: 'profile_id')
  final int profileId;

  @JsonKey(name: 'user_id')
  final int userId;

  @JsonKey(name: 'full_name')
  final String fullName;

  @JsonKey(name: 'phone')
  final String? phone;

  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;

  @JsonKey(name: 'address')
  final String? address;

  @JsonKey(name: 'dob')
  final String? dob;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'updated_at')
  final String updatedAt;

  /// User info nested under profile payload (from /profile/me)
  @JsonKey(name: 'user')
  final UserModel? user;

  ProfileModel({
    required this.profileId,
    required this.userId,
    required this.fullName,
    this.phone,
    this.avatarUrl,
    this.address,
    this.dob,
    required this.createdAt,
    required this.updatedAt,
    this.user,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);

  /// Convert model to entity
  Profile toEntity() {
    return Profile(
      profileId: profileId,
      userId: userId,
      fullName: fullName,
      phone: phone,
      avatarUrl: '${DioConfig.baseUrl}/public/${avatarUrl ?? ''}',
      address: address,
      dateOfBirth: dob != null ? DateTime.tryParse(dob!) : null,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
    );
  }
}

/// Profile response wrapper
@JsonSerializable()
class ProfileResponseModel {
  @JsonKey(name: 'data')
  final ProfileModel data;

  ProfileResponseModel({required this.data});

  factory ProfileResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileResponseModelToJson(this);
}

/// Update profile request model
@JsonSerializable()
class UpdateProfileRequest {
  @JsonKey(name: 'full_name')
  final String fullName;

  @JsonKey(name: 'phone')
  final String? phone;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final File? image;

  @JsonKey(name: 'address')
  final String? address;

  @JsonKey(name: 'dob')
  final String? dob;

  UpdateProfileRequest({
    required this.fullName,
    this.phone,
    this.image,
    this.address,
    this.dob,
  });

  factory UpdateProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateProfileRequestToJson(this);

  Future<FormData> toFormData() async {
    final formData = FormData.fromMap({
      'full_name': fullName,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (dob != null) 'dob': dob,
    });

    if (image != null) {
      formData.files.add(
        MapEntry('image', await MultipartFile.fromFile(image!.path)),
      );
    }

    return formData;
  }

  /// Create update request from current profile
  factory UpdateProfileRequest.fromProfile(Profile profile) {
    return UpdateProfileRequest(
      fullName: profile.fullName,
      phone: profile.phone,
      image: profile.image,
      address: profile.address,
      dob: profile.dateOfBirth?.toIso8601String(),
    );
  }
}
