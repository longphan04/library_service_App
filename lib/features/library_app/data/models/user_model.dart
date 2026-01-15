import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/user.dart';

part 'user_model.g.dart';

List<String> _rolesFromJson(dynamic roles) {
  final list = roles is List ? roles : const [];

  return list
      .map((e) {
        if (e is String) return e;
        if (e is Map<String, dynamic>) return e['name'] as String?;
        return null;
      })
      .whereType<String>()
      .toList();
}

List<dynamic> _rolesToJson(List<String> roles) {
  return roles.map((name) => {'name': name}).toList();
}

/// User model for API deserialization
@JsonSerializable()
class UserModel {
  @JsonKey(name: 'user_id')
  final int userId;

  @JsonKey(name: 'email')
  final String email;

  @JsonKey(name: 'status')
  final String status;

  @JsonKey(name: 'roles', fromJson: _rolesFromJson, toJson: _rolesToJson)
  final List<String> roles;

  UserModel({
    required this.userId,
    required this.email,
    required this.status,
    required this.roles,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  /// Convert model to entity
  User toEntity() {
    return User(userId: userId, email: email, status: status, roles: roles);
  }
}
