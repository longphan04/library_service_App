import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/login_response.dart';
import 'user_model.dart';

part 'login_response_model.g.dart';

/// Login response model for API deserialization
@JsonSerializable()
class LoginResponseModel {
  @JsonKey(name: 'accessToken')
  final String accessToken;

  @JsonKey(name: 'refreshToken')
  final String? refreshToken;

  @JsonKey(name: 'user')
  final UserModel user;

  LoginResponseModel({
    required this.accessToken,
    this.refreshToken,
    required this.user,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseModelToJson(this);

  /// Convert model to entity
  LoginResponse toEntity() {
    return LoginResponse(
      accessToken: accessToken,
      refreshToken: refreshToken,
      user: user.toEntity(),
    );
  }
}
