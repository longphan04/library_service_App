import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/register_request.dart';

part 'register_request_model.g.dart';

/// Register request model for API serialization
@JsonSerializable()
class RegisterRequestModel {
  @JsonKey(name: 'email')
  final String email;

  @JsonKey(name: 'password')
  final String password;

  @JsonKey(name: 'full_name')
  final String fullName;

  RegisterRequestModel({
    required this.email,
    required this.password,
    required this.fullName,
  });

  factory RegisterRequestModel.fromEntity(RegisterRequest entity) {
    return RegisterRequestModel(
      email: entity.email,
      password: entity.password,
      fullName: entity.fullName,
    );
  }

  factory RegisterRequestModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterRequestModelToJson(this);
}
