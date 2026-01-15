// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  userId: (json['user_id'] as num).toInt(),
  email: json['email'] as String,
  status: json['status'] as String,
  roles: _rolesFromJson(json['roles']),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'user_id': instance.userId,
  'email': instance.email,
  'status': instance.status,
  'roles': _rolesToJson(instance.roles),
};
