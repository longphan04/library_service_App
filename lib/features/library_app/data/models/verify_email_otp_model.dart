import 'package:json_annotation/json_annotation.dart';

part 'verify_email_otp_model.g.dart';

@JsonSerializable()
class VerifyEmailOtpModel {
  @JsonKey(name: 'email')
  final String email;
  @JsonKey(name: 'otp')
  final String otp;

  VerifyEmailOtpModel({required this.email, required this.otp});

  factory VerifyEmailOtpModel.fromJson(Map<String, dynamic> json) =>
      _$VerifyEmailOtpModelFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyEmailOtpModelToJson(this);
}
