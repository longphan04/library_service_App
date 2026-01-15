// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) => ProfileModel(
  profileId: (json['profile_id'] as num).toInt(),
  userId: (json['user_id'] as num).toInt(),
  fullName: json['full_name'] as String,
  phone: json['phone'] as String?,
  avatarUrl: json['avatar_url'] as String?,
  address: json['address'] as String?,
  dob: json['dob'] as String?,
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
  user: json['user'] == null
      ? null
      : UserModel.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ProfileModelToJson(ProfileModel instance) =>
    <String, dynamic>{
      'profile_id': instance.profileId,
      'user_id': instance.userId,
      'full_name': instance.fullName,
      'phone': instance.phone,
      'avatar_url': instance.avatarUrl,
      'address': instance.address,
      'dob': instance.dob,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'user': instance.user,
    };

ProfileResponseModel _$ProfileResponseModelFromJson(
  Map<String, dynamic> json,
) => ProfileResponseModel(
  data: ProfileModel.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ProfileResponseModelToJson(
  ProfileResponseModel instance,
) => <String, dynamic>{'data': instance.data};

UpdateProfileRequest _$UpdateProfileRequestFromJson(
  Map<String, dynamic> json,
) => UpdateProfileRequest(
  fullName: json['full_name'] as String,
  phone: json['phone'] as String?,
  address: json['address'] as String?,
  dob: json['dob'] as String?,
);

Map<String, dynamic> _$UpdateProfileRequestToJson(
  UpdateProfileRequest instance,
) => <String, dynamic>{
  'full_name': instance.fullName,
  'phone': instance.phone,
  'address': instance.address,
  'dob': instance.dob,
};
